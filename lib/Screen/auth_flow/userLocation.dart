import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/auth_flow/userSetUpScreen.dart';
import 'package:health2mama/Screen/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/apis/auth_flow/authentication_bloc.dart';
import 'package:health2mama/apis/auth_flow/authentication_event.dart';
import '../../Utils/CommonFuction.dart';
import '../../Utils/constant.dart';
import '../../Utils/flutter_colour_theams.dart';
import '../../Utils/flutter_font_style.dart';
import '../../Utils/pref_utils.dart';

class UserLocationScreen extends StatefulWidget {
  final bool isSignup;

  const UserLocationScreen({Key? key, required this.isSignup})
      : super(key: key);

  @override
  State<UserLocationScreen> createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  String _location = 'Unknown';
  double _latitude = 0.0;
  double _longitude = 0.0;
  bool isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocation();
  }

  /// Checks and requests location permission, and automatically fetches the location if enabled
  Future<void> _checkAndRequestLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        _location = 'Location services are disabled. Please enable them.';
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _location = 'Location permission denied.';
        });
        return;
      }
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _getLocation();
    }
  }

  /// Fetches the user's current location and updates the state
  _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _location = 'Lat: $_latitude, Lon: $_longitude';
        print(_location);
      });

      // Store the location in PrefUtils
      PrefUtils.setLatitude(_latitude);
      PrefUtils.setLongitude(_longitude);
    } catch (e) {
      setState(() {
        _location = 'Error fetching location: ${e.toString()}';
      });
      print('Error fetching location: $e');

      // If location fails, store default values
      PrefUtils.setLatitude(0.0);
      PrefUtils.setLongitude(0.0);
    }
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
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
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
                'assets/Images/back.png',
                width: (displayType == 'desktop' || displayType == 'tablet')
                    ? 35.w
                    : 35,
                height: (displayType == 'desktop' || displayType == 'tablet')
                    ? 35.h
                    : 35,
              ),
            ),
          ),
        ),
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is LocationLoaded) {
              setState(() {
                isLoading = false;
              });
              _getLocation();
            } else if (state is LocationError) {
              setState(() {
                isLoading = false;
              });
              Navigator.pop(context);
              CommonPopups.showCustomPopup(
                  context, state.error['responseMessage']);
            } else if (state is LocationLoading) {
              setState(() {
                isLoading = true;
              });
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    (displayType == 'desktop' || displayType == 'tablet')
                        ? 15.h
                        : 15.0),
            child: Container(
              margin: EdgeInsets.only(
                  top: (displayType == 'desktop' || displayType == 'tablet')
                      ? 10.h
                      : 10,
                  bottom: (displayType == 'desktop' || displayType == 'tablet')
                      ? 50.h
                      : 50),
              alignment: Alignment.center,
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(top: 20, bottom: 70),
                    child: Image.asset(
                      'assets/Images/app_logo.png',
                      width:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 180.w
                              : 180,
                      height:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 75.h
                              : 75,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? 20.h
                            : 20),
                    margin: EdgeInsets.symmetric(
                        horizontal: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? 60.h
                            : 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0.0, 0.0),
                          color: Colors.grey,
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Center(
                            child: Text(
                              Constants.locationScreenHeadingTxt,
                              style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? FTextStyle.loginTitleStyleTablet
                                  : FTextStyle.loginTitleStyle,
                            ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: AppColors.editTextBorderColor,
                            height: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 18, right: 15),
                          child: Text(
                            Constants.locationScreensubTxt,
                            style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? FTextStyle.loginEmailFieldHeadingStyleTablet
                                : FTextStyle.loginEmailFieldHeadingStyle,
                          ).animateOnPageLoad(
                              animationsMap['imageOnPageLoadAnimation2']!),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 10),
                          child: Image.asset('assets/Images/location.png'),
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                        Padding(
                                padding: const EdgeInsets.only(
                                    left: 120, right: 120, bottom: 15),
                                child: Image.asset('assets/Images/divider.png'))
                            .animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, bottom: 5),
                          child: ElevatedButton(
                            onPressed: () async {
                              await _getLocation(); // Attempt to get the location before sending

                              // Store the updated latitude and longitude in PrefUtils
                              PrefUtils.setLatitude(_latitude);
                              PrefUtils.setLongitude(_longitude);

                              BlocProvider.of<AuthenticationBloc>(context).add(
                                LocationRequested(
                                  token: PrefUtils.getUserLoginToken(),
                                  latitude: PrefUtils.getLatitude(),
                                  longitude: PrefUtils.getLongitude(),
                                ),
                              );

                              if (widget.isSignup) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UserSetUpScreen()),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomBottomNavigationBar()),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.pinkButton,
                              textStyle: FTextStyle.buttonStyle,
                              minimumSize: const Size(double.infinity, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 2,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: isLoading
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Sure, I’d like that',
                                      style: (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? FTextStyle.idTab
                                          : FTextStyle.id,
                                    ),
                            ),
                          ),
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                        GestureDetector(
                          onTap: () {
                            // Reset the latitude and longitude to default values (0.0)
                            PrefUtils.setLatitude(0.0);
                            PrefUtils.setLongitude(0.0);

                            // Proceed to the next screen based on isSignup
                            if (widget.isSignup) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserSetUpScreen(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CustomBottomNavigationBar(),
                                ),
                              );
                            }
                          },
                          child: Text(
                            Constants.denuAccessLocationTxt,
                            style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? FTextStyle.denyLocationPermissionTxtStyleTab
                                : FTextStyle.denyLocationPermissionTxtStyle,
                          ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
