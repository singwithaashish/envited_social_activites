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
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

          event.docs.forEach((event) {
            // print(event.data());
            try {
              _allInvites.add(
                InvitesBlueprint(
                    title: event.data()['title'],
                    time: event.data()['time'].toDate(),
                    nameOfInviter: event.data()['nameOfInviter'],
                    location: LatLng(event.data()['location'].latitude,
                        event.data()['location'].longitude),
                    shortDescription: event.data()['shortDescription'],
                    chatAndUsersCollection:
                        event.data()['chatAndUsersCollection'],
                    uIDofInviter: event.data()['uIdOfInviter'],
                    imageURL: event.data()['imageURL'],
                    isPrivate: event.data()['isPrivate']),
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

      var chatAndUserCollectionId;
      await FirebaseFirestore.instance
          .collection('chatAndUsersCollection')
          .add({
        'timeCreated': DateTime.now(),
      }).then((value) {
        chatAndUserCollectionId = value.id;
      }); //get the chat and collection uid to store in all invites for refrence

      // return FirebaseFirestore.instance
      //     .collection('AllInvites')
      //     .add(iBP.toJson());

      return FirebaseFirestore.instance.collection('AllInvites').add({
        'title': iBP.title,
        'time': DateTime.now(),
        'nameOfInviter': iBP.nameOfInviter,
        'location': GeoPoint(iBP.location.latitude, iBP.location.longitude),
        'shortDescription': iBP.shortDescription,
        'chatAndUsersCollection': chatAndUserCollectionId, //its and id btw
        'uIdOfInviter': iBP.uIDofInviter,
        'imageURL': downloadUrl,
        'isPrivate': iBP.isPrivate
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

  Future<void> registerAccount(
      String email, String displayName, String password) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: password);
      await credential.user!.updateProfile(displayName: displayName);
      // changeScreen(HomeScreen(), context);
    } on FirebaseAuthException catch (e) {
      print('ERROR ON LINE 94 BUDDY : $e');
      //TODO:make an AlertDialouge
    }
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

  Future<void> createNewUser(String email, String password, String firstName,
      String lastName, DateTime dob, bool isFemale) async {
    //create new user
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: password);
      await credential.user!.updateProfile(displayName: firstName);
      // changeScreen(HomeScreen(), context);
    } on FirebaseAuthException catch (e) {
      print('ERROR ON LINE 94 BUDDY : $e');
      //TODO:make an AlertDialouge
    }
    //upload an image and get url
    var snapshot = await _storage
        .ref()
        .child(
            'UsersProfilePics/${FirebaseAuth.instance.currentUser!.uid.toString()}')
        .putFile(File(res![0].path));
    String downloadUrl = await snapshot.ref.getDownloadURL();
    //get uid and create new doc with that id under all user
    await FirebaseFirestore.instance
        .collection('AllUsers')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
      'firstName': firstName,
      'lastName': lastName,
      'linkToProfilePhoto': downloadUrl,
      'isFemale': isFemale,
      'isPremium': false,
      'dob': dob,
      'email': FirebaseAuth.instance.currentUser!.email,
      'peerRating': 0,
      'attendingRatio': 0,
      'idsOfInviteAttended': [],
    }).onError((error, stackTrace) => print(error));
    notifyListeners();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    _loginState = ApplicationLoginState.emailAddress;

    notifyListeners();
  }
}
