import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';

class ChildHoodSearch extends StatefulWidget {
  const ChildHoodSearch({Key? key}) : super(key: key);

  @override
  State<ChildHoodSearch> createState() => _ChildHoodSearchState();
}

class _ChildHoodSearchState extends State<ChildHoodSearch> {
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
  final formKey = GlobalKey<FormState>();
  String? developer;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Builder(
          builder: (context) {
            DatePickerThemeData _datePickerTheme = DatePickerTheme.of(context).copyWith(
              headerBackgroundColor: AppColors.appBlue,
              headerForegroundColor: Colors.white,
              dividerColor: Colors.transparent,
            );
            return Theme(
              data: ThemeData(
                datePickerTheme: _datePickerTheme,
                colorScheme: ColorScheme.light(
                  primary: AppColors.appBlue, // Color of the pointer
                  onPrimary: Colors.white, // Color of the text on the pointer
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
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
        isButtonEnabled();
      });
    }
  }

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController profession = TextEditingController();

  bool isButtonEnabled() {
    return _dateController.text.isNotEmpty;
  }

  bool isFilled = false;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title:  Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Childhood Calculator", style: FTextStyle.appBarTitleStyle)),
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
          child: ListView(
            children: [
              const Divider(thickness: 1.2, color: Color(0XFFF6F6F6)),
              Padding(
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
                          const Text(
                            "Childhood Calculator",
                            style: FTextStyle.heading,
                          ).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!),
                           Padding(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            child: Text(
                              "Select Date of birth",
                              style: FTextStyle.loginEmailFieldHeadingStyle,
                            ).animateOnPageLoad(animationsMap[
                            'imageOnPageLoadAnimation2']!),
                          ),
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
                                      hintText: _dateController.text.isEmpty ? "Select date and search" : null,
                                      hintStyle: FTextStyle.ForumsTextFieldHint,
                                      contentPadding: EdgeInsets.all(10.0),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                                IconButton(
                                  icon: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.appBlue,
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
                          ).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                            child: ElevatedButton(
                              onPressed: isButtonEnabled()
                                  ? () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => ConsultantListScreen()), // Replace NextPage() with your next page widget
                                // );
                              }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isButtonEnabled() ? AppColors.appBlue : Colors.grey,
                                textStyle: FTextStyle.buttonStyle,
                                minimumSize: const Size(double.infinity, 52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 2,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Search',
                                  style: FTextStyle.buttonStyle,
                                ),
                              ),
                            ),
                          ).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!),
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
    );
  }
}


