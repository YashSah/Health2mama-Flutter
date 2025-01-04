import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/schedule/consultation_online_view.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/schedule/schedule_bloc.dart';
import 'package:intl/intl.dart';

class Consult extends StatefulWidget {
  const Consult({Key? key}) : super(key: key);

  @override
  _ConsultState createState() => _ConsultState();
}

class _ConsultState extends State<Consult> {
  DateTime? _selectedDate;
  late String _formattedDate;
  late String _upcomingText;

  String convertHtmlToText(String htmlContent) {
    dom.Document document = parse(htmlContent);
    return document.body?.text ?? '';
  }

  TextEditingController _dateController = TextEditingController();
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
    BlocProvider.of<ScheduleBloc>(context).add(ScheduleBooking());
  }

  void _updateDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd MMM yyyy');
    _formattedDate = formatter.format(now);
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Builder(
          builder: (context) {
            DatePickerThemeData _datePickerTheme = DatePickerTheme.of(context)
                .copyWith(
                    headerBackgroundColor: AppColors.pink,
                    headerForegroundColor: Colors.white,
                    dividerColor: Colors.transparent);
            return Theme(
              data: ThemeData(
                datePickerTheme: _datePickerTheme,
                colorScheme: const ColorScheme.light(
                  primary: AppColors.pink,
                  onPrimary: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        _upcomingText = 'Selected';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            thickness: 2,
            color: AppColors.linecolor,
          ),
          SizedBox(
            height: (displayType == 'desktop' || displayType == 'tablet')
                ? 30.h
                : 0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    (displayType == 'desktop' || displayType == 'tablet')
                        ? 30.h
                        : 0.0),
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? 2.h
                          : 2,
                  horizontal:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? 10.h
                          : 20),
              color: Colors.white,
              child: Card(
                margin: EdgeInsets.only(
                    bottom:
                        (displayType == 'desktop' || displayType == 'tablet')
                            ? 10.h
                            : 10),
                elevation: 0.2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                        (displayType == 'desktop' || displayType == 'tablet')
                            ? 30.h
                            : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text("Upcoming",
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.upcomingtextTab.copyWith(
                                          color: AppColors.customblack)
                                      : FTextStyle.upcomingtext.copyWith(
                                          color: AppColors.customblack)),
                            ),
                            SizedBox(
                              height: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? 10.h
                                  : 10,
                            ),
                            Expanded(
                              child: Text(
                                _formattedDate ?? 'Loading...',
                                style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.currenttimeStyleTab
                                        .copyWith(color: AppColors.currentdate)
                                    : FTextStyle.currenttimeStyle
                                        .copyWith(color: AppColors.currentdate),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: Colors.black.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.ForumsTextFieldTitleTab
                                      : FTextStyle.ForumsTextFieldTitle,
                                  controller: _dateController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Select Date",
                                    hintStyle: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle.ForumsTextFieldHintTab
                                        : FTextStyle.ForumsTextFieldHint,
                                    contentPadding: EdgeInsets.all(10.0),
                                  ),
                                  readOnly: true,
                                ),
                              ),
                              IconButton(
                                  icon: Container(
                                    width: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? 34.h
                                        : 34,
                                    height: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? 34.h
                                        : 34,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColors.pink,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Image.asset(
                                          'assets/Images/Calender.png'),
                                    ),
                                  ),
                                  onPressed: () {
                                    _selectDate(context);
                                  })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animateOnPageLoad(
                    animationsMap['imageOnPageLoadAnimation2']!),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ScheduleBloc, ScheduleState>(
              builder: (context, state) {
                if (state is ScheduleflowLoading) {
                  return Center(child: CircularProgressIndicator(color: AppColors.pink));
                } else if (state is ScheduleflowLoaded) {
                  List<dynamic> bookings = state.bookings;
                  print(bookings);

                  DateTime now =
                      DateTime.now(); // Get the current date and time
                  List<dynamic> filteredBookings = bookings.where((booking) {
                    // Parse the date string from booking
                    DateTime bookingDate =
                        DateFormat('yyyy-MM-dd').parse(booking['date']);

                    // Show all bookings if no date is selected; otherwise, show upcoming/current bookings only
                    if (_selectedDate == null) {
                      return bookingDate.isAfter(now) ||
                          bookingDate.isAtSameMomentAs(now);
                    }

                    // Compare year, month, and day for exact match if a date is selected
                    return bookingDate.year == _selectedDate!.year &&
                        bookingDate.month == _selectedDate!.month &&
                        bookingDate.day == _selectedDate!.day;
                  }).toList();

                  return state.bookings.isEmpty
                      ? Center(child: Image.asset('assets/Images/nodata.jpg'))
                      : ListView.builder(
                          padding: EdgeInsets.only(
                              top: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? 3.h
                                  : 3),
                          itemCount: filteredBookings.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final booking = filteredBookings[index];
                            String date = booking['date'];
                            String time = booking['time'];

                            return Padding(
                              padding: EdgeInsets.all(
                                  (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? 5.h
                                      : 0.0),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? 35.h
                                        : 20),
                                color: AppColors.customwhite,
                                child: Card(
                                  margin: EdgeInsets.only(
                                      bottom: (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? 10.h
                                          : 10),
                                  elevation: 0.2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? 13.h
                                              : 13.0,
                                          horizontal:
                                              (displayType == 'desktop' ||
                                                      displayType == 'tablet')
                                                  ? 8.h
                                                  : 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? 16.h
                                                    : 16.0,
                                                bottom: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? 8.h
                                                    : 8.0),
                                            child: Text(
                                              booking['consult']['consultName']
                                                  .toString(),
                                              style: (displayType ==
                                                          'desktop' ||
                                                      displayType == 'tablet')
                                                  ? FTextStyle.cardTitleTable
                                                  : FTextStyle.cardTitle,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? 13.h
                                                    : 16.0),
                                            child: Text(
                                              convertHtmlToText(
                                                  booking['consult']
                                                          ['consultDescription']
                                                      .toString()),
                                              style: (displayType ==
                                                          'desktop' ||
                                                      displayType == 'tablet')
                                                  ? FTextStyle.loremtextTab
                                                      .copyWith(
                                                          color: AppColors
                                                              .loremtextcolor)
                                                  : FTextStyle.loremtext
                                                      .copyWith(
                                                          color: AppColors
                                                              .loremtextcolor),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? 8.h
                                                    : 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: (displayType ==
                                                                    'desktop' ||
                                                                displayType ==
                                                                    'tablet')
                                                            ? 16.h
                                                            : 16.0,
                                                        vertical: (displayType ==
                                                                    'desktop' ||
                                                                displayType ==
                                                                    'tablet')
                                                            ? 2.h
                                                            : 2.0),
                                                    child: Text(
                                                      'Appointment Date & Time',
                                                      style: (displayType ==
                                                                  'desktop' ||
                                                              displayType ==
                                                                  'tablet')
                                                          ? FTextStyle
                                                              .currenttimeStyleTab
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .currentdate)
                                                          : FTextStyle
                                                              .currenttimeStyle
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .currentdate),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: (displayType ==
                                                                    'desktop' ||
                                                                displayType ==
                                                                    'tablet')
                                                            ? 16.h
                                                            : 16.0),
                                                    child: Text(
                                                      '$date  $time',
                                                      style: (displayType ==
                                                                  'desktop' ||
                                                              displayType ==
                                                                  'tablet')
                                                          ? FTextStyle
                                                              .listtext4Tab
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .darkblack)
                                                          : FTextStyle.listtext4
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .darkblack),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? 13.h
                                                    : 13.0),
                                            child: SizedBox(
                                              width: (displayType ==
                                                          'desktop' ||
                                                      displayType == 'tablet')
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.45
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.45,
                                              height: (displayType ==
                                                          'desktop' ||
                                                      displayType == 'tablet')
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.10,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: (displayType ==
                                                                'desktop' ||
                                                            displayType ==
                                                                'tablet')
                                                        ? 13.h
                                                        : 16.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            OnlineDetail(
                                                          bookingData: booking,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.appBlue,
                                                    padding: EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'View',
                                                    style: (displayType ==
                                                                'desktop' ||
                                                            displayType ==
                                                                'tablet')
                                                        ? TextStyle(
                                                            fontSize: 10.0.sp,
                                                            color: Colors.white)
                                                        : const TextStyle(
                                                            fontSize: 16.0,
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 6)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                } else if (state is ScheduleflowError) {
                  return Center(child: Image.asset('assets/Images/nodata.jpg'));
                }
                return SizedBox();
              },
            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
          ),
        ],
      ),
    );
  }
}
