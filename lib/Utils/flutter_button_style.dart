import 'package:flutter/material.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';

import 'package:flutter/material.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';

class FButtonStyle {
  //for login btn
  static ButtonStyle loginBtnStyle() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.all(0),
      // backgroundColor: AppColors.primaryColorPink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  static ButtonStyle sub() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.all(0),
      backgroundColor: AppColors.appBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }
  static ButtonStyle subPink() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.all(0),
      backgroundColor: AppColors.primaryColorPink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }


  //for login btn
  static ButtonStyle loginWithBtnStyle() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.all(0),
      backgroundColor: AppColors.lightGreyColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
  static ButtonStyle subscriptionBtnStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(0),
      backgroundColor: AppColors.primaryColorPink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  static ButtonStyle subscriptionOfferCodeStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(0),
      backgroundColor: const Color(0xff3D94D1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  //for login btn


}
