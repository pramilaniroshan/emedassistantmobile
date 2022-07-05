import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_colors.dart';
import '../config/app_images.dart';
import '../screens/auth/home/home_screen.dart';
import '../screens/scan_qr/scan_qr_screen.dart';

class PatientDrawer extends StatelessWidget {
  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Drawer(
      backgroundColor: AppColors.white,
      elevation: 0.0,
      child: endDrawerData(height),
    );
  }

  Widget endDrawerData(height) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40.0),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: SvgPicture.asset(
                AppImages.closeIcon,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          ListTile(
            onTap: () {
              Get.to(QRViewExample());
            },
            leading: Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 12.0),
              child: SvgPicture.asset(
                AppImages.supportIcon,
                height: 13.0,
                width: 13.0,
                fit: BoxFit.scaleDown,
                color: AppColors.secondary,
              ),
            ),
            title: const Align(
              alignment: Alignment(-1.5, 0),
              child: Text(
                'Scan QR code',
                style: TextStyle(
                  fontSize: 21.0,
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 12.0),
              child: SvgPicture.asset(
                AppImages.supportIcon,
                height: 13.0,
                width: 13.0,
                fit: BoxFit.scaleDown,
                color: AppColors.secondary,
              ),
            ),
            title: const Align(
              alignment: Alignment(-1.3, 0),
              child: Text(
                'Support',
                style: TextStyle(
                  fontSize: 21.0,
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 12.0),
              child: SvgPicture.asset(
                AppImages.contactIcon,
                height: 13.0,
                width: 13.0,
                fit: BoxFit.scaleDown,
                color: AppColors.secondary,
              ),
            ),
            title: const Align(
              alignment: Alignment(-1.3, 0),
              child: Text(
                'Contact',
                style: TextStyle(
                  fontSize: 21.0,
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 12.0),
              child: SvgPicture.asset(
                AppImages.termsIcon,
                height: 13.0,
                width: 13.0,
                fit: BoxFit.scaleDown,
                color: AppColors.secondary,
              ),
            ),
            title: const Align(
              alignment: Alignment(-1.3, 0),
              child: Text(
                'Terms',
                style: TextStyle(
                  fontSize: 21.0,
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () async {
              prefs = await SharedPreferences.getInstance();
              print(prefs.getString("token"));
            },
            leading: Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 12.0),
              child: SvgPicture.asset(
                AppImages.linkIcon,
                height: 13.0,
                width: 13.0,
                fit: BoxFit.scaleDown,
                color: AppColors.secondary,
              ),
            ),
            title: const Align(
              alignment: Alignment(-1.3, 0),
              child: Text(
                'eMed.com',
                style: TextStyle(
                  fontSize: 21.0,
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.06),
          ListTile(
            onTap: () async {
              prefs = await SharedPreferences.getInstance();
              prefs.clear();
              EasyLoading.showSuccess('Sign out');
              Get.to(const HomeScreen());
            },
            leading: Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 12.0),
              child: SvgPicture.asset(
                AppImages.linkIcon,
                height: 13.0,
                width: 13.0,
                fit: BoxFit.scaleDown,
                color: AppColors.secondary,
              ),
            ),
            title: const Align(
              alignment: Alignment(-1.3, 0),
              child: Text(
                ' Sign out',
                style: TextStyle(
                  fontSize: 21.0,
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.06),
          ListTile(
            onTap: () {},
            leading: Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 12.0),
              child: SvgPicture.asset(
                AppImages.globeIcon,
                height: 13.0,
                width: 13.0,
                fit: BoxFit.scaleDown,
                color: AppColors.secondary,
              ),
            ),
            title: const Align(
              alignment: Alignment(-1.1, 0),
              child: Text(
                'English',
                style: TextStyle(
                  fontSize: 16.0,
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down_outlined,
                color: AppColors.black),
          ),
        ],
      );
}
