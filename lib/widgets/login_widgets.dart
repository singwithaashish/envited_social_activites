import 'package:envited/authentication/auth.dart';
import 'package:envited/components/all_components.dart';
import 'package:envited/components/methods.dart';
import 'package:envited/screens/constants.dart';
import 'package:envited/screens/home_screen.dart';
import 'package:envited/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class LoginOptions extends StatelessWidget {
//   // LoginOptions({required this.context});
//   // final BuildContext context;
//   final TextEditingController eC = new TextEditingController(),
//       pwC = new TextEditingController(),
//       regC = new TextEditingController(); //username

//   @override
//   Widget build(BuildContext context) {
//     final ApplicationLoginState loginState =
//         Provider.of<Authentication>(context).loginState;

// }

// Widget loginPhase(Authentication authentication, BuildContext context) {
//   final TextEditingController eC = new TextEditingController(),
//       pwC = new TextEditingController(),
//       unC = new TextEditingController();

//   switch (authentication.loginState) {
//     case ApplicationLoginState.emailAddress:
//       // eC.clear();
//       return Column(
//         children: [
//           customTextField(eC, 'Email'),
//           TextButton(
//             onPressed: () {
//               print('GIVEN EMAIL: ${eC.text}');
//               // authentication.memail = eC.text;
//               authentication.verifyEmail(eC.text);
//             },
//             child: customButtonStyle(),
//           ),
//           // IconButton(
//           //     onPressed: () {
//           //       print('GIVEN EMAIL: ${eC.text}');
//           //       // authentication.memail = eC.text;
//           //       authentication.verifyEmail(eC.text);
//           //     },
//           //     icon: Icon(Icons.arrow_right_rounded))
//         ],
//       );
//     case ApplicationLoginState.password:
//       return Column(
//         children: [
//           customTextField(pwC, 'Password'),
//           TextButton(
//             onPressed: () {
//               authentication.signInWithEmailAndPassword(
//                   eC.text, pwC.text, context);
//             },
//             child: customButtonStyle(),
//           )
//         ],
//       );
//     case ApplicationLoginState.register:
//       return Column(
//         children: [
//           customTextField(unC, 'Username'), //username
//           customTextField(pwC, 'Password'), //password
//           // TextField(), //reenter password
//           TextButton(
//             onPressed: () {
//               print(eC.text);
//               authentication.registerAccount(
//                   eC.text, unC.text, pwC.text, context);
//             },
//             child: customButtonStyle(),
//           )
//         ],
//       );
//   }
// }

Container customButtonStyle(String text) {
  return Container(
    // width: 150,
    // height: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      gradient: LinearGradient(colors: [Colors.red, Colors.cyan]),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(color: kTextColor, fontSize: 20),
        ),
      ),
    ),
  );
}

Padding customTextField(TextEditingController tec, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: TextField(
      controller: tec,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black, fontSize: 15),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none),
        fillColor: Color.fromRGBO(200, 200, 200, 50),
        focusColor: Colors.red,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
