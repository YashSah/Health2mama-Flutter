import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';

class CommonPopups {
  static void showCustomPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(
          message: message,
          onOkPressed: () {
            Navigator.pop(context); // Close the popup when OK is pressed.
          },
        );
      },
    );
  }

  static void cancelShowCustomPopup(BuildContext context, String message ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(
          message: message,
          onOkPressed: () {
            Navigator.pop(context); // Close the popup when OK is pressed.
          },
        );
      },
    );
  }

  static void showSnackBar(context, textMsg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(textMsg)));
  }
}

class CustomPopup extends StatelessWidget {
  final String message;
  final VoidCallback onOkPressed;

  const CustomPopup(
      {super.key, required this.message, required this.onOkPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: FTextStyle.lightText,
          ),
          const SizedBox(height: 16), // Add extra SizedBox for spacing
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: onOkPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                textStyle: FTextStyle.buttonStyleHealth,
                // Adjusted button height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
                elevation: 1,
                shadowColor: AppColors.boarderLight,
                side: const BorderSide(color: Colors.white),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                    fontFamily: 'Outfit-Regular',
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ImagePopupWithButton extends StatelessWidget {
  final String message;
  final VoidCallback onOkPressed;

  ImagePopupWithButton({required this.message, required this.onOkPressed});


  final animationsMap = {
    'imageOnPageLoadAnimation': AnimationInfo(
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
    'textOnPageLoadAnimation': AnimationInfo(
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
  };

  @override
  Widget build(BuildContext context) {

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    final Size screenSize = MediaQuery.of(context).size;

    final double dialogWidth = screenSize.width * 0.8;
    final double imageWidth = screenSize.width * 0.3;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0.1 * screenSize.width),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.white,
      child: Container(
        width: dialogWidth,
        padding: EdgeInsets.symmetric(horizontal: 0.05 * screenSize.width),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Image.asset(
              'assets/Images/Frame.png',
              width: imageWidth,
              height: imageWidth * (85 / 107), // Maintain aspect ratio
            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation']!),
            SizedBox(height: 15),
            Text(
              message,
              style: TextStyle(
                fontSize: 0.045 * screenSize.width, // Responsive font size
                fontFamily: 'Poppins-Regular',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation']!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onOkPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(dialogWidth, 40.0), // Adjust these values as needed
                backgroundColor: const Color(0xFFF58CA9), // Pink background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0.r),
                ),
                elevation: 1,
              ),
              child: Padding(
                padding: (displayType == 'desktop' || displayType == 'tablet') ? EdgeInsets.symmetric(vertical: 25.0) : EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white, // White text
                    fontSize: (displayType == 'desktop' || displayType == 'tablet') ? 25 : 15, // Adjust based on your design
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins-Regular',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
