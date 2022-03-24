import 'package:emedassistantmobile/config/app_colors.dart';
import 'package:emedassistantmobile/screens/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp( MaterialApp(theme :ThemeData(
    primarySwatch: Colors.blue,
  ),home:const SignInScreen()),);
  
}