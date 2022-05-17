import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:emedassistantmobile/config/app_colors.dart';
import 'date_row.dart';

class ExpandDates extends StatefulWidget {
  const ExpandDates({Key? key}) : super(key: key);

  @override
  State<ExpandDates> createState() => _ExpandDatesState();
}

class _ExpandDatesState extends State<ExpandDates> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ExpandablePanel(
      theme: const ExpandableThemeData(
        useInkWell: true,
        hasIcon: false,
      ),
      header: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text('Show available dates',
            style: TextStyle(
              fontSize: 14.0,
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
      collapsed: const SizedBox(),
      expanded: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          DateRow(
            dayText: 'Monday, ',
            dateText: '11 Apr ',
            timeSlotText: '2022 - 9-11am 3°slot',
          ),
          DateRow(
            dayText: 'Tuesday, ',
            dateText: '12 Apr ',
            timeSlotText: '2022 - 9-11am 3°slot',
          ),
          DateRow(
            dayText: 'Tuesday, ',
            dateText: '12 Apr ',
            timeSlotText: '2022 - 9-11am 3°slot',
          ),
          DateRow(
            dayText: 'Saturday, ',
            dateText: '12 Apr ',
            timeSlotText: '2022 - 9-11am 3°slot',
          ),
          DateRow(
            dayText: 'Tuesday, ',
            dateText: '12 Apr ',
            timeSlotText: '2022 - 9-11am 3°slot',
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.centerRight,
            child: Text('Show more dates',
              style: TextStyle(
                fontSize: 14.0,
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

}