import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/drawer/edit_screen.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/drawer/drawer_bloc.dart';

class EditDetails extends StatefulWidget {
  const EditDetails({super.key});

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

bool notificationSwitch = false;
bool synccalendarSwitch = false;

_saveSwitchValue(bool value) {
  PrefUtils.setsyncCalendar(value); // Save the value in PrefUtils
}

class _EditDetailsState extends State<EditDetails> {
  // Load the saved switch value from PrefUtils
  _loadSwitchValue() async {
    bool? savedValue = await PrefUtils.getsyncCalendar(); // Assuming get method exists
    setState(() {
      synccalendarSwitch = savedValue ?? false; // Default to false if no value found
    });
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
  void initState() {
    super.initState();
    _loadSwitchValue();
    BlocProvider.of<DrawerBloc>(context).add(LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("My Account",
                  style: (displayType == 'desktop' || displayType == 'tablet')
                      ? FTextStyle.appTitleStyleTablet
                      : FTextStyle.appBarTitleStyle)),
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
        body: BlocBuilder<DrawerBloc, DrawerState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return Center(child: CircularProgressIndicator(color: AppColors.pink));
            } else if (state is UserProfileLoaded) {
              final userProfile = state.successResponse;
              final fullName = userProfile['fullName'];
              final country = userProfile['countryCode'];
              final countryCode = userProfile['country'];
              final phone = userProfile['phoneNumber'];
              final emailAddress = userProfile['email'];
              final otherthanmum = userProfile['otherWork'];
              final languages = userProfile['languages'];
              final exercises = userProfile['exercise'];
              final other = userProfile['others'];
              final havekids = userProfile['kids'];
              final ageBracket = userProfile['age'];
              final profileImage = userProfile['profilePicture'];

              print("User Full Name Is :${fullName}");
              print("User Country Code Is: ${countryCode}");
              print("User Country Is :${country}");
              print("User Phone Number Is :${phone}");
              print("User Email Address Is :${emailAddress}");
              print("User Other Than Mum Status Is :${otherthanmum}");
              print("User Langauge Is :${languages}");
              print("User Exercise Is :${exercises}");
              print("User Other Work Is :${other}");
              print("User Have Kids Is :${havekids}");
              print("User Age Bracket Is :${ageBracket}");
              print("User Profile Image Is:${profileImage}");


              return SingleChildScrollView(
                child: Padding(
                  padding: (displayType == 'desktop' || displayType == 'tablet')
                      ? EdgeInsets.symmetric(horizontal: 25.w)
                      : EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(thickness: 1.2, color: Color(0XFFF6F6F6)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                          "General Details",
                          style: (displayType == 'desktop' ||
                              displayType == 'tablet')
                              ? FTextStyle.generalTablet
                              : FTextStyle.general,
                        ),
                      ),
                      SizedBox(
                        height: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? 20.h
                            : 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey, // Specify the border color here
                                width: 2, // Specify the border width here
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: (userProfile['profilePicture'] == null || userProfile['profilePicture'].isEmpty)
                                  ? Image.asset(
                                'assets/Images/show.png',
                                fit: BoxFit.cover,
                                height: (displayType == 'desktop' || displayType == 'tablet') ? 70.w : 100,
                                width: (displayType == 'desktop' || displayType == 'tablet') ? 70.w : 100,
                              )
                                  : userProfile['profilePicture'].startsWith('http')
                                  ? Image.network(
                                userProfile['profilePicture'],
                                fit: BoxFit.cover,
                                height: (displayType == 'desktop' || displayType == 'tablet') ? 70.w : 100,
                                width: (displayType == 'desktop' || displayType == 'tablet') ? 70.w : 100,
                              )
                                  : Image.memory(
                                base64Decode(userProfile['profilePicture']),
                                fit: BoxFit.cover,
                                height: (displayType == 'desktop' || displayType == 'tablet') ? 70.w : 100,
                                width: (displayType == 'desktop' || displayType == 'tablet') ? 70.w : 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? 20.h
                            : 0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                        22.0), // Adjust the padding value as needed
                                    child: Text(
                                      "Full Name",
                                      style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                          ? FTextStyle.editTablet
                                          : FTextStyle.edit,
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 22.0),
                                    child: Text(
                                      "Country / Region",
                                      style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                          ? FTextStyle.editTablet
                                          : FTextStyle.edit,
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 22.0),
                                    child: Text(
                                      "Phone No.",
                                      style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                          ? FTextStyle.editTablet
                                          : FTextStyle.edit,
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 22.0),
                                    child: Text(
                                      "Email Address",
                                      style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                          ? FTextStyle.editTablet
                                          : FTextStyle.edit,
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 22.0),
                                    child: Text(
                                      userProfile['fullName'].length > 25 ? '${userProfile['fullName'].substring(0,25)}...' : userProfile['fullName']
                                      ,style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle.editTitleTablet
                                        : FTextStyle.editTitle,
                                        overflow: TextOverflow.ellipsis),

                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 22.0),
                                    child: Text("${userProfile['countryCode']}",style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle.editTitleTablet
                                        : FTextStyle.editTitle,),
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 22.0),
                                    child: Text("${userProfile['phoneNumber']}",style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle.editTitleTablet
                                        : FTextStyle.editTitle,),
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 22.0),
                                    child: Text("${userProfile['email']}",style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle.editTitleTablet
                                        : FTextStyle.editTitle,),
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? 20.h
                            : 0,
                      ),
                      Visibility(
                        visible: displayType == 'mobile' ? true : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          child: Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              // Added margin for spacing
                              elevation: 0.5, // Adjust the elevation as needed
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
                                      offset: const Offset(
                                          0, 1.5), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text(
                                        "Sync Calendar",
                                        style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                            ? FTextStyle.clearAllTablet
                                            : FTextStyle.clearAll,
                                      ),
                                    ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Transform.scale(
                                        scale:
                                        0.8, // Adjust the scale factor as needed
                                        child: Switch(
                                          value: synccalendarSwitch,
                                          // Assuming _switchValue is a boolean variable indicating the state of the switch
                                          onChanged: (newValue) {
                                            setState(() {
                                              synccalendarSwitch = newValue;
                                            });
                                            _saveSwitchValue(newValue);
                                          },
                                          activeColor: Colors
                                              .blue, // Set the selected color to blue
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      Visibility(
                        visible: displayType == 'mobile' ? true : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
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
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(18.0),
                                    child: Text(
                                      "Notification",
                                      style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                          ? FTextStyle.clearAllTablet
                                          : FTextStyle.clearAll,
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Transform.scale(
                                      scale:
                                      0.8, // Adjust the scale factor as needed
                                      child: Switch(
                                        value: notificationSwitch,
                                        // Assuming _switchValue is a boolean variable indicating the state of the switch
                                        onChanged: (newValue) {
                                          setState(() {
                                            notificationSwitch = newValue;
                                          });
                                        },
                                        activeColor: Colors
                                            .blue, // Set the selected color to blue
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? 20.h
                            : 0,
                      ),
                      Visibility(
                        visible: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? true
                            : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Card(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      // Added margin for spacing
                                      elevation:
                                      0.5, // Adjust the elevation as needed
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                              Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: const Offset(0,
                                                  1.5), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(18.0),
                                              child: Text(
                                                "Sync Calendar",
                                                style: (displayType ==
                                                    'desktop' ||
                                                    displayType == 'tablet')
                                                    ? FTextStyle.clearAllTablet
                                                    : FTextStyle.clearAll,
                                              ),
                                            ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation2']!),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 3.0),
                                              child: Transform.scale(
                                                scale:
                                                0.8, // Adjust the scale factor as needed
                                                child: Switch(
                                                  value: synccalendarSwitch,
                                                  // Assuming _switchValue is a boolean variable indicating the state of the switch
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      synccalendarSwitch = newValue;
                                                    });
                                                    _saveSwitchValue(newValue);
                                                  },
                                                  activeColor: Colors
                                                      .blue, // Set the selected color to blue
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
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
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Text(
                                              "Notification",
                                              style: (displayType ==
                                                  'desktop' ||
                                                  displayType == 'tablet')
                                                  ? FTextStyle.clearAllTablet
                                                  : FTextStyle.clearAll,
                                            ),
                                          ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                          Transform.scale(
                                            scale:
                                            0.8, // Adjust the scale factor as needed
                                            child: Switch(
                                              value: notificationSwitch,
                                              // Assuming _switchValue is a boolean variable indicating the state of the switch
                                              onChanged: (newValue) {
                                                setState(() {
                                                  notificationSwitch = newValue;
                                                });
                                              },
                                              activeColor: Colors
                                                  .blue, // Set the selected color to blue
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
                      ),
                      SizedBox(
                        height: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? 20.h
                            : 0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 28),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => DrawerBloc(),
                                  child: EditScreen(
                                    fullName: userProfile['fullName'] ?? '',
                                    country: userProfile['countryCode'] ?? '',
                                    phone: userProfile['phoneNumber'] ?? '',
                                    emailAddress: userProfile['email'] ?? '',
                                    otherthanmum: userProfile['otherWork'] ?? '',
                                    languages: userProfile['languages'] ?? '',
                                    exercises: userProfile['exercise'] ?? '',
                                    other: userProfile['others'] ?? '',
                                    havekids: userProfile['kids'] ?? '',
                                    ageBracket: userProfile['age'] ?? '',
                                    countryCode: userProfile['country'] ?? '',
                                    profileImage: base64Decode(userProfile['profilePicture'] ?? ''), // Convert to List<int>
                                  ),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.appBlue,
                            textStyle: (displayType == 'desktop' ||
                                displayType == 'tablet')
                                ? FTextStyle.buttonStyleTablet
                                : FTextStyle.buttonStyle,
                            minimumSize: (displayType == 'desktop' ||
                                displayType == 'tablet')
                                ? Size(120.w, 50.h)
                                : const Size(120, 40),
                            // Adjust button size as needed
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            'Edit profile',
                            style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                                ? FTextStyle.buttonStyleTablet
                                : FTextStyle.buttonStyle,
                          ),
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is UserProfileError) {
              CommonPopups.showCustomPopup(context, '${state.failureResponse['responseMessage']}');
            } else if (state is CommonServerFailure) {
              Center(
                child: Image.asset('assets/Images/somethingwentwrong.png'),
              );
            } else if (state is CheckNetworkConnection) {
              CommonPopups.showCustomPopup(context, 'Please check your internet connection.');
            } else {
              return Center(child: CircularProgressIndicator(color: AppColors.pink));
            }
            return SizedBox.shrink(); // Returns an empty widget
          },
        ),
      ),
    );
  }
}
