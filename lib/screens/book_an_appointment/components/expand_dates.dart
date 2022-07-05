import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:emedassistantmobile/config/app_colors.dart';
import 'package:intl/intl.dart';
import 'date_row.dart';

class ExpandDates extends StatefulWidget {
  final String id;
  final List freeSlots;
  final String doctorTitle;
  final String doctorFullName;
  final double consultationFee;
  final String locationName;
  final String locationAddress;

  const ExpandDates(
      //this.id,
      this.freeSlots,
      this.doctorTitle,
      this.doctorFullName,
      this.id,
      this.consultationFee,
      this.locationName,
      this.locationAddress,
      {Key? key})
      : super(key: key);

  @override
  State<ExpandDates> createState() => _ExpandDatesState();
}

class _ExpandDatesState extends State<ExpandDates> {
  List dateConvert(String date) {
    var dateFormat =
        DateFormat("yMMMEd").add_jm(); // you can change the format here
    var utcDate =
        dateFormat.format(DateTime.parse(date)); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
    String createdDate = dateFormat.format(DateTime.parse(localDate));
    // you will local time
    List<String> dayList = createdDate.split(",");
    print(dayList);
    return dayList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          child: Text(
            'Show available dates',
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
        children: [
          widget.freeSlots.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: List.generate(
                      widget.freeSlots.length,
                      (index) => DateRow(
                            dayText: dateConvert(widget.freeSlots[index])[0],
                            dateText: dateConvert(widget.freeSlots[index])[1],
                            timeSlotText:
                                dateConvert(widget.freeSlots[index])[2],
                            timeSlot: widget.freeSlots[index],
                            id: widget.id,
                            title: widget.doctorTitle,
                            doctorFullName: widget.doctorFullName,
                            consultationFee: widget.consultationFee,
                            locationName: widget.locationName,
                            locationAddress: widget.locationAddress,
                          ))),
          /*DateRow(
          
            dayText: 'Monday, ',
            dateText: '11 Apr ',
            timeSlotText: '2022 - 9-11am 3°slot',
            id : '123',

          ),*/
          SizedBox(height: 16.0),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: Text('Show more dates',
          //     style: TextStyle(
          //       fontSize: 14.0,
          //       color: AppColors.secondary,
          //       fontWeight: FontWeight.w600,
          //       decoration: TextDecoration.underline,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
