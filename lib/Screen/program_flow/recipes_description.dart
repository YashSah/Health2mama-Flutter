import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/program_flow/programflow_bloc.dart';
import 'package:health2mama/apis/program_flow/programflow_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:screenshot/screenshot.dart';


class RecipesDescription extends StatefulWidget {
  final String recipeName;
  final String recipeThumbnailImage;
  final int preparationTime;
  final int servings;
  final String ingredientDetails;
  final String notes;
  final List<String> steps;
  final List<Map<String, dynamic>> nutrition;
  final String recipeType;

  const RecipesDescription({
    Key? key,
    required this.recipeName,
    required this.recipeThumbnailImage,
    required this.preparationTime,
    required this.servings,
    required this.ingredientDetails,
    required this.notes,
    required this.steps,
    required this.nutrition,
    required this.recipeType,
  }) : super(key: key);

  @override
  _RecipesDescriptionState createState() => _RecipesDescriptionState();
}

class _RecipesDescriptionState extends State<RecipesDescription> {
  int stepIndex = 0;
  bool isSaved = false;
  bool isCompleted = false;
  bool pointsAdded = false;
  String actionType = '';
  ScreenshotController screenshotController = ScreenshotController();

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
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProgramflowBloc>(context).add(FetchSaveUnsaveStatus(
        itemId: PrefUtils.getitemId(), categoryId: PrefUtils.getCategoryId()));
  }
  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              // Add your action here, if needed
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    (displayType == 'desktop' || displayType == 'tablet')
                        ? 4.w
                        : screenWidth * 0.03,
                vertical: (displayType == 'desktop' || displayType == 'tablet')
                    ? 2.w
                    : screenWidth * 0.01,
              ),
              child: Image.asset(
                'assets/Images/back.png', // Replace with your image path
                width: (displayType == 'desktop' || displayType == 'tablet')
                    ? 35.w
                    : 35, // Set width as needed
                height: (displayType == 'desktop' || displayType == 'tablet')
                    ? 35.h
                    : 35, // Set height as needed
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                downloadClick();
              },
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Image.asset(
                  "assets/Images/download.png",
                  width: (displayType == 'desktop' || displayType == 'tablet')
                      ? 24.h
                      : 24, // Adjust width as needed
                  height:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? 24.w
                          : 24, // Adjust height as needed
                ),
              ),
            ),
          ],
        ),
        body: BlocListener<ProgramflowBloc, ProgramflowState>(
          listener: (context, state) {
            if (state is SaveUnsaveStatusLoading) {
              print('Save Unsave Status Loading');
            }
            else if (state is SaveUnsaveStatusLoaded) {
              setState(() {
                isSaved = state.isSaved;
                isCompleted = state.isCompleted;
              });
            } else if (state is SaveUnsaveItemSuccess) {
              if (actionType == 'complete') {
                CommonPopups.showCustomPopup(context, 'Topic completed successfully.');
              } else if (actionType == 'save') {
                CommonPopups.showCustomPopup(context, 'Topic saved successfully.');
              } else if (actionType == 'unsave') {
                CommonPopups.showCustomPopup(context, 'Topic unsaved successfully.');
              }
            } else if (state is SaveUnsaveItemFailure) {
              CommonPopups.showCustomPopup(
                context,
                state.failureresponse['responseMessage'],
              );
            }
          },
  child: SafeArea(
            child: Screenshot(
              controller: screenshotController,
              child: Column(
                        children: [
              Expanded(
                child: ListView(
                  children: [
                    Divider(thickness: 1,color:AppColors.primaryGreyColor),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.recipeName,
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle
                                          .recipeDescriptionValueTextStyleTab
                                      : FTextStyle
                                          .recipeDescriptionValueTextStyle)
                              .animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.6,
                      width: double.infinity,
                      child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                widget.recipeThumbnailImage,
                                fit: BoxFit.cover,
                              ))
                          .animateOnPageLoad(
                              animationsMap['imageOnPageLoadAnimation2']!),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.018),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IntrinsicWidth(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(screenHeight * 0.009),
                                border: Border.all(width: screenWidth * 0.003, color: AppColors.blue1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    if (!isCompleted) {
                                      if (widget.recipeName != null) {
                                        final categoryId = PrefUtils.getCategoryId();
                                        if (categoryId != null) {
                                          final List<String> categoryIds = [categoryId];
                                          final categoryIdsJsonString = jsonEncode(categoryIds); // Convert list to JSON string
              
                                          // Dispatch event to save completion status
                                          BlocProvider.of<ProgramflowBloc>(context).add(
                                            SaveUnsaveItemEvent(
                                              itemName: widget.recipeName,
                                              itemId: PrefUtils.getitemId(),
                                              categoryId: categoryIdsJsonString, // Pass JSON string
                                              isCompleted: 'true',
                                            ),
                                          );
                                          setState(() {
                                            actionType = 'complete'; // Set action to complete
                                            isCompleted = true;
                                          });
              
                                          // Add points only the first time
                                          if (!pointsAdded) {
                                            BlocProvider.of<ProgramflowBloc>(context).add(
                                              AddPointsToWalletEvent(5),
                                            );
              
                                            setState(() {
                                              pointsAdded = true;
                                            });
                                          }
                                        }
                                      }
                                    } else {
                                      // Show "Topic already completed" message for subsequent taps
                                      CommonPopups.showCustomPopup(
                                        context,
                                        'Topic already completed',
                                      );
                                    }
                                  },
              
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/Images/IconCheck.png',
                                        width: (displayType == 'desktop' || displayType == 'tablet') ? 15.w : 15,
                                        height: (displayType == 'desktop' || displayType == 'tablet') ? 15.h : 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          isCompleted ? 'Completed' : 'Complete',
                                          style: (displayType == 'desktop' || displayType == 'tablet')
                                              ? FTextStyle.recipeNameButtonTextStyleTab
                                              : FTextStyle.recipeNameButtonTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02), // Adjust spacing between containers
                          IntrinsicWidth(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(screenHeight * 0.009),
                                border: Border.all(width: screenWidth * 0.003, color: AppColors.blue1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    if (widget.recipeName != null) {
                                      final categoryId = PrefUtils.getCategoryId();
                                      if (categoryId != null) {
                                        final List<String> categoryIds = [categoryId];
                                        final String categoryIdsJsonString = jsonEncode(categoryIds);
              
                                        BlocProvider.of<ProgramflowBloc>(context).add(
                                          SaveUnsaveItemEvent(
                                            itemName: widget.recipeName,
                                            itemId: PrefUtils.getitemId(),
                                            categoryId: categoryIdsJsonString,
                                            isSaved: isSaved ? 'true' : 'true',
                                          ),
                                        );
                                        setState(() {
                                          actionType = isSaved ? 'unsave' : 'save'; // Set action based on state
                                        });
                                        setState(() {
                                          isSaved = !isSaved;
                                        });
                                      }
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/Images/SaveIcon.png',
                                        width: (displayType == 'desktop' || displayType == 'tablet') ? 15.w : 15,
                                        height: (displayType == 'desktop' || displayType == 'tablet') ? 15.h : 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          isSaved ? 'Unsave' : 'Save',
                                          style: (displayType == 'desktop' || displayType == 'tablet')
                                              ? FTextStyle.recipeNameButtonTextStyleTab
                                              : FTextStyle.recipeNameButtonTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          IntrinsicWidth(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    screenHeight * 0.009),
                                border: Border.all(
                                    width: screenWidth * 0.003,
                                    color: AppColors.blue1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    bool syncCalendarEnabled = await PrefUtils
                                        .getsyncCalendar(); // Assuming it returns a Future<bool>

                                    if (syncCalendarEnabled) {
                                      _openGoogleCalendar();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please turn on the Sync Calendar option under the My Account settings.',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/Images/IconCalender.png',
                                        width: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                            ? 15.w
                                            : 15,
                                        height: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                            ? 15.h
                                            : 15,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Schedule',
                                          style: (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                              ? FTextStyle
                                              .recipeNameButtonTextStyleTab
                                              : FTextStyle
                                              .recipeNameButtonTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? 24.h
                              : 24,
                          vertical: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? 34.h
                              : 12),
                      child: Row(
                        children: [
                          Text(
                            '${widget.preparationTime}m' ?? '',
                            style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? FTextStyle.recipeDescriptionValueTextStyleTab
                                : FTextStyle.recipeDescriptionValueTextStyle,
                          ).animateOnPageLoad(
                              animationsMap['imageOnPageLoadAnimation2']!),
                          Text(
                            ' prep | ',
                            style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? FTextStyle.recipeDescriptionPrepTextStyleTab
                                : FTextStyle.recipeDescriptionPrepTextStyle,
                          ).animateOnPageLoad(
                              animationsMap['imageOnPageLoadAnimation2']!),
                          Text(
                            'Serving ${widget.servings ?? ''}',
                            style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? FTextStyle.recipeDescriptionValueTextStyleTab
                                : FTextStyle.recipeDescriptionValueTextStyle,
                          ).animateOnPageLoad(
                              animationsMap['imageOnPageLoadAnimation2']!),
                          Text(
                            ' | ',
                            style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? FTextStyle.recipeDescriptionPrepTextStyleTab
                                : FTextStyle.recipeDescriptionPrepTextStyle,
                          ).animateOnPageLoad(
                              animationsMap['imageOnPageLoadAnimation2']!),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Ingredients',
                                style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle
                                        .recipeDescriptionTitleTextStyleTab
                                    : FTextStyle.recipeDescriptionTitleTextStyle,
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Column(
                              children: [
                                HtmlWidget(
                                widget.ingredientDetails,textStyle: FTextStyle.titleText,
                                ).animateOnPageLoad(
                                    animationsMap['imageOnPageLoadAnimation2']!),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Directions',
                                style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle
                                        .recipeDescriptionTitleTextStyleTab
                                    : FTextStyle.recipeDescriptionTitleTextStyle,
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 21),
                        color: Colors.white,
                        child: ListView.builder(
                            itemCount: widget.steps.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return IntrinsicHeight(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          verticalDirection:
                                              VerticalDirection.down,
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'assets/Images/circle.png'),
                                                  height: (displayType ==
                                                              'desktop' ||
                                                          displayType == 'tablet')
                                                      ? 38.h
                                                      : 38,
                                                  width: (displayType ==
                                                              'desktop' ||
                                                          displayType == 'tablet')
                                                      ? 38.w
                                                      : 38,
                                                ).animateOnPageLoad(animationsMap[
                                                    'imageOnPageLoadAnimation2']!),
                                                Text(
                                                  '${index + 1}',
                                                  style: (displayType ==
                                                              'desktop' ||
                                                          displayType == 'tablet')
                                                      ? FTextStyle.trakerStyleTab
                                                      : FTextStyle.trakerStyle,
                                                ).animateOnPageLoad(animationsMap[
                                                    'imageOnPageLoadAnimation2']!),
                                              ],
                                            ),
                                            Visibility(
                                              visible: !(index ==
                                                  widget.steps.length - 1),
                                              child: Container(
                                                height: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? 50.h
                                                    : 50,
                                                child: CustomPaint(
                                                  painter: LineDashedPainter(
                                                    lineColor:
                                                        AppColors.dashedLineColor,
                                                    strokeWidth:
                                                        2, // Adjust as needed
                                                    gapWidth:
                                                        5, // Adjust as needed
                                                    dashWidth:
                                                        3, // Adjust as needed
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.steps[index],
                                                style: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? FTextStyle
                                                        .filterLabelTextStyleTab
                                                    : FTextStyle
                                                        .filterLabelTextStyle,
                                              ).animateOnPageLoad(animationsMap[
                                                  'imageOnPageLoadAnimation2']!),
                                            ],
                                          ),
                                        )
                                      ]),
                                ),
                              );
                            })),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      child: Row(
                        children: [
                          Text(
                            'Nutrition',
                            style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? FTextStyle.recipeDescriptionTitleTextStyleTab
                                : FTextStyle.recipeDescriptionTitleTextStyle,
                          ).animateOnPageLoad(
                              animationsMap['imageOnPageLoadAnimation2']!),
                        ],
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: widget.nutrition.length,
                        itemBuilder: (context, index) {
                          final nutritionItem = widget.nutrition[index];
                          return Container(
                            color: (index % 2 == 0)
                                ? AppColors.recipesDescriptionDataColor
                                : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          nutritionItem['key'] ?? '',
                                          style: (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle
                                                  .recipeDescriptionTextStyleTab
                                              : FTextStyle
                                                  .recipeDescriptionTextStyle,
                                        ).animateOnPageLoad(
                                          animationsMap[
                                              'imageOnPageLoadAnimation2']!,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          nutritionItem['value'] ?? '',
                                          style: (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle
                                                  .recipeDescriptionTextStyleTab
                                              : FTextStyle
                                                  .recipeDescriptionTextStyle,
                                        ).animateOnPageLoad(
                                          animationsMap[
                                              'imageOnPageLoadAnimation2']!,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Notes',
                                style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle
                                        .recipeDescriptionTitleTextStyleTab
                                    : FTextStyle.recipeDescriptionTitleTextStyle,
                              ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: HtmlWidget(
                                    displayType == 'desktop' ||
                                            displayType == 'tablet'
                                        ? '''
                                <span style="font-weight: 600; font-family: 'Poppins-Regular'; font-size: 16px;">
                                  ${widget.notes}
                                </span>
                              '''
                                        : '''
                                <span style="font-weight: 400; font-family: 'Poppins-Regular'; font-size: 12px;">
                                  ${widget.notes}
                                </span>
                              ''',
                                  ).animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation2']!),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
                        ],
                      ),
            )),
),
      ),
    );
  }
  final String location = 'www.health2mama.com';
  void _openGoogleCalendar() async {
    final url = Uri.encodeFull(
      'https://calendar.google.com/calendar/render?action=TEMPLATE'
          '&text=${widget.recipeName}'
          '&details=${widget.notes}'
          '&location=$location',
    );
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void downloadClick() {
    screenshotController.capture(delay: const Duration(milliseconds: 10)).then((capturedImage) async {
      ShowCapturedWidget(capturedImage!);
    }).catchError((onError) {
      print(onError);
    });

  }

  Future<void> ShowCapturedWidget(Uint8List capturedImage) async {
    if (Platform.isAndroid && await _requestManageExternalStoragePermission()) {
      Directory? downloadsDir = Directory('/storage/emulated/0/Download');

      if (downloadsDir != null) {
        final downloadFilePath = '${downloadsDir.path}/${widget.recipeName}).png';
        final downloadFile = File(downloadFilePath);

        // Save the captured image to the Downloads folder
        await downloadFile.writeAsBytes(capturedImage);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image saved to ${downloadFilePath}')));
        print('Image saved to ${downloadFilePath}');
      } else {
        print('Could not find the downloads directory');
      }
    } else {
      print('Permission denied');
    }
  }

  Future<bool> _requestManageExternalStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      // Request the MANAGE_EXTERNAL_STORAGE permission
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      } else {
        // Direct the user to the settings page to manually grant permission
        openAppSettings();
        return false;
      }
    }
    return true;
  }
}

class LineDashedPainter extends CustomPainter {
  final Color lineColor;
  final double strokeWidth;
  final double gapWidth;
  final double dashWidth;

  LineDashedPainter({
    required this.lineColor,
    required this.strokeWidth,
    required this.gapWidth,
    required this.dashWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;

    // Calculate the total length of the dashed line
    final double totalLength = dashWidth + gapWidth;

    // Calculate the number of dashes needed to cover the entire height
    final int totalDashes = (size.height / totalLength).ceil();

    // Calculate the space between dashes
    final double spaceBetweenDashes =
        (size.height - dashWidth * totalDashes) / (totalDashes - 1);

    // Draw each dash
    for (int i = 0; i < totalDashes; i++) {
      final double startY = i * (dashWidth + spaceBetweenDashes);
      final double endY = startY + dashWidth;
      canvas.drawLine(
        Offset(halfWidth, startY),
        Offset(halfWidth, endY > size.height ? size.height : endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
