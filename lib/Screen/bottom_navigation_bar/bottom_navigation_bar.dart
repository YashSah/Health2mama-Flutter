import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/APIs/auth_flow/authentication_bloc.dart';
import 'package:health2mama/Screen/Activate/activate.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/auth_flow/login_Screen.dart';
import 'package:health2mama/Screen/childhood_tracker/childhood_tracker.dart';
import 'package:health2mama/Screen/drawer/change_password.dart';
import 'package:health2mama/Screen/drawer/edit_details.dart';
import 'package:health2mama/Screen/drawer/edit_quiz.dart';
import 'package:health2mama/Screen/find/consult.dart';
import 'package:health2mama/Screen/forums/forum_screen.dart';
import 'package:health2mama/Screen/health_Point/health_point.dart';
import 'package:health2mama/Screen/pregnnacy/pregnnacy_tracker.dart';
import 'package:health2mama/Screen/program_flow/program.dart';
import 'package:health2mama/Screen/schedule/consult_screen.dart';
import 'package:health2mama/Screen/program_flow/notification_screen.dart';
import 'package:health2mama/Screen/program_flow/save_item.dart';
import 'package:health2mama/Screen/subscription_plan/buy_subscription_screen.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/StageConverter.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/drawer/drawer_bloc.dart';
import 'package:health2mama/apis/subscription_plan/subscription_bloc.dart';
import '../../Utils/pref_utils.dart';
import '../find/your_consultant.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;
  bool isButtonLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _tabTitles = [
    'Programs',
    'Saved',
    'Find',
    'Activate',
    'Schedule'
  ];
  final List<Widget> _screens = [
    const Programs(),
    const SaveItem(),
    const ConsultFind(),
    const Activate(),
    const Consult(),
  ];
  final List<String> _tabIcons = [
    'assets/Images/program.png',
    'assets/Images/bookmark.png',
    'assets/Images/find.png',
    'assets/Images/activate.png',
    'assets/Images/shedulebuttom.png',
  ];

  int _selectionIndex = 0;
  final List<dynamic> _content = [
    {
      "title": "Change Interest",
      "unSelectedImagePath": "assets/Images/UnSelectedEditQuiz.png",
      "selectedImagePath": "assets/Images/SelectedEditQuiz.png"
    },
    {
      "title": "My Account",
      "unSelectedImagePath": "assets/Images/UnSelectedMyAccount.png",
      "selectedImagePath": "assets/Images/SelectedMyAccount.png"
    },
    {
      "title": "Subscription Plans",
      "unSelectedImagePath": "assets/Images/UnSelectedSubscription.png",
      "selectedImagePath": "assets/Images/SelectedSubscription.png"
    },
    {
      "title": "Health Point",
      "unSelectedImagePath": "assets/Images/UnSelectedHealthPoint.png",
      "selectedImagePath": "assets/Images/SelectedHealthPoint.png"
    },
    // {"title": "Childhood Tracker","unSelectedImagePath": "assets/Images/UnSelectedTracker.png" ,"selectedImagePath": "assets/Images/SelectedTracker.png"},
    {
      "title": "Change Password",
      "unSelectedImagePath": "assets/Images/UnSelectedChangePassword.png",
      "selectedImagePath": "assets/Images/SelectedChangePassword.png"
    },
    {
      "title": "Forums",
      "unSelectedImagePath": "assets/Images/UnSelectedSaved.png",
      "selectedImagePath": "assets/Images/SelectedSaved.png"
    },

    {
      "title": "Logout",
      "unSelectedImagePath": "assets/Images/UnSelectedLogout.png",
      "selectedImagePath": "assets/Images/SelectedLogout.png"
    }
  ];
  final animationsMap = {
    'imageOnPageLoadAnimation': AnimationInfo(
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
    'imageOnPageLoadAnimation1': AnimationInfo(
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
    )
  };

  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Stack(
        children: [
          Visibility(
            visible: (_currentIndex == 2) ? true : false,
            child: Positioned.fill(
              child: Image.asset(
                'assets/Images/findbackground.png', // Background image
                fit: BoxFit.contain,
              ),
            ),
          ),
          Visibility(
            visible: (_currentIndex == 2) ? true : false,
            child: Positioned.fill(
              child: Image.asset(
                'assets/Images/findback.png', // Overlay image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            drawerEnableOpenDragGesture: false,
            backgroundColor: (_currentIndex == 2) ? Colors.transparent : null,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Builder(builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/Images/drawer.png',
                        fit: BoxFit.fill,
                        width: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? 25.w
                            : 30,
                        height: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? 20.h
                            : 30, // Adjust the height as needed
                      ),
                    ),
                  );
                }),
              ),
              title: Text(
                (_currentIndex == 0)
                    ? "Programs"
                    : (_currentIndex == 2)
                        ? "Consult"
                        : (_currentIndex == 3)
                            ? "${StageConverter.formatStage(PrefUtils.getUserStage())}"
                            : _tabTitles[_currentIndex],
                style: (displayType == 'desktop' || displayType == 'tablet')
                    ? FTextStyle.appTitleStyleTablet
                    : FTextStyle.appTitleStyle,
              ),
              actions: [
                if (_currentIndex == 0) // Show the image only if index is 2
                  Padding(
                    padding: const EdgeInsets.only(right: 26.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const HealthPoint(), // Replace NewScreen() with the screen you want to navigate to
                            ));
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/Images/like.png',
                          width: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? 15.w
                              : 20,
                          height: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? 15.w
                              : 20, // Adjust the height as needed
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 26.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/Images/notification.png',
                        width: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? 13.w
                            : 20,
                        height: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? 13.w
                            : 20, // Adjust the height as needed
                      ),
                    ),
                  ),
                ),
              ],
            ),
            drawer:
                CustomDrawer(content: _content, selectedIndex: _selectionIndex),
            body: Container(
                color: Colors.transparent, child: _screens[_currentIndex]),
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35.0),
                topRight: Radius.circular(35.0),
              ),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: BottomNavigationBar(
                    useLegacyColorScheme: true,
                    mouseCursor: SystemMouseCursors.grab,
                    unselectedIconTheme: const IconThemeData(
                      color: AppColors.unselectNavColor,
                    ),
                    unselectedItemColor: AppColors.unselectNavColor,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _currentIndex,
                    onTap: (int index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    selectedItemColor: AppColors.appBlue,
                    selectedLabelStyle:
                        (displayType == 'desktop' || displayType == 'tablet')
                            ? FTextStyle.navTitleTablet
                            : FTextStyle.navTitle,
                    unselectedLabelStyle:
                        (displayType == 'desktop' || displayType == 'tablet')
                            ? FTextStyle.sunSelectedNavTitleTablet
                            : FTextStyle.sunSelectedNavTitle,
                    items: List.generate(_tabTitles.length, (index) {
                      return BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ImageIcon(
                            AssetImage(_tabIcons[index]),
                            size: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? 17.sp
                                : 22,
                          ),
                        ),
                        label: _tabTitles[index],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  List<dynamic> content;
  int selectedIndex;

  CustomDrawer({required this.content, required this.selectedIndex, Key? key})
      : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int selectedIndex = 0; // Initially selecting the first item

  void navigateToScreen(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const EditQuiz()));

        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EditDetails()));

      case 2:
        // Directly push the navigation and wrap only the BuySubscriptionScreen with BlocProvider
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => SubscriptionBloc()),
                BlocProvider(create: (context) => DrawerBloc()),
                BlocProvider(create: (context) => AuthenticationBloc()),
              ],
              child: const BuySubscriptionScreen(),
            ),
          ),
        );
        break;

      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HealthPoint()));

      // case 4:
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) =>
      //               const ChildhoodTracker()));

      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ChangePassword()));

      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ForumsTopics()));

      case 6:
        Navigator.pop(context);
        var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
        var displayType = valueType.toString().split('.').last;
        print('displayType>> $displayType');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.white,
              insetPadding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 16),
              child: Container(
                width: (displayType == 'desktop' || displayType == 'tablet')
                    ? 200.w
                    : MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/Images/logout.png",
                        height: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? 60.w
                            : 60,
                        width: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? 40.h
                            : 40,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        "LOGOUT ",
                        style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? FTextStyle.logoutTablet
                            : FTextStyle.logout,
                        textAlign: TextAlign.center,
                      ),
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                    Text(
                      "Are you sure you want to logout ?",
                      style:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? FTextStyle.lightTextlargeTablet
                              : FTextStyle.lightTextlarge,
                      textAlign: TextAlign.center,
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                    const SizedBox(height: 30),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? 80.w
                                : 100,
                            height: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? 40.h
                                : 45,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.defaultButton),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                        color: AppColors.appBlue, width: 1)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: Text(
                                "No",
                                style: TextStyle(
                                    color: AppColors.appBlue,
                                    fontSize: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? 9.sp
                                        : 15),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? 80.w
                                : 100,
                            height: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? 40.h
                                : 45,
                            child: TextButton(
                              onPressed: () {
                                final squeezes = PrefUtils.getSqueezes();
                                final strength = PrefUtils.getStrength();
                                final endurance = PrefUtils.getEndurance();
                                PrefUtils
                                    .clearAll(); // Clear all shared preferences
                                PrefUtils.setIsLogout(true);
                                PrefUtils.setSqueezes(squeezes);
                                PrefUtils.setStrength(strength);
                                PrefUtils.setEndurance(endurance);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.appBlue),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.appBlue),
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                        color: Colors.white, width: 1)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? 9.sp
                                        : 15),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!);
          },
        );

      // Add cases for other menu items here
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return SizedBox(
      width: height * 0.32,
      child: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: width * 0.15),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: SizedBox(
                  height: (displayType == 'desktop' || displayType == 'tablet')
                      ? 80.h
                      : 80,
                  child: Image.asset('assets/Images/splash.png'),
                ),
              ),
              SizedBox(height: width * 0.03),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.content.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          vertical: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? 10.h
                              : 5.0,
                          horizontal: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      elevation: widget.selectedIndex == index ? 2.5 : 0.9,
                      // shadowColor: widget.selectedIndex == index
                      //     ? Colors.white
                      //     : Colors.transparent,
                      shadowColor: Colors.white,

                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: widget.selectedIndex == index
                                ? AppColors.primaryColorPink
                                : Colors.transparent,
                            width: 0.9, // You can adjust the border width here
                          ),
                          color: widget.selectedIndex == index
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? const EdgeInsets.symmetric(vertical: 10.0)
                              : EdgeInsets.zero,
                          child: ListTile(
                            minVerticalPadding: 0.0,
                            title: Row(
                              children: [
                                Image.asset(
                                        widget.selectedIndex == index
                                            ? widget.content[index]
                                                ['selectedImagePath']
                                            : widget.content[index]
                                                ['unSelectedImagePath'],
                                        width: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 15.w
                                            : 25.0,
                                        color: AppColors.primaryColorPink)
                                    .animateOnPageLoad(animationsMap[
                                        'imageOnPageLoadAnimation2']!),
                                const SizedBox(width: 10),
                                Text(
                                  widget.content[index]['title'],
                                  style: widget.selectedIndex == index
                                      ? (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? FTextStyle
                                              .sideMenuTextSelectedTablet
                                          : FTextStyle.sideMenuTextSelected
                                      : (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? FTextStyle
                                              .sideMenuTextUnSelectedTablet
                                          : FTextStyle.sideMenuTextUnSelected,
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                widget.selectedIndex = index;
                                selectedIndex = index;
                              });

                              navigateToScreen(index); // Navi
                              // Navigator.pop(context); // Close the drawer
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
