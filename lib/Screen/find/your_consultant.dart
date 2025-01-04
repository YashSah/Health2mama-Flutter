import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/find/consult_descriptions.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/find/find_bloc.dart';
import 'package:html/parser.dart' show parse;
import '../../Utils/CommonFuction.dart';

class YourConsultant extends StatefulWidget {
  final List<String> services;
  final List<String> specialisations;
  final int maxDistance;

  const YourConsultant({
    super.key,
    required this.services,
    required this.specialisations,
    required this.maxDistance,
  });

  @override
  State<YourConsultant> createState() => _YourConsultantState();
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

class _YourConsultantState extends State<YourConsultant> {
  void initState() {
    super.initState();
    BlocProvider.of<FindBloc>(context).add(SearchQuery1(
      services:
      widget.services.isNotEmpty ? widget.services : [], // Ensure non-null
      specialisations:
      widget.specialisations.isNotEmpty ? widget.specialisations : [],
      maxDistance: widget.maxDistance,
      latitude: PrefUtils.getLatitude().toString(),
      longitude: PrefUtils.getLongitude().toString(), // Ensure non-null
    ));
  }

  String convertHtmlToText(String html) {
    final document = parse(html);
    return document.body?.text ?? '';
  }

  List<Map<String, dynamic>> programdata = [];

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Your Consultants",
                  style: (displayType == 'desktop' || displayType == 'tablet')
                      ? FTextStyle.appTitleStyleTablet
                      : FTextStyle.appBarTitleStyle)),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                (displayType == 'desktop' || displayType == 'tablet')
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
        body: Column(
          children: [
            const Divider(thickness: 1.2, color: Color(0XFFF6F6F6)),
            const SizedBox(
              height: 3,
            ),
            BlocBuilder<FindBloc, FindState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return Center(child: CircularProgressIndicator(color: AppColors.pink));
                } else if (state is SearchLoaded) {
                  programdata = state.results;
                  developer.log('Loaded data: ${state.results}');
                  return Expanded(
                    child: Padding(
                      padding:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? EdgeInsets.symmetric(horizontal: 25.w)
                          : EdgeInsets.zero,
                      child: ListView.builder(
                          itemCount: programdata.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 2),
                                child: InkWell(
                                  onTap: () {
                                    // Navigate to another screen when the item is tapped
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ConsultDescriptions(
                                                    consultantData:
                                                    programdata[index])));
                                  },
                                  child: Card(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      // Added margin for spacing
                                      elevation: 0.5,
                                      // Adjust the elevation as needed
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
                                                  1), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: (displayType ==
                                                      'desktop' ||
                                                      displayType ==
                                                          'tablet')
                                                      ? 50.w
                                                      : 65,
                                                  // Adjust the width as needed
                                                  height: (displayType ==
                                                      'desktop' ||
                                                      displayType ==
                                                          'tablet')
                                                      ? 50.w
                                                      : 65,
                                                  // Adjust the height as needed
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.blue,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      programdata[index]
                                                      ['companyLogo'] ??
                                                          '',
                                                      fit: BoxFit.cover,
                                                      height:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.16,
                                                      width:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.4,
                                                    ).animateOnPageLoad(
                                                        animationsMap[
                                                        'imageOnPageLoadAnimation2']!),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              // Add some space between the image and text
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          top: 12.0),
                                                      child: Text(
                                                        programdata[index][
                                                        'companyName'] ??
                                                            '',
                                                        style: (displayType ==
                                                            'desktop' ||
                                                            displayType ==
                                                                'tablet')
                                                            ? FTextStyle
                                                            .forumTopicsTitleTablet
                                                            : FTextStyle
                                                            .cardTitle,
                                                      ),
                                                    ).animateOnPageLoad(
                                                        animationsMap[
                                                        'imageOnPageLoadAnimation2']!),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          bottom: 12.0,
                                                          top: 4,
                                                          right: 5),
                                                      child: Text(
                                                        convertHtmlToText(
                                                            programdata[index][
                                                            'consultDescription'] ??
                                                                ''),
                                                        style: (displayType ==
                                                            'desktop' ||
                                                            displayType ==
                                                                'tablet')
                                                            ? FTextStyle
                                                            .forumTopicsSubTitleTablet
                                                            : FTextStyle
                                                            .cardSubtitle,
                                                        maxLines: 2,
                                                      ),
                                                    ).animateOnPageLoad(
                                                        animationsMap[
                                                        'imageOnPageLoadAnimation2']!),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                ));
                          }),
                    ),
                  );
                } else if (state is SearchError) {
                  String responseMessage = state.message;
                  return Center(child: Text(responseMessage));
                }
                return SizedBox();
              },
            ),
          ],
        ));
  }
}
