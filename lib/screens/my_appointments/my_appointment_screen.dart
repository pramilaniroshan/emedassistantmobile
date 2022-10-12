import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:emedassistantmobile/controller/patientController.dart';

import 'package:emedassistantmobile/screens/book_an_appointment/book_an_appointment_screen.dart';
import 'package:emedassistantmobile/services/get_patient_profile.dart';
import 'package:emedassistantmobile/widgets/drawer.dart';
import 'package:emedassistantmobile/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:open_settings/open_settings.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

import 'package:emedassistantmobile/widgets/custom_button.dart';
import 'package:emedassistantmobile/config/app_colors.dart';
import 'package:emedassistantmobile/config/app_images.dart';

import '../../config/constants.dart';
import '../../controller/countController.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  /// door rating dropdown items
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        value: "All doctors",
        child: Text("All doctors"),
      ),
    ];
    return menuItems;
  }

  String selectedValue = "All doctors";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPlanned = true;
  bool isPast = false;
  late SharedPreferences prefs;
  List appointments = [];
  late final Event event;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final PatientController countController = Get.put(PatientController());

  void planActive() {
    setState(() {
      isPlanned = true;
      isPast = false;
    });
  }

  void pastActive() {
    setState(() {
      isPlanned = false;
      isPast = true;
    });
  }

  void checkPermissons() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      EasyLoading.showInfo("Please enble location services");
    }

// You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {}
    if (status.isGranted) {}
  }

  Future<void> getAppointments() async {
    EasyLoading.showInfo('status');
    appointments.clear();
    EasyLoading.show(status: 'loading...');
    prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';
    try {
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer " + token;
      await dio
          .get(
        Constants().getBaseUrl() + '/Patient/Appointment',
      )
          .then((res) {
        //print(res.data['Data']['Data']);
        setState(() {
          appointments = res.data['Data']['Data'];
        });
        EasyLoading.dismiss();
        //print(appointments[0]['DoctorAvailability']['Doctor']);
      });
    } on DioError catch (e) {
      EasyLoading.dismiss();
      //print(e.response!.statusCode);
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
    super.initState();
    getPatientProfile();
    getAppointments();
    checkPermissons();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.lightBackground,

      /// app Bar
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: SvgPicture.asset(AppImages.eMedLogo),
        ),
        leadingWidth: 110.0,
        actions: [PatientDrawerAction()],
      ),

      /// end drawer
      endDrawer: PatientDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// My Appointments texts
            const SizedBox(height: 24.0),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'My appointment',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            WillPopScope(
              onWillPop: _onWillPop,
              child: const Text(''),
            ),

            /// planned and past tab
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: planActive,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        'Planned',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: isPlanned == true
                              ? AppColors.black
                              : AppColors.secondary,
                          fontWeight: isPlanned == true
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: pastActive,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        'Past',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: isPast == true
                              ? AppColors.black
                              : AppColors.secondary,
                          fontWeight: isPast == true
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Container(
                      height: 36.0,
                      padding: const EdgeInsets.only(left: 12.0, right: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: AppColors.white,
                        border: Border.all(
                          width: 1.0,
                          color: AppColors.primary,
                        ),
                      ),
                      child: DropdownButton(
                        value: selectedValue,
                        items: dropdownItems,
                        hint: const Text(
                          'United Kingdom',
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          ),
                        ),
                        style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: AppColors.primary, size: 20.0),
                        isExpanded: true,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// planned texts and Book Button
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Planned',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          {Get.to(const BookAnAppointmentScreen())},
                      icon: const Icon(Icons.group_outlined,
                          color: AppColors.white, size: 20.0),
                      label: const Text('Book'),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.secondary,
                        side: BorderSide(color: AppColors.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// detail Box
            const SizedBox(height: 16.0),

            RefreshIndicator(
                color: Colors.white,
                backgroundColor: AppColors.secondary,
                strokeWidth: 3.0,
                onRefresh: () {
                  getAppointments();
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: appointments.isEmpty
                    ? const Center(child: Text('No any data to display'))
                    : SizedBox(
                        height: 600.0,
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 5,
                            );
                          },
                          itemCount: appointments.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DoctorDetailsBox(
                              width: width,
                              id: appointments[index]['DoctorAvailability']
                                      ['Doctor']['Id'] ??
                                  '',
                              title: appointments[index]['DoctorAvailability']
                                      ['Doctor']['Title'] ??
                                  '',
                              fullName: appointments[index]
                                          ['DoctorAvailability']['Doctor']
                                      ['FullName'] ??
                                  '',
                              phoneNumber: appointments[index]
                                          ['DoctorAvailability']['Doctor']
                                      ['PhoneNumber'] ??
                                  '',
                              locationAddress: appointments[index]
                                          ['DoctorAvailability']['Location']
                                      ['LocationAddress'] ??
                                  '',
                              locationName: appointments[index]
                                          ['DoctorAvailability']['Location']
                                      ['LocationName'] ??
                                  '',
                              startTime: appointments[index]
                                      ['DoctorAvailability']['StartTime'] ??
                                  '',
                              endTime: appointments[index]['DoctorAvailability']
                                      ['EndTime'] ??
                                  '',
                              patientNotes:
                                  appointments[index]['PatientNotes'] ?? '',
                            );
                          },
                        ),
                      )),

            /// book and appointment button
            const SizedBox(height: 24.0),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.1),
                child: ElevatedButton.icon(
                  onPressed: () => {Get.to(const BookAnAppointmentScreen())},
                  icon: const Icon(Icons.group_outlined,
                      color: AppColors.white, size: 20.0),
                  label: const Text('Book an appointment'),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.secondary,
                    side: BorderSide(color: AppColors.secondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
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
              'Name',
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

class DoctorDetailsBox extends StatelessWidget {
  const DoctorDetailsBox({
    this.id,
    this.title,
    this.fullName,
    this.phoneNumber,
    this.locationName,
    this.locationAddress,
    this.startTime,
    this.endTime,
    this.patientNotes,
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;
  final String? id;
  final String? title;
  final String? fullName;
  final String? phoneNumber;
  final String? locationName;
  final String? locationAddress;
  final String? startTime;
  final String? endTime;
  final String? patientNotes;
  //void VoidCallback();

  List dateConvert(String date) {
    var dateFormat =
        DateFormat('EEE, MMM d ,y,h:mm a'); // you can change the format here
    var utcDate =
        dateFormat.format(DateTime.parse(date)); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
    String createdDate = dateFormat.format(DateTime.parse(localDate));
    // you will local time
    List<String> dayList = createdDate.split(",");
   // print(dayList);
    return dayList;
  }

  appointmentsDelete() async {
    EasyLoading.show();
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? '';
      try {
        var dio = Dio();
        dio.options.headers["authorization"] = "Bearer " + token;
        await dio.post(Constants().getBaseUrl() + '/Patient/Appointment/Cancel',
            data: {"AppointmentId": id} ).then((res) {
          
          EasyLoading.dismiss();
          Get.back();
          EasyLoading.showSuccess('Done');
         
        });
      } on DioError catch (e) {
        EasyLoading.dismiss();
        //print(e.response!.statusCode);
      }
    }

  @override
  Widget build(BuildContext context) {


    

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.lightBlue,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// date and image row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      dateConvert(startTime ?? '')[0] +
                          ' ' +
                          dateConvert(startTime ?? '')[1] +
                          ' ' +
                          dateConvert(startTime ?? '')[2],
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      dateConvert(startTime ?? '')[3],
                      style: TextStyle(
                        fontSize: 24.0,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      dateConvert(endTime ?? '')[3],
                      style: TextStyle(
                        fontSize: 20.0,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 22.0,
                backgroundImage: AssetImage(AppImages.doctorImage),
              ),
            ],
          ),
          Divider(
            thickness: 1.0,
            color: AppColors.primary.withOpacity(0.4),
          ),

          /// name and specialists
          const SizedBox(height: 8.0),
          Text(
            title! + ' ' + fullName!,
            style: TextStyle(
              fontSize: 24.0,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4.0),
          const Text(
            'Dermatologists - Pediatricians',
            style: TextStyle(
              fontSize: 12.0,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),

          /// location address center
          const SizedBox(height: 15.0),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.primary),
              const SizedBox(height: 2.0),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: locationName! + ' -',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' ' + locationAddress!,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// brief description text
          const SizedBox(height: 16.0),
          Text(
            patientNotes!,
            style: TextStyle(
              fontSize: 12.0,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10.0),
          Divider(
            thickness: 1.0,
            color: AppColors.primary.withOpacity(0.4),
          ),

          /// Calender and phone
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.calendar_today_outlined,
                  color: AppColors.primary, size: 20.0),
              SizedBox(width: 8.0),
              Text(
                'M567854',
                style: TextStyle(
                  fontSize: 20.0,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: CustomButton(
              onTap: () {
                Add2Calendar.addEvent2Cal(Event(
                  title: 'Event title',
                  description: patientNotes ?? 'Event description',
                  location: locationName ?? 'Event location',
                  startDate: DateTime.now(),
                  endDate: DateTime.now().add(const Duration(minutes: 30)),
                  iosParams: const IOSParams(
                    reminder: Duration(
                        /* Ex. hours:1 */), // on iOS, you can set alarm notification after your event.
                  ),
                  androidParams: const AndroidParams(
                    emailInvites: [
                      'test@t.com'
                    ], // on Android, you can add invite emails to your event.
                  ),
                ));
              },
              btnText: 'Add to my calender',
              height: 30.0,
              width: MediaQuery.of(context).size.width / 3,
              fontSize: 13.0,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.phone, color: AppColors.primary, size: 20.0),
              SizedBox(width: 8.0),
              Text(
                phoneNumber!,
                style: TextStyle(
                  fontSize: 16.0,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Divider(
            thickness: 1.0,
            color: AppColors.primary.withOpacity(0.4),
          ),

          /// delete and edit button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 42.0,
                width: 42.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary,
                ),
                child: Center(
                  child: IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                            title: "Are you sure?",
                            middleText: "Please Confirm",
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              appointmentsDelete();
                             // print('--------------------------------------------------------------------');
                            },
                            onCancel: () {
                              Get.to(MyAppointmentsScreen());
                            });
                      },
                      icon: Icon(Icons.delete,
                          color: AppColors.white, size: 18.0)),
                ),
              ),
              const SizedBox(width: 16.0),
              // Container(
              //   height: 42.0,
              //   width: 42.0,
              //   decoration: const BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: AppColors.secondary,
              //   ),
              //   // child: const Center(
              //   //   child: Icon(Icons.edit, color: AppColors.white, size: 18.0),
              //   // ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
