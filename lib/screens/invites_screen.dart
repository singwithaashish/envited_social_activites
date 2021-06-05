import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:envited/components/all_components.dart';
import 'package:envited/screens/constants.dart';
import 'package:envited/screens/messaging_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InvitesScreen extends StatelessWidget {
  InvitesScreen({required this.invitesBlueprint});
  final InvitesBlueprint invitesBlueprint;
  final TextEditingController messageTextEditingController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: kThemeColor, actions: [
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return MessagingScreen(
                        messageTextEditingController:
                            messageTextEditingController);
                  });
            },
            child: Text(
              'Discuss',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ]),
        body: Column(
          // mainAxisAliglabelnment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text(invitesBlueprint.nameOfInviter),
                  Hero(
                      tag: 'tag',
                      child: Image.network(invitesBlueprint.imageURL)),
                  Text(
                    invitesBlueprint.title,
                    style: TextStyle(fontSize: 30, color: Colors.amber),
                  ),
                  Text(invitesBlueprint.shortDescription),
                  Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      markers: {
                        Marker(
                            markerId: MarkerId('value'),
                            position: invitesBlueprint.location),
                      },
                      initialCameraPosition: CameraPosition(
                        target: invitesBlueprint.location,
                        zoom: 14.4746,
                      ),
                    ),
                  ),
                  Text('Date & time : ${invitesBlueprint.time}')
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                //TODO:change button's color to green if attending
                acceptInvite();
              },
              // icon: Icon(Icons.check),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.red,
                child: Center(
                    child: Text(
                  'Accept Invite',
                  style: TextStyle(color: Colors.white),
                )),
              ),
            )
          ],
        ));
  }
}

Future<void> acceptInvite() async {
  //TODO:check if user is already attending and change state of accept invite or leave
  print(await hasUserJoined());
  FirebaseFirestore.instance
      .collection('chatAndUsersCollection')
      .doc('T32Jqmdq5c1sMWIOeRhj')
      .collection('AllAttendees')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .set({'timeOfJoin': DateTime.now(), 'wasInvited': false}).onError(
          (error, stackTrace) => print(error));
  print('it did something');
}

Future<bool> hasUserJoined() async {
  bool huh = false;

  FirebaseFirestore.instance
      .collection('chatAndUsersCollection')
      .doc('T32Jqmdq5c1sMWIOeRhj')
      .collection('AllAttendees')
      // .doc('GGbBJY8nLQBUERvhD0G4')
      .snapshots()
      .listen((event) {
    event.docs.forEach((element) {
      // print(element.id);
      if (element.id == FirebaseAuth.instance.currentUser!.uid) {
        huh = true;
      }
    });
    // doneChecking = true;
  });

  await Future.delayed(Duration(seconds: 1));
  return huh;
}
