import 'package:emedassistantmobile/models/test_model.dart';
import 'package:emedassistantmobile/screens/my_appointments/my_appointment_screen.dart';
import 'package:emedassistantmobile/screens/profile/create_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:form_validator/form_validator.dart';

import 'package:emedassistantmobile/config/app_colors.dart';
import 'package:emedassistantmobile/config/app_images.dart';
import 'package:emedassistantmobile/widgets/clipper.dart';
import 'package:emedassistantmobile/widgets/custom_button.dart';
import 'package:emedassistantmobile/widgets/custom_field.dart';
//import 'package:emedassistantmobile/screens/profile_setup/setup_one_screen.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/constants.dart';
import '../../../services/get_patient_profile.dart';
import '../../../widgets/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController smsController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  late SharedPreferences prefs;
  late bool user;
  String error = "";

  bool isemailtab = true;

  final List<Posts> posts = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  FToast? fToast;

  void check_if_already_login() async {
    prefs = await SharedPreferences.getInstance();

    user = (prefs.getBool('login') ?? false);
    print(prefs.getBool('login'));
    if (user == true) {
      Get.to(const MyAppointmentsScreen());
    }
  }

  Future<void> login(double width) async {
    EasyLoading.show(status: 'loading...');
    try {
      var dio = Dio();
      await dio
          .post(Constants().getBaseUrl() + '/Authentication/Login-init', data: {
        "Username": emailController.text,
        "UserLoginType": isemailtab ? 0 : 1,
        "CountryCode": 210,
        "Application": 0
      }).then((res) {
        if (res.statusCode == 200) {
          EasyLoading.dismiss();
          EasyLoading.showSuccess('Code sent');
          //showErrorToast(fToast: fToast, isError: false, msg: 'Code sent');
          Get.defaultDialog(
            backgroundColor: AppColors.lightBackground,
            radius: 2.0,
            title: '',
            content: bottomSheetColumn(width),
          );
        }
      });
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        EasyLoading.dismiss();
        var t = e.response!.data["Error"];
        EasyLoading.showError(
            e.response!.data["Error"] ?? 'Something went wrong');
        // showErrorToast(
        //     fToast: fToast, isError: true, msg: e.response!.data["Error"]);
        setState(() {
          error = t;
        });
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError('Something went wrong');
        //showErrorToast(fToast: fToast, isError: true, msg: e.message);
      }
    }
  }

  Future<void> loginResend() async {
    try {
      var dio = Dio();
      await dio
          .post(Constants().getBaseUrl() + '/Authentication/Login-init', data: {
        "Username": emailController.text,
        "UserLoginType": isemailtab ? 0 : 1,
        "CountryCode": 210,
        "Application": 0
      }).then((res) {
        if (res.statusCode == 200) {
          //showErrorToast(fToast: fToast, isError: false, msg: 'Code sent');
          EasyLoading.showSuccess('Code Sent');
        }
      });
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        var t = e.response!.data["Error"];
        EasyLoading.showError(
            e.response!.data["Error"] ?? 'Something went wrong');
        // showErrorToast(
        //     fToast: fToast, isError: true, msg: e.response!.data["Error"]);
        setState(() {
          error = t;
        });
      } else {
        EasyLoading.showError('Something went wrong');
      }
    }
  }

  void otp() async {
    try {
      var dio = Dio();
      await dio.post(Constants().getBaseUrl() + '/Authentication/Login', data: {
        "UserName": emailController.text,
        "Otp": codeController.text,
        "DeviceId": "210"
      }).then((res) async {
        showErrorToast(fToast: fToast, isError: false, msg: 'Done');
        final body = res.data["Data"];
        prefs = await SharedPreferences.getInstance();
        prefs.setString('token', body["AccessToken"]);
        prefs.setString('refresh_token', "yes");
        prefs.setBool('login', true);
        getPatientProfile();
        Get.offAll(const MyAppointmentsScreen());
        print(res.data);
      });
    } on DioError catch (e) {
      String error = e.response!.data['Error'] +
          'Remaining' +
          '${e.response!.data['Data']}' +
          'Attempts';
      EasyLoading.showError(
          e.response!.data['Error'] ?? 'Something went wrong');
      // showErrorToast(
      //     fToast: fToast, isError: true, msg: e.response!.data['Error']);
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // get_posts ();
    // print(isemailtab);
    check_if_already_login();
    // fToast = FToast();
    // fToast!.init(context);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    smsController.dispose();
    codeController.dispose();
    super.dispose();
  }

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
              onTap: () {},
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
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WillPopScope(
                onWillPop: _onWillPop,
                child: const Text(''),
              ),
              Image.asset(
                AppImages.homeImage,
                width: width,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 12.0),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Welcome to eMed Assistant',
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
              isemailtab
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: CustomField(
                            validator: isemailtab
                                ? ValidationBuilder()
                                    .email()
                                    .maxLength(50)
                                    .build()
                                : ValidationBuilder()
                                    .phone()
                                    .maxLength(50)
                                    .build(),
                            height: 50.0,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            padding:
                                const EdgeInsets.only(bottom: 0.0, left: 16.0),
                            hintText: 'Your email',
                          ),
                        ),
                        //error.isEmpty ? SizedBox() : Text("${error}"),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomField(
                        height: 50.0,
                        validator: isemailtab
                            ? ValidationBuilder().email().maxLength(50).build()
                            : ValidationBuilder().phone().maxLength(50).build(),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        padding: const EdgeInsets.only(bottom: 0.0, left: 16.0),
                        hintText: 'Your phone number',
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
                      onTap: () {
                        // if(emailController.text!=null){
                        //     login(width);

                        // }
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          login(width);
                        }
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
                child: Text(
                  'Don\'t have an account yet?',
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
                    const Text(
                      'Join now as',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    CustomButton(
                      onTap: () {
                        Get.to(const CreateProfileScreen());
                      },
                      btnText: 'Patient',
                      width: 80.0,
                      btnColor: AppColors.white,
                      fontColor: AppColors.secondary,
                      borderColor: AppColors.secondary,
                    ),
                    // test();
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<test_model>  () {

  // print('heloo!');
  // var dio = Dio();
  // final response =  dio.get('https://google.com');
  // print(response.data);
  // }

  Widget menuButton() => TextButton(
        onPressed: () {
          _scaffoldKey.currentState!.openEndDrawer();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              'Menu',
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
            const Text(
              '@2022 EMED Limited - Company number 123456789',
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

  Widget clipTopImage(height, width) => ClipPath(
        clipper: NativeClipper(),
        child: Stack(
          children: [
            SizedBox(
              height: height * 0.4,
              width: width,
              child: Image.asset(
                AppImages.doctorImage,
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
                    child: Text(
                      'We care \nabout your \nhealth',
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
                    child: Text(
                      'eMed is your Assistent in Lorem Ipsum is simply '
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
              child: Text(
                'Sign in',
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
                  onTap: () {
                    setState(() {
                      isemailtab = true;
                    });
                    print(isemailtab);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                      border: Border.all(
                        color: isemailtab
                            ? AppColors.secondary
                            : AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 15.0,
                        color:
                            isemailtab ? AppColors.secondary : AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Bounceable(
                  onTap: () {
                    setState(() {
                      isemailtab = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                      border: Border.all(
                        color: isemailtab
                            ? AppColors.primary
                            : AppColors.secondary,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'SMS',
                      style: TextStyle(
                        fontSize: 15.0,
                        color:
                            isemailtab ? AppColors.black : AppColors.secondary,
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
              Form(
                key: _otpFormKey,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Authentication',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      const Text(
                        'We have sent you the access code',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      const Text(
                        'Attention, the code will expire in 5',
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
                          validator: ValidationBuilder().build(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'code',
                            contentPadding:
                                EdgeInsets.only(left: 16.0, bottom: 16.0),
                            errorStyle: TextStyle(
                              fontSize: 16.0,
                            ),
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
                              onTap: () {
                                // Get.to(ProfileSetupOneScreen());
                                if (_otpFormKey.currentState!.validate()) {
                                  otp();
                                }
                              },
                              btnText: 'Submit',
                              width: 80.0,
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          loginResend();
                        },
                        child: const Text(
                          'Send me again the verification code',
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
              ),
            ],
          ),
        ],
      );
}
