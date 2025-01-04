import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/healthpoint/healthpoint_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:developer' as developer;
class HealthPoint extends StatefulWidget {
  const HealthPoint({super.key});

  @override
  State<HealthPoint> createState() => _HealthPointState();
}

class _HealthPointState extends State<HealthPoint> {
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
  int getWeekNumber(DateTime date) {
    final year = date.year;
    final firstDayOfYear = DateTime(year, 1, 1);
    final firstDayOfYearDay = firstDayOfYear.weekday;

    if (firstDayOfYearDay == DateTime.sunday) {
      if (date.isBefore(DateTime(year, 1, 2))) {
        return 1;
      } else {
        final daysSinceJan2 = date
            .difference(DateTime(year, 1, 2))
            .inDays;
        return ((daysSinceJan2 + 1) / 7).ceil() + 1;
      }
    }

    final nearestMonday = date.subtract(Duration(days: (date.weekday + 6) % 7));
    final daysDifference = nearestMonday
        .difference(firstDayOfYear)
        .inDays;
    final weekNumber = (daysDifference +
        (firstDayOfYearDay == DateTime.sunday ? 1 : 0)) ~/ 7 + 1;

    return weekNumber;
  }
  int weeklyGoal = 0; // Default value
  List<int> weeklyPoints = List.filled(52, 0);
  List<int> weeklyGoals = [];
  int currentWeekPoints = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HealthpointBloc>(context).add(FetchWeeklyPoints());
    BlocProvider.of<HealthpointBloc>(context).add(FetchWeeklyGoalEvent());
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(
                  left: (displayType == 'desktop' || displayType == 'tablet')
                      ? 15.h
                      : 15,
                  top: (displayType == 'desktop' || displayType == 'tablet')
                      ? 3.h
                      : 3),
              child: Image.asset(
                'assets/Images/back.png', // Replace with your image path
                width: (displayType == 'desktop' || displayType == 'tablet')
                    ? 24.w
                    : 24, // Set width as needed
                height: (displayType == 'desktop' || displayType == 'tablet')
                    ? 24.h
                    : 24, // Set height as needed
              ),
            ),
          ),
        ),
        body: BlocListener<HealthpointBloc, HealthpointState>(
          listener: (context, state) {
            if (state is CreateWeeklyGoalLoaded) {
              BlocProvider.of<HealthpointBloc>(context)
                  .add(FetchWeeklyGoalEvent());
              CommonPopups.showCustomPopup(
                  context, state.successResponse['responseMessage']);
            } else if (state is CreateWeeklyGoalError) {
              CommonPopups.showCustomPopup(
                  context, state.failureResponse['responseMessage']);
            }
            else if (state is WeeklyPointsLoaded) {
              final successResponse = state.successResponse;
              developer.log('WeeklyPointsLoaded successResponse: $successResponse');
              final result = successResponse['result'] ?? {};
              final userPoints = List<Map<String, dynamic>>.from(result['userPoints'] ?? []);
              developer.log('userPoints data: $userPoints');

              final weeklyPointsByYear = <int, List<int>>{};
              for (var point in userPoints) {
                try {
                  final entryDate = DateTime.parse(point['date']);
                  final entryYear = entryDate.year;
                  final entryWeekNumber = getWeekNumber(entryDate);
                  weeklyPointsByYear.putIfAbsent(entryYear, () => List<int>.filled(52, 0));
                  final points = point['points'];
                  if (points != null) {
                    developer.log('Adding $points points for Year: $entryYear, Week: $entryWeekNumber');
                    weeklyPointsByYear[entryYear]![entryWeekNumber - 1] += (points as int);
                  } else {
                    developer.log('No points found for entry: $point');
                  }
                } catch (e) {
                  developer.log('Error parsing date or points for entry: $point - Error: $e');
                }
              }

              final now = DateTime.now();
              final currentYear = now.year;
              final weeklyPointsArray = weeklyPointsByYear[currentYear] ?? List.filled(52, 0);
              final currentWeekNumber = getWeekNumber(now);
              final thisWeekPoints = weeklyPointsArray[currentWeekNumber - 1];
              // Print the formatted data
              print("Processed Weekly Points Data: $weeklyPointsArray");
              print("Latest Week Points for Year $currentYear, Week $currentWeekNumber: $thisWeekPoints");
              setState(() {
                currentWeekPoints = thisWeekPoints;
              });
              setState(() {
                weeklyPoints = weeklyPointsArray;
              });
            } else if (state is WeeklyGoalLoaded) {
              final successResponse = state.successResponse;
              final result = successResponse['result'] ?? {};
              final userWeeklyGoals = List<Map<String, dynamic>>.from(result['userWeeklyGoal'] ?? []);
              developer.log('userWeeklyGoals data: $userWeeklyGoals');

              final weeklyGoalsByYear = <int, List<int>>{};
              for (var goal in userWeeklyGoals) {
                try {
                  final entryDate = DateTime.parse(goal['date']);
                  final entryYear = entryDate.year;
                  final entryWeekNumber = getWeekNumber(entryDate);
                  weeklyGoalsByYear.putIfAbsent(entryYear, () => List<int>.filled(52, 0));
                  final goalValue = goal['weeklyGoal'];
                  if (goalValue != null) {
                    developer.log('Adding $goalValue goal for Year: $entryYear, Week: $entryWeekNumber');
                    weeklyGoalsByYear[entryYear]![entryWeekNumber - 1] += (goalValue as int);
                  } else {
                    developer.log('No goal found for entry: $goal');
                  }
                } catch (e) {
                  developer.log('Error parsing date or goal for entry: $goal - Error: $e');
                }
              }

              final now = DateTime.now();
              final currentYear = now.year;
              final weeklyGoalsArray = weeklyGoalsByYear[currentYear] ?? List.filled(52, 0);
              final currentWeekNumber = getWeekNumber(now);
              final thisWeekGoal = weeklyGoalsArray[currentWeekNumber - 1];

              // Print the formatted data
              print("Processed Weekly Goals Data: $weeklyGoalsArray");
              print("Latest Week Goal for Year $currentYear, Week $currentWeekNumber: $thisWeekGoal");

              setState(() {
                weeklyGoal = thisWeekGoal;
              });
              setState(() {
                weeklyGoals = weeklyGoalsArray;
              });
            }

          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  thickness: 2,
                  color: Color(0XFFF6F6F6),
                ),
                Padding(
                  padding: (displayType == 'desktop' || displayType == 'tablet')
                      ? EdgeInsets.symmetric(horizontal: 25.w, vertical: 5)
                      : EdgeInsets.symmetric(horizontal: 28.0, vertical: 5),
                  child: Text(
                    "Health Points",
                    style: FTextStyle.appBarTitleStyle,
                  ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                ),
                Padding(
                  padding: (displayType == 'desktop' || displayType == 'tablet')
                      ? EdgeInsets.symmetric(horizontal: 25.w)
                      : const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Text(
                    "5 Point Award each time you complete a workout, recipe & advice.",
                    style: (displayType == 'desktop' || displayType == 'tablet')
                        ? FTextStyle.lightTextTablet
                        : FTextStyle.lightText,
                  ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                ),
                Padding(
                  padding: (displayType == 'desktop' || displayType == 'tablet')
                      ? EdgeInsets.symmetric(horizontal: 25.w, vertical: 32)
                      : const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.cardBack,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cardBack),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'This Week Points',
                                  style: FTextStyle.small,
                                ),
                                Text(
                                  '$currentWeekPoints',
                                  style: FTextStyle.cardTitle10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 18.0),
                          child: VerticalDivider(
                            thickness: 1,
                            color: Colors.black12,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Weekly Goal',
                                  style: FTextStyle.small,
                                ),
                                Text(
                                  '$weeklyGoal',
                                  style: FTextStyle.clearAll15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                Padding(
                  padding: (displayType == 'desktop' || displayType == 'tablet')
                      ? EdgeInsets.symmetric(horizontal: 25.w)
                      : const EdgeInsets.symmetric(horizontal: 28.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SetWeeklyGoalDialog();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pinkButton,
                      textStyle: FTextStyle.buttonStyle,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 0,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'SET MY WEEKLY GOAL',
                        style: FTextStyle.buttonStyleHealth,
                      ),
                    ),
                  ),
                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                Padding(
                  padding: (displayType == 'desktop' || displayType == 'tablet')
                      ? EdgeInsets.symmetric(horizontal: 25.w, vertical: 25)
                      : const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
                  child: Container(
                    height: screenHeight * 0.49,
                    child: ColumnChart(
                      weeklyPoints: weeklyPoints, // Ensure this is populated
                      weeklyGoals: weeklyGoals,   // Ensure this is populated
                    ),
                  ),
                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class ColumnChart extends StatelessWidget {
  final List<int> weeklyPoints;
  final List<int> weeklyGoals;

  ColumnChart({required this.weeklyPoints, required this.weeklyGoals});

  @override
  Widget build(BuildContext context) {
    // Calculate the maximum value from both lists
    final maxPoints = weeklyPoints.isNotEmpty ? weeklyPoints.reduce((a, b) => a > b ? a : b) : 0;
    final maxGoals = weeklyGoals.isNotEmpty ? weeklyGoals.reduce((a, b) => a > b ? a : b) : 0;

    // Define maximum value of the Y-axis to be the greater of maxPoints or maxGoals, with a margin
    final yAxisMaximum = (maxPoints > maxGoals ? maxPoints : maxGoals) * 1.1; // Adding 10% margin

    return SfCartesianChart(
      title: ChartTitle(text: 'Weekly Points and Goals',textStyle: FTextStyle.buttonStyleHealth1,
      ),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.scroll,
        textStyle: TextStyle(fontSize: 12, color: Colors.black),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        canShowMarker: true,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true, // Enables zooming with pinch gesture
        enablePanning: true, // Enables panning with dragging gesture
        zoomMode: ZoomMode.xy, // Allows zooming in both x and y directions
      ),
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 'Weeks'),
        labelStyle: TextStyle(fontSize: 12, color: Colors.black),
        interval: 6, // Weeks 1, 5, 10, etc.
        majorGridLines: const MajorGridLines(width: 1),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          // Format axis labels to show only the desired weeks
          final weekNumber = int.tryParse(details.text) ?? 0;
          if (weekNumber % 2 == 1) { // Show odd weeks
            return ChartAxisLabel('$weekNumber', TextStyle(fontSize: 12, color: Colors.black));
          } else {
            return ChartAxisLabel('', TextStyle(fontSize: 0, color: Colors.transparent)); // Hide even weeks
          }
        },
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Points'),
        minimum: 0,
        maximum: yAxisMaximum,
        interval: 5000, // Set interval to 5000
        labelStyle: TextStyle(fontSize: 12, color: Colors.black),
        majorGridLines: const MajorGridLines(width: 1),
      ),
      series: <ChartSeries>[
        // First add Weekly Goal as a bar chart
        ColumnSeries<int, String>(
          xValueMapper: (int goal, int index) => (index + 1).toString(),
          yValueMapper: (int goal, _) => goal,
          color: Colors.blue, // Set color to blue for weekly goals
          width: 0.4,
          dataSource: weeklyGoals,
          name: 'Weekly Goal',
          dataLabelSettings: DataLabelSettings(
            isVisible: false, // Disable data labels
          ),
        ),
        // Then add Weekly Points as a bar chart
        ColumnSeries<int, String>(
          xValueMapper: (int points, int index) => (index + 1).toString(),
          yValueMapper: (int points, _) => points,
          color: Colors.pink, // Set color to pink for weekly points
          width: 0.4,
          dataSource: weeklyPoints,
          name: 'Weekly Points',
          dataLabelSettings: DataLabelSettings(
            isVisible: false, // Disable data labels
          ),
        ),
      ],
    );
  }
}

class SetWeeklyGoalDialog extends StatefulWidget {
  @override
  _SetWeeklyGoalDialogState createState() => _SetWeeklyGoalDialogState();
}

class _SetWeeklyGoalDialogState extends State<SetWeeklyGoalDialog> {
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
  final TextEditingController weeklypointsTextField = TextEditingController();
  bool isConfirmButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Add listener to update button state based on text field input
    weeklypointsTextField.addListener(() {
      setState(() {
        isConfirmButtonEnabled = weeklypointsTextField.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    weeklypointsTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Set my weekly goal",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)).animateOnPageLoad(
                animationsMap['imageOnPageLoadAnimation2']!),
            const SizedBox(height: 20),
            TextFormField(
              maxLength: 3, // Limit to 3 digits
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Allow only numbers
              ],
              controller: weeklypointsTextField,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(),
                labelText: "Weekly Goal",
              ),
            ).animateOnPageLoad(
                animationsMap['imageOnPageLoadAnimation2']!),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text("Cancel",
                      style: FTextStyle.buttonStyleHealth1).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  child: const Text("Confirm",
                      style: FTextStyle.buttonStyleHealth).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!),
                  onPressed: isConfirmButtonEnabled
                      ? () {
                    final int goal =
                        int.tryParse(weeklypointsTextField.text) ?? 0;
                    BlocProvider.of<HealthpointBloc>(context)
                        .add(CreateWeeklyGoalEvent(goal));
                    weeklypointsTextField.text = '';
                    Navigator.of(context).pop();
                  }
                      : null, // Disable button if not enabled
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isConfirmButtonEnabled
                        ? AppColors.pinkButton
                        : Colors.grey, // Change color if disabled
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),

                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}