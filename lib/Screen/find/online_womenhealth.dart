import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/booking_appointDialog.dart';
import 'package:health2mama/Utils/custom_radio.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/Utils/submisson_dialog.dart';
import 'package:health2mama/apis/find/find_bloc.dart';
import 'package:health2mama/services/StripePaymentService.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class OnlineWomenHealth extends StatefulWidget {
  final String consultId;
  const OnlineWomenHealth({Key? key, required this.consultId})
      : super(key: key);

  @override
  State<OnlineWomenHealth> createState() => _OnlineWomenHealthState();
}

class _OnlineWomenHealthState extends State<OnlineWomenHealth> {
  String convertHtmlToText(String htmlContent) {
    dom.Document document = parse(htmlContent);
    return document.body?.text ?? '';
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FindBloc>(context)
        .add(ViewConsult(consultId: widget.consultId));
  }

  String? selectedOption;
  String? onlinePackageOption;
  Map<String, dynamic> sectionTopicdata1 = {};

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

  int calculateAmountBasedOnPlan() {
    int amount = 0;

    if (selectedOption != null) {
      // Look up the price for the selected option in sectionTopicdata1
      var plans = sectionTopicdata1['plans'] as List<dynamic>;
      var selectedPlan = plans.firstWhere(
        (plan) => plan['serviceName'] == selectedOption,
        orElse: () => null,
      );
      if (selectedPlan != null) {
        amount = (selectedPlan['price'] is int)
            ? (selectedPlan['price'] as int)
            : selectedPlan['price'];
      }
    } else if (onlinePackageOption != null) {
      var packages = sectionTopicdata1['packages'] as List<dynamic>;
      var selectedPackage = packages.firstWhere(
        (package) => package['packageName'] == onlinePackageOption,
        orElse: () => null,
      );
      if (selectedPackage != null) {
        amount = (selectedPackage['price'] is int)
            ? (selectedPackage['price'] as int)
            : selectedPackage['price'];
      }
    }
    return amount;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    void showBookingDialog(String selectedOptionOrPackage) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              // Handle back navigation
              if (Navigator.canPop(context)) {
                // Show a dialog to inform the user that the booking is cancelled
                bool isCancelled = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Booking Cancelled'),
                      content: Text('You have cancelled the booking.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(true); // Return true to close dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                return isCancelled ?? false;
              }
              return false;
            },
            child: AppointmentDialog(
              onConfirm: (date, time) async {
                final amount = calculateAmountBasedOnPlan();
                bool paymentSuccessful = false;

                try {
                  await StripePaymentService.initialize();
                  paymentSuccessful =
                      await StripePaymentService.createPaymentIntent(amount);

                  if (paymentSuccessful) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SubmissionDialog(message: 'Booking Successful')
                            .animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!);
                      },
                    );

                    // Proceed with the booking API call
                    BlocProvider.of<FindBloc>(context).add(
                      MakePurchaseEvent(
                        consultId: widget.consultId,
                        selectedPlan: selectedOption ?? onlinePackageOption,
                        amount: amount.toString(),
                        date: date,
                        time: time,
                        user: PrefUtils.getUserId(),
                        status: 'ACTIVE',
                      ),
                    );

                    // Close the dialogs
                    Navigator.of(context).pop(); // Close the success dialog
                    Navigator.of(context).pop(); // Close the booking dialog
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Payment cancelled or failed. Booking not completed.')),
                    );
                    Navigator.of(context).pop(); // Close the booking dialog
                  }
                } catch (e) {
                  // Handle payment errors
                  print('Error during payment: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Payment failed, please try again.')),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (displayType == 'desktop' || displayType == 'tablet')
                ? 4.w
                : screenWidth * 0.03,
            vertical: (displayType == 'desktop' || displayType == 'tablet')
                ? 2.w
                : screenWidth * 0.01,
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, [true]);
            },
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/Images/back.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<FindBloc, FindState>(builder: (context, state) {
        if (state is ViewConsultLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.pink));
        } else if (state is ViewConsultLoaded) {
          sectionTopicdata1 = state.consultData;
          String plainDescription =
              convertHtmlToText(sectionTopicdata1['consultDescription']);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(thickness: 1, color: AppColors.dark1),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.06,
                            right: screenWidth * 0.06,
                            top: screenHeight * 0.008),
                        child: Text(
                          sectionTopicdata1['consultName'],
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.appTitleStyleTablet
                              : FTextStyle.appBarTitleStyle,
                        ),
                      ).animateOnPageLoad(
                          animationsMap['imageOnPageLoadAnimation2']!),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.06,
                            top: screenHeight * 0.03,
                            right: screenWidth * 0.06),
                        child: Text(
                          plainDescription,
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.forumTopicsSubTitleTablet
                              : FTextStyle.forumContent,
                        ),
                      ).animateOnPageLoad(
                          animationsMap['imageOnPageLoadAnimation2']!),
                      SizedBox(height: screenHeight * 0.015),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03),
                        child: Card(
                          color: AppColors.cardBack,
                          elevation: 0.05,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: screenWidth * 0.05, top: 10),
                                child: Text(
                                  'Physio Online Consults',
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.forumTopicsTitleTablet
                                      : FTextStyle.forumTopicsTitle,
                                ),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: sectionTopicdata1['plans'].length,
                                itemBuilder: (context, index) {
                                  var plans = sectionTopicdata1['plans']
                                      as List<
                                          dynamic>; // Convert to List<dynamic>
                                  var Plans =
                                      plans[index] as Map<String, dynamic>;

                                  String key = Plans['serviceName'] as String;
                                  dynamic price = Plans['price'];

                                  String formattedPrice;
                                  if (price is int) {
                                    formattedPrice = price.toString() + '.00';
                                  } else if (price is double) {
                                    formattedPrice = price.toStringAsFixed(2);
                                  } else {
                                    formattedPrice = '0.00';
                                  }
                                  String subtitle = '\$$formattedPrice';

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedOption = key;
                                        onlinePackageOption =
                                            null; // Reset package selection
                                      });
                                    },
                                    hoverColor: Colors
                                        .transparent, // Removes hover color
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.05,
                                            vertical: screenHeight * 0.004,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    child: Text(
                                                      key,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: (displayType ==
                                                                  'desktop' ||
                                                              displayType ==
                                                                  'tablet')
                                                          ? FTextStyle
                                                              .forumTopicsSubTitleTablet
                                                          : FTextStyle
                                                              .blackHeading,
                                                    ).animateOnPageLoad(
                                                        animationsMap[
                                                            'imageOnPageLoadAnimation2']!),
                                                  ),
                                                  Text(
                                                    subtitle,
                                                    style: (displayType ==
                                                                'desktop' ||
                                                            displayType ==
                                                                'tablet')
                                                        ? FTextStyle
                                                            .forumTopicsTitleTablet
                                                        : FTextStyle.buttonpink,
                                                  ).animateOnPageLoad(animationsMap[
                                                      'imageOnPageLoadAnimation2']!),
                                                ],
                                              ),
                                              CustomRadio(
                                                value: key,
                                                groupValue: selectedOption,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectedOption = newValue;
                                                    onlinePackageOption = null;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (index !=
                                            sectionTopicdata1['plans'].length -
                                                1)
                                          Divider(
                                            thickness: 1,
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            indent: 16,
                                            endIndent: 16,
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenWidth * 0.03),
                        child: Card(
                          color: AppColors.cardBack,
                          elevation: 0.05,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: screenWidth * 0.05, top: 10),
                                child: Text('Online Consult Packages',
                                    style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle.forumTopicsTitleTablet
                                        : FTextStyle.forumTopicsTitle),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: sectionTopicdata1['packages'].length,
                                itemBuilder: (context, index) {
                                  var packages = sectionTopicdata1['packages']
                                      as List<
                                          dynamic>; // Convert to List<dynamic>
                                  var Packages = packages[index] as Map<String,
                                      dynamic>; // Convert to Map<String, dynamic>

                                  String key = Packages['packageName']
                                      as String; // Extract the packageName
                                  dynamic price = Packages[
                                      'price']; // Extract the price (could be int or double)

                                  String formattedPrice;

                                  if (price is int) {
                                    // If price is an int, format it as dollars with two decimal places
                                    formattedPrice = price.toStringAsFixed(2);
                                  } else if (price is double) {
                                    // If price is already a double, format it with two decimal places
                                    formattedPrice = price.toStringAsFixed(2);
                                  } else {
                                    // Handle unexpected price types
                                    formattedPrice = '0.00';
                                  }

                                  // Add the dollar sign
                                  String subtitle = '\$$formattedPrice';

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        onlinePackageOption =
                                            key; // Update selected package
                                        selectedOption =
                                            null; // Reset plan selection
                                      });
                                    },
                                    overlayColor: MaterialStatePropertyAll(
                                        Colors.transparent),
                                    // Removes hover color
                                    hoverColor: Colors.transparent,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.05,
                                            vertical: screenHeight * 0.004,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    child: Text(
                                                      key,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: (displayType ==
                                                                  'desktop' ||
                                                              displayType ==
                                                                  'tablet')
                                                          ? FTextStyle
                                                              .ForumsNameTitleTab
                                                          : FTextStyle
                                                              .blackHeading,
                                                    ),
                                                  ),
                                                  Text(
                                                    subtitle,
                                                    style: (displayType ==
                                                                'desktop' ||
                                                            displayType ==
                                                                'tablet')
                                                        ? FTextStyle
                                                            .forumTopicsTitleTablet
                                                        : FTextStyle.buttonpink,
                                                  ),
                                                ],
                                              ),
                                              CustomRadio(
                                                value: key,
                                                groupValue: onlinePackageOption,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    onlinePackageOption =
                                                        newValue;
                                                    selectedOption =
                                                        null; // Reset plan selection
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).animateOnPageLoad(animationsMap[
                                        'imageOnPageLoadAnimation2']!),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.06,
                            top: screenHeight * 0.015,
                            right: screenWidth * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                fixedSize: MaterialStatePropertyAll(Size(
                                    screenWidth * 0.47, screenHeight * 0.06)),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                backgroundColor:
                                    MaterialStatePropertyAll(AppColors.blue1),
                              ),
                              onPressed: (selectedOption != null ||
                                      onlinePackageOption != null)
                                  ? () {
                                      showBookingDialog(selectedOption ??
                                          onlinePackageOption ??
                                          '');
                                    }
                                  : null, // Disable button if no option is selected
                              child: Text(
                                'Single Purchase',
                                style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.ForumsButtonStylingTablet
                                    : FTextStyle.ForumsButtonStyling,
                              ),
                            ),
                          ],
                        ),
                      ).animateOnPageLoad(
                          animationsMap['imageOnPageLoadAnimation2']!),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else if (state is ViewConsultError) {
          return Center(
              child: Image.asset('assets/Images/somethingwentwrong.png'));
        }
        return SizedBox();
      }),
    );
  }
}
