import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart'; // Import the device_info_plus package
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:health2mama/Screen/Auth_flow/login_Screen.dart';
import 'package:health2mama/Screen/find_mum/mum_requests.dart';
import 'package:health2mama/Screen/program_flow/globalSearch.dart';
import 'package:health2mama/Utils/shared_preference.dart';
import 'package:health2mama/Screen/splash_screen.dart';
import 'package:health2mama/apis/Activate/activate_bloc.dart';
import 'package:health2mama/apis/auth_flow/authentication_bloc.dart';
import 'package:health2mama/apis/drawer/drawer_bloc.dart';
import 'package:health2mama/apis/find/find_bloc.dart';
import 'package:health2mama/apis/find_mum/find_mum_bloc.dart';
import 'package:health2mama/apis/pregnancy/pregnancy_bloc.dart';
import 'package:health2mama/apis/forums/forums_bloc.dart';
import 'package:health2mama/apis/healthpoint/healthpoint_bloc.dart';
import 'package:health2mama/apis/program_flow/programflow_bloc.dart';
import 'package:health2mama/apis/schedule/schedule_bloc.dart';
import 'package:health2mama/apis/social_login/social_login_bloc.dart';
import 'package:health2mama/apis/subscription_plan/subscription_bloc.dart';
import 'Screen/Activate/tab_to_start.dart';
import 'Screen/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'Utils/constant.dart';
import 'Utils/pref_utils.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey = Constants.stripePublishableKey;
  await Prefs.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
  await FlutterDownloader.initialize(
    debug:
        true, // optional: set to false to disable printing logs to console (default: true)
    ignoreSsl:
        true, // option: set to false to disable working with http links (default: false)
  );
}

void registerFcmToken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      PrefUtils.setDeviceToken(token);
      log("FCM Token: $token"); // Print the FCM token in the debug console
      log("Stored Device Token: ${PrefUtils.getDeviceToken()}"); // Print the stored token from shared preferences
    } else {
      log("FCM Token is null");
    }
  } catch (error) {
    log("Error getting FCM token: $error");
  }
}

// Function to get device information
Future<String> getDeviceInfo(BuildContext context) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceType = '';

  // Check platform and set device type accordingly
  if (Theme.of(context).platform == TargetPlatform.android) {
    deviceType = 'android';
  } else if (Theme.of(context).platform == TargetPlatform.iOS) {
    deviceType = 'ios';
  } else if (kIsWeb) {
    deviceType = 'web';
  } else {
    deviceType = 'Unknown Device';
  }

  log(deviceType); // Print the device type in the debug console
  return deviceType; // Return the device type for further use
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    registerFcmToken(); // Register and print the FCM token here
    initMessaging();
    requestNotificationPermission();
    // Pass the context to getDeviceInfo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDeviceInfo(context);
    });
  }

  void requestNotificationPermission() async {
    // Request permission for iOS devices
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  void initMessaging() {
    var androidInitialization =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialization = DarwinInitializationSettings();
    var initSettings = InitializationSettings(
      android: androidInitialization,
      iOS: iosInitialization,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initSettings);

    var androidNotificationDetails = AndroidNotificationDetails(
      '1', // ID of the channel
      'channelName', // Name of the channel
      channelDescription: 'channel Description', // Description of the channel
      importance: Importance.max,
      priority: Priority.high,
    );

    var iosNotificationDetails = DarwinNotificationDetails();
    var notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      var data = message.data;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          notificationDetails,
        );
      }
    });

    // Listen to background messages when the app is in the terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // This callback is triggered when a notification is tapped while the app is in the background or terminated
      print("Message clicked!");
      var data = message.data;
      var type = data['type'];
      print(type);
      // Navigate based on the notification type
      if (type == "FRIENDREQUEST") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MumRequest(),
          ),
        );
      } else if (type == "REMINDER") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TabToStart(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 840),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthenticationBloc()),
            BlocProvider(create: (context) => SocialLoginBloc()),
            BlocProvider(create: (context) => ActivateBloc()),
            BlocProvider(create: (context) => DrawerBloc()),
            BlocProvider(create: (context) => ForumsBloc()),
            BlocProvider(create: (context) => ProgramflowBloc()),
            BlocProvider(create: (context) => FindBloc()),
            BlocProvider(create: (context) => FindMumBloc()),
            BlocProvider(create: (context) => HealthpointBloc()),
            BlocProvider(create: (context) => ScheduleBloc()),
            BlocProvider(create: (context) => PregnancyBloc()),
            BlocProvider(create: (context) => SubscriptionBloc()),
          ],
          child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Health2Mama',
                    theme: ThemeData(
                      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                      useMaterial3: true,
                    ),
                    home: (PrefUtils.getIsLogin())
                        ? CustomBottomNavigationBar()
                        : (PrefUtils.getIsLogout())
                            ? LoginScreen()
                            : SplashScreen(),
                  ),
        );
      },
    );
  }
}
