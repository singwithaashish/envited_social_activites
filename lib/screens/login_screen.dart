// import 'package:envited/authentication/auth.dart';
// import 'package:envited/components/all_components.dart';
import 'package:envited/authentication/auth.dart';
import 'package:envited/screens/constants.dart';
import 'package:envited/widgets/login_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Welcome Back',
          style: TextStyle(color: kTextColor),
        ),
        elevation: 0,
        backgroundColor: kThemeColor,
      ),
      body: Container(
        color: kThemeColor,
        child: ListView(
          children: [
            SizedBox(
              height: screenSize.height / 3,
            ),
            Consumer<Authentication>(builder: (context, authentication, _) {
              return Column(children: [
                loginPhase(authentication, context),
              ]);
            }),
          ],
        ),
      ),
    );
  }
}
