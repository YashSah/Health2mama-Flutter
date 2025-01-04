import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class ChildhoodPersonalized extends StatefulWidget {
  const ChildhoodPersonalized({super.key});

  @override
  State<ChildhoodPersonalized> createState() => _ChildhoodPersonalizedState();
}

class _ChildhoodPersonalizedState extends State<ChildhoodPersonalized> {
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
final List<Map<String, dynamic>> searchResultData = [

  {
    'image': 'assets/Images/baby1.png',
    'text': 'Bloating',
  },
  {
    'image': 'assets/Images/baby2.png',
    'text': 'Tiredness',
  },
  {
    'image': 'assets/Images/baby3.png',
    'text': 'Insomnia',
  },
  {
    'image': 'assets/Images/baby4.png',
    'text': 'Sickness',
  },
  {
    'image': 'assets/Images/baby2.png',
    'text': 'Tiredness',
  },
  {
    'image': 'assets/Images/baby5.png',
    'text': 'Skin darkening',
  },
];
final List<Map<String, dynamic>> searchResult1Data = [
  {
    'image': 'assets/Images/child.png',
    'text': 'Different clearing steps.',
  },
  {
    'image': 'assets/Images/child.png',
    'text': 'Why is amniotic fluid important.',
  },
  {
    'image': 'assets/Images/child.png',
    'text': 'When should I start preparing for birth.',
  },
  {
    'image': 'assets/Images/child.png',
    'text': 'Is it save to have a sex when pregnant?',
  },
];
final List<Map<String, dynamic>> searchResult2Data = [
  {
    'text':
    '147 grams Pitted Dates 6 slices Bacon (cut in half) 30 militaries Balsamic Vinegar ',
  },
  {
    'text':
    '147 grams Pitted Dates 6 slices Bacon (cut in half) 30 militaries Balsamic Vinegar ',
  },
  {
    'text':
    '147 grams Pitted Dates 6 slices Bacon (cut in half) 30 militaries Balsamic Vinegar ',
  },
  {
    'text':
    '147 grams Pitted Dates 6 slices Bacon (cut in half) 30 militaries Balsamic Vinegar ',
  },
  {
    'text':
    '147 grams Pitted Dates 6 slices Bacon (cut in half) 30 militaries Balsamic Vinegar ',
  },
];
@override
Widget build(BuildContext context) {
  var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
  var displayType = valueType.toString().split('.').last;
  print('displayType>> $displayType');

  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      title:  Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
              "Weeks & Trimesters",
              style: FTextStyle.appBarTitleStyle)
      ),
      leading:

      GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Image.asset(
            "assets/Images/back.png",
            height: 14,
            width: 14,
          ),
        ),
      ),
    ),
    body: SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 200, // Adjust the height according to your requirement
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                border: Border.all(
                  color: AppColors.appBlue,
                  width: 1,
                ),
              ),
              child:  ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: Image(
                  image: AssetImage('assets/Images/childhoodback.png'),
                  fit: BoxFit.cover,
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!),
              ),
            ),
          ),

           Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                Text(
                  'HCG levels are high enough now to confirm a\npregnancy. whether you feel Excitement or Nerves at\nthis point it is a big thing.',
                  style: FTextStyle.recipeDescriptionSubTextStyle,
                  textAlign: TextAlign.center,
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!)
              ],
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color.fromRGBO(0, 0, 0, 1),
              height: 193,
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: YoutubePlayer.convertUrlToId(
                      "https://www.youtube.com/watch?v=su5Pjxywpik&pp=ygUodWx0cmEgc291bmQgdGhlcmFweSBmb3IgYmxvY2tlZCBub3NlIG1vbQ%3D%3D")!,
                  flags: const YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                    hideControls: false,
                    controlsVisibleAtStart: true,
                    showLiveFullscreenButton: true,




                  ),

                ),
                aspectRatio: 16 / 9,

                showVideoProgressIndicator: false,
                progressIndicatorColor: Colors.blueAccent,

              ),
            ),
          ).animateOnPageLoad(animationsMap[
          'imageOnPageLoadAnimation2']!),
           Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 21, top: 10, bottom: 10),
                child: Text(
                  'Your Baby',
                  style: FTextStyle.babySearchResult4Style,
                ),
              ).animateOnPageLoad(animationsMap[
              'imageOnPageLoadAnimation2']!),
            ],
          ),
           Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 26),
                child: Text(
                  'HCG levels are high enough now to confirm a\npregnancy. whether you feel Excitement or Nerves at\nthis point it is a big thing.',
                  style: FTextStyle.recipeDescriptionSubTextStyle,
                  textAlign: TextAlign.start,
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const Image(
                    image: AssetImage(
                      'assets/Images/babyelcipse.png',
                    ),
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                )
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 21, vertical: 3),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.searchResultGreyColor,
                      border: Border.all(
                          color: AppColors.primaryGreyColor, width: 1)),
                  child:  Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Facial Features',
                          style: FTextStyle.searchResult5Style,
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                        Image(
                          image: AssetImage(
                            'assets/Images/dropDown.png',
                          ),
                          width: displayType == "mobile" ? 10 : 15.0,
                          height: displayType == "mobile" ? 5 :12.0,

                          color: AppColors.searchResultdropDownColor,
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 21, vertical: 3),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.searchResultGreyColor,
                      border: Border.all(
                          color: AppColors.primaryGreyColor, width: 1)),
                  child:  Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Body Organs & Systems',
                          style: FTextStyle.searchResult5Style,
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                        Image(
                          image: AssetImage(
                            'assets/Images/dropDown.png',
                          ),
                          width: displayType == "mobile" ? 10 : 15.0,
                          height: displayType == "mobile" ? 5 :12.0,

                          color: AppColors.searchResultdropDownColor,
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(
                    horizontal: 21, vertical: 3),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.searchResultGreyColor,
                      border: Border.all(
                          color: AppColors.primaryGreyColor, width: 1)),
                  child:  Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Skin, Hair & Nails',
                          style: FTextStyle.searchResult5Style,
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                        Image(
                          image: AssetImage(
                            'assets/Images/dropDown.png',
                          ),
                          width: displayType == "mobile" ? 10 : 15.0,
                          height: displayType == "mobile" ? 5 :12.0,

                          color: AppColors.searchResultdropDownColor,
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 21, vertical: 3),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.searchResultGreyColor,
                      border: Border.all(
                          color: AppColors.primaryGreyColor, width: 1)),
                  child:  Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Movement & Senses',
                          style: FTextStyle.searchResult5Style,
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                        Image(
                          image: AssetImage(
                            'assets/Images/dropDown.png',
                          ),
                          width: displayType == "mobile" ? 10 : 15.0,
                          height: displayType == "mobile" ? 5 :12.0,

                          color: AppColors.searchResultdropDownColor,
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 21, top: 10, bottom: 10),
                child: Text(
                  'Your Baby',
                  style: FTextStyle.babySearchResult4Style,
                ),
              ).animateOnPageLoad(animationsMap[
              'imageOnPageLoadAnimation2']!),
            ],
          ),
           Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 26),
                child: Text(
                  'Breasts are likely to still feel sore and tender with the\ncontinued increase in Reproductive hormones.',
                  style: FTextStyle.recipeDescriptionSubTextStyle,
                  textAlign: TextAlign.start,
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  child:  Image(
                    image: AssetImage(
                      'assets/Images/babyrac.png',
                    ),
                    height: 259,
                    width: 259,
                    fit: BoxFit.cover,
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                )
              ],
            ),
          ),
           Padding(
            padding: EdgeInsets.only(top: 10, left: 21, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Possible Symptoms',
                  style: FTextStyle.searchResult2Style,
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!)
              ],
            ),
          ),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 0.99,
            ),
            itemCount: 6,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                child: Column(
                  children: [
                    Card(
                      child: Image(
                        image:
                        AssetImage(searchResultData[index]['image']),
                        height: 100,
                        width: 100,
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(
                        searchResultData[index]['text'],
                        style: FTextStyle.searchResult6Style,
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),
                    )
                  ],
                ),
              );
            },
          ),
           Padding(
            padding: EdgeInsets.only(top: 20, left: 21, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '5 Top Tips',
                  style: FTextStyle.searchResult2Style,
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!)
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Images/backsky.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchResult2Data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            '${index + 1}. ${searchResult2Data[index]['text']}',
                            style: FTextStyle.babySearchResult7Style
                          ),
                        )
                      ],
                    ),
                  );
                },
              ).animateOnPageLoad(animationsMap[
              'imageOnPageLoadAnimation2']!),
            ),
          ),
        ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 21),
          //   child: Container(
          //     color: AppColors.appBlurColor1,
          //     padding: const EdgeInsets.symmetric(horizontal: 21),
          //     child:
          //     Padding(
          //       padding: const EdgeInsets.only(top: 10),
          //       child: ListView.builder(
          //         physics: const NeverScrollableScrollPhysics(),
          //         shrinkWrap: true,
          //         itemCount: searchResult2Data.length,
          //         itemBuilder: (context, index) {
          //           return Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Flexible(
          //                   child: Text(
          //                     '${index + 1}. ${searchResult2Data[index]['text']}',
          //                     style: FTextStyle.babySearchResult7Style,
          //                   ),
          //                 )
          //               ],
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ),
          // ),
           Padding(
            padding: EdgeInsets.only(top: 10, left: 21, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'FAQ’s',
                  style: FTextStyle.searchResult2Style,
                )
              ],
            ).animateOnPageLoad(animationsMap[
            'imageOnPageLoadAnimation2']!),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 5),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: searchResult1Data.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.baby),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4)),
                            child: Image(
                              image: AssetImage(
                                  searchResult1Data[index]['image']),
                              width: 46,
                              height: 36,
                            ).animateOnPageLoad(animationsMap[
                            'imageOnPageLoadAnimation2']!),
                          ),
                        ),
                        Text(
                          searchResult1Data[index]['text'],
                          style: FTextStyle.recipeDescriptionSubTextStyle,
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF3D94D1)),
                  shape:
                  MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Next Topic  >',
                  style: FTextStyle.tabToStartButton,
                ),
              ),
            ),
          ).animateOnPageLoad(animationsMap[
          'imageOnPageLoadAnimation2']!),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Back to Section',
                style: FTextStyle.recipeDescriptionSubTextStyle,
                textAlign: TextAlign.start,
              ).animateOnPageLoad(animationsMap[
              'imageOnPageLoadAnimation2']!)
            ],
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF3D94D1)),
                  shape:
                  MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                child: const Text(
                  '<  Previous Topic',
                  style: FTextStyle.tabToStartButton,
                ),
              ),
            ),
          ).animateOnPageLoad(animationsMap[
          'imageOnPageLoadAnimation2']!),
        ],
      ),
    ),
  );
}
}
