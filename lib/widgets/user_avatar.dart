import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_colors.dart';
import '../services/get_patient_profile.dart';

class PatientDrawerAction extends StatelessWidget {
  PatientDrawerAction({Key? key}) : super(key: key);
  late SharedPreferences prefs;
  String? firstname;

  void getProfile() async {
    prefs = await SharedPreferences.getInstance();
    firstname = prefs.getString('firstName');
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Scaffold.of(context).openEndDrawer();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Vibhu',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          SizedBox(width: 12.0),
          Icon(Icons.menu, color: AppColors.black, size: 28.0),
          SizedBox(width: 12.0),
        ],
      ),
    );
  }
}
