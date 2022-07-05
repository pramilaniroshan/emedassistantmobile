import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emedassistantmobile/config/app_colors.dart';
import 'package:emedassistantmobile/config/app_images.dart';
import 'package:emedassistantmobile/screens/my_appointments/my_appointment_screen.dart';
import 'package:emedassistantmobile/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:emedassistantmobile/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constants.dart';
import '../../widgets/toast.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? title;
  List<String> items = ['Mr', 'Mrs', 'Ms', 'Miss'];

  String? cCode = '+94';
  List<String> cCodes = ['+94', '+91'];

  FToast? fToast;
  late SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();

  void patientRegister(double width) async {
    EasyLoading.show(status: 'loading...');
    try {
      var dio = Dio();
      await dio.post(Constants().getBaseUrl() + '/Registration/Patient', data: {
        "Title": title,
        "FirstName": nameController.text,
        "LastName": lastNameController.text,
        "Email": emailController.text,
        "PhoneNumber": cCode! + mobileNumberController.text,
        "RegisterType": 0,
        "CountryCode": 210,
        "Address": addressController.text
      }).then((res) {
        if (res.statusCode == 200) {
          EasyLoading.dismiss();
          EasyLoading.showSuccess('Code Sent');
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
        //showErrorToast(
        //  fToast: fToast, isError: true, msg: e.response!.data["Error"]);
        setState(() {});
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(
            e.response!.data["Error"] ?? 'Something went wrong');
        //showErrorToast(fToast: fToast, isError: true, msg: e.message);
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
        //showErrorToast(fToast: fToast, isError: false, msg: 'Done');
        EasyLoading.showSuccess('Done');
        final body = res.data["Data"];
        prefs = await SharedPreferences.getInstance();
        prefs.setString('token', body["AccessToken"]);
        prefs.setString('refresh_token', "yes");
        prefs.setBool('login', true);
        Get.offAll(const MyAppointmentsScreen());
      });
    } on DioError catch (e) {
      String error = e.response!.data['Error'] +
          'Remaining' +
          '${e.response!.data['Data']}' +
          'Attempts';
      EasyLoading.showError(
          e.response!.data["Error"] ?? 'Something went wrong');
      // showErrorToast(
      //     fToast: fToast, isError: true, msg: e.response!.data['Error']);
    }
  }

  Future<void> loginResend() async {
    try {
      var dio = Dio();
      await dio
          .post(Constants().getBaseUrl() + '/Authentication/Login-init', data: {
        "Username": emailController.text,
        "UserLoginType": 1,
        "CountryCode": 210,
        "Application": 0
      }).then((res) {
        if (res.statusCode == 200) {
          // showErrorToast(fToast: fToast, isError: false, msg: 'Code sent');
          EasyLoading.showSuccess('Code Sent');
        }
      });
    } on DioError catch (e) {
      if (e.response != null) {
        var t = e.response!.data["Error"];
        // showErrorToast(
        //     fToast: fToast, isError: true, msg: e.response!.data["Error"]);
        EasyLoading.showError(
            e.response!.data["Error"] ?? 'Something went wrong');
        setState(() {});
      } else {
        EasyLoading.showError(
            e.response!.data["Error"] ?? 'Something went wrong');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fToast = FToast();
    fToast!.init(context);
    super.initState();
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
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: GestureDetector(
                onTap: () {
                  Get.to(const MyAppointmentsScreen());
                },
                child: const Text(
                  'Create your profile',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Container(
              width: width,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: AppColors.lightBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      height: 40.0,
                      width: 110.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.lightBackground,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          value: title,
                          style: const TextStyle(color: Colors.black),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          hint: const Text(
                            '',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: AppColors.lightBlack,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          items: items
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: AppColors.lightBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              title = newValue;
                            });
                          },
                          buttonHeight: 40,
                          buttonWidth: 140,
                          itemHeight: 36.0,
                          dropdownWidth: 150,
                          buttonPadding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                          dropdownDecoration: const BoxDecoration(
                            color: AppColors.lightBackground,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          '* ',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: AppColors.lightBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    CustomField(
                      controller: nameController,
                      validator: ValidationBuilder()
                          .minLength(3, 'Min lenght is 3')
                          .maxLength(50, 'Max Lenght is 500')
                          .build(),
                      height: 40.0,
                      keyboardType: TextInputType.name,
                      width: width,
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          '* ',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Last Name',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: AppColors.lightBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    CustomField(
                      controller: lastNameController,
                      validator: ValidationBuilder()
                          .minLength(3, 'Min lenght is 3')
                          .maxLength(50, 'Max Lenght is 500')
                          .build(),
                      height: 40.0,
                      keyboardType: TextInputType.name,
                      width: width,
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          '* ',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: AppColors.lightBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    CustomField(
                      controller: emailController,
                      validator:
                          ValidationBuilder().email().maxLength(50).build(),
                      height: 40.0,
                      keyboardType: TextInputType.emailAddress,
                      width: width,
                      isPrefixIcon: true,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        size: 24.0,
                        color: AppColors.lightBlack,
                      ),
                      padding: const EdgeInsets.only(top: 4.0),
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    '* ',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Country Code',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: AppColors.lightBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 40.0,
                                margin: const EdgeInsets.only(top: 8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.lightBackground,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    hint: const Text(
                                      ' +94',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    items: cCodes
                                        .map(
                                          (item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                color: AppColors.lightBlack,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    value: cCode,
                                    onChanged: (value) {
                                      setState(() {
                                        cCode = value as String;
                                      });
                                    },
                                    buttonHeight: 40,
                                    buttonWidth: 140,
                                    itemHeight: 36.0,
                                    dropdownWidth: 150,
                                    dropdownDecoration: const BoxDecoration(
                                      color: AppColors.lightBackground,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    '* ',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Mobile Number',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: AppColors.lightBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              CustomField(
                                controller: mobileNumberController,
                                validator: ValidationBuilder().phone().build(),
                                hintText: '710000000',
                                height: 40.0,
                                keyboardType: TextInputType.number,
                                width: width,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          '* ',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Your home location: City, Street name...',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: AppColors.lightBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    CustomField(
                      controller: addressController,
                      validator: ValidationBuilder()
                          .minLength(3, 'Min lenght is 10')
                          .maxLength(50, 'Max Lenght is 500')
                          .build(),
                      height: 40.0,
                      keyboardType: TextInputType.streetAddress,
                      width: width,
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
                              if (_formKey.currentState!.validate()) {
                                patientRegister(width);
                              }
                            },
                            btnText: 'Submit',
                            width: 80.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget bottomSheetColumn(width) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 10.0),
              //SvgPicture.asset(AppImages.termsIcon, height: 20.0, width: 20.0),
              //const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Thanks for your \nregistration.',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    const Text(
                      'We have just sent you via email and SMS the temporary code to access.Please check your inbox or mobile phone and sign in.',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    const Text(
                      'Attention, the code will expire in 5',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
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
                          contentPadding:
                              EdgeInsets.only(left: 16.0, bottom: 16.0),
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
                              otp();
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
            ],
          ),
        ],
      );
}
