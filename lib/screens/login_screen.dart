// import 'package:envited/authentication/auth.dart';
// import 'package:envited/components/all_components.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:envited/authentication/auth.dart';
import 'package:envited/screens/constants.dart';
import 'package:envited/widgets/login_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController eC = new TextEditingController(),
      pwC = new TextEditingController(),
      unC = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     'Welcome Back',
      //     style: TextStyle(color: kTextColor),
      //   ),
      //   elevation: 0,
      //   backgroundColor: kThemeColor,
      // ),
      body: Container(
        // color: kThemeColor,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black, Colors.deepPurple.shade800])),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            // SizedBox(
            //   height: screenSize.height / 2,
            // ),
            // Consumer<Authentication>(builder: (context, authentication, _) {
            //   return Column(children: [
            //     loginPhase(authentication, context),
            //   ]);
            // }),

            Text('Welcome'),
            Image.asset(
              'assets/resort_1.jpeg',
              // 'https://images-na.ssl-images-amazon.com/images/I/81S8MPFKsHL._AC_SL1500_.jpg',
              width: 2,
              height: 150,
            ),
            customTextField(eC, 'Email'),
            customTextField(pwC, 'Password'),
            TextButton(onPressed: () {}, child: Text('forgot password?')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {
                      print("atleast im trying");
                      Provider.of<Authentication>(context, listen: false)
                          .signInWithEmailAndPassword(eC.text, pwC.text);
                    },
                    child: customButtonStyle('login fuck')),
                TextButton(
                    onPressed: () {
                      Provider.of<Authentication>(context, listen: false)
                          .signInWithGoogle();
                    },
                    child: customButtonStyle('Sign Up')),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: Divider(
                    height: 40,
                    thickness: 1,
                    color: Colors.black,
                  ),
                ),
                Text('OR'),
                Expanded(
                  child: Divider(
                    height: 40,
                    thickness: 1,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            customButtonStyle('Sign in with Google'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () {}, child: Text('Terms of Service')),
                Divider(
                  thickness: 10,
                  height: 10,
                  color: Colors.black,
                ),
                TextButton(onPressed: () {}, child: Text('Privacy policy'))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key, required this.authentication}) : super(key: key);
  final Authentication authentication;
  late DateTime dob;
  late bool isFemale;
  final TextEditingController eC = new TextEditingController(),
      pwC = new TextEditingController(),
      rePwC = new TextEditingController(),
      firstNameC = new TextEditingController(),
      lastNameC = new TextEditingController();
  // eC = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: kThemeColor,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black, Colors.deepPurple.shade800])),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Text('Welcome'),
            Image.asset(
              'assets/resort_1.jpeg',
              // 'https://images-na.ssl-images-amazon.com/images/I/81S8MPFKsHL._AC_SL1500_.jpg',
              width: 2,
              height: 150,
            ),
            customTextField(eC, 'Email'),
            customTextField(firstNameC, 'First name'),
            customTextField(lastNameC, 'Last name'),
            customTextField(pwC, 'Password'),
            customTextField(rePwC, 'Confirm Password'),
            DateTimePicker(
              initialValue: 'Enter your happy bday',
              firstDate: DateTime.now().subtract(Duration(days: 26000)),
              icon: Icon(Icons.calendar_today),
              lastDate: DateTime.now(),
              dateLabelText: 'Date',
              timeFieldWidth: 50,
              type: DateTimePickerType.date,
              onChanged: (val) {
                print(DateTime.parse(val));
                dob = DateTime.parse(val);
              },
              validator: (val) {
                print('validator $val');
                return null;
              },
              onSaved: (val) => print(val),
            ),
            IconButton(
                onPressed: () async {
                  await authentication.uploadPic();
                },
                icon: Icon(Icons.image)),
            // DropdownButton(items: [
            //   DropdownMenuItem(
            //     child: Text('male'),
            //     onTap: () {
            //       isFemale = false;
            //     },
            //   ),
            //   DropdownMenuItem(
            //     child: Text('male'),
            //     onTap: () {
            //       isFemale = false;
            //     },
            //   ),
            // ]),
            // TextButton(onPressed: () {}, child: Text('forgot password?')),
            TextButton(
                onPressed: () {
                  Provider.of<Authentication>(context, listen: false)
                      .createNewUser(eC.text, pwC.text, firstNameC.text,
                          lastNameC.text, DateTime.now(), false);
                  // print(dob);
                },
                child: Text('sign up')),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    height: 40,
                    thickness: 1,
                    color: Colors.black,
                  ),
                ),
                Text('OR'),
                Expanded(
                  child: Divider(
                    height: 40,
                    thickness: 1,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            customButtonStyle('Sign in with Google'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () {}, child: Text('Terms of Service')),
                Divider(
                  thickness: 10,
                  height: 10,
                  color: Colors.black,
                ),
                TextButton(onPressed: () {}, child: Text('Privacy policy'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
