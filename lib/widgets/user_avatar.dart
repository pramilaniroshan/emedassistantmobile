import 'package:emedassistantmobile/controller/patientController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_colors.dart';

class PatientDrawerAction extends StatelessWidget {
  PatientDrawerAction({Key? key}) : super(key: key);

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
          GetBuilder<PatientController>(
            // You can initialize your controller here the first time. Don't use init in your other GetBuilders of same controller
            // GetX/Obx is reactive (streams) while GetBuilder only rebuilds on update()
            builder: (s) => Text(
              '${s.firstName}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
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
