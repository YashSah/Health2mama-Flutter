import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/api_constant.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/apis/program_flow/programflow_state.dart';
import 'package:html/parser.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/Utils/video_player.dart';
import 'package:health2mama/apis/program_flow/programflow_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Auth_flow/forgotPassword.dart';

class SelectedWorkout extends StatefulWidget {
  final String id;
  final String workoutSubCategoryName;
  final String image;
  final List<dynamic> exerciseSections;
  final String description;

  const SelectedWorkout({
    Key? key,
    required this.id,
    required this.workoutSubCategoryName,
    required this.image,
    required this.exerciseSections,
    required this.description,
  }) : super(key: key);

  @override
  _SelectedWorkoutState createState() => _SelectedWorkoutState();
}

final String baseUrl = APIEndPoints.dynTubeBaseUrl;

// Function to extract the video key prefix by removing the fixed suffix.
String extractVideoKeyPrefix(String videoKey, String fixedSuffix) {
  // Remove the fixed suffix "13120427" from the end of the video key, if present.
  if (videoKey.endsWith(fixedSuffix)) {
    return videoKey.substring(0, videoKey.length - fixedSuffix.length);
  }
  // If the suffix is not present, return the original video key.
  return videoKey;
}

class _SelectedWorkoutState extends State<SelectedWorkout> {
  bool isSaved = false;
  bool isCompleted = false;
  bool pointsAdded = false;
  String actionType = '';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProgramflowBloc>(context).add(
      FetchSaveUnsaveStatus(
          itemId: PrefUtils.getitemId(), categoryId: PrefUtils.getCategoryId()),
    );
  }

  String htmlToPlainText(String html) {
    final document = parse(html);
    final body = document.body;
    if (body == null) return '';

    // Initialize a list to collect text parts
    final textParts = <String>[];

    // Extract text from paragraphs
    final paragraphs = body.querySelectorAll('p');
    textParts.addAll(paragraphs.map((p) => p.text.trim()));

    // Extract text from lists with bullet points
    final lists = body.querySelectorAll('ul');
    for (var list in lists) {
      final listItems = list.querySelectorAll('li');
      final listText = listItems.map((li) => '• ${li.text.trim()}').join('\n');
      textParts.add(listText);
    }

    // Extract text from other tags if needed
    final headers = body.querySelectorAll('h1, h2, h3, h4, h5, h6');
    textParts.addAll(headers.map((h) => '${h.text.trim()}\n'));

    // Join all parts with double new lines to separate different sections
    return textParts.join('\n\n');
  }

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Image.asset('assets/Images/back.png', width: 35, height: 35),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        body: BlocListener<ProgramflowBloc, ProgramflowState>(
          listener: (context, state) {
            if (state is SaveUnsaveStatusLoading) {
              print('Save Unsave Status Loading...');
            } else if (state is SaveUnsaveStatusLoaded) {
              setState(() {
                isSaved = state.isSaved;
                isCompleted = state.isCompleted;
              });
            } else if (state is SaveUnsaveItemSuccess) {
              if (actionType == 'complete') {
                CommonPopups.showCustomPopup(
                    context, 'Topic completed successfully.');
              } else if (actionType == 'save') {
                CommonPopups.showCustomPopup(
                    context, 'Topic saved successfully.');
              } else if (actionType == 'unsave') {
                CommonPopups.showCustomPopup(
                    context, 'Topic unsaved successfully.');
              }
            } else if (state is SaveUnsaveItemFailure) {
              CommonPopups.showCustomPopup(
                context,
                state.failureresponse['responseMessage'],
              );
            }
          },
          child: SafeArea(
              child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              // Workout Sub Category Name
              Text(
                widget.workoutSubCategoryName,
                style: FTextStyle.recipeDescriptionValueTextStyle,
              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),

              const SizedBox(height: 20),

              // Workout Image
              widget.image.isNotEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                      ).animateOnPageLoad(
                          animationsMap['imageOnPageLoadAnimation2']!),
                    )
                  : const SizedBox.shrink(),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Complete Button
                  IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(screenHeight * 0.009),
                        border: Border.all(
                            width: screenWidth * 0.003, color: AppColors.blue1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            if (!isCompleted) {
                              // If the program is not completed yet
                              if (widget.workoutSubCategoryName != null) {
                                final categoryId = PrefUtils.getCategoryId();
                                if (categoryId != null) {
                                  final List<String> categoryIds = [categoryId];
                                  final categoryIdsJsonString = jsonEncode(
                                      categoryIds); // Convert list to JSON string

                                  // Dispatch event to save completion status
                                  BlocProvider.of<ProgramflowBloc>(context).add(
                                    SaveUnsaveItemEvent(
                                      itemName: widget.workoutSubCategoryName,
                                      itemId: PrefUtils.getitemId(),
                                      categoryId:
                                          categoryIdsJsonString, // Pass JSON string
                                      isCompleted: 'true',
                                    ),
                                  );
                                  setState(() {
                                    actionType =
                                        'complete'; // Set action to complete
                                  });
                                  setState(() {
                                    isCompleted = true; // Mark as completed
                                  });

                                  // Add points only the first time
                                  if (!pointsAdded) {
                                    BlocProvider.of<ProgramflowBloc>(context)
                                        .add(
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
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  isCompleted ? 'Completed' : 'Complete',
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
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
                  SizedBox(
                      width: screenWidth *
                          0.02), // Adjust spacing between containers

                  // Save Button
                  IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(screenHeight * 0.009),
                        border: Border.all(
                            width: screenWidth * 0.003, color: AppColors.blue1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            if (widget.workoutSubCategoryName != null) {
                              final categoryId = PrefUtils.getCategoryId();
                              if (categoryId != null) {
                                final List<String> categoryIds = [categoryId];
                                final categoryIdsJsonString =
                                    jsonEncode(categoryIds);

                                BlocProvider.of<ProgramflowBloc>(context).add(
                                  SaveUnsaveItemEvent(
                                    itemName: widget.workoutSubCategoryName,
                                    itemId: PrefUtils.getitemId(),
                                    categoryId: categoryIdsJsonString,
                                    isSaved: isSaved
                                        ? 'true'
                                        : 'true', // Corrected to 'false' for not saved
                                  ),
                                );
                                setState(() {
                                  actionType = isSaved
                                      ? 'unsave'
                                      : 'save'; // Set action based on state
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
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  isSaved ? 'Unsave' : 'Save',
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
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
                  SizedBox(
                      width: screenWidth *
                          0.02), // Adjust spacing between containers

                  // Schedule Button
                  IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(screenHeight * 0.009),
                        border: Border.all(
                            width: screenWidth * 0.003, color: AppColors.blue1),
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
                              ScaffoldMessenger.of(context).showSnackBar(
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
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Schedule',
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
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
                ],
              ),
              const SizedBox(height: 20),
              HtmlWidget(
                widget.description.toString().replaceAll("&nbsp;", ""),
                textStyle: TextStyle(
                  fontFamily:
                      'Poppins-Regular', // Set the font family to Poppins-Regular
                ), // Assuming you are using flutter_html
              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
              const SizedBox(height: 20),

              //   Exercises List
              ...widget.exerciseSections.map<Widget>((exerciseSection) {
                final String descriptionHtml = exerciseSection['description']
                        .toString()
                        .replaceAll("&nbsp;", "") ??
                    '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the description using Html widget
                    HtmlWidget(
                      descriptionHtml, // Assuming you are using flutter_html
                      textStyle: TextStyle(
                        fontFamily: 'Poppins-Regular', // Set the font family to Poppins-Regular
                      ),
                    ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!,
                    ),
                    SizedBox(height: 16),
                    ...exerciseSection['exercises'].map<Widget>((exercise) {
                      String videoKey = exercise['videoKey'] ?? '';

                      // The fixed string to be removed from the video key.
                      String fixedSuffix = '13120427';

                      // Extract the video key prefix and construct the complete video URL.
                      String videoKeyPrefix = extractVideoKeyPrefix(videoKey, fixedSuffix);
                      String completeVideoUrl = '$baseUrl$videoKeyPrefix';
                      String? title = exercise['title']; // Keep title nullable

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the exercise title only when it is non-empty and not null
                          if (title != null && title.isNotEmpty)
                            Text(
                              title,
                              style: FTextStyle.exerciseText,
                            ).animateOnPageLoad(
                              animationsMap['imageOnPageLoadAnimation2']!,
                            ),
                          const SizedBox(height: 10),
                          // Show the video player if the video key prefix is present
                          if (videoKeyPrefix.isNotEmpty)
                            SizedBox(
                              width: double.infinity,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: VideoPlayerWidget(
                                      // Use the complete video URL here
                                      videoUrl: completeVideoUrl,
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  ],
                );

              }).toList(),
            ],
          )),
        ));
  }

  final String location = 'www.health2mama.com';
  void _openGoogleCalendar() async {
    final url = Uri.encodeFull(
      'https://calendar.google.com/calendar/render?action=TEMPLATE'
      '&text=${widget.workoutSubCategoryName}'
      '&details=${widget.description}'
      '&location=$location',
    );
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
