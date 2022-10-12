import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emedassistantmobile/widgets/custom_button.dart';
import 'package:emedassistantmobile/widgets/drawer.dart';
import 'package:emedassistantmobile/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

import 'package:emedassistantmobile/config/app_colors.dart';
import 'package:emedassistantmobile/config/app_images.dart';
import '../../config/constants.dart';
import '../../widgets/custom_field.dart';
import 'components/search_doctor_box.dart';

class BookAnAppointmentScreen extends StatefulWidget {
  const BookAnAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<BookAnAppointmentScreen> createState() =>
      _BookAnAppointmentScreenState();
}

class _BookAnAppointmentScreenState extends State<BookAnAppointmentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late SharedPreferences prefs;

  List doctorlist = [];

 double ? lat;
 double ? long;
  String? selectedValue;
  List<String> items = [
    'Allergists/Immunologists',
    'Anesthesiologists',
    'Cardiologists',
    'Colon and Rectal Surgeons',
    'Critical Care Medicine Spec.',
    'Dermatologists',
    'Endocrinologists',
    'Preventive Medicine Spec.',
    'Psychiatrists',
    'Pulmonologists',
    'Radiologists',
    'Rhenumatologists',
    'Medicine Spec.',
    'Sports Medicine Spec.',
    'General Surgeons',
    'Urologists',
  ];

  final Set<Marker> _markers = {};



/// Location persmisionss



  @override
  void initState() {
    super.initState();
  }

    Set<Circle> circles = {};

  void searchDoctor() async {
    EasyLoading.show(status: 'loading...');
    doctorlist.clear();
    prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';
    print(token);
    try {
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer " + token;
      await dio.get(
          Constants().getBaseUrl() + '/Patient/SearchDoctorAvailability',
          
          queryParameters: selectedValue != null ?{
            "DoctorName": nameController.text,
            "LocationAddress": locationController.text,
            "SpecializationIds" : items.indexOf(selectedValue ?? '') + 1,
            "Date": date,
            "LocationLatitude" : lat,
            "LocationLongitude" : long,
            "LocationRadius" : lat != null ? 3000 : null
          }: {
            "DoctorName": nameController.text,
            "LocationAddress": locationController.text,
            "Date": date,
            "LocationLatitude" : lat,
            "LocationLongitude" : long,
            "LocationRadius" : lat != null ? 3000 : null
          }).then((res) {
        EasyLoading.dismiss();
        var rdata = res.data['Data']['Data'];
        for (var i in rdata) {
          doctorlist.add(i);
        }
        setState(() {});
        print(res.data);
      });
    } on DioError catch (e) {
      EasyLoading.dismiss();
      print(e.response!.statusCode);
    }
  }

  void clearForm() {
    setState(() {
      date = DateTime.now();
      nameController.clear();
      locationController.clear();
      lat = null;
      long = null;
      selectedValue = null;
      doctorlist.clear();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    //TODO
  }

  final myFormat = DateFormat('yyyy-MM-dd');
  var date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      setState(() {
        date = picked ?? date;
      });
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.lightBackground,
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
      endDrawer: PatientDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'Book and appointment',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            /// Search Box
            Container(
              width: width,
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border(
                  top: BorderSide(
                    color: AppColors.lightBlack.withOpacity(0.5),
                    width: 1.0,
                  ),
                  bottom: BorderSide(
                    color: AppColors.lightBlack.withOpacity(0.5),
                    width: 1.0,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Define one or more search criteria',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  /// Doctor name field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomField(
                      height: 40.0,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      padding: const EdgeInsets.only(bottom: 12.0, left: 16.0),
                      hintText: 'Doctor Name',
                    ),
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.only(left: 20.0, top: 8.0),
                  //   child: Text(

                  //     '',
                  //     style: TextStyle(
                  //       fontSize: 16.0,
                  //       fontWeight: FontWeight.w500,
                  //       color: AppColors.secondary,

                  //     ),
                  //   ),
                  // ),

                  /// doctor medical speciality dropdown
                  const SizedBox(height: 16.0),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Doctor\'s medical specialty',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Container(
                    height: 40.0,
                    width: width,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        hint: const Text(
                          '',
                          
                        ),
                        items: items
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    //backgroundColor: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        value: selectedValue,
                        style: TextStyle(color: Colors.white,
                        //background: Paint(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                          print(selectedValue);
                        },
                        buttonHeight: 40,
                        buttonWidth: 140,
                        itemHeight: 36.0,
                        dropdownWidth: width/1.5,
                        buttonPadding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                        // dropdownDecoration: const BoxDecoration(
                        //   color: AppColors.lightBlack,
                        // ),
                      ),
                    ),
                  ),

                  /// Appointment Location
                  const SizedBox(height: 24.0),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Appointment Location',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomField(
                      height: 40.0,
                      controller: locationController,
                      keyboardType: TextInputType.name,
                      padding: const EdgeInsets.only(bottom: 12.0, left: 16.0),
                      hintText: 'Colombo',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 8.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      // children: const [
                      //   Text(
                      //     'Colombo',
                      //     style: TextStyle(
                      //       fontSize: 16.0,
                      //       fontWeight: FontWeight.w500,
                      //       color: AppColors.secondary,
                      //       decoration: TextDecoration.underline,
                      //     ),
                      //   ),
                      //   SizedBox(width: 12.0),
                      //   Text(
                      //     'Kandy',
                      //     style: TextStyle(
                      //       fontSize: 16.0,
                      //       fontWeight: FontWeight.w500,
                      //       color: AppColors.secondary,
                      //       decoration: TextDecoration.underline,
                      //     ),
                      //   ),
                      // ],
                    ),
                  ),

                  /// Date Picker
                  const SizedBox(height: 16.0),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Container(
                    height: 40.0,
                    width: width,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            myFormat.format(date),
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              selectDate(context);
                            },
                            child: const Icon(Icons.calendar_today,
                                color: AppColors.primary, size: 20.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                      Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: kIsWeb
                      ? Text('Map plugin')
                      : Container(
                        child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            liteModeEnabled: false,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            scrollGesturesEnabled: true,
                            rotateGesturesEnabled: true,
                            markers: _markers,
                            gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
                            circles: circles,
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(7.93, 80.8612),
                              zoom: 7.5,
                            ),
                            onTap: (latlang) {
                              setState(() {
                                lat = latlang.latitude;
                                long = latlang.longitude;
                                _markers.add(
                                  Marker(
                                      markerId: MarkerId('id-1'),
                                      position: LatLng(
                                          latlang.latitude, latlang.longitude),
                                      infoWindow: InfoWindow(
                                          title: 'Title',
                                          snippet: "${latlang.latitude}" +
                                              "${latlang.longitude}")),
                                );
                                circles.add(Circle(
                                    circleId: CircleId('id-1'),
                                    center: LatLng(
                                        latlang.latitude , latlang.longitude),
                                    radius: 3000,
                                    fillColor: AppColors.lightBlue.withOpacity(0.5),
                                    strokeWidth: 3,
                                    strokeColor: AppColors.lightBlue,
                                    ));
                              });
                              
                            },
                          ),
                      ),
                ),
              ),
            ),

                  /// Search Button
                  const SizedBox(height: 32.0),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Expanded(
                          child: CustomButton(
                            onTap: () {
                              searchDoctor();
                              /*Get.dialog(
                          const ScheduleSlotDialog(),
                        );*/
                              // Get.dialog(
                              //   const DoctorAvailabilityDialog(),
                              // );
                            },
                            btnText: 'Search',
                            width: 90.0,
                            height: 36.0,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: CustomButton(
                              btnText: 'Clear',
                              btnColor: AppColors.lightBackground,
                              fontColor: AppColors.lightBlack,
                              width: 90.0,
                              height: 36.0,
                              onTap: (() => {clearForm()})),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            /// Search Result List
        const SizedBox(height: 32.0),
            doctorlist.isEmpty
                ?  Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                       Image.asset(AppImages.noResultImage ,semanticLabel: "No results found.",),
                       Center(child: Text('No results found.'),)
          ])
                : Column(
                  
                    children: 
                   
                    List.generate(
                        doctorlist.length,
                        (index) => SearchDoctorBox(
                            doctorlist[index]["IanaTimeZoneId"],
                            doctorlist[index]["Id"],
                            doctorlist[index]["DoctorTitle"],
                            doctorlist[index]["DoctorFullName"],
                            doctorlist[index]["FreeSlots"],
                            doctorlist[index]["ConsultationFee"],
                            doctorlist[index]["Location"]['LocationName'],
                            doctorlist[index]["Location"]['LocationAddress'])))
          ],
        ),
      ),
    );
  }

  // Widget getDoctorList(List<String> strings)
  // {
  //   return new Row(children: children: list);
  // }

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
              //Get.to();
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
      );

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
