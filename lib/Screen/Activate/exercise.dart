import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/Activate/activate_bloc.dart';
import 'package:health2mama/apis/Activate/activate_event.dart';
import 'package:health2mama/apis/Activate/activate_state.dart';
import 'package:pie_chart/pie_chart.dart';

class Exercise extends StatefulWidget {
  const Exercise({super.key});

  @override
  State<Exercise> createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  List<dynamic>? result = [];
  int remainingPoints = 0;
  int totalPoints = 0;
  String progressText = "100";
  final Color healthPointsColor = Color.fromARGB(255, 2, 178, 175);
  final Color remainingPointsColor = Color.fromARGB(255, 46, 150, 255);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ActivateBloc>(context).add(getExerciseRecord());
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

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    int progressPercentage = int.tryParse(progressText) ?? 0;
    progressPercentage = progressPercentage.clamp(0, 100);

    int currentStep = (progressPercentage * 75) ~/ 100;

    final Map<String, double> dataMap = {
      "Achieved Points": totalPoints.toDouble(),
      "Remaining Points": remainingPoints.toDouble(),
    };

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
              padding: EdgeInsets.only(
                  left: (displayType == 'desktop' || displayType == 'tablet')
                      ? 10.h
                      : 8.0),
              child:
              Text("Exercise Records", style: FTextStyle.appBarTitleStyle)),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(
                  left: (displayType == 'desktop' || displayType == 'tablet')
                      ? 10.h
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
        body: BlocListener<ActivateBloc, LearnHowToActivateState>(
          listener: (context, state) {
            if (state is GetExerciseRecordLoading) {
              Center(child: CircularProgressIndicator(color: AppColors.pink));
            } else if (state is GetExerciseRecordLoaded) {
              setState(() {
                totalPoints = state.totalPoints ?? 0;
                result = state.result ?? [];
                int totalHealthPoints = (result?.length ?? 0) * 40;
                remainingPoints = totalHealthPoints - totalPoints;
                progressText = (totalPoints / totalHealthPoints * 100).toStringAsFixed(0);
              });
            } else if (state is GetExerciseRecordError) {
              setState(() {
                String response = state.failureResponse['responseMessage'];
                print(response);
              });
            }
          },
          child: Padding(
            padding: EdgeInsets.all(
                (displayType == 'desktop' || displayType == 'tablet')
                    ? 30.0
                    : 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  thickness: 1.2,
                  color: Color(0XFFF6F6F6),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? 20.h
                            : 28.0,
                        vertical: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? 30.h
                            : 10),
                    child: Text(
                      "This Week",
                      style: FTextStyle.appBarTitleStyle,
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? 20.h
                            : 35),
                    child: Text(
                      "Activate Session",
                      style:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? FTextStyle.lightTextTablet
                          : FTextStyle.lightText,
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: (displayType == 'desktop' || displayType == 'tablet')
                          ? 20.h
                          : 28.0,
                      vertical: (displayType == 'desktop' || displayType == 'tablet')
                          ? 30.h
                          : 20.h,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5), // Outer border to simulate the gap
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white, // Color of the gap
                              width: 4,
                            ),
                          ),
                          child: PieChart(
                            dataMap: dataMap,
                            chartType: ChartType.ring,
                            colorList: [healthPointsColor, remainingPointsColor],
                            legendOptions: LegendOptions(
                              showLegends: false, // Hide default legend
                            ),
                            chartRadius: (displayType == 'desktop' || displayType == 'tablet')
                                ? 160.w
                                : 150,
                            ringStrokeWidth: 32, // Increase stroke width for more separation
                          ),
                        ),
                        SizedBox(height: 15), // Space between chart and indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              color: healthPointsColor,
                            ),
                            SizedBox(width: 5),
                            Text("Achieved Points", style: FTextStyle.lightText),
                            SizedBox(width: 20),
                            Container(
                              width: 15,
                              height: 15,
                              color: remainingPointsColor,
                            ),
                            SizedBox(width: 5),
                            Text("Remaining Points", style: FTextStyle.lightText),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: (displayType == 'desktop' || displayType == 'tablet')
                          ? 38.h
                          : 28.0,
                      vertical: 20.h,
                    ),
                    child: Text(
                      "${totalPoints ?? 0} Healthy Points Awarded",
                      style: (displayType == 'desktop' || displayType == 'tablet')
                          ? FTextStyle.lightTextTablet1
                          : FTextStyle.lightText1,
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
