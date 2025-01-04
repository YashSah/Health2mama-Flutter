import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/find/gallery_screen.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:html/parser.dart' show parse;
import '../../Utils/CommonFuction.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsultDescriptions extends StatefulWidget {
  final Map<String, dynamic> consultantData;

  const ConsultDescriptions({Key? key, required this.consultantData})
      : super(key: key);

  @override
  State<ConsultDescriptions> createState() => _ConsultDescriptionsState();
}

class _ConsultDescriptionsState extends State<ConsultDescriptions> {
  String convertHtmlToText(String html) {
    final document = parse(html);
    return document.body?.text ?? '';
  }

  List<dynamic> jsonData = [];
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

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    final companyName = widget.consultantData['companyName'] ?? '';
    final companyLogo = widget.consultantData['companyLogo'] ?? '';
    final description = widget.consultantData['consultDescription'] ??
        'No description available';
    final email = widget.consultantData['email'] ?? 'No email provided';
    final phoneNumber = widget.consultantData['countryCode'] +
            ' ' +
            widget.consultantData['phone'] ??
        'No phone number provided';
    final websiteURL = widget.consultantData['websiteURL'] ?? 'No Website Url';

    final facebookURL = widget.consultantData['facebook'] ?? 'No Facebook Link';
    final instagramURL = widget.consultantData['instagram'] ?? 'No Instagram Link';
    final twitterURL = widget.consultantData['twitter'] ?? 'No Twitter Link';
    final linkedinURL = widget.consultantData['linkedin'] ?? 'No LinkedIn Link';

    final images = widget.consultantData['images'] ?? [];
    jsonData = widget.consultantData['specializations'] ??
        [];

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Align(
              alignment: FractionalOffset.centerLeft,
              child: Text(companyName,
                  style: (displayType == 'desktop' || displayType == 'tablet')
                      ? FTextStyle.appTitleStyleTablet
                      : FTextStyle.appBarTitleStyle),
            ),
          ),
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
                    ? 24.w
                    : 24, // Set width as needed
                height: (displayType == 'desktop' || displayType == 'tablet')
                    ? 24.h
                    : 24, // Set height as needed
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          primary: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: (displayType == 'desktop' || displayType == 'tablet')
                    ? EdgeInsets.symmetric(horizontal: 25.0.w)
                    : EdgeInsets.symmetric(
                        vertical: screenWidth * 0.01, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      thickness: 1.2,
                      color: Color(0XFFF6F6F6),
                    ),
                    Padding(
                      padding:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? EdgeInsets.symmetric(vertical: 30.w)
                              : EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical:
                                      8, // Adjust padding based on screen dimensions
                                ),
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFEDEDED), // Border color
                              width: 1.11, // Border width
                            ),
                          ),
                          child: Center(
                            child: Image.network(
                              companyLogo ?? '',
                              // height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: Text(
                          convertHtmlToText(description),
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.loremtextTab.copyWith(
                                  color: AppColors.loremtextcolor,
                                )
                              : FTextStyle.loremtext
                                  .copyWith(color: AppColors.loremtextcolor),
                        ),
                      ),
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                    Padding(
                      padding: EdgeInsets.only(top: 28),
                      child: Text(
                        "Website",
                        style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? FTextStyle.cardTitleTable
                            : FTextStyle.cardTitle,
                      ),
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                    GestureDetector(
                      onTap: () => _launchURL(websiteURL),
                      child: Text(
                        websiteURL,
                        style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? FTextStyle.fontsizetab
                                .copyWith(color: AppColors.textbluecolor)
                            : FTextStyle.fontsize
                                .copyWith(color: AppColors.textbluecolor),
                      ),
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),

                    Padding(
                      padding: EdgeInsets.only(top: 28),
                      child: Text(
                        "Social Media",
                        style: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? FTextStyle.cardTitleTable
                            : FTextStyle.cardTitle,
                      ),
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset("assets/Images/facebook_logo.png", width: 16,).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                            ),
                            GestureDetector(
                              onTap: () => _launchURL(facebookURL),
                              child: Text(
                                "Facebook",
                                style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                    ? FTextStyle.fontsizetab
                                    .copyWith(color: AppColors.textbluecolor)
                                    : FTextStyle.fontsize
                                    .copyWith(color: AppColors.textbluecolor),
                              ),
                            ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset("assets/Images/instagram.png", width: 16,).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                            ),
                            GestureDetector(
                              onTap: () => _launchURL(instagramURL),
                              child: Text(
                                "Instagram",
                                style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                    ? FTextStyle.fontsizetab
                                    .copyWith(color: AppColors.textbluecolor)
                                    : FTextStyle.fontsize
                                    .copyWith(color: AppColors.textbluecolor),
                              ),
                            ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset("assets/Images/twitter.png", width: 16,).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                            ),
                            GestureDetector(
                              onTap: () => _launchURL(twitterURL),
                              child: Text(
                                "Twitter",
                                style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                    ? FTextStyle.fontsizetab
                                    .copyWith(color: AppColors.textbluecolor)
                                    : FTextStyle.fontsize
                                    .copyWith(color: AppColors.textbluecolor),
                              ),
                            ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset("assets/Images/linkedin.png", width: 16,).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                            ),
                            GestureDetector(
                              onTap: () => _launchURL(linkedinURL),
                              child: Text(
                               "LinkedIn",
                                style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                    ? FTextStyle.fontsizetab
                                    .copyWith(color: AppColors.textbluecolor)
                                    : FTextStyle.fontsize
                                    .copyWith(color: AppColors.textbluecolor),
                              ),
                            ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!),
                          ],
                        ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Text(
                        "Contact",
                        style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? FTextStyle.cardTitleTable
                            : FTextStyle.cardTitle,
                      ),
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: screenWidth *
                                  0.02), // Adjust padding based on screen width
                          child: Image(
                            image: const AssetImage("assets/Images/email.png"),
                            height: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? 20.h
                                : screenHeight * 0.018,
                            width: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? 20.w
                                : screenHeight * 0.03,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _launchURL('mailto:$email'),
                          child: Text(
                            email,
                            style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? FTextStyle.fontsizetab
                                    .copyWith(color: AppColors.textbluecolor)
                                : FTextStyle.fontsize
                                    .copyWith(color: AppColors.textbluecolor),
                          ),
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                      ],
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8), // Adjust padding based on screen height
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: screenWidth *
                                    0.02), // Adjust padding based on screen width
                            child: Image(
                              image: const AssetImage(
                                  "assets/Images/phoneblue.png"),
                              height: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? 20.h
                                  : screenHeight * 0.018,
                              width: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? 20.w
                                  : screenHeight * 0.03,
                              // Adjust width based on screen height
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _launchURL('tel:$phoneNumber'),
                            child: Text(
                              phoneNumber,
                              style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? FTextStyle.fontsizetab
                                      .copyWith(color: AppColors.textbluecolor)
                                  : FTextStyle.fontsize
                                      .copyWith(color: AppColors.textbluecolor),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['imageOnPageLoadAnimation2']!),
                        ],
                      ),
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                  ],
                ),
              ),
              if (jsonData.isNotEmpty) Padding(
                padding: (displayType == 'desktop' || displayType == 'tablet')
                    ? EdgeInsets.symmetric(horizontal: 25.0.w, vertical: 20.w)
                    : EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                child: Card(
                  color: AppColors.cardBack,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28), // Adjust borderRadius based on screen width
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Specialisation",
                          style: (displayType == 'desktop' || displayType == 'tablet')
                              ? FTextStyle.loginEmailFieldHeadingStyleTablet
                              : FTextStyle.loginEmailFieldHeadingStyle,
                        ),
                        const SizedBox(height: 5), // Add spacing after the title
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            jsonData.length, // Iterate over the list of specializations
                                (index) {
                              final specialization = jsonData[index]; // The specialization object
                              // Access the 'name' property safely, since each item is a map
                              final specializationName = specialization['name']; // Extract the name

                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.02), // Adjust padding based on screen height
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.02), // Adjust padding based on screen width
                                          child: Image(
                                            image: AssetImage('assets/Images/pinkcircle.png'),
                                            height: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                                ? screenHeight * 0.025
                                                : screenHeight * 0.015, // Adjust height based on screen height
                                            width: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                                ? screenHeight * 0.03
                                                : screenHeight * 0.03, // Adjust width based on screen height
                                          ),
                                        ),
                                        Text(
                                          specializationName ?? 'Unknown', // Safely handle missing names
                                          style: (displayType == 'desktop' || displayType == 'tablet')
                                              ? FTextStyle.cardSubtitleTab
                                              : FTextStyle.cardSubtitle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (index != jsonData.length - 1) // Render divider for all items except the last one
                                    const Divider(
                                      thickness: 1.2,
                                      height: 1,
                                      color: AppColors.pinkButton,
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),


              GestureDetector(
                onTap: () {
                  // Extract images from the consultantData
                  final List<String> images = List<String>.from(widget.consultantData['images'] ?? []);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryScreen(images: images)));
                },
                child: Padding(
                  padding: (displayType == 'desktop' || displayType == 'tablet')
                      ? EdgeInsets.symmetric(horizontal: 25.0.w)
                      : EdgeInsets.symmetric(
                      vertical: screenWidth * 0.01, horizontal: 25.0.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.cardBack,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "Gallery",
                      style: (displayType == 'desktop' ||
                          displayType == 'tablet')
                          ? FTextStyle.cardTitleTable
                          : FTextStyle.cardTitle,
                    ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
