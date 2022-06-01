import 'dart:html';

import 'package:emedassistantmobile/config/app_colors.dart';
import 'package:emedassistantmobile/config/app_images.dart';
import 'package:emedassistantmobile/screens/auth/home/home_screen.dart';
import 'package:emedassistantmobile/screens/book_an_appointment/book_an_appointment_screen.dart';
import 'package:emedassistantmobile/screens/book_an_appointment/patient_booking_screen.dart';
import 'package:emedassistantmobile/screens/my_appointments/my_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async{
SharedPreferences prefs = await SharedPreferences.getInstance();
bool isLoggedIn = true;
 runApp( const MyApp());  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    

    
    
    return GetMaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'eMed App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      //home: CreateProfileScreen(),
      home: AnimatedSplashScreen(
            duration: 3000,
            splash: SvgPicture.asset(AppImages.eMedLogo,height: 50, width: 50,
      fit: BoxFit.scaleDown),
            nextScreen: false ? MyAppointmentsScreen() : HomeScreen(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white));
  }

  // Future <bool> checkLogin() async {
  
  
  // if(prefs.containsKey('Jwt_token')){
  //   return true;
  // }
  // return false;
  //}
  
}