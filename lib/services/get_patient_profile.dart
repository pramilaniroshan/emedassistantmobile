import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../config/constants.dart';

late SharedPreferences prefs;

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
        prefs.setString('firstName', res.data['Data']['FirstName'] ?? '');
        print(res.data['Data']['FirstName']);
      }
    });
  } on DioError catch (e) {
    print(e.response!.data);
  }
}
