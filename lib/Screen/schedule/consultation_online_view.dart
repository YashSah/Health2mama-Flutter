import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/apis/schedule/schedule_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/flutter_font_style.dart';

class OnlineDetail extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const OnlineDetail({
    Key? key,
    required this.bookingData,
  }) : super(key: key);

  @override
  _ConsultState createState() => _ConsultState();
}

class _ConsultState extends State<OnlineDetail> {
  late String _formattedDate;
  late String _upcomingText;

  String convertHtmlToText(String htmlContent) {
    dom.Document document = parse(htmlContent);
    return document.body?.text ?? '';
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
  void initState() {
    super.initState();
    _updateDate();
    _upcomingText = 'Upcoming';
  }

  void _updateDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd MMM yyyy');
    _formattedDate = formatter.format(now);
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _composeEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not open email app';
    }
  }

  void _dialPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      throw 'Could not dial $phone';
    }
  }

  Future<void> _showCancelConfirmationDialog(BuildContext context, String appointmentId) async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(vertical: 100, horizontal: 16),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    "assets/Images/icons8-cross-48.png",
                    height: 40,
                    width: 40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    "Cancel Appointment",
                    style: FTextStyle.logout,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  "Are you sure you want to cancel this appointment?",
                  style: FTextStyle.lightTextlarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 45,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, false); // No
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.defaultButton),
                            foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                            side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                    color: AppColors.appBlue, width: 1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          child: Text(
                            "No",
                            style: TextStyle(
                                color: AppColors.appBlue, fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      SizedBox(
                        width: 100,
                        height: 45,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, true); // Yes, cancel
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.appBlue),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                AppColors.whiteColor),
                            side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                    color: Colors.white, width: 1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                color: AppColors.whiteColor, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // If the user confirmed they want to cancel, proceed with cancellation
    if (shouldCancel == true) {
      BlocProvider.of<ScheduleBloc>(context).add(ScheduleCancelBooking(appointmentId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String BookingDate = widget.bookingData['createdAt'] ?? 'No Date';
    final String AppointmentDate = widget.bookingData['date'] ?? 'No Date';
    final String AppointmentTime = widget.bookingData['time'] ?? 'No Time';
    final String _id = widget.bookingData['_id'] ?? 'No BookingId';
    final String consultName =
        widget.bookingData['consult']['consultName'] ?? 'No Name';

    final String consultDescription = convertHtmlToText(
            widget.bookingData['consult']['consultDescription']) ??
        'No Description';
    final String websiteURL =
        widget.bookingData['consult']['websiteURL'] ?? 'No Url';
    final String email = widget.bookingData['consult']['email'] ?? 'No email';
    final String phone = widget.bookingData['consult']['countryCode'] +
            ' ' +
            widget.bookingData['consult']['phone'] ??
        'No email';

    // Convert and format the BookingDate
    DateTime bookingDateTime;
    try {
      bookingDateTime =
          DateTime.parse(BookingDate).toLocal(); // Convert to local time
    } catch (e) {
      bookingDateTime = DateTime.now(); // Fallback if parsing fails
    }

    final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
    final DateFormat timeFormatter = DateFormat('HH:mm');

    final String formattedDate = dateFormatter.format(bookingDateTime);
    final String formattedTime = timeFormatter.format(bookingDateTime);

    final String formattedDateTime = '$formattedDate $formattedTime';

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
          padding: EdgeInsets.only(
              left: (displayType == 'desktop' || displayType == 'tablet')
                  ? 4.w
                  : 8.0),
          child: Text(
            consultName,
            style: FTextStyle.appBarTitleStyle,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            BlocProvider.of<ScheduleBloc>(context).add(ScheduleBooking());
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (displayType == 'desktop' || displayType == 'tablet')
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: (displayType == 'desktop' || displayType == 'tablet')
                ? 30.h
                : 27.0),
        child: ListView(
          children: [
            const Divider(
              thickness: 2,
              color: AppColors.linecolor,
            ),
            SizedBox(
                height: (displayType == 'desktop' || displayType == 'tablet')
                    ? 30
                    : 10),
            Text(
              consultDescription,
              style: (displayType == 'desktop' || displayType == 'tablet')
                  ? FTextStyle.loremtextTab.copyWith(
                      color: AppColors.loremtextcolor,
                    )
                  : FTextStyle.loremtext.copyWith(
                      color: AppColors.loremtextcolor,
                    ),
            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
            Padding(
              padding: EdgeInsets.only(
                  top: (displayType == 'desktop' || displayType == 'tablet')
                      ? 28.h
                      : 28),
              child: Text(
                "Website",
                style: (displayType == 'desktop' || displayType == 'tablet')
                    ? FTextStyle.cardTitleTable
                    : FTextStyle.cardTitle,
              ),
            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
            GestureDetector(
                    onTap: () => _launchURL(websiteURL),
                    child: Text(
                      websiteURL,
                      style:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? FTextStyle.fontsizetab.copyWith(
                                  color: AppColors.textbluecolor,
                                )
                              : FTextStyle.fontsize.copyWith(
                                  color: AppColors.textbluecolor,
                                ),
                    ))
                .animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? 20.h
                          : 18),
              child: Text(
                "Contact",
                style: (displayType == 'desktop' || displayType == 'tablet')
                    ? FTextStyle.cardTitleTable
                    : FTextStyle.cardTitle,
              ),
            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      right:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 4.h
                              : screenWidth * 0.02),
                  child: Image(
                    image: const AssetImage("assets/Images/email.png"),
                    height:
                        (displayType == 'desktop' || displayType == 'tablet')
                            ? 20.h
                            : screenHeight * 0.018,
                    width: (displayType == 'desktop' || displayType == 'tablet')
                        ? 20.w
                        : screenHeight * 0.03,
                  ),
                ).animateOnPageLoad(
                    animationsMap['imageOnPageLoadAnimation2']!),
                GestureDetector(
                        onTap: () => _composeEmail(email),
                        child: Text(
                          email,
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.fontsizetab.copyWith(
                                  color: AppColors.textbluecolor,
                                )
                              : FTextStyle.fontsize.copyWith(
                                  color: AppColors.textbluecolor,
                                ),
                        ))
                    .animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? 20.h
                          : screenHeight * 0.01),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? 4.h
                            : screenWidth * 0.02),
                    child: Image(
                      image: const AssetImage("assets/Images/phoneblue.png"),
                      height:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 20.h
                              : screenHeight * 0.018,
                      width:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 20.w
                              : screenHeight * 0.03,
                    ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!),
                  GestureDetector(
                          onTap: () => _dialPhone(phone),
                          child: Text(
                            phone,
                            style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? FTextStyle.fontsizetab.copyWith(
                                    color: AppColors.textbluecolor,
                                  )
                                : FTextStyle.fontsize.copyWith(
                                    color: AppColors.textbluecolor,
                                  ),
                          ))
                      .animateOnPageLoad(
                          animationsMap['imageOnPageLoadAnimation2']!),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? 10.h
                          : 18,
                  horizontal:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? 5.h
                          : 5),
              child: Text(
                "Appointment Details",
                style: (displayType == 'desktop' || displayType == 'tablet')
                    ? FTextStyle.cardTitleTable
                    : FTextStyle.cardTitle,
              ),
            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? 5.h
                          : 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Booked On: ",
                    style: (displayType == 'desktop' || displayType == 'tablet')
                        ? FTextStyle.fontsizetab.copyWith(
                            color: AppColors.textbluecolor,
                          )
                        : FTextStyle.fontsize.copyWith(
                            color: AppColors.textbluecolor,
                          ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!),
                  Text(
                    formattedDateTime,
                    maxLines: 2,
                    style: (displayType == 'desktop' || displayType == 'tablet')
                        ? FTextStyle.fontsizetab.copyWith(
                            color: AppColors.textbluecolor,
                          )
                        : FTextStyle.fontsize.copyWith(
                            color: AppColors.textbluecolor,
                          ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!),
                ],
              ),
            ),
            SizedBox(
              height: (displayType == 'desktop' || displayType == 'tablet')
                  ? 10.h
                  : 6,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? 2.h
                          : 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Appointment On: ",
                    style: (displayType == 'desktop' || displayType == 'tablet')
                        ? FTextStyle.fontsizetab.copyWith(
                            color: AppColors.textbluecolor,
                          )
                        : FTextStyle.fontsize.copyWith(
                            color: AppColors.textbluecolor,
                          ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!),
                  Text(
                    AppointmentDate + ' ' + AppointmentTime,
                    maxLines: 2,
                    style: (displayType == 'desktop' || displayType == 'tablet')
                        ? FTextStyle.fontsizetab.copyWith(
                            color: AppColors.textbluecolor,
                          )
                        : FTextStyle.fontsize.copyWith(
                            color: AppColors.textbluecolor,
                          ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!)
                ],
              ),
            ),
            BlocListener<ScheduleBloc, ScheduleState>(
              listener: (context, state) {
                if (state is ScheduleCancelSuccess) {
                  BlocProvider.of<ScheduleBloc>(context).add(ScheduleBooking());
                  Navigator.pop(context);
                } else if (state is ScheduleCancelFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical:
                        (displayType == 'desktop' || displayType == 'tablet')
                            ? 20.h
                            : 25.0,
                    horizontal:
                        (displayType == 'desktop' || displayType == 'tablet')
                            ? 5.h
                            : 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      _showCancelConfirmationDialog(context, _id);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.lightgray,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: (displayType == 'desktop' || displayType == 'tablet') ? 12.h : 12.0,
                          horizontal: (displayType == 'desktop' || displayType == 'tablet') ? 20.h : 23
                      ),
                      child: Text(
                        'Cancel Appointment',
                        textAlign: TextAlign.center,
                        style: (displayType == 'desktop' || displayType == 'tablet')
                            ? FTextStyle.blackStyleSmallTab
                            : FTextStyle.blackStyleSmall,
                      ),
                    ),
                  ),
                ),
              ),
            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
          ],
        ),
      ),
    );
  }
}
