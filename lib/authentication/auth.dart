import 'dart:async';
// import 'dart:html';
import 'dart:io';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:envited/components/all_components.dart';
import 'package:envited/components/methods.dart';
import 'package:envited/screens/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';

class Authentication extends ChangeNotifier {
  Authentication() {
    initialize();
  }

  List<InvitesBlueprint> _allInvites = [];
  List<InvitesBlueprint> get allInvites => _allInvites;

  StreamSubscription<QuerySnapshot>? _listSubscription;
  StreamSubscription<QuerySnapshot>? chatSubscription;

  ApplicationLoginState _loginState = ApplicationLoginState.emailAddress;
  ApplicationLoginState get loginState => _loginState;

  late String _email; //not the best way but you can access the email locally
  // String get memail => _email;
  // set memail(String em) => _email = em;

  //get and listen to changes in AllInvites collection
  Future<void> initialize() async {
    // WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseAuth.instance.userChanges().listen((user) {
      //if logged in or out, this will be called

      if (FirebaseAuth.instance.currentUser?.uid != null) {
        _listSubscription = FirebaseFirestore.instance
            .collection('AllInvites')
            .snapshots()
            .listen((event) {
          _allInvites = [];
          FirebaseFirestore.instance
              .collection('AllInvites')
              .doc('CdTO4XIuJBiniP92LEOF')
              .get()
              .then((value) => print(value['title']));
          event.docs.forEach((event) {
            // print(event.data());
            try {
              _allInvites.add(
                InvitesBlueprint(
                    title: event.data()['title'],
                    time: event.data()['time'].toDate(),
                    nameOfInviter: event.data()['nameOfInviter'],
                    location: event.data()['location'],
                    shortDescription: event.data()['shortDescription'],
                    chatAndUsersCollection:
                        event.data()['chatAndUsersCollection'],
                    // allMessages: [
                    //   new MessageBlueprint(
                    //       messageText: event.data()['allMessages'][0]
                    //           ['messageText'],
                    //       nameOfSender: event.data()['allMessages'][0]
                    //           ['nameOfSender'],
                    //       photoLinkOfSender: event.data()['allMessages'][0]
                    //           ['photoLinkOfSender'],
                    //       uIdOfSender: '')
                    // ],
                    // usersGoing: event.data()['usersGoing'],
                    uIDofInviter: event.data()['uIdOfInviter'],
                    imageURL: event.data()['imageURL']),
              );
            } catch (e) {
              print(e);
            }
            notifyListeners();
            // print(_allInvites[0].title);
          });
        });
        notifyListeners();
      } else {
        _listSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  // Future<QuerySnapshot> SubscribeToChat(String chatId) async{
  //   chatSubscription = FirebaseFirestore.instance.collection('chatAndUsersCollection').
  // }

  FirebaseStorage _storage = FirebaseStorage.instance;
  var res;

  Future<void> uploadPic() async {
    res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
    );
  }

  //pass a InvitesBlueprint to add it to the database
  Future<DocumentReference> addInvites(InvitesBlueprint iBP) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      //we upload image only when user clicks on download button
      var snapshot = await _storage
          .ref()
          .child(
              'InvitesImages/${DateTime.now().toString() + FirebaseAuth.instance.currentUser!.uid.toString()}')
          .putFile(File(res![0].path));
      String downloadUrl = await snapshot.ref.getDownloadURL();

      //TODO:make a new entry in the Chats Document and get it's id
      var chatAndUserCollectionId;
      await FirebaseFirestore.instance
          .collection('chatAndUsersCollection')
          .add({
        'messages': [
          {
            'messageText': 'hellow motherfucker',
            'uIdOfSender': 'idkSomeBodyIGuess',
            'timeOfSending': DateTime.now(),
            'UserNameOfSender': 'mr Fuck YOu',
            'linkToSendersProfile': 'HaventAddedYEt'
          }
        ],
        'AllAttendees': [' ']
      }).then((value) {
        chatAndUserCollectionId = value.id;
      });

      return FirebaseFirestore.instance.collection('AllInvites').add({
        'title': iBP.title,
        'time': DateTime.now(),
        'nameOfInviter': iBP.nameOfInviter,
        'location': iBP.location,
        'shortDescription': iBP.shortDescription,
        'chatAndUsersCollection': chatAndUserCollectionId, //its and id btw
        'uIdOfInviter': iBP.uIDofInviter,
        'imageURL': downloadUrl
      });
    } else {
      throw Exception('Login first');
    }
  }

  void verifyEmail(String email) async {
    try {
      _email = email;
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
        print("this email exist in my database");
      } else {
        _loginState = ApplicationLoginState.register;
        // print("this email doesnt exist in my database");
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void registerAccount(String email, String displayName, String password,
      BuildContext context) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: password);
      await credential.user!.updateProfile(displayName: displayName);
      changeScreen(HomeScreen(), context);
    } on FirebaseAuthException catch (e) {
      print('ERROR ON LINE 94 BUDDY : $e');
      //TODO:make a AlertDialouge
    }
    notifyListeners();
  }

  void signInWithEmailAndPassword(
      //this gets you in
      String email,
      String password,
      BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: password,
      );
      changeScreen(HomeScreen(), context);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    _loginState = ApplicationLoginState.emailAddress;

    notifyListeners();
  }
}
