import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:envited/components/all_components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({
    Key? key,
    required this.messageTextEditingController,
  }) : super(key: key);

  final TextEditingController messageTextEditingController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatAndUsersCollection')
          .doc('T32Jqmdq5c1sMWIOeRhj')
          .collection('AllMessages')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var doc = snapshot.data!.docs;
          return Column(
            children: [
              Expanded(
                // child: Text(doc[0].get('messages').toString()),
                child: Container(
                  child: ListView.builder(
                      itemCount: doc.length,
                      itemBuilder: (BuildContext context, int index) {
                        MessageBlueprint message = MessageBlueprint(
                            messageText: doc[index].get('messageText'),
                            nameOfSender: doc[index].get('nameOfSender'),
                            photoLinkOfSender:
                                doc[index].get('photoLinkOfSender'),
                            uIdOfSender: doc[index].get('uIdOfSender'),
                            timeOfSending:
                                doc[index].get('timeOfSending').toDate());
                        return _buildMessage(
                            message,
                            doc[index].get('uIdOfSender') ==
                                FirebaseAuth.instance.currentUser?.uid,
                            context);
                        // return Text(doc[index].get('messageText').toString());
                      }),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                height: 70.0,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.photo),
                      iconSize: 25.0,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        controller: messageTextEditingController,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (value) {},
                        decoration: InputDecoration.collapsed(
                          hintText: 'Send a message...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      iconSize: 25.0,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        addMessages(MessageBlueprint(
                            messageText: messageTextEditingController.text,
                            nameOfSender: FirebaseAuth
                                    .instance.currentUser?.displayName ??
                                'illegal',
                            photoLinkOfSender:
                                FirebaseAuth.instance.currentUser?.photoURL ??
                                    'illegal',
                            uIdOfSender:
                                FirebaseAuth.instance.currentUser?.uid ??
                                    'illegal',
                            timeOfSending: DateTime.now()));
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

Future<void> addMessages(MessageBlueprint messageBlueprint) async {
  FirebaseFirestore.instance
      .collection('chatAndUsersCollection')
      .doc('T32Jqmdq5c1sMWIOeRhj')
      .collection('AllMessages')
      .add({
    'messageText': messageBlueprint.messageText,
    'nameOfSender': messageBlueprint.nameOfSender,
    'photoLinkOfSender': messageBlueprint.photoLinkOfSender,
    'uIdOfSender': messageBlueprint.uIdOfSender,
    'timeOfSending': messageBlueprint.timeOfSending
  });
  // print('it did something');
}

Widget _buildMessage(
    MessageBlueprint message, bool isMe, BuildContext context) {
  return Container(
    margin: isMe
        ? EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 80.0,
          )
        : EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
          ),
    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
    width: MediaQuery.of(context).size.width * 0.75,
    decoration: BoxDecoration(
      color: isMe ? Colors.black : Color(0xFFFFEFEE),
      borderRadius: isMe
          ? BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            )
          : BorderRadius.only(
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          message.timeOfSending.toString(),
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          message.messageText,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
