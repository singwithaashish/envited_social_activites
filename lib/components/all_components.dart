// import 'dart:html';

// import 'dart:html';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class InvitesBlueprint {
  final String title;
  // final Image picture;
  final String imageURL;
  // late List<MessageBlueprint> allMessages; //gonna be added later
  final String chatAndUsersCollection;
  // late List<UserBlueprint> usersGoing; //gonna be added later
  final String nameOfInviter; //get name
  final String uIDofInviter; //get uid
  final LatLng location; //get location
  final String shortDescription;
  final DateTime time;
  final bool isPrivate;
  //TODO: add Image url and list of users going and messages list

  InvitesBlueprint(
      {required this.title,
      required this.time,
      required this.nameOfInviter,
      required this.location,
      required this.shortDescription,
      required this.chatAndUsersCollection,
      required this.uIDofInviter,
      required this.imageURL,
      required this.isPrivate});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'nameOfInviter': nameOfInviter,
      'location': location,
      'shortDescription': shortDescription,
      'chatAndUsersCollection': chatAndUsersCollection,
      'uIDofInviter': uIDofInviter,
      'imageURL': imageURL,
      'isPrivate': isPrivate
    };
  }
}

class UserBlueprint {
  final String firstName;
  final String lastName;
  final bool isFemale;
  late List<String> idsOfInviteAttended;
  final DateTime dob;
  final int inviteAttendanceRate;
  final int peerReview;
  final String linkToProfilePhoto;
  // final List<InvitesBlueprint> allInvitesAttended; //add it to firebaseuser instead
  final bool isPremium;

  UserBlueprint(
      {required this.firstName,
      required this.lastName,
      required this.linkToProfilePhoto,
      required this.isFemale,
      required this.isPremium,
      required this.inviteAttendanceRate,
      required this.peerReview,
      required this.dob,
      required this.idsOfInviteAttended});

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'linkToProfilePhoto': linkToProfilePhoto,
      'isFemale': isFemale,
      'isPremium': isPremium,
      'dob': dob
    };
  }
}

enum Status {
  LongTermUser, //attended 50 invites chad
  Subscriber, //monthly subscriber
  Donator, //one time supporter
  Basic //freemium virgin
}

class MessageBlueprint {
  final String messageText;
  final String nameOfSender;
  final String uIdOfSender;
  final String photoLinkOfSender;
  final DateTime timeOfSending;
  //final Status premiumStatusOfSender;
  MessageBlueprint(
      {required this.messageText,
      required this.nameOfSender,
      required this.photoLinkOfSender,
      required this.uIdOfSender,
      required this.timeOfSending});
}

class TemporaryInvite {
  late String title;
  // late List<String> allGoing;
  late String shortDescription;
  late DateTime time;
  late String nameOfInviter;
  late LatLng location;
  late String imageurl;
}

enum ApplicationLoginState {
  emailAddress,
  register,
  password,
}
