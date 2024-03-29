import 'package:envited/authentication/auth.dart';
import 'package:envited/components/all_components.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:envited/components/methods.dart';
import 'package:envited/screens/constants.dart';
import 'package:envited/screens/invites_screen.dart';
import 'package:envited/screens/location_picker.dart';
import 'package:envited/screens/profile_screen.dart';
import 'package:envited/widgets/login_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titC = new TextEditingController(),
      desC = new TextEditingController();

  final TemporaryInvite temporaryInvite = new TemporaryInvite();
  int selectedIndex = 0;
  final tabs = [
    HomeWidget(),
    AttendingScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kThemeColor,
        title: Text('ENVITED'),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<Authentication>(context, listen: false).signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: tabs[selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context, temporaryInvite, titC, desC);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.watch), label: 'Attending'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        currentIndex: selectedIndex,
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Authentication>(
      builder: (context, value, child) {
        // print(value.allInvites);

        return value.allInvites != []
            ? ListView.builder(
                itemCount: value.allInvites.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return InvitesScreen(
                            invitesBlueprint: value.allInvites[index],
                          );
                        }));
                      },
                      child: showInvitesAttended(value.allInvites[index]));
                },
              )
            : CircularProgressIndicator();
      },
    );
  }
}

class AttendingScreen extends StatelessWidget {
  const AttendingScreen({Key? key /*, required this.invitesBlueprint*/})
      : super(key: key);
  // final InvitesBlueprint invitesBlueprint;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Authentication>(context).allInvitesByUser(),
      // initialData: Center(child: CircularProgressIndicator()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return showInvitesAttended(snapshot.data);
                },
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

void _showBottomSheet(BuildContext context, TemporaryInvite temporaryInvite,
    TextEditingController titC, TextEditingController desC) {
  showModalBottomSheet(
      //TODO:wrap with consumer and show an image if done picking
      elevation: 0,
      context: context,
      builder: (context) {
        return Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                customTextField(titC, 'TITLE'), //title picker
                customTextField(desC, 'Description'), //description picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      //location picker
                      onPressed: () {
                        showModalBottomSheet(
                            enableDrag: false,
                            // isScrollControlled: false,
                            context: context,
                            builder: (context) {
                              return MapSample(
                                tinv: temporaryInvite,
                              );
                            });
                      },
                      icon: Icon(Icons.location_pin),
                    ),
                    Container(
                      //date time picker
                      width: 20,
                      height: 20,
                      child: DateTimePicker(
                        initialValue: '',
                        firstDate: DateTime.now(),
                        icon: Icon(Icons.calendar_today),
                        lastDate: DateTime.now().add(Duration(days: 7)),
                        dateLabelText: 'Date',
                        timeFieldWidth: 50,
                        type: DateTimePickerType.dateTime,
                        onChanged: (val) {
                          print(DateTime.parse(val));
                          temporaryInvite.time = DateTime.parse(val);
                        },
                        validator: (val) {
                          print('validator $val');
                          return null;
                        },
                        onSaved: (val) => print(val),
                      ),
                    ),
                    IconButton(
                      //photo picker
                      onPressed: () async {
                        //TODO: show a spinner
                        temporaryInvite.nameOfInviter =
                            FirebaseAuth.instance.currentUser!.displayName ??
                                'Null';
                        await Provider.of<Authentication>(context,
                                listen: false)
                            .uploadPic();
                      },
                      icon: Icon(Icons.photo),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    InvitesBlueprint ibV = new InvitesBlueprint(
                        title: titC.text,
                        time: DateTime.now(),
                        nameOfInviter: temporaryInvite.nameOfInviter,
                        location: temporaryInvite.location,
                        shortDescription: desC.text,
                        imageURL: 'temporaryInvite.imageurl',
                        chatAndUsersCollection: ' ',
                        isPrivate: false,
                        uIDofInviter:
                            FirebaseAuth.instance.currentUser?.uid ?? 'null');
                    Provider.of<Authentication>(context, listen: false)
                        .addInvites(ibV)
                        .then((value) {
                      print(value.id);
                    });
                    print('temporaryInvite.location');
                    Navigator.pop(context);
                  },
                  child: Container(
                    // width: MediaQuery.of(context).size.width / 2,
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      child: Text(
                        'UPLOAD',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}

Widget inviteView(InvitesBlueprint ivB, var screenSize) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
    child: Container(
      // height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(children: [
        Hero(
            tag: 'tag',
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(200)),
              child: Image.network(
                ivB.imageURL,
                fit: BoxFit.cover,
                height: 300,
                width: screenSize.width,
              ),
            )),
        Container(
          // padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: kThemeColor),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person),
                        Text(
                          ivB.nameOfInviter,
                          style: TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_city_outlined),
                              Text(
                                ivB.location.toString(),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.lock_clock),
                              Text(ivB.time.toString(),
                                  overflow: TextOverflow.fade)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Text(
                ivB.title,
                style: TextStyle(fontSize: 25, color: Colors.red),
              ),
              Text(
                ivB.shortDescription,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ]),
    ),
  );
}
