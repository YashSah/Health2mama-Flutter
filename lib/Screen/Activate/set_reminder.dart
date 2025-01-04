import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/Activate/activate_bloc.dart';
import 'package:health2mama/apis/Activate/activate_event.dart';
import 'package:health2mama/apis/Activate/activate_state.dart';
import 'package:intl/intl.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';

class SetReminderScreen extends StatefulWidget {
  @override
  _SetReminderScreenState createState() => _SetReminderScreenState();
}

class _SetReminderScreenState extends State<SetReminderScreen> {
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
          begin: const Offset(0.0, 20.0),
          end: const Offset(0.0, 0.0),
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
          begin: const Offset(0.0, 20.0),
          end: const Offset(0.0, 0.0),
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
          begin: const Offset(0.0, 20.0),
          end: const Offset(0.0, 0.0),
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
          begin: const Offset(40.0, 0.0),
          end: const Offset(0.0, 0.0),
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

  List<Map<String, dynamic>> _reminders = [
    {'date': '', 'time': '', 'isOn': false},
    {'date': '', 'time': '', 'isOn': false},
    {'date': '', 'time': '', 'isOn': false},
  ];

  final TextEditingController _calendarController = TextEditingController();
  bool _isReminderOff = false;

  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Builder(
          builder: (context) {
            DatePickerThemeData _datePickerTheme =
                DatePickerTheme.of(context).copyWith(
              headerBackgroundColor: AppColors.primaryColorPink,
              headerForegroundColor: Colors.white,
              dividerColor: Colors.transparent,
            );
            return Theme(
              data: ThemeData(
                datePickerTheme: _datePickerTheme,
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primaryColorPink, // Color of the pointer
                  onPrimary: Colors.white, // Color of the text on the pointer
                ),
              ),
              child: child!,
            );
          },
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Builder(
            builder: (context) {
              DatePickerThemeData _datePickerTheme =
                  DatePickerTheme.of(context).copyWith(
                headerBackgroundColor: AppColors.primaryColorPink,
                headerForegroundColor: Colors.white,
                dividerColor: Colors.transparent,
              );
              return Theme(
                data: ThemeData(
                  datePickerTheme: _datePickerTheme,
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primaryColorPink, // Color of the pointer
                    onPrimary: Colors.white, // Color of the text on the pointer
                  ),
                ),
                child: child!,
              );
            },
          );
        },
      );
      if (pickedTime != null) {
        final formatterDate = DateFormat('dd/MM/yyyy');
        final formatterTime = DateFormat('HH:mm'); // 24-hour format
        setState(() {
          _reminders[index]['date'] = formatterDate.format(pickedDate);
          _reminders[index]['time'] = formatterTime.format(
            DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
                pickedTime.hour, pickedTime.minute),
          );
        });
      }
    }
  }

  void _onReminderSwitchChanged(bool value, int index) {
    // Update the state before API call
    setState(() {
      _reminders[index]['isOn'] = value;
    });

    if (value) {
      // API call when switch is toggled ON
      BlocProvider.of<ActivateBloc>(context).add(
        SetReminderRequested(
          userId: PrefUtils.getUserId(),
          time: _reminders[index]['time']!,
          reminderId: (index + 1).toString(),
        ),
      );
    } else {
      // API call when switch is toggled OFF (i.e., delete reminder)
      BlocProvider.of<ActivateBloc>(context).add(
        DeleteReminderRequested(
          reminderId: (index + 1).toString(),
          index: index,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    BlocProvider.of<ActivateBloc>(context).add(getReminderRequested());
  }

  void _updateDateTime() {
    final now = DateTime.now();
    final formatterDate = DateFormat('dd/MM/yyyy');
    final formatterTime = DateFormat('HH:mm');
    setState(() {
      for (var reminder in _reminders) {
        reminder['date'] = formatterDate.format(now);
        reminder['time'] = formatterTime.format(now);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;

    return BlocListener<ActivateBloc, LearnHowToActivateState>(
      listener: (context, state) {
        if (state is SetReminderSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Reminder set successfully!")),
          );
        } else if (state is SetReminderFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("Failed to set reminder: ${state.FailureResponse}")),
          );
        } else if (state is getReminderSuccess) {
          final List<dynamic> results = state.reminders;
          setState(() {
            // Set all reminders off by default
            for (int i = 0; i < _reminders.length; i++) {
              _reminders[i]['isOn'] = false;
            }

            // Loop through the reminders coming from the API
            for (var reminder in results) {
              int reminderId = int.parse(reminder['reminderId']);
              String time = reminder['time'];
              bool isOn = true; // Set this reminder to ON

              // Ensure the reminderId matches the correct index in _reminders list
              if (reminderId >= 1 && reminderId <= _reminders.length) {
                // Update time and set the switch to ON for the matching reminder
                _reminders[reminderId - 1]['time'] = time;
                _reminders[reminderId - 1]['isOn'] = isOn;
              }
            }
          });
        } else if (state is DeleteReminderSuccess) {
          // Handle the success state for delete reminder
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Reminder deleted successfully!")),
          );

          // Permanently turn off the switch in the UI
          setState(() {
            _reminders[state.index]['isOn'] =
                false; // This will work since state.index is now int
          });
        } else if (state is DeleteReminderFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Failed to delete reminder: ${state.FailureResponse}")),
          );
        } else if (state is getReminderFailure) {
          print("Failed To Get Reminder");
        } else if (state is getReminderLoading) {
          Center(child: CircularProgressIndicator(color: AppColors.pink));
        }
      },
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "Set Reminders",
                style: FTextStyle.appBarTitleStyle,
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: (displayType == 'desktop' || displayType == 'tablet')
                        ? 8.h
                        : 22.0),
                child: Image.asset(
                  "assets/Images/back.png",
                  height: (displayType == 'desktop' || displayType == 'tablet')
                      ? 60.h
                      : 14,
                  width: (displayType == 'desktop' || displayType == 'tablet')
                      ? 55.w
                      : 14,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(
                (displayType == 'desktop' || displayType == 'tablet')
                    ? 30.0
                    : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Divider(
                    thickness: screenHeight * 0.0015,
                    color: const Color(0XFFF6F6F6)),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(
                      left:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 20.h
                              : 20.0,
                      right:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 30.h
                              : 30,
                      bottom:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 5.h
                              : 5),
                  child:
                  Text(
                    'PELVIC FLOOR & DEEP ABS',
                    style: (displayType == 'desktop' || displayType == 'tablet')
                        ? FTextStyle.programsHeadingStyleTable
                        : FTextStyle.programsHeadingStyle,
                    softWrap: true,
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!),
                ),
                SizedBox(height: 5.h),
                Padding(
                    padding: EdgeInsets.only(
                        left: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? 20.h
                            : 20.0,
                        right: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? 30.h
                            : 30,
                        bottom: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? 5.h
                            : 5),
                    child: Text(
                      "We recommend 3 sessions a day but choose number of sessions you feel is achievable.",
                      style: FTextStyle.lightText,
                    )),
                SizedBox(height: 18.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: _reminders.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? 15.h
                                : 15.0,
                            vertical: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? 10.h
                                : 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? 8.h
                                          : 8.0),
                                  child: Text('0.${index + 1}',
                                          style: (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle
                                                  .set_reminder_index_tablet
                                              : FTextStyle.set_reminder_index)
                                      .animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                ),
                              ],
                            ),
                            _buildDateTimePicker(context, index),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(BuildContext context, int index) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;

    return Row(
      children: [
        Expanded(
          child: TextField(
            style: (displayType == 'desktop' || displayType == 'tablet')
                ? FTextStyle.set_reminder_text_field_tablet
                : FTextStyle.set_reminder_text_field,
            readOnly: true,
            onTap: () {
              _selectDate(context, index);
            },
            controller: TextEditingController(
              text: '${_reminders[index]['time']}', // Only show time now
            ),
            decoration: InputDecoration(
              hintText: 'Select Time', // Updated hint text
              contentPadding: EdgeInsets.symmetric(
                  vertical:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? 3.h
                          : 7,
                  horizontal:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? 10.h
                          : 7),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.date_border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.date_border),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.all(
                    (displayType == 'desktop' || displayType == 'tablet')
                        ? 10.h
                        : 10.0),
                child: Image.asset(
                  'assets/Images/remiderCalender.png',
                  color: AppColors.reminder_on,
                  width: (displayType == 'desktop' || displayType == 'tablet')
                      ? 20.w
                      : 10,
                  height: (displayType == 'desktop' || displayType == 'tablet')
                      ? 20.h
                      : 10,
                ),
              ),
            ),
          ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
        ),
        SizedBox(
            width: (displayType == 'desktop' || displayType == 'tablet')
                ? 10.h
                : 15),
        ReminderSwitch(
          onChanged: (value) => _onReminderSwitchChanged(value, index),
          isOn: _reminders[index]
              ['isOn'], // Keep the state based on the API response
        ),
      ],
    );
  }
}

class ReminderSwitch extends StatelessWidget {
  final ValueChanged<bool> onChanged;
  final bool isOn;

  const ReminderSwitch({Key? key, required this.onChanged, required this.isOn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Text(
            isOn ? 'Reminder On' : 'Reminder Off',
            style: TextStyle(
              color: isOn ? AppColors.reminder_on : AppColors.reminder_off,
              fontFamily: 'Poppins-Regular',
              fontWeight: (displayType == 'desktop' || displayType == 'tablet')
                  ? FontWeight.w300
                  : FontWeight.w500,
              fontSize: (displayType == 'desktop' || displayType == 'tablet')
                  ? 10.sp
                  : 15,
            ),
          ),
        ),
        Transform.scale(
          scale:
              (displayType == 'desktop' || displayType == 'tablet') ? 1.1 : 0.8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Switch(
              value: isOn, // Switch state directly controlled by parent
              onChanged: onChanged,
              activeTrackColor: AppColors.reminder_on,
              activeColor: Colors.white,
              inactiveTrackColor: AppColors.reminder_off,
              inactiveThumbColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
