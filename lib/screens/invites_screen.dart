import 'package:envited/components/all_components.dart';
import 'package:envited/screens/messaging_screen.dart';

import 'package:flutter/material.dart';

class InvitesScreen extends StatelessWidget {
  InvitesScreen({required this.invitesBlueprint});
  final InvitesBlueprint invitesBlueprint;
  final TextEditingController messageTextEditingController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MessagingScreen(
          messageTextEditingController: messageTextEditingController),
    );
  }
}
