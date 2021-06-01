import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void changeScreen(Widget whatPage, BuildContext context) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    return whatPage;
  }));
}
