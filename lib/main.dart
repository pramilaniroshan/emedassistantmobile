import 'package:emedassistantmobile/config/app_images.dart';
import 'package:emedassistantmobile/screens/auth/home/home_screen.dart';
import 'package:emedassistantmobile/screens/my_appointments/my_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // //prefs.getString('login');
  // print(prefs.getBool('login'));
  // print(prefs.getBool('login'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    // var isLoggedUser = prefs.then((value) {
    //   value..getBool('login');
    //   return value..getBool('login');
    // });

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eMed App',
      theme: Themes.light,
      darkTheme: Themes.dark,
      //themeMode: ThemeService().theme,

      //home: CreateProfileScreen(),
      home: AnimatedSplashScreen(
          duration: 500,
          splash: SvgPicture.asset(AppImages.eMedLogo,
              height: 50, width: 50, fit: BoxFit.scaleDown),
          nextScreen: const HomeScreen(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.white),
      builder: EasyLoading.init(),
    );
  }
}

class Themes {
  static final light = ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: 'Roboto',
  );
  static final dark = ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: 'Roboto',
  );
}
