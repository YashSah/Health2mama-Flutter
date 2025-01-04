import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';

import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/submisson_dialog.dart';
import 'package:intl/intl.dart';

class AppointmentDialog extends StatefulWidget {
  final Future<void> Function(String date, String time) onConfirm; // Updated
  const AppointmentDialog({Key? key, required this.onConfirm})
      : super(key: key);

  @override
  _AppointmentDialogState createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  bool isFilled = false;
  bool isLoading = false; // Loading state

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Builder(
          builder: (context) {
            DatePickerThemeData _datePickerTheme = DatePickerTheme.of(context)
                .copyWith(
                headerBackgroundColor: AppColors.pink,
                headerForegroundColor: Colors.white,
                dividerColor: Colors.transparent);
            return Theme(
              data: ThemeData(
                datePickerTheme: _datePickerTheme,
                colorScheme: ColorScheme.light(
                  primary: AppColors.pink,
                  onPrimary: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Format the date to yyyy-MM-dd
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        checkFilled();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Builder(
          builder: (context) {
            TimePickerThemeData _timePickerTheme =
            TimePickerTheme.of(context).copyWith(
              dayPeriodColor: AppColors.pink,
            );
            return Theme(
              data: ThemeData(
                timePickerTheme: _timePickerTheme,
                primaryColor: AppColors.pink,
                hintColor: AppColors.pink,
                colorScheme: ColorScheme.light(
                  primary: AppColors.pink,
                  onPrimary: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
      },
    );
    if (picked != null) {
      setState(() {
        // Convert the selected time to 24-hour format and update the controller
        final now = DateTime.now();
        final DateTime fullTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        _timeController.text = DateFormat('HH:mm').format(fullTime);
        checkFilled();
      });
    }
  }

  final animationsMap = {
    'columnOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 20.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'columnOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 600.ms,
          begin: Offset(0.0, 20.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'columnOnPageLoadAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: Offset(0.0, 20.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'imageOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(40.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
  };

  void checkFilled() {
    if (_dateController.text.isNotEmpty && _timeController.text.isNotEmpty) {
      setState(() {
        isFilled = true;
      });
    } else {
      setState(() {
        isFilled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _submit(BuildContext context) async {
      print("Submit button tapped");
      if (isFilled) {
        setState(() {
          isLoading = true; // Show loading indicator
        });
        print("Date: ${_dateController.text}, Time: ${_timeController.text}");
        await widget.onConfirm(_dateController.text, _timeController.text);
        setState(() {
          isLoading = false; // Hide loading indicator
        });
      } else {
        print("Fields are not filled");
      }
    }


    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: (displayType == 'desktop' || displayType == 'tablet')
            ? 0.04 * screenWidth
            : 0.06 * screenWidth,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                color: AppColors.pink,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Text(
              "Book Your Appointment",
              textAlign: TextAlign.center,
              style: (displayType == 'desktop' || displayType == 'tablet')
                  ? FTextStyle.forumMainHeadingTab
                  : FTextStyle.forumMainHeading,
            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
            SizedBox(height: screenHeight * 0.03),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.black.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: FTextStyle.ForumsTextFieldTitle,
                      controller: _dateController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select Date",
                        hintStyle: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? FTextStyle.ForumsTextFieldHintTab
                            : FTextStyle.ForumsTextFieldHint,
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                      readOnly: true,
                    ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                  ),
                  IconButton(
                    icon: Container(
                      width: (displayType == 'desktop' || displayType == 'tablet') ? 34.h : 34,
                      height: (displayType == 'desktop' || displayType == 'tablet') ? 34.h : 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.pink,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Image.asset('assets/Images/Calender.png'),
                      ),
                    ),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.black.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: FTextStyle.ForumsTextFieldTitle,
                      controller: _timeController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select Time",
                        hintStyle: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? FTextStyle.ForumsTextFieldHintTab
                            : FTextStyle.ForumsTextFieldHint,
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                      readOnly: true,
                    ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                  ),
                  IconButton(
                    icon: Container(
                      width: (displayType == 'desktop' || displayType == 'tablet') ? 34.h : 34,
                      height: (displayType == 'desktop' || displayType == 'tablet') ? 34.h : 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.pink,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Image.asset('assets/Images/Timer.png'),
                      ),
                    ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                    onPressed: () {
                      _selectTime(context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
              child: ElevatedButton(
                onPressed: isFilled
                    ? () {
                  _submit(context);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.85, screenHeight * 0.05),
                  backgroundColor: isFilled
                      ? AppColors.pink
                      : AppColors.searchResultPinkColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
                    : Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                      color: isFilled ? Colors.white : Colors.black,
                      fontSize: (displayType == 'desktop' || displayType == 'tablet')
                          ? 15.h
                          : 15,
                      fontWeight: (displayType == 'desktop' || displayType == 'tablet')
                          ? FontWeight.w800
                          : FontWeight.w600,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

