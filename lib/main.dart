import 'package:envited/authentication/auth.dart';
import 'package:envited/screens/constants.dart';
import 'package:envited/screens/home_screen.dart';
import 'package:envited/screens/location_picker.dart';
import 'package:envited/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: Authentication())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(brightness: Brightness.dark),
        color: kThemeColor,
        home:
            HomeScreen(), //TODO: check if user's signed in and navigate to respective screen
      ),
    );
  }
}
