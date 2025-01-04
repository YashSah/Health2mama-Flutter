import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/find_mum/find_mum_bloc.dart';
import '../../Utils/CommonFuction.dart';

class MumRequestDetails extends StatefulWidget {
  final List<dynamic> other;
  final List<dynamic> interest;
  final List<dynamic> exercise;
  final List<dynamic> language;
  String ProfilePic;
  String name;
  String id;
  String stage;
  String kids;
  String areYou;
  MumRequestDetails({
    Key? key,
    required this.other,
    required this.interest,
    required this.exercise,
    required this.language,
    required this.ProfilePic,
    required this.name,
    required this.stage,
    required this.kids,
    required this.id,
    required this.areYou,
  }) : super(key: key);

  @override
  State<MumRequestDetails> createState() => _MumRequestDetailsState();
}

class _MumRequestDetailsState extends State<MumRequestDetails> {
  bool _isAccepted = false;
  bool _isCancelled = false;

  String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    }
    return text;
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

  @override
  Widget build(BuildContext context) {
    List<String> labels = [
      'Work Status',
      'Exercise | Enjoy',
      'Other Interest',
      'Language Known'
    ];
    List<List<dynamic>> values = [
      widget.interest,
      widget.exercise,
      widget.other,
      widget.language
    ];

    String ProfilePicture = widget.ProfilePic;
    String name = widget.name;
    String stage = widget.stage;
    String kids = widget.kids;
    String id = widget.id;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("Mum Request Details",
                style: (displayType == 'desktop' || displayType == 'tablet')
                    ? FTextStyle.appTitleStyleTablet
                    : FTextStyle.appBarTitleStyle)),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, [true]);
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
          if (state is AcceptMumRequestLoaded) {
            setState(() {
              _isAccepted = true;
            });
            Navigator.pop(context); // Ensure dialog or popup is dismissed
            CommonPopups.showCustomPopup(
                context, state.responseMessage['responseMessage']);
          } else if (state is AcceptMumRequestError) {
            Navigator.pop(context); // Ensure dialog or popup is dismissed
            CommonPopups.showCustomPopup(
                context, state.responseMessage['responseMessage']);
          } else if (state is AcceptMumRequestLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => CircularProgressIndicator(color: AppColors.pink),
            );
          } else if (state is CancelMumRequestLoaded) {
            setState(() {
              _isCancelled = true;
            });
            CommonPopups.showCustomPopup(
                context, state.responseMessage['responseMessage']);
            Navigator.pop(context, [true]);
          } else if (state is CancelMumRequestError) {
            Navigator.pop(context); // Ensure dialog or popup is dismissed
            CommonPopups.showCustomPopup(
                context, state.responseMessage['responseMessage']);
          }
        },
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.007),
              child: Column(
                children: [
                  const Divider(
                    thickness: 1.2,
                    color: Color(0XFFF6F6F6),
                  ),
                  Padding(
                    padding: (displayType == 'desktop' ||
                            displayType == 'tablet')
                        ? EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.w)
                        : EdgeInsets.zero,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
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
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 45.w
                                            : 72,
                                        width: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 45.w
                                            : 72,
                                        decoration: BoxDecoration(
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
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                    return Container(
                                                        child: Image.asset(
                                                      'assets/Images/defaultUser.png',
                                                      fit: BoxFit.fill,
                                                    ));
                                                  },
                                                ).animateOnPageLoad(animationsMap[
                                                  'imageOnPageLoadAnimation2']!),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, left: 15),
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
                                                          displayType ==
                                                              'tablet')
                                                      ? FTextStyle
                                                          .tabToStart2TextStyleTablet
                                                      : FTextStyle
                                                          .tabToStart2TextStyle,
                                                ),
                                              ],
                                            ).animateOnPageLoad(animationsMap[
                                                'imageOnPageLoadAnimation2']!),
                                            SizedBox(height: 5.h),
                                            Row(
                                              children: [
                                                Text(
                                                  stage,
                                                  style: (displayType ==
                                                              'desktop' ||
                                                          displayType ==
                                                              'tablet')
                                                      ? FTextStyle
                                                          .dateTimeTablet
                                                      : FTextStyle.dateTime,
                                                ),
                                              ],
                                            ).animateOnPageLoad(animationsMap[
                                                'imageOnPageLoadAnimation2']!),
                                            SizedBox(height: 5.h),
                                            Row(
                                              children: [
                                                Text(
                                                  kids.isNotEmpty
                                                      ? 'Have ${kids} Kids'
                                                      : 'Have no kids',
                                                  style: (displayType ==
                                                              'desktop' ||
                                                          displayType ==
                                                              'tablet')
                                                      ? FTextStyle
                                                          .findMum2StyleTablet
                                                      : FTextStyle
                                                          .findMum2Style,
                                                ),
                                              ],
                                            ).animateOnPageLoad(animationsMap[
                                                'imageOnPageLoadAnimation2']!),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        screenWidth * 0.04,
                                        screenHeight * 0.003,
                                        screenWidth * 0.04,
                                        screenHeight * 0.015),
                                    child: Divider(
                                        thickness: screenHeight * 0.0015,
                                        color: AppColors.opacityBlack3),
                                  ),
                                  Container(
                                    height: screenHeight * 0.25,
                                    child: ListView.builder(
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
                                                              displayType ==
                                                                  'tablet')
                                                          ? FTextStyle
                                                              .findMumDetailsTitleTablet
                                                          : FTextStyle
                                                              .findMumDetailsTitle,
                                                    ).animateOnPageLoad(
                                                        animationsMap[
                                                            'imageOnPageLoadAnimation2']!),
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
                                                              displayType ==
                                                                  'tablet')
                                                          ? FTextStyle
                                                              .findMumDetailsTitleTablet
                                                          : FTextStyle
                                                              .findMumDetailsTitle,
                                                    ).animateOnPageLoad(
                                                        animationsMap[
                                                            'imageOnPageLoadAnimation2']!)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? _isCancelled
                                          ? SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 10),
                                              child: ElevatedButton(
                                                onPressed: _isAccepted
                                                    ? null
                                                    : () {
                                                        BlocProvider.of<
                                                                    FindMumBloc>(
                                                                context)
                                                            .add(AcceptMumRequest(
                                                                requestId:
                                                                    widget.id,
                                                                status:
                                                                    'accepted'));
                                                      },
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: Size(
                                                      screenWidth * 0.85,
                                                      screenHeight * 0.05),
                                                  backgroundColor:
                                                      AppColors.pink,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Text(
                                                    _isAccepted
                                                        ? "Accepted"
                                                        : "Accept",
                                                    style: FTextStyle
                                                        .ForumsButtonStylingTablet,
                                                  ).animateOnPageLoad(animationsMap[
                                                      'imageOnPageLoadAnimation2']!),
                                                ),
                                              ),
                                            ).animateOnPageLoad(animationsMap[
                                              'imageOnPageLoadAnimation2']!)
                                      : _isCancelled
                                          ? SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              child: ElevatedButton(
                                                onPressed: _isAccepted
                                                    ? null
                                                    : () {
                                                        BlocProvider.of<
                                                                    FindMumBloc>(
                                                                context)
                                                            .add(AcceptMumRequest(
                                                                requestId:
                                                                    widget.id,
                                                                status:
                                                                    'accepted'));
                                                      },
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: Size(
                                                      screenWidth * 0.85,
                                                      screenHeight * 0.05),
                                                  backgroundColor:
                                                      AppColors.pink,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          screenHeight * 0.02),
                                                  child: Text(
                                                    _isAccepted
                                                        ? "Accepted"
                                                        : "Accept",
                                                    style: FTextStyle
                                                        .ForumsButtonStyling,
                                                  ).animateOnPageLoad(animationsMap[
                                                      'imageOnPageLoadAnimation2']!),
                                                ),
                                              ),
                                            ).animateOnPageLoad(animationsMap[
                                              'imageOnPageLoadAnimation2']!),
                                  (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? _isAccepted
                                          ? SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 10),
                                              child: ElevatedButton(
                                                onPressed: _isCancelled
                                                    ? null
                                                    : () {
                                                        BlocProvider.of<
                                                                    FindMumBloc>(
                                                                context)
                                                            .add(CancelMumRequest(
                                                                requestId:
                                                                    widget.id));
                                                      },
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: Size(
                                                      screenWidth * 0.85,
                                                      screenHeight * 0.05),
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Text(
                                                    _isCancelled
                                                        ? "Rejected"
                                                        : "Reject",
                                                    style: FTextStyle
                                                        .ForumsButtonStylingTablet,
                                                  ).animateOnPageLoad(animationsMap[
                                                      'imageOnPageLoadAnimation2']!),
                                                ),
                                              ),
                                            ).animateOnPageLoad(animationsMap[
                                              'imageOnPageLoadAnimation2']!)
                                      : _isAccepted
                                          ? SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 10),
                                              child: ElevatedButton(
                                                onPressed: _isCancelled
                                                    ? null
                                                    : () {
                                                        BlocProvider.of<
                                                                    FindMumBloc>(
                                                                context)
                                                            .add(CancelMumRequest(
                                                                requestId:
                                                                    widget.id));
                                                      },
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: Size(
                                                      screenWidth * 0.85,
                                                      screenHeight * 0.05),
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          screenHeight * 0.02),
                                                  child: Text(
                                                    _isCancelled
                                                        ? "Rejected"
                                                        : "Reject",
                                                    style: FTextStyle
                                                        .ForumsButtonStyling,
                                                  ).animateOnPageLoad(animationsMap[
                                                      'imageOnPageLoadAnimation2']!),
                                                ),
                                              ),
                                            ).animateOnPageLoad(animationsMap[
                                              'imageOnPageLoadAnimation2']!),
                                ],
                              ),
                            ),
                          ),
                        )),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
