import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/static_screen/privacy_policy.dart';
import 'package:health2mama/Screen/static_screen/subscription.dart';
import 'package:health2mama/Screen/static_screen/terms_and_conditions.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/flutter_text_form_fields_style.dart';

class RedeemOfferScreen extends StatefulWidget {
  const RedeemOfferScreen({Key? key}) : super(key: key);

  @override
  State<RedeemOfferScreen> createState() => _RedeemOfferScreenState();
}

class _RedeemOfferScreenState extends State<RedeemOfferScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  bool isButtonEnabled = false;
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
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title:  Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Redeem Offer",
              style: FTextStyle.appBarTitleStyle,
            ),
          ),
          leading: GestureDetector(
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
        body: Column(
          children: [
            const Divider(
              thickness: 1.2,
              color: Color(0XFFF6F6F6),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0.0, 0.0),
                      color: Colors.grey,
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),

                  child: Form(
                    onChanged: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isButtonEnabled =
                          true; // Enable the button if the entire form is valid
                        });
                      } else {
                        setState(() {
                          isButtonEnabled =
                          false; // Disable the button if the entire form is invalid
                        });
                      }
                    },
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0,vertical: 10),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                "assets/Images/redeem.png",
                                fit: BoxFit.cover,
                                height: 130,
                                width: 130,
                              ).animateOnPageLoad(animationsMap[
                              'imageOnPageLoadAnimation2']!),
                            ),
                          ),
                        ),
                         Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: const Center(child: Text("Health, Fitness & Recipes",style: FTextStyle.health,),).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!),
                        ),
                         Padding(
                           padding: EdgeInsets.only(top: 18,bottom: 2,left: 18),
                          child: const Text(
                            "Enter Code",
                            style: FTextStyle.title,
                          ).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!),
                        ),
                        Padding(
                          padding:  const EdgeInsets.only(top: 6,bottom: 20,left: 18,right: 18),
                          child: TextFormField(
                            controller: _codeController,
                            cursorColor: AppColors.authScreensHeading,
                            keyboardType: TextInputType.text,
                            decoration: TextFormFieldStyle.hindCode(displayType),
                            obscureText: true,
                            obscuringCharacter: '*',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the code";
                              } else if (value.length < 4) {
                                return "Code must be at least 4 characters";
                              } else if (value.length > 15) {
                                return "Code must not exceed 15 characters";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),



                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 25),
                          child: ElevatedButton(
                            onPressed: isButtonEnabled ?() {
                              if (formKey.currentState!.validate()) {

                              }
                            }:null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.pinkButton,
                              textStyle: FTextStyle.buttonStyle,
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 2,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Redeem',
                                style: FTextStyle.buttonStyle,
                              ),
                            ),
                          ),
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Action to open the Terms of Use screen
                  // Replace Navigator.push with your navigation logic
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsCondition()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Terms of Use',
                            style: FTextStyle.PolicyTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            ' & ',
                            style: FTextStyle.subscriptionPolicyTextStyle, // Style for separator
                          ),
                          GestureDetector(
                            onTap: () {
                              // Action to open the Privacy Policy screen
                              // Replace Navigator.push with your navigation logic
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
                              );
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text(
                                'Privacy Policy',
                                style: FTextStyle.PolicyTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SubscriptionPlan()),
                              );
                            },
                            child:  Text(
                              'Subscription Term',
                              style: FTextStyle.PolicyTextStyle,
                              textAlign: TextAlign.center,
                            ).animateOnPageLoad(animationsMap[
                            'imageOnPageLoadAnimation2']!),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
                  .animateOnPageLoad(animationsMap[
              'imageOnPageLoadAnimation2']!),
            )

          ],
        ),
      ),
    );
  }
}

