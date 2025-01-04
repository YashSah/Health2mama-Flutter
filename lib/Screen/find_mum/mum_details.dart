import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/StageConverter.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/find_mum/find_mum_bloc.dart';
import '../../Utils/CommonFuction.dart';

class MumDetails extends StatefulWidget {
  final Map<String, dynamic> mumData;

  const MumDetails({Key? key, required this.mumData}) : super(key: key);

  @override
  State<MumDetails> createState() => _MumDetailsState();
}

class _MumDetailsState extends State<MumDetails> {
  String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    }
    return text;
  }

  bool isCancelled = false;

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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<String> labels = [
      'Work Status',
      'Exercise | Enjoy',
      'Other Interest',
      'Language Known'
    ];
    List<List<dynamic>> values = [
      widget.mumData['otherWork'] ?? [],
      widget.mumData['exercise'] ?? [],
      widget.mumData['others'] ?? [],
      widget.mumData['language'] ?? []
    ];

    String ProfilePicture = widget.mumData['profilePicture'] ?? '';
    String name = widget.mumData['fullName'] ?? '';
    String stage = StageConverter.formatStage(widget.mumData['stage'] ?? '');
    String kids = widget.mumData['kids'] ?? '';
    String connected = widget.mumData['connected'].toString() ?? '';
    String requestId = widget.mumData['requestId']?.toString() ?? '';
    final connectedStatus = connected == 'true' ? 'connected' : 'pending';
    print(widget.mumData);

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text("Mum Details",
                style: (displayType == 'desktop' || displayType == 'tablet')
                    ? FTextStyle.appTitleStyleTablet
                    : FTextStyle.appBarTitleStyle)),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context,[true]);
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
      body: BlocListener<FindMumBloc, FindMumState>(
        listener: (context, state) {
          if (state is CancelMumRequestLoaded) {
            setState(() {
              isCancelled = true;
            });

            CommonPopups.showCustomPopup(context, state.responseMessage['responseMessage']);

          } else if (state is CancelMumRequestError) {
            setState(() {
              isCancelled = false;
            });
            CommonPopups.showCustomPopup(context, state.responseMessage['responseMessage']);
          }
        },
        child: SafeArea(
            child: Column(
          children: [
            const Divider(
              thickness: 1.2,
              color: Color(0XFFF6F6F6),
            ),
            Padding(
                padding: (displayType == 'desktop' || displayType == 'tablet')
                    ? EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.w)
                    : EdgeInsets.zero,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 1.5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Container(
                                        height: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 45.w
                                            : 72,
                                        width: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 45.w
                                            : 72,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors
                                                    .filterBackroundColor,
                                                width: 3),
                                            shape: BoxShape.circle),
                                        child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: ProfilePicture.isEmpty
                                              ? Image.asset(
                                                  'assets/Images/defaultUser.png',
                                                  fit: BoxFit.fill,
                                                )
                                              : Image.network(
                                                  ProfilePicture,
                                                  fit: BoxFit.cover,
                                                ).animateOnPageLoad(animationsMap[
                                                  'imageOnPageLoadAnimation2']!),
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              truncateText(name, 20),
                                              style: (displayType ==
                                                          'desktop' ||
                                                      displayType == 'tablet')
                                                  ? FTextStyle
                                                      .tabToStart2TextStyleTablet
                                                  : FTextStyle
                                                      .tabToStart2TextStyle,
                                            ),
                                          ],
                                        ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation2']!),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                          stage.length > 25
                                          ? '${stage.substring(0, 25)}...'
                                            : stage ?? 'No Stage',
                                                style: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? FTextStyle
                                                        .findMum2StyleTablet
                                                    : FTextStyle.findMum2Style,
                                              ).animateOnPageLoad(animationsMap[
                                                  'imageOnPageLoadAnimation2']!),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                kids.isNotEmpty
                                                    ? 'Have ${kids} Kids'
                                                    : 'Have no kids',
                                                style: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? FTextStyle
                                                        .findMum2StyleTablet
                                                    : FTextStyle.findMum2Style,
                                              ),
                                            ],
                                          ),
                                        ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation2']!),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, left: 35, right: 35),
                              child: Container(
                                height: 1,
                                color: AppColors.findMumBorderColor,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: labels.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              labels[index],
                                              style: (displayType ==
                                                          'desktop' ||
                                                      displayType == 'tablet')
                                                  ? FTextStyle
                                                      .findMumDetailsTitleTablet
                                                  : FTextStyle
                                                      .findMumDetailsTitle,
                                            ).animateOnPageLoad(animationsMap[
                                                'imageOnPageLoadAnimation2']!)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                '${values[index].isEmpty ? '___' : values[index]}',
                                                style: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? FTextStyle
                                                        .findMumDetails2TitleTablet
                                                    : FTextStyle
                                                        .findMumDetails2Title),
                                          ],
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!)
                                    ],
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Status',
                                          style: (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle
                                                  .findMumDetailsTitleTablet
                                              : FTextStyle.findMumDetailsTitle,
                                        ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation2']!)
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                        Text(connectedStatus,
                                            style: (displayType == 'desktop' ||
                                                    displayType == 'tablet')
                                                ? FTextStyle
                                                    .programAskButtonStyleTablet
                                                : FTextStyle
                                                    .programAskButtonStyle),
                                      ]))
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            (connectedStatus == 'pending') ?
                                Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: ElevatedButton(
                                onPressed: isCancelled ? null : () {
                                  BlocProvider.of<FindMumBloc>(context).add(
                                      CancelMumRequest(requestId: requestId));
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      screenWidth * 0.85, screenHeight * 0.05),
                                  backgroundColor:  AppColors.blueGridTextColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: isCancelled ? Text(
                                    "Cancelled",
                                    style: (displayType == 'desktop' ||
                                        displayType == 'tablet') ?  FTextStyle.newMum :  FTextStyle.ForumsButtonStyling,
                                  ).animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation2']!) :
                                  Text(
                                    "Cancel Request",
                                    style: (displayType == 'desktop' ||
                                        displayType == 'tablet') ?  FTextStyle.newMum :  FTextStyle.ForumsButtonStyling,
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                ),
                              ),
                            ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!) : SizedBox(),
                          ]),
                        ),
                      )),
                ))
          ],
        )),
      ),
    );
  }
}
