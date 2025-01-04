import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/api_constant.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/program_flow/programflow_bloc.dart';
import 'package:health2mama/apis/program_flow/programflow_state.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Utils/pref_utils.dart';
import '../../Utils/video_player.dart';

class TopicDescription extends StatefulWidget {
  final String topicName;
  final String topicImage;
  // final String topicDescription;
  final List<dynamic> contentDetails;

  const TopicDescription({
    Key? key,
    required this.topicName,
    required this.topicImage,
    // required this.topicDescription,
    required this.contentDetails,
  }) : super(key: key);

  @override
  State<TopicDescription> createState() => _TopicDescriptionState();
}

class _TopicDescriptionState extends State<TopicDescription> {
  bool isSaved = false;
  bool isCompleted = false;
  bool pointsAdded = false;
  String actionType = '';
  int? _expandedAccordionIndex;

  String extractVideoKeyPrefix(String videoKey, String fixedSuffix) {
    // Remove the fixed suffix "13120427" from the end of the video key, if present.
    if (videoKey.endsWith(fixedSuffix)) {
      return videoKey.substring(0, videoKey.length - fixedSuffix.length);
    }
    // If the suffix is not present, return the original video key.
    return videoKey;
  }

  final String baseUrl = APIEndPoints.dynTubeBaseUrl;
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
  };

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProgramflowBloc>(context).add(FetchSaveUnsaveStatus(
        itemId: PrefUtils.getitemId(), categoryId: PrefUtils.getCategoryId()));
    pointsAdded = false;
  }

  @override
  Widget build(BuildContext context) {
    var displayType = CommonFunction.getMyDeviceType(MediaQuery.of(context))
        .toString()
        .split('.')
        .last;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset('assets/Images/back.png', width: 35, height: 35),
          onPressed: () {
            Navigator.pop(context, [true]);
          },
        ),
      ),
      body: SafeArea(
        child: BlocListener<ProgramflowBloc, ProgramflowState>(
          listener: (context, state) {
            if (state is SaveUnsaveStatusLoading) {
              Center(child: CircularProgressIndicator(color: AppColors.pink));
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
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               // Topic Name
                Text(
                  widget.topicName,
                  style: FTextStyle.programsHeadingStyle,
                ).animateOnPageLoad(
                    animationsMap['columnOnPageLoadAnimation1']!),

                SizedBox(height: screenHeight * 0.02),

// Topic Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: widget.topicImage.isNotEmpty
                      ? Image.network(
                          widget.topicImage,
                          width: double.infinity,
                          height: screenHeight * 0.3,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: double.infinity,
                          height: screenHeight * 0.3,
                          color: Colors.grey[300],
                          child: Center(child: Text("No Image Available")),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IntrinsicWidth(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.009),
                            border: Border.all(
                                width: screenWidth * 0.003,
                                color: AppColors.blue1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                if (!isCompleted) {
// If the program is not completed yet
                                  if (widget.topicName != null) {
                                    final categoryId =
                                        PrefUtils.getCategoryId();
                                    if (categoryId != null) {
                                      final List<String> categoryIds = [
                                        categoryId
                                      ];
                                      final categoryIdsJsonString = jsonEncode(
                                          categoryIds); // Convert list to JSON string

// Dispatch event to save completion status
                                      BlocProvider.of<ProgramflowBloc>(context)
                                          .add(
                                        SaveUnsaveItemEvent(
                                          itemName: widget.topicName,
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
                                        BlocProvider.of<ProgramflowBloc>(
                                                context)
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
                      SizedBox(
                          width: screenWidth *
                              0.02), // Adjust spacing between containers
                      IntrinsicWidth(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.009),
                            border: Border.all(
                                width: screenWidth * 0.003,
                                color: AppColors.blue1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                if (widget.topicName != null) {
                                  final categoryId = PrefUtils.getCategoryId();
                                  if (categoryId != null) {
                                    final List<String> categoryIds = [
                                      categoryId
                                    ];
                                    final String categoryIdsJsonString =
                                        jsonEncode(categoryIds);

                                    BlocProvider.of<ProgramflowBloc>(context)
                                        .add(
                                      SaveUnsaveItemEvent(
                                        itemName: widget.topicName,
                                        itemId: PrefUtils.getitemId(),
                                        categoryId: categoryIdsJsonString,
                                        isSaved: isSaved ? 'true' : 'true',
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
                      SizedBox(
                          width: screenWidth *
                              0.02), // Adjust spacing between containers
                      IntrinsicWidth(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.009),
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
                // Display Additional Content Details
                // Initialize a variable to track the index of the currently expanded accordion
                ...widget.contentDetails.map((content) {
                  // Ensure content['videos'] is a list
                  List<dynamic> videos =
                      content['videos'] is List ? content['videos'] : [];

                  // Get the video script from the first video (if available)
                  String videoScript =
                      videos.isNotEmpty ? videos[0]['videoHls'] ?? '' : '';

                  // Extract the video key from the video script using your fixed suffix
                  String fixedSuffix = '13120427';
                  String videoKey =
                      extractVideoKeyPrefix(videoScript, fixedSuffix);

                  // Construct the complete video URL
                  String completeVideoUrl = '$baseUrl$videoKey';
                  print(completeVideoUrl);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HtmlWidget(
                        content['description']
                            .toString()
                            .replaceAll("&nbsp;", ""),
                        textStyle: TextStyle(
                          fontFamily:
                              'Poppins-Regular', // Set the font family to Poppins-Regular
                        ),
                      ),
                      if (content['accordianFeatures'] != null &&
                          content['accordianFeatures'].isNotEmpty)
                        Column(
                          children: content['accordianFeatures']
                              .asMap()
                              .entries
                              .map<Widget>((entry) {
                            final index = entry
                                .key; // Get the index of the current accordion
                            final accordianFeature = entry.value;

                            // Ensure accordianFeature is not null
                            if (accordianFeature == null) {
                              return SizedBox.shrink();
                            }

                            // Initialize isExpanded based on the current index
                            bool isExpanded = _expandedAccordionIndex == index;

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: GestureDetector(
                                onTap: () {
                                  // Toggle the expanded state for the current accordion and close others
                                  setState(() {
                                    _expandedAccordionIndex = isExpanded
                                        ? null
                                        : index; // Close if already expanded, else expand
                                  });
                                },
                                child: Column(
                                  children: [
                                    // Title and Icon with background
                                    Container(
                                      decoration: BoxDecoration(
                                        color: isExpanded
                                            ? Color.fromRGBO(119, 119, 119, 0.1)
                                            : Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              isExpanded
                                                  ? Icons.remove
                                                  : Icons.add,
                                              color: isExpanded
                                                  ? Colors.black
                                                  : Colors.white,
                                              size: 35,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                accordianFeature['title'] ??
                                                    'Untitled Feature',
                                                style: TextStyle(
                                                  color: isExpanded
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontFamily: 'Poppins-Regular',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isExpanded) // Show content if expanded
                                      Container(
                                        color: Colors.white,
                                        padding: const EdgeInsets.all(8.0),
                                        child: HtmlWidget(
                                          accordianFeature['description']
                                                  .toString()
                                                  .replaceAll("&nbsp;", "") ??
                                              '',
                                          textStyle: TextStyle(
                                            fontFamily:
                                                'Poppins-Regular', // Set the font family to Poppins-Regular
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      SizedBox(height: 16),
                      if (content['images'] != null &&
                          content['images'].isNotEmpty)
                        Column(
                          children: content['images'].map<Widget>((image) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: GestureDetector(
                                onTap: () async {
                                  final Uri _url =
                                      Uri.parse(image['redirectUrl']);
                                  if (await canLaunchUrl(_url)) {
                                    await launchUrl(_url,
                                        mode: LaunchMode.externalApplication);
                                  } else {
                                    print(
                                        'Could not launch ${image['redirectUrl']}');
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    image['image'],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      if (videos.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: videos.map<Widget>((video) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (video['title'] != null &&
                                      video['title']!.trim().isNotEmpty)
                                    Text(
                                      video['title']!,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontFamily: 'Poppins-Regular',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  SizedBox(height: 8.0),
                                  videoKey.isNotEmpty
                                      ? SizedBox(
                                          width: double.infinity,
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return AspectRatio(
                                                aspectRatio: 16 / 9,
                                                child: VideoPlayerWidget(
                                                  videoUrl: completeVideoUrl,
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  SizedBox(height: 12.0),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final String location = 'www.health2mama.com';
  void _openGoogleCalendar() async {
    final url = Uri.encodeFull(
      'https://calendar.google.com/calendar/render?action=TEMPLATE'
      '&text=${widget.topicName}'
      '&location=$location',
    );
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
