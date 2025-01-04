import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/program_flow/programflow_bloc.dart';
import 'package:health2mama/apis/program_flow/programflow_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
    BlocProvider.of<ProgramflowBloc>(context)
        .add(GetAllNotifications(receiverId: PrefUtils.getUserId()));
  }

  void clearAllNotifications() {
    // Dispatch the event to clear all notifications
    BlocProvider.of<ProgramflowBloc>(context).add(DeleteAllNotificationsEvent(PrefUtils.getUserId()));
  }

  void deleteNotification(String notificationId) {
    BlocProvider.of<ProgramflowBloc>(context).add(DeleteNotificationEvent(notificationId));
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
            padding: EdgeInsets.only(
                left: (displayType == 'desktop' || displayType == 'tablet')
                    ? 4.w
                    : 8.0),
            child: Text(
              "Notifications",
              style: FTextStyle.appBarTitleStyle,
              textAlign: TextAlign.center,
            ),
          ),
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
          actions: [
            Padding(
              padding: EdgeInsets.only(
                  right: (displayType == 'desktop' || displayType == 'tablet')
                      ? 28.h
                      : 28.0),
              child: TextButton(
                onPressed: clearAllNotifications,
                child: Text(
                  'Clear All',
                  style: (displayType == 'desktop' || displayType == 'tablet')
                      ? FTextStyle.clearAllTab
                      : FTextStyle.clearAll,
                ).animateOnPageLoad(
                    animationsMap['imageOnPageLoadAnimation2']!),
              ),
            ),
          ],
        ),
        body: BlocConsumer<ProgramflowBloc, ProgramflowState>(
          listener: (context, state) {
            if (state is NotificationDeleteSuccess) {
              print('Notification Deleted Successfully!');
              // Reload notifications
              BlocProvider.of<ProgramflowBloc>(context).add(GetAllNotifications(receiverId: PrefUtils.getUserId()));
            } else if (state is NotificationDeleteFailure) {
              // Optionally show an error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to delete notification.')),
              );
            } else if (state is NotificationDeletedState) {
              print('All Notifications Cleared Successfully!');
              // Reload notifications
              BlocProvider.of<ProgramflowBloc>(context).add(GetAllNotifications(receiverId: PrefUtils.getUserId()));
            } else if (state is NotificationErrorState) {
              // Optionally show an error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to clear all notifications.')),
              );
            }
          },
          builder: (context, state) {
            if (state is NotificationLoadingState) {
              // Show loading spinner
              return Center(child: CircularProgressIndicator(color: AppColors.pink));
            } else if (state is NotificationLoaded) {
              final notifications = state.notifications;
              if (notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image(
                          image: AssetImage("assets/Images/notificationNotFound.png"),
                          height: (displayType == 'desktop' || displayType == 'tablet') ? 120.h : 120,
                          width: (displayType == 'desktop' || displayType == 'tablet') ? 200.w : 120,
                        ),
                      ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                      SizedBox(height: (displayType == 'desktop' || displayType == 'tablet') ? 20.h : 20),
                      Center(
                        child: Text(
                          'No Notifications Yet',
                          style: TextStyle(
                            fontSize: (displayType == 'desktop' || displayType == 'tablet') ? 10.sp : 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    const Divider(
                      thickness: 1.2,
                      color: Color(0XFFF6F6F6),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          final bool isWhite = index % 2 == 0;
                          final notificationId = notification['_id'];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: (displayType == 'desktop' || displayType == 'tablet') ? 12.h : 12.0),
                            child: Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.225,
                                motion: const ScrollMotion(),
                                children: [
                                  Card(
                                    color: isWhite ? AppColors.cardBack : Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(
                                        color: isWhite ? AppColors.cardBack : Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    child: InkWell(
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onTap: () {
                                        deleteNotification(notificationId);
                                        print('You Deleted Notification ${notificationId}');
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: (displayType == 'desktop' || displayType == 'tablet') ? 73.h : 43.0,
                                            horizontal: (displayType == 'desktop' || displayType == 'tablet') ? 26.h : 26.0),
                                        child: SizedBox(
                                          height: (displayType == 'desktop' || displayType == 'tablet') ? 20.h : 20,
                                          width: (displayType == 'desktop' || displayType == 'tablet') ? 20.w : 20,
                                          child: Image.asset(
                                            'assets/Images/delete.png',
                                            height: (displayType == 'desktop' || displayType == 'tablet') ? 34.h : 24,
                                            width: (displayType == 'desktop' || displayType == 'tablet') ? 34.w : 24,
                                          ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              child: Card(
                                color: isWhite ? AppColors.cardBack : Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(
                                    color: isWhite ? AppColors.cardBack : Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Handle card tap action
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: (displayType == 'desktop' || displayType == 'tablet') ? 3.h : 5.0,
                                        vertical: (displayType == 'desktop' || displayType == 'tablet') ? 13.h : 13),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SizedBox(
                                            width: (displayType == 'desktop' || displayType == 'tablet') ? 50.w : 60,
                                            height: (displayType == 'desktop' || displayType == 'tablet') ? 50.w : 60,
                                            child: Image.asset(
                                              'assets/Images/notificationImage.png',
                                              fit: BoxFit.fill,
                                            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: (displayType == 'desktop' || displayType == 'tablet') ? 15.h : 14.0),
                                                    child: Text(
                                                      notification['title'] ?? '',
                                                      style: TextStyle(
                                                        fontSize: (displayType == 'desktop' || displayType == 'tablet') ? 12.sp : 16.0,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                  ),
                                                  SizedBox(height: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : 5),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : 8.0),
                                                    child: Text(
                                                      getRelativeTime(notification['createdAt']) ?? '',
                                                      style: TextStyle(
                                                        fontSize: (displayType == 'desktop' || displayType == 'tablet') ? 12.sp : 14.0,
                                                        color: Colors.grey,
                                                      ),
                                                    ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : 5),
                                              Text(
                                                notification['message'] ?? '',
                                                style: TextStyle(
                                                  fontSize: (displayType == 'desktop' || displayType == 'tablet') ? 9.sp : 14.0,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!);
                        },
                      ),
                    ),
                  ],
                );
              }
            } else if (state is NotificationError) {
              // Show error message
              return Center(
                child: Image.asset('assets/Images/nodata.jpg'),
              );
            } else {
              // Fallback widget
              return Center(
                  child: CircularProgressIndicator()
              );
            }
          },
        ),
      ),
    );
  }

  String getRelativeTime(String createdAt) {
    DateTime notificationDate = DateTime.parse(createdAt); // Parse the date
    DateTime currentDate = DateTime.now(); // Get current time
    Duration difference =
    currentDate.difference(notificationDate); // Calculate the difference

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec${difference.inSeconds == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      int years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }
}
