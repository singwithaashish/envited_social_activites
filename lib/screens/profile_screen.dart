import 'package:envited/authentication/auth.dart';
import 'package:envited/components/all_components.dart';
import 'package:envited/screens/invites_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.white,
          pinned: true,

          floating: true,
          // leading: Hero(tag: 'prof',child: ,),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Random User',
              style: TextStyle(color: Colors.red),
            ),
            centerTitle: true,
            stretchModes: [StretchMode.fadeTitle],
            background: ProfileInfo(),
          ),
          expandedHeight: 300,
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Text('tbd'); //showInvitesAttended();
          }),
        )
      ],
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://i.pinimg.com/originals/19/cf/78/19cf789a8e216dc898043489c16cec00.jpg'),
              fit: BoxFit.cover),
          // color: Colors.blueAccent,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                statsShow('69', 'Invites attended'),
                statsShow('100%', 'attending rate'),
                statsShow('⭐ * 5', 'peer review'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Container showInvitesAttended(InvitesBlueprint ibp) {
  return Container(
    margin: EdgeInsets.all(20),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.grey),
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Hero(
            tag: 'image',
            child: Image.network(
              ibp.imageURL,
              height: 400,
              width: 400,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                ibp.title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Text(ibp.nameOfInviter),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('in ${DateTime.now().difference(ibp.time)}'),
                        Text('50 kms away')
                      ], //TODO: convert latlng to distance
                    ),
                  ),
                  ElevatedButton(onPressed: () {}, child: Text('Discuss'))
                ],
              ),
              Text(ibp.shortDescription)
            ],
          ),
        ),
      ],
    ),
  );
}

Widget statsShow(String topText, String bottomText) {
  return Container(
    height: 80,
    // width: Get.size.width / 4,
    // decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10), color: Colors.purpleAccent),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            topText,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // Divider(
          //   color: Colors.black,
          //   height: 2,
          //   thickness: 2,
          // ),
          Text(
            bottomText,
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    ),
  );
}
