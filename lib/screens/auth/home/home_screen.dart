import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:emedassistantmobile/config/app_colors.dart';
import 'package:emedassistantmobile/config/app_images.dart';
import 'package:emedassistantmobile/widgets/clipper.dart';
import 'package:emedassistantmobile/widgets/custom_button.dart';
import 'package:emedassistantmobile/widgets/custom_field.dart';
//import 'package:emedassistantmobile/screens/profile_setup/setup_one_screen.dart';
import 'package:emedassistantmobile/screens/scan_qr/scan_qr_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController smsController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.lightBackground,
      bottomNavigationBar: bottomBar(width),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: SvgPicture.asset(AppImages.eMedLogo),
        ),
        leadingWidth: 110.0,
        actions: [
          menuButton(),
        ],
      ),

      endDrawer: Drawer(
        backgroundColor: AppColors.white,
        elevation: 0.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40.0),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: (){
                  Get.back();
                },
                icon: SvgPicture.asset(
                  AppImages.closeIcon,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ListTile(
              onTap: (){},
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
                child: Text('Support',
                  style: TextStyle(
                    fontSize: 21.0,
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: (){},
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
                child: Text('Contact',
                  style: TextStyle(
                    fontSize: 21.0,
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: (){},
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
                child: Text('Terms',
                  style: TextStyle(
                    fontSize: 21.0,
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: (){},
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
                child: Text('eMed.com',
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
              onTap: (){},
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
                child: Text('English',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              trailing: const Icon(Icons.keyboard_arrow_down_outlined, color: AppColors.black),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(AppImages.homeImage),
            const SizedBox(height: 12.0),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text('Welcome to eMed Assistant',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                color: AppColors.lightBlack,
              ),
              ),
            ),
            const SizedBox(height: 10.0),
            emailSMSRow(),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomField(
                height: 50.0,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                padding: const EdgeInsets.only(bottom: 0.0, left: 16.0),
                hintText: 'Your email',
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    onTap: (){
                      Get.defaultDialog(
                        backgroundColor: AppColors.lightBackground,
                        radius: 2.0,
                        title: '',
                        content: bottomSheetColumn(width),
                      );
                    },
                    btnText: 'Submit',
                    width: 80.0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text('Don\'t have an account yet?',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Join now as',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  CustomButton(
                    onTap: (){},
                    btnText: 'Doctor',
                    width: 80.0,
                    btnColor: AppColors.white,
                    fontColor: AppColors.secondary,
                    borderColor: AppColors.secondary,
                  ),
                  const SizedBox(width: 8.0),
                  const Text('or',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  CustomButton(
                    onTap: (){},
                    btnText: 'Patient',
                    width: 80.0,
                    btnColor: AppColors.white,
                    fontColor: AppColors.secondary,
                    borderColor: AppColors.secondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuButton() => TextButton(
    onPressed: (){
      _scaffoldKey.currentState!.openEndDrawer();
    },
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        Text('Menu',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: 5.0),
        Icon(Icons.menu, color: AppColors.black, size: 28.0),
        SizedBox(width: 12.0),
      ],
    ),
  );

  Widget bottomBar(width) => Container(
    height: 50.0,
    width: width,
    color: AppColors.white,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('@2022 EMED Limited - Company number 123456789',
          style: TextStyle(
            fontSize: 12.0,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8.0),
        SvgPicture.asset(AppImages.eMedIcon, height: 20.0, width: 20.0),
      ],
    ),
  );

  Widget clipTopImage(height, width) =>  ClipPath(
    clipper: NativeClipper(),
    child: Stack(
      children: [
        SizedBox(
          height: height * 0.4,
          width: width,
          child: Image.asset(AppImages.doctorImage,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          height: height * 0.4,
          color: Colors.red.withOpacity(0.85),
        ),
        SizedBox(
          height: height * 0.3,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('We care \nabout your \nhealth',
                  style: TextStyle(
                    fontSize: 40.0,
                    color: AppColors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 70.0),
                child: Text('eMed is your Assistent in Lorem Ipsum is simply '
                    'dummy text of the printing and typesetting industry. '
                    'Lorem Ipsum has been the industry\'s standard dummy text '
                    'ever since the 1500s,',
                  maxLines: 4,
                  style: TextStyle(
                    fontSize: 13.0,
                    color: AppColors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget emailSMSRow() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Text('Sign in',
            style: TextStyle(
              fontSize: 28.0,
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Bounceable(
              onTap: (){},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                  border: Border.all(
                    color: AppColors.secondary,
                    width: 1.5,
                  ),
                ),
                child: const Text('Email',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Bounceable(
              onTap: (){},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                child: const Text('SMS',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget bottomSheetColumn(width) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10.0),
          SvgPicture.asset(AppImages.termsIcon, height: 20.0, width: 20.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Authentication',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14.0),
                const Text('We have sent you the access code',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 14.0),
                const Text('Attention, the code will expire in 5',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  height: 35.0,
                  width: width,
                  margin: const EdgeInsets.only(right: 16.0, top: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  child: TextFormField(
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'code',
                      contentPadding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        onTap: (){
                         // Get.to(ProfileSetupOneScreen());
                          Get.to(ScanQrScreen());
                        },
                        btnText: 'Submit',
                        width: 80.0,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: (){},
                  child: const Text('Send me again the verification code',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
