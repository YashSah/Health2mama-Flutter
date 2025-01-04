import 'package:flutter/cupertino.dart';

class CommonFunction {
  static DisplayType getMyDeviceType(MediaQueryData mediaQueryData) {
    var deviceWidth = mediaQueryData.size.width;
    if(deviceWidth > 950) {
      return DisplayType.desktop;
    }
    if(deviceWidth > 600) {
      return DisplayType.tablet;
    }
    return DisplayType.mobile;
  }
}

enum DisplayType {
  mobile,
  tablet,
  desktop,
}