import 'package:emedassistantmobile/screens/book_an_appointment/patient_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:emedassistantmobile/config/app_colors.dart';
import 'package:emedassistantmobile/config/app_images.dart';
import 'expand_dates.dart';

class SearchDoctorBox extends StatelessWidget {
  const SearchDoctorBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: AppColors.white,
        border: Border.all(
          color: AppColors.lightBlue,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          /// Doctor name and image
          Material(
            elevation: 0.0,
            child: InkWell(
              onTap: (){
                Get.to(const PatientBookingScreen());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text('Dr. Lorem Ipsum Name',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          SizedBox(height: 6.0),
                          Text('Lorem Ipsum - Lorem Ipsum',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      radius: 20.0,
                      backgroundImage: AssetImage(AppImages.doctorImage),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Divider
          const Divider(
            color: AppColors.primary,
            thickness: 0.5,
          ),
          const SizedBox(height: 8.0),

          /// Location Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 8.0),
              const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20.0),
              const SizedBox(width: 5.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Colombo Center ',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: AppColors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: '- Hospital St, Colombo 00100, Sri Lanka',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: AppColors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// show/hide available dates
          const ExpandDates(),
        ],
      ),
    );
  }
}
