import 'package:emedassistantmobile/config/colors.dart';
import 'package:emedassistantmobile/config/constants.dart';
import 'package:emedassistantmobile/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;


void main() {
  runApp( MaterialApp(theme :ThemeData(
    primarySwatch: Colors.yellow,
  ),home: LoginScreen(),),);
  
}