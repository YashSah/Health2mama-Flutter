import 'package:health2mama/Utils/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static void setLatitude(double value) {
    Prefs.prefs?.setDouble(SharedPrefsKeys.latitude, value);
  }

  static double getLatitude() {
    final double? value = Prefs.prefs?.getDouble(SharedPrefsKeys.latitude);
    return value ?? 0.0;
  }

  static void setLongitude(double value) {
    Prefs.prefs?.setDouble(SharedPrefsKeys.longitude, value);
  }

  static double getLongitude() {
    final double? value = Prefs.prefs?.getDouble(SharedPrefsKeys.longitude);
    return value ?? 0.0;
  }

  static void setUserSignupToken(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.signupToken, value);
  }

  static String getUserSignupToken() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.signupToken);
    return value ?? '';
  }

  static void setDeviceToken(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.deviceToken, value);
  }

  static String getDeviceToken() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.deviceToken);
    return value ?? '';
  }

  static void setUserLoginToken(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.loginToken, value);
  }

  static String getUserLoginToken() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.loginToken);
    return value ?? '';
  }

  static void setIsLogin(bool value) {
    Prefs.prefs?.setBool(SharedPrefsKeys.isLogin, value);
  }

  static bool getIsLogin() {
    final bool? value = Prefs.prefs?.getBool(SharedPrefsKeys.isLogin);
    return value ?? false;
  }

  static void setIsLogout(bool value) {
    Prefs.prefs?.setBool(SharedPrefsKeys.isLogout, value);
  }

  static bool getIsLogout() {
    final bool? value = Prefs.prefs?.getBool(SharedPrefsKeys.isLogout);
    return value ?? false;
  }

  static void setsyncCalendar(bool value) {
    Prefs.prefs?.setBool(SharedPrefsKeys.issyncCalendar, value);
  }

  static bool getsyncCalendar() {
    final bool? value = Prefs.prefs?.getBool(SharedPrefsKeys.issyncCalendar);
    return value ?? false;
  }

  static void setIsSocialLogin(bool value) {
    Prefs.prefs?.setBool(SharedPrefsKeys.isSocialLogin, value);
  }

  static bool getIsSocialLogin() {
    final bool? value = Prefs.prefs?.getBool(SharedPrefsKeys.isSocialLogin);
    return value ?? false;
  }

  static void setIsSearching(bool value) {
    Prefs.prefs?.setBool(SharedPrefsKeys.isSearching, value);
  }

  static bool getIsSearching() {
    final bool? value = Prefs.prefs?.getBool(SharedPrefsKeys.isSearching);
    return value ?? false;
  }

  static void setUserEmail(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.userEmail, value);
  }

  static String getUserEmail() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.userEmail);
    return value ?? '';
  }

  static void setRepsVideo(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.RepsVideo, value);
  }

  static String getRepsVideo() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.RepsVideo);
    return value ?? '';
  }

  static void setSquezzesVideo(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.SquezzesVideo, value);
  }

  static String getSquezzesVideo() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.SquezzesVideo);
    return value ?? '';
  }

  static void setEnduranceVideo(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.EnduranceVideo, value);
  }

  static String getEnduranceVideo() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.EnduranceVideo);
    return value ?? '';
  }

  static void setUserStage(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.userStage, value);
  }

  static String getUserStage() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.userStage);
    return value ?? '';
  }

  static void setCategoryId(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.categoryID, value);
  }

  static String getCategoryId() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.categoryID);
    return value ?? '';
  }

  static void setUserId(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.userId, value);
  }

  static void setUserName(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.userName, value);
  }

  static String getUserId() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.userId);
    return value ?? '';
  }

  static String getUserName() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.userName);
    return value ?? '';
  }

  static void setProgramId(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.programID, value);
  }

  static String getProgramId() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.programID);
    return value ?? '';
  }

  static void setitemId(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.itemID, value);
  }

  static String getitemId() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.itemID);
    return value ?? '';
  }

  static Future<void> setCategoryIds(List<String> categoryIds) async {
    Prefs.prefs?.setStringList('categoryIds', categoryIds);
  }

  static Future<List<String>> getCategoryIds() async {
    return Prefs.prefs?.getStringList('categoryIds') ?? [];
  }

  static void clearAll() {
    Prefs.prefs?.clear();
  }

  static void setUserPassword(String value) {
    Prefs.prefs?.setString(SharedPrefsKeys.userPassword, value);
  }

  static String getUserPassword() {
    final String? value = Prefs.prefs?.getString(SharedPrefsKeys.userPassword);
    return value ?? '';
  }

  static Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefsKeys.userEmail, email);
    await prefs.setString(SharedPrefsKeys.userPassword, password);
  }

  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPrefsKeys.userEmail);
    await prefs.remove(SharedPrefsKeys.userPassword);
  }

  static void setSqueezes(int value) {
    Prefs.prefs?.setInt(SharedPrefsKeys.squeezes, value);
  }

  static int getSqueezes() {
    final int? value = Prefs.prefs?.getInt(SharedPrefsKeys.squeezes);
    return value ?? 0;
  }

  static void setStrength(int value) {
    Prefs.prefs?.setInt(SharedPrefsKeys.strength, value);
  }

  static int getStrength() {
    final int? value = Prefs.prefs?.getInt(SharedPrefsKeys.strength);
    return value ?? 0;
  }

  static void setEndurance(int value) {
    Prefs.prefs?.setInt(SharedPrefsKeys.endurance, value);
  }

  static int getEndurance() {
    final int? value = Prefs.prefs?.getInt(SharedPrefsKeys.endurance);
    return value ?? 0;
  }

}

class SharedPrefsKeys {
  static const signupToken = 'signupToken';
  static const loginToken = 'loginToken';
  static const userEmail = 'userEmail';
  static const RepsLocalPathVideo = 'RepsLocalPathVideo';
  static const RepsVideo = 'RepsVideo';
  static const SquezzesLocalPathVideo = 'SquezzesLocalPathVideo';
  static const SquezzesVideo = 'SquezzesVideo';
  static const EnduranceLocalPathVideo = 'EnduranceLocalPathVideo';
  static const EnduranceVideo = 'EnduranceVideo';
  static const latitude = 'latitude';
  static const longitude = 'longitude';
  static const userStage = 'userStage';
  static const categoryID = 'categoryID';
  static const userId = 'userId';
  static const userName = 'userName';
  static const programID = 'programID';
  static const itemID = 'itemID';
  static const preferredCategory = 'preferredCategory';
  static const userPassword = 'userPassword';
  static const isLogin = 'isLogin';
  static const isSocialLogin = 'isSocialLogin';
  static const isSearching = 'isSearching';
  static const squeezes = 'squeezes';
  static const strength = 'strength';
  static const endurance = 'endurance';
  static const issyncCalendar = 'issyncCalendar';
  static const deviceToken = 'deviceToken';
  static const isLogout = 'isLogout';
}
