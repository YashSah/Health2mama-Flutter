import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/program_flow/saved.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/auth_flow/authentication_bloc.dart';
import '../../apis/auth_flow/authentication_event.dart';

class SaveItem extends StatefulWidget {
  const SaveItem({super.key});

  @override
  State<SaveItem> createState() => _SaveItemState();
}

class _SaveItemState extends State<SaveItem> {
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
    BlocProvider.of<AuthenticationBloc>(context)
        .add(SelectStageRequested(stage: PrefUtils.getUserStage()));
  }

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    // Define the fixed width and height for images
    const double imageWidth = double.infinity; // Adjust as needed
    const double imageHeight = 250; // Adjust as needed

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is SelectStageLoading) {
              // return Center(child: CircularProgressIndicator());
            } else if (state is SelectStageSuccess) {
              final sectionTopicData =
                  state.SelectStageResponse['result'] as List<dynamic>;
              return Column(
                children: [
                  const Divider(thickness: 1.2, color: Color(0XFFF6F6F6)),
                  (displayType == 'desktop' || displayType == 'tablet')
                      ? Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(15.h),
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 18,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 1.9),
                              itemCount: sectionTopicData.length,
                              itemBuilder: (context, index) {
                                final item = sectionTopicData[index]
                                    as Map<String, dynamic>;
                                final imageUrl = item['image'] ?? '';
                                final text = item['categoryName'] ?? '';
                                final categoryId = item['_id'] ?? '';
                                return InkWell(
                                  onTap: () {
                                    PrefUtils.setCategoryId(categoryId);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SavedItem()));
                                  },
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: imageWidth,
                                          height: imageHeight,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              text,
                                              style: FTextStyle.saveItems,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: sectionTopicData.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = sectionTopicData[index]
                                  as Map<String, dynamic>;
                              final imageUrl = item['image'] ?? '';
                              final text = item['categoryName'] ?? '';
                              final categoryId = item['_id'] ?? '';
                              return InkWell(
                                onTap: () {
                                  PrefUtils.setCategoryId(categoryId);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SavedItem()));
                                },
                                child: Center(
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 24),
                                        child: SizedBox(
                                          width: imageWidth,
                                          height: imageHeight,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                  'assets/Images/defaultprogram.png',
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.12,
                                                );
                                              },
                                            ).animateOnPageLoad(animationsMap[
                                                'imageOnPageLoadAnimation2']!),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                                alignment: Alignment.center,
                                                child: Text(text,
                                                    style:
                                                        FTextStyle.saveItems))
                                            .animateOnPageLoad(animationsMap[
                                                'imageOnPageLoadAnimation2']!),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              );
            } else if (state is SelectStageFailure) {
              return Center(child: Text('Failed to load data'));
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
