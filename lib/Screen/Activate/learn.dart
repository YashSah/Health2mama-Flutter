import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/Activate/activate_bloc.dart';
import 'package:health2mama/apis/Activate/activate_event.dart';
import 'package:health2mama/apis/Activate/activate_state.dart';
import 'package:html/parser.dart';
import '../../Utils/CommonFuction.dart';
import '../../Utils/flutter_font_style.dart';
import '../FluterFlow/flutter_flow_animations.dart';

class LearnActivate extends StatefulWidget {
  const LearnActivate({super.key});

  @override
  State<LearnActivate> createState() => _LearnActivateState();
}

String parseHtml(String html) {
  final document = parse(html);
  return document.body?.text ?? '';
}

class _LearnActivateState extends State<LearnActivate> {

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
    // Dispatch the event to fetch data when the widget is initialized
    BlocProvider.of<ActivateBloc>(context).add(FetchLearnHowToActivate());
  }

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;

    // Get the user stage from PrefUtils
    final userStage = PrefUtils.getUserStage();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Learn How To Activate",
          style: (displayType == 'desktop' || displayType == 'tablet')
              ? FTextStyle.appBarTitleStyleTablet
              : FTextStyle.appTitleStyle,
        ),
      ),
      body: BlocBuilder<ActivateBloc, LearnHowToActivateState>(
        builder: (context, state) {
          if (state is LearnHowToActivateLoading) {
            return Center(child: CircularProgressIndicator(color: AppColors.pink));
          } else if (state is LearnHowToActivateLoaded) {
            // Find the content matching the user’s stage
            var matchedContent = state.successResponse['result'].firstWhere(
                  (exercise) => exercise['stage'] == userStage,
              orElse: () => null,
            );

            if (matchedContent != null) {
              return ListView(
                children: [
                  Divider(
                    thickness: 1.2,
                    color: Color(0XFFF6F6F6),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28.0,vertical: 8),
                    child: Text(
                      parseHtml(matchedContent['learn']),
                      style: FTextStyle.lightText,
                    ),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                ],
              );

          } else {
              return Center(child: Image.asset('assets/Images/nodata.jpg'));
            }
          } else if (state is LearnHowToActivateError) {
            return Center(child: Text(state.failureResponse['responseMessage']));
          }
          return Center(child: Image.asset('assets/Images/somethingwentwrong.png'));
        },
      ),
    );
  }
}