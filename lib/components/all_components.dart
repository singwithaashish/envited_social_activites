// import 'dart:html';

// import 'dart:html';

class InvitesBlueprint {
  final String title;
  // final Image picture;
  final String imageURL;
  // late List<MessageBlueprint> allMessages; //gonna be added later
  final String chatAndUsersCollection;
  // late List<UserBlueprint> usersGoing; //gonna be added later
  final String nameOfInviter; //get name
  final String uIDofInviter; //get uid
  final String location; //get location
  final String shortDescription;
  final DateTime time;
  //TODO: add Image url and list of users going and messages list

  InvitesBlueprint(
      {required this.title,
      required this.time,
      required this.nameOfInviter,
      required this.location,
      required this.shortDescription,
      required this.chatAndUsersCollection,
      required this.uIDofInviter,
      required this.imageURL});
}

class UserBlueprint {
  final String username;
  final String userId;
  final String linkToProfilePhoto;
  // final List<InvitesBlueprint> allInvitesAttended; //add it to firebaseuser instead
  final Status premiumStatus;

  UserBlueprint(
      {required this.username,
      required this.userId,
      required this.linkToProfilePhoto,
      required this.premiumStatus});
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
  late String location;
  late String imageurl;
}

enum ApplicationLoginState {
  emailAddress,
  register,
  password,
}
