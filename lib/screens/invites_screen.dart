import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:envited/authentication/auth.dart';
import 'package:envited/components/all_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvitesScreen extends StatelessWidget {
  InvitesScreen({required this.invitesBlueprint});
  final InvitesBlueprint invitesBlueprint;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance.collection('chatAndUsersCollection').snapshots();
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //         var doc = snapshot.data.documents;
      //         return

      //         }
      //   }
      //   ),
    );
  }
}
