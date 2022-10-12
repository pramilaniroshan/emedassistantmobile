import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../config/constants.dart';
import '../controller/patientController.dart';

late SharedPreferences prefs;
final PatientController countController = Get.put(PatientController());

void getPatientProfile() async {
  prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? '';
  try {
    var dio = Dio();
    dio.options.headers["authorization"] = "Bearer " + token;
    await dio
        .get(
      Constants().getBaseUrl() + '/Patient/Profile',
    )
        .then((res) {
      if (prefs.getString("token") != null) {
        prefs.setString('FirstName', res.data['Data']['FirstName']);
        Get.find<PatientController>()
            .setFirstname(prefs.getString('FirstName') ?? '');
      }
    });
  } on DioError catch (e) {
    print(e.response!.data ?? 'Something went wrong!');
  }
}
