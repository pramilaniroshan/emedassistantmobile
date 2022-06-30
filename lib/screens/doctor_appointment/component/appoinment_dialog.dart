import 'package:emedassistantmobile/screens/settings/setting_screen.dart';
import 'package:emedassistantmobile/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:emedassistantmobile/config/app_colors.dart';

class AppointmentDialog extends StatefulWidget {
  const AppointmentDialog({Key? key}) : super(key: key);

  @override
  State<AppointmentDialog> createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {

  TextEditingController customMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: width,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: const BoxDecoration(
            color: AppColors.lightBackground,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Late announcement',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                width: width,
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      /// set the delay
                      const Text('Set the delay',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: AppColors.lightBlack,
                        fontWeight: FontWeight.w500,
                      ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          delayBox(AppColors.secondary, '10 min', AppColors.secondary),
                          delayBox(AppColors.primary, '20 min', AppColors.black),
                          delayBox(AppColors.primary, '30 min', AppColors.black),
                          delayBox(AppColors.primary, '45 min', AppColors.black),
                          delayBox(AppColors.primary, '60 min', AppColors.black),
                        ],
                      ),

                      /// select a preset message
                      const SizedBox(height: 24.0),
                      const Text('Select a preset message',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: AppColors.lightBlack,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        width: width,
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          color: AppColors.white,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(''),
                            Spacer(),
                            Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                            SizedBox(width: 8.0),
                          ],
                        ),
                      ),

                      /// or create a custom message
                      const SizedBox(height: 24.0),
                      const Text('or create a custom message',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: AppColors.lightBlack,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 10.0),
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          color: AppColors.white,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.0,
                          ),
                        ),
                        child: TextFormField(
                          maxLines: 5,
                          controller: customMessageController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              left: 16.0, top: 16.0,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: CustomButton(
                      onTap: (){
                        Get.back();
                      },
                      btnText: 'Cancel',
                      borderColor: AppColors.primary,
                      btnColor: AppColors.white,
                      width: 60.0,
                      fontColor: AppColors.black,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: CustomButton(
                      onTap: (){
                        Get.to(const SettingsScreen());
                      },
                      btnText: 'Publish',
                      width: 80.0,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget delayBox(borderColor, minText, textColor) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    decoration: BoxDecoration(
      border: Border.all(
        color: borderColor,
        width: 1.0,
      ),
    ),
    child: Text(minText,
      style: TextStyle(
        fontSize: 14.0,
        color: textColor,
      ),
    ),
  );
}
