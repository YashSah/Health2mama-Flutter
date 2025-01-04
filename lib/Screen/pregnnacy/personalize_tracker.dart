import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/pregnnacy/pregnnacy_tracker.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/constant.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/pregnancy/pregnancy_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalizedTracker extends StatefulWidget {
  const PersonalizedTracker({super.key});

  @override
  State<PersonalizedTracker> createState() => _PersonalizedTrackerState();
}

class _PersonalizedTrackerState extends State<PersonalizedTracker> {
  final formKey = GlobalKey<FormState>();
  String? developer;

  bool serviceVisible = false;
  bool specialist = false;
  String servicesStage = ""; // Initial stage selection
  String? dueDate;
  bool isLoading = false;

  List<Map<String, dynamic>> serviceStages = [
    {
      "title": Constants.services1,
      "value": Constants.services1,
      "selected": false
    },
    {
      "title": Constants.services2,
      "value": Constants.services2,
      "selected": false
    },
    {
      "title": Constants.services3,
      "value": Constants.services3,
      "selected": false
    },
    {
      "title": Constants.services4,
      "value": Constants.services4,
      "selected": false
    }
  ];
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

  final TextEditingController _calendarController = TextEditingController();
  final TextEditingController profession = TextEditingController();

  bool isButtonEnabled() {
    return servicesStage.isNotEmpty && _calendarController.text.isNotEmpty;
  }

  void showPregnancyDueDateDialog(BuildContext context, String dueDate) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Image
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  'assets/Images/pregnantWoman.png', // Replace with your image asset path
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              // Estimated Due Date Text
              Center(
                child: Text(
                  'Your Estimated Due Date:',
                  style: FTextStyle.blackstyle
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  dueDate,
                  style: FTextStyle.blackstyle
                ),
              ),
              SizedBox(height: 20.0),
              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF58CAB), // Background color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    textStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    BlocProvider.of<PregnancyBloc>(context).add(FetchTrimesterData());
                    BlocProvider.of<PregnancyBloc>(context).add(LoadUserProfile());
                  },
                  child: Text('Go to Pregnancy Tracker',style: FTextStyle.buttonStyle),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String selectedService = Constants.services1; // Example initialization

  void calculateDueDate(DateTime selectedDate) {
    int daysToAdd;

    // Determine the number of days to add based on the selected service
    switch (selectedService) {
      case Constants.services1:
        daysToAdd = 280;
        break;
      case Constants.services2:
        daysToAdd = 277;
        break;
      case Constants.services3:
        daysToAdd = 275;
        break;
      case Constants.services4:
        daysToAdd = 0; // Assuming this means the selected date is the due date
        break;
      case Constants.services5:
        daysToAdd = 280; // Example for first trimester start
        break;
      case Constants.services6:
        daysToAdd = 189; // Example for second trimester start
        break;
      case Constants.services7:
        daysToAdd = 98; // Example for third trimester start
        break;
      default:
        daysToAdd = 280; // Default if no valid service is selected
    }

    DateTime dueDateTime = selectedDate.add(Duration(days: daysToAdd));

    setState(() {
      dueDate = DateFormat('yyyy-MM-dd').format(dueDateTime); // Format as 'yyyy-MM-dd'
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, 1, 1), // Allow past dates from the start of the current year
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)), // 10 years in the future
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
        _calendarController.text = DateFormat('dd-MM-yyyy').format(picked); // Set the selected date
        calculateDueDate(picked); // Calculate and update the due date
      });
    }
  }

// Assuming this is inside the build method or a method that can access the context
  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text("Pregnancy Calculator", style: FTextStyle.appBarTitleStyle),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Image.asset(
                "assets/Images/back.png",
                height: 14,
                width: 14,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: BlocListener<PregnancyBloc, PregnancyState>(
            listener: (context, state) {
              if (state is DueDateSuccess) {
                setState(() {
                  isLoading = false;
                });
              } else if (state is DueDateFailure) {
                setState(() {
                  isLoading = false;
                });
              }
              else if (state is DueDateLoading){
                setState(() {
                  isLoading = true;
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: (displayType == 'desktop' ||
                      displayType == 'tablet')
                      ? 45.h
                      : 0),
              child: ListView(
                children: [
                  const Divider(thickness: 1.2, color: Color(0XFFF6F6F6)),
                  Padding (
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0.0, 0.0),
                            color: Colors.grey,
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                                child: Text(
                                  "Pregnancy Due Date Calculator",
                                  style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle.headingTablet
                                      : FTextStyle.heading,
                                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 18, bottom: 8),
                                child: Text(
                                  "What stage are you in",
                                  style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle
                                      .loginEmailFieldHeadingStyleTablet
                                      : FTextStyle
                                      .loginEmailFieldHeadingStyle,
                                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: serviceVisible
                                          ? AppColors.boarderColour
                                          : AppColors.boarderColour,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.boarderColour,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.boarderColour,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: AppColors.pinkButton,
                                    size: 30,
                                  ),
                                  hintText: "Select stage",
                                  // hintStyle: TextStyle(
                                  //     color: servicesStage.isEmpty ? Colors.grey : Colors.black),

                                  hintStyle: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle
                                      .loginFieldHintTextStyleTablet
                                      : FTextStyle.loginFieldHintTextStyle,
                                  errorStyle: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle
                                      .formFieldErrorTxtStyleTablet
                                      : FTextStyle
                                      .formFieldErrorTxtStyle,
                                ),
                                readOnly: true,
                                controller: TextEditingController(text: servicesStage),
                                style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                    ? FTextStyle.cardSubtitleTablet
                                    : FTextStyle.cardSubtitle,
                                maxLines: 1,
                                onTap: () {
                                  setState(() {
                                    serviceVisible = !serviceVisible;
                                  });
                                },
                              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                              Visibility(
                                visible: serviceVisible,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: serviceStages.map((stage) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                // Deselect all other stages
                                                for (var s in serviceStages) {
                                                  s['selected'] = false;
                                                }
                                                // Select the tapped stage
                                                stage['selected'] = true;

                                                // Update the servicesStage with the selected stage
                                                servicesStage = stage['value'];
                                                selectedService = stage['value']; // Update the selectedService

                                                // Close the dropdown after selection
                                                serviceVisible = false;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      // Deselect all other stages
                                                      for (var s in serviceStages) {
                                                        s['selected'] = false;
                                                      }
                                                      // Select the tapped stage
                                                      stage['selected'] = true;

                                                      // Update the servicesStage with the selected stage
                                                      servicesStage = stage['value'];
                                                      selectedService = stage['value']; // Update the selectedService

                                                      // Close the dropdown after selection
                                                      serviceVisible = false;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(3),
                                                        border: Border.all(
                                                          color: stage['selected'] == true
                                                              ? AppColors.primaryColorPink
                                                              : AppColors.boarderColour,
                                                          width: 1.5,
                                                        ),
                                                        color: stage['selected'] == true
                                                            ? AppColors.primaryColorPink
                                                            : Colors.white,
                                                      ),
                                                      child: stage['selected'] == true
                                                          ? const Icon(
                                                        Icons.check_box,
                                                        color: Colors.white,
                                                        size: 24,
                                                      )
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    stage['title'],
                                                    maxLines: 3,
                                                    style: (displayType ==
                                                        'desktop' ||
                                                        displayType ==
                                                            'tablet')
                                                        ? FTextStyle
                                                        .rememberMeTextStyleTablet
                                                        : FTextStyle
                                                        .rememberMeTextStyle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (stage != serviceStages.last)
                                            const Padding(
                                              padding: EdgeInsets.only(top: 15, bottom: 10),
                                              child: Divider(
                                                color: AppColors.darkGreyColor,
                                                height: 0.5,
                                              ),
                                            ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 8, top: 14),
                                child: Text(
                                  "Enter Date",
                                  style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle
                                      .loginEmailFieldHeadingStyleTablet
                                      : FTextStyle
                                      .loginEmailFieldHeadingStyle,
                                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: serviceVisible
                                          ? AppColors.boarderColour
                                          : AppColors.boarderColour,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.boarderColour,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.boarderColour,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                  suffixIcon: GestureDetector(
                                    onTap: () async {
                                      final DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(DateTime.now().year - 5),
                                        lastDate: DateTime(DateTime.now().year + 5),
                                        builder: (BuildContext context, Widget? child) {
                                          return Theme(
                                            data: ThemeData(
                                              primaryColor: AppColors.primaryColorPink,
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );

                                      if (pickedDate != null) {
                                        final formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                        setState(() {
                                          _calendarController.text = formattedDate;
                                          calculateDueDate(pickedDate); // Recalculate due date based on selected stage
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: AppColors.pinkButton,
                                      size: 24,
                                    ),
                                  ),
                                  hintText: "Select date and search",
                                  hintStyle: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle
                                      .loginFieldHintTextStyleTablet
                                      : FTextStyle.loginFieldHintTextStyle,
                                  errorStyle: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle
                                      .formFieldErrorTxtStyleTablet
                                      : FTextStyle
                                      .formFieldErrorTxtStyle, // Set hint color to grey if userPregnancyStage is empty, otherwise black

                                ),
                                readOnly: true,
                                controller: _calendarController,
                                style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                    ? FTextStyle.cardSubtitleTablet
                                    : FTextStyle.cardSubtitle,
                                maxLines: 1,
                                onTap: () {
                                  _selectDate(context); // Show the date picker
                                },
                              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 5),
                                child: ElevatedButton(
                                  onPressed: isButtonEnabled()
                                      ? () {
                                    print(dueDate);
                                    if (dueDate != null && dueDate!.isNotEmpty) {
                                      BlocProvider.of<PregnancyBloc>(context)
                                          .add(DueDateCalculator(dueDate!));
                                      showPregnancyDueDateDialog(context, dueDate.toString());
                                    }
                                  }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isButtonEnabled()
                                        ? AppColors.pinkButton
                                        : Colors.grey,
                                    textStyle: FTextStyle.buttonStyle,
                                    minimumSize: const Size(double.infinity, 52),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Search',
                                      style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                          ? FTextStyle.buttonStyleTablet
                                          : FTextStyle.buttonStyle,
                                    ),
                                  ),
                                ),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
