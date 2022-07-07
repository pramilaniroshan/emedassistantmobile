import 'package:easy_localization/easy_localization.dart';
import 'package:emedassistantmobile/config/app_images.dart';
import 'package:emedassistantmobile/screens/auth/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('si', 'LK')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'eMed App',
      theme: Themes.light,
      darkTheme: Themes.dark,
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
