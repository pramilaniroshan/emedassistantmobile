import 'package:get/state_manager.dart';

class PatientController extends GetxController {
  String firstName = 'User'; //no need for .obs

  void setFirstname(String name) {
    this.firstName = name;
    // use update method to update all count variables
    update();
  }
}
