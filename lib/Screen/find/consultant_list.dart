import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';

import 'package:health2mama/Screen/find/online_nutrition.dart';
import 'package:health2mama/Screen/find/online_womenhealth.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/find/find_bloc.dart';
import 'package:health2mama/singleton_class.dart';

import '../../Utils/CommonFuction.dart';

class ConsultantListScreen extends StatefulWidget {

  final List<String> services;
  final List<String> specialisations;

  const ConsultantListScreen({
    super.key,
    required this.services,
    required this.specialisations,
  });

  @override
  State<ConsultantListScreen> createState() => _ConsultantListScreenState();
}

class _ConsultantListScreenState extends State<ConsultantListScreen> {

  void initState() {
    super.initState();
    BlocProvider.of<FindBloc>(context)
        .add(SearchQuery(
      services: widget.services.isNotEmpty ? widget.services : [], // Ensure non-null
      specialisations: widget.specialisations.isNotEmpty ? widget.specialisations : [], // Ensure non-null
    ));
  }

  List<Map<String, dynamic>> programdata = [];

  final formKey = GlobalKey<FormState>();
  String? developer;
  bool developerError = false;
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
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
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
        body: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start, // Align children to the start
          children: [
            const Divider(thickness: 1.2, color: Color(0XFFF6F6F6)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Online Consults',
                  style: (displayType == 'desktop' || displayType == 'tablet')
                      ? FTextStyle.appTitleStyleTablet
                      : FTextStyle.appBarTitleStyle,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            BlocBuilder<FindBloc, FindState>(builder: (context, state) {
              if (state is SearchLoading) {
                return Center(child: CircularProgressIndicator(color: AppColors.pink));
              } else if (state is SearchLoaded) {
                programdata = state.results;
                print('Loaded data: ${state.results}');
                // Add debugging statement here
                return Expanded(
                  child: ListView.builder(
                    itemCount: programdata.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2.0),
                        child: GestureDetector(
                          onTap: () {},
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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        programdata[index]['consultLogo'] ?? '',
                                        fit: BoxFit.cover,
                                        height: MediaQuery.of(context).size.height * 0.16,
                                        width: MediaQuery.of(context).size.width * 0.4,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 3.0),
                                            child: Text(
                                              programdata[index]['consultName'] ?? '',
                                              maxLines: 3,
                                              style: (displayType == 'desktop' || displayType == 'tablet')
                                                  ? FTextStyle.forumTopicsSubTitleTablet
                                                  : FTextStyle.blackHeading,
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: SizedBox(
                                              width: width,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  final consultId = programdata[index]['_id']; // Get consultId from the data
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => OnlineWomenHealth(consultId: consultId),
                                                    ),
                                                  ).then((value) {
                                                    if (value != null && value[0] == true) {
                                                      BlocProvider.of<FindBloc>(context)
                                                          .add(SearchQuery(
                                                        services: widget.services.isNotEmpty ? widget.services : [], // Ensure non-null
                                                        specialisations: widget.specialisations.isNotEmpty ? widget.specialisations : [], // Ensure non-null
                                                      ));
                                                    }
                                                  });
                                                },
                                                style: (displayType == 'desktop' || displayType == 'tablet')
                                                    ? ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.appBlue,
                                                  textStyle: FTextStyle.buttonStyleTablet,
                                                  minimumSize: Size(double.infinity, 40.h),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12.0),
                                                  ),
                                                  elevation: 2,
                                                )
                                                    : ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.appBlue,
                                                  textStyle: FTextStyle.buttonStyle,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12.0),
                                                  ),
                                                  elevation: 2,
                                                ),
                                                child: Text(
                                                  'See Details',
                                                  style: (displayType == 'desktop' || displayType == 'tablet')
                                                      ? FTextStyle.ForumsButtonStylingTablet
                                                      : FTextStyle.buttonStyle,
                                                ),
                                              ),
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
                    },
                  ),
                );
              } else if (state is SearchError) {
                return Center(child: Text(state.message));
              } else {
                return Center(child: Image.asset('assets/Images/nodata.jpg'));
              }
            }),
          ],
        ),
      ),
    );
  }
}
