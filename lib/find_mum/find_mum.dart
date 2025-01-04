// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
// import 'package:health2mama/Screen/find_mum/find_friend.dart';
// import 'package:health2mama/Screen/find_mum/chat_screen.dart';
// import 'package:health2mama/Screen/find_mum/mum_details.dart';
// import 'package:health2mama/Utils/CommonFuction.dart';
// import 'package:health2mama/Utils/constant.dart';
// import 'package:health2mama/Utils/flutter_colour_theams.dart';
// import 'package:health2mama/Utils/flutter_font_style.dart';
//
// class FindMumData extends StatefulWidget {
//   const FindMumData({super.key});
//
//   @override
//   State<FindMumData> createState() => _FindMumDataState();
// }
//
// class _FindMumDataState extends State<FindMumData> {
//   bool serviceVisible = false;
//   String servicesStage = "";
//   final animationsMap = {
//     'columnOnPageLoadAnimation1': AnimationInfo(
//       trigger: AnimationTrigger.onPageLoad,
//       effects: [
//         FadeEffect(
//           curve: Curves.easeInOut,
//           delay: 0.ms,
//           duration: 600.ms,
//           begin: 0.0,
//           end: 1.0,
//         ),
//         MoveEffect(
//           curve: Curves.easeInOut,
//           delay: 0.ms,
//           duration: 600.ms,
//           begin: Offset(0.0, 20.0),
//           end: Offset(0.0, 0.0),
//         ),
//       ],
//     ),
//     'columnOnPageLoadAnimation2': AnimationInfo(
//       trigger: AnimationTrigger.onPageLoad,
//       effects: [
//         FadeEffect(
//           curve: Curves.easeInOut,
//           delay: 200.ms,
//           duration: 600.ms,
//           begin: 0.0,
//           end: 1.0,
//         ),
//         MoveEffect(
//           curve: Curves.easeInOut,
//           delay: 200.ms,
//           duration: 600.ms,
//           begin: Offset(0.0, 20.0),
//           end: Offset(0.0, 0.0),
//         ),
//       ],
//     ),
//     'columnOnPageLoadAnimation3': AnimationInfo(
//       trigger: AnimationTrigger.onPageLoad,
//       effects: [
//         FadeEffect(
//           curve: Curves.easeInOut,
//           delay: 400.ms,
//           duration: 600.ms,
//           begin: 0.0,
//           end: 1.0,
//         ),
//         MoveEffect(
//           curve: Curves.easeInOut,
//           delay: 400.ms,
//           duration: 600.ms,
//           begin: Offset(0.0, 20.0),
//           end: Offset(0.0, 0.0),
//         ),
//       ],
//     ),
//     'imageOnPageLoadAnimation2': AnimationInfo(
//       trigger: AnimationTrigger.onPageLoad,
//       effects: [
//         MoveEffect(
//           curve: Curves.easeInOut,
//           delay: 0.ms,
//           duration: 600.ms,
//           begin: Offset(40.0, 0.0),
//           end: Offset(0.0, 0.0),
//         ),
//         FadeEffect(
//           curve: Curves.easeInOut,
//           delay: 0.ms,
//           duration: 600.ms,
//           begin: 0.0,
//           end: 1.0,
//         ),
//       ],
//     ),
//   };
//   List<Map<String, dynamic>> serviceStages = [
//   {"title": "0-2 km", "value": "0-2 km", "selected": false},
// {"title": "2-4 km ", "value": "2-4 km ", "selected": false},
// {"title": "4-6 km", "value": "4-6 km", "selected": false},
// {"title": "6-8 km", "value": "6-8 km", "selected": false},
//   ];
//   final List<Map<String, dynamic>> findMumData = [
//     {
//       'image': 'assets/Images/mom.jpg',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//       'status': 'Connected'
//     },
//     {
//       'image': 'assets/Images/mom1.png',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//       'status': 'Connect'
//     },
//     {
//       'image': 'assets/Images/mom.jpg',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//       'status': 'Connected'
//     },
//     {
//       'image': 'assets/Images/mom1.png',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//       'status': 'Connect'
//     },
//     {
//       'image': 'assets/Images/mom.jpg',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//       'status': 'Connected'
//     },
//     {
//       'image': 'assets/Images/mom.jpg',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//       'status': 'Connected'
//     },
//     {
//       'image': 'assets/Images/mom.jpg',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//       'status': 'Connect'
//     }
//   ];
//   @override
//   Widget build(BuildContext context) {
//     var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
//     var displayType = valueType.toString().split('.').last;
//     print('displayType>> $displayType');
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title:  Padding(
//             padding: EdgeInsets.only(left: 8.0),
//             child: Text(
//                 "Find a Mum",
//                 style: (displayType == 'desktop' || displayType == 'tablet')
//                     ? FTextStyle.appTitleStyleTablet
//                     : FTextStyle.appBarTitleStyle)
//         ),
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Padding(
//             padding: EdgeInsets.only(
//                 left: (displayType == 'desktop' || displayType == 'tablet')
//                     ? 15.h
//                     : 15,
//                 top: (displayType == 'desktop' || displayType == 'tablet')
//                     ? 3.h
//                     : 3),
//             child: Image.asset(
//               'assets/Images/back.png', // Replace with your image path
//               width: (displayType == 'desktop' || displayType == 'tablet')
//                   ? 35.w
//                   : 35, // Set width as needed
//               height: (displayType == 'desktop' || displayType == 'tablet')
//                   ? 35.h
//                   : 35, // Set height as needed
//             ),
//           ),
//         ),
//       ),
//       body: SafeArea(
//
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 12),
//                 child: Container(
//                   height: 1,
//                   color: AppColors.findMumBorderColor,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                         child: Column(
//                           children: [
//                             TextFormField(
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: serviceVisible
//                                         ? AppColors.boarderColour
//                                         : AppColors.boarderColour,
//                                   ),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                     color: AppColors.boarderColour, // Color when the field is focused
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                     color: AppColors.boarderColour, // Color when the field is not focused
//                                   ),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//                                 suffixIcon: const Icon(
//                                   Icons.arrow_drop_down, // or Icons.arrow_drop_up based on your condition
//                                   color: AppColors.pinkButton,
//                                   size: 30,
//                                 ),
//                                 hintText: "Select range", // Set an empty hintText initially
//                                 hintStyle: (displayType == 'desktop' ||
//                                     displayType == 'tablet')
//                                     ? FTextStyle.loginFieldHintTextStyleTablet
//                                     : FTextStyle.loginFieldHintTextStyle,
//                                 errorStyle: (displayType == 'desktop' ||
//                                     displayType == 'tablet')
//                                     ? FTextStyle.formFieldErrorTxtStyleTablet
//                                     : FTextStyle
//                                     .formFieldErrorTxtStyle, // Set hint color to grey if userPregnancyStage is empty, otherwise black
//                               ),
//                               readOnly: true, // Making it read-only to show the selected value
//                               controller: TextEditingController(text: servicesStage), // Setting initial value
//                               style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.cardSubtitleTablet : FTextStyle.cardSubtitle,
//                               maxLines: 1,
//                               onTap: () {
//                                 setState(() {
//                                   serviceVisible = !serviceVisible;
//                                 });
//                               },
//                             ),
//                             Visibility(
//                               visible: serviceVisible,
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
//                                 margin: const EdgeInsets.only(bottom: 10),
//                                 alignment: Alignment.center,
//                                 decoration: const BoxDecoration(
//                                   color: AppColors.lightGreyColor,
//                                   borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(10),
//                                     bottomRight: Radius.circular(10),
//                                   ),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: serviceStages.map((stage) {
//                                     return Column(
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             setState(() {
//                                               servicesStage =
//                                               stage['value']!;
//                                               serviceStages
//                                                   .forEach((s) {
//                                                 s['selected'] =
//                                                 (s == stage);
//                                               });
//                                             });
//                                             Future.delayed(
//                                                 const Duration(
//                                                     microseconds:
//                                                     1500), () {
//                                               setState(() {
//                                                 serviceVisible =
//                                                 !serviceVisible;
//                                               });
//                                             });
//                                             // setState(() {
//                                             //   // Toggle the 'selected' property of the tapped stage
//                                             //   stage['selected'] = !stage['selected'];
//                                             //
//                                             //   // Update the servicesStage based on selected stages
//                                             //   List<String> selectedValues = [];
//                                             //   for (var s in serviceStages) {
//                                             //     if (s['selected']) {
//                                             //       selectedValues.add(s['value']);
//                                             //     }
//                                             //   }
//                                             //   if(selectedValues.length > 2) {
//                                             //     servicesStage = '${selectedValues.take(2).join(',')} +${selectedValues.length-2}';
//                                             //   } else {
//                                             //     servicesStage = selectedValues.join(', ');
//                                             //   }
//                                             //   // Join selected values with a comma
//                                             // });
//                                           },
//                                           child: Row(
//                                             children: [
//
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     servicesStage =
//                                                     stage['value']!;
//                                                     serviceStages
//                                                         .forEach((s) {
//                                                       s['selected'] =
//                                                       (s == stage);
//                                                     });
//                                                   });
//                                                   Future.delayed(
//                                                       const Duration(
//                                                           microseconds:
//                                                           1500), () {
//                                                     setState(() {
//                                                       serviceVisible =
//                                                       !serviceVisible;
//                                                     });
//                                                   });
//                                                   // setState(() {
//                                                   //   // Toggle the 'selected' property of the tapped stage
//                                                   //   stage['selected'] = !stage['selected'];
//                                                   //
//                                                   //   // Update the servicesStage based on selected stages
//                                                   //   List<String> selectedValues = [];
//                                                   //   for (var s in serviceStages) {
//                                                   //     if (s['selected']) {
//                                                   //       selectedValues.add(s['value']);
//                                                   //     }
//                                                   //   }
//                                                   //   if(selectedValues.length > 2) {
//                                                   //     servicesStage = '${selectedValues.take(2).join(',')} +${selectedValues.length-2}';
//                                                   //   } else {
//                                                   //     servicesStage = selectedValues.join(', ');
//                                                   //   }
//                                                   //   // Join selected values with a comma
//                                                   // });
//                                                 },
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.only(right: 8.0),
//                                                   child: Container(
//                                                     width: 24, // Adjust the width as needed
//                                                     height: 24, // Adjust the height as needed
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(3), // Adjust the radius as needed
//                                                       border: Border.all(
//                                                         color: stage['selected'] == true ? AppColors.primaryColorPink : AppColors.boarderColour,
//                                                         width: 1.5, // Adjust the width as needed
//                                                       ),
//                                                       color: stage['selected'] == true ? AppColors.primaryColorPink : Colors.white,
//                                                     ),
//                                                     child: stage['selected'] == true
//                                                         ? const Icon(
//                                                       Icons.check_box,
//                                                       color: Colors.white,
//                                                       size: 24,
//
//                                                     )
//                                                         : null, // No icon when unselected
//                                                   ),
//                                                 ),
//                                               ),
//
//
//
//
//                                               Expanded(
//                                                 child: Text(
//                                                   stage['title'],
//                                                   maxLines: 3,
//                                                   style: (displayType ==
//                                                       'desktop' ||
//                                                       displayType ==
//                                                           'tablet')
//                                                       ? FTextStyle
//                                                       .rememberMeTextStyleTablet
//                                                       : FTextStyle
//                                                       .rememberMeTextStyle,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         if (stage != serviceStages.last) // Add this condition
//                                           const Padding(
//                                             padding: EdgeInsets.only(top: 15, bottom: 10),
//                                             child: Divider(
//                                               color: AppColors.darkGreyColor,
//                                               height: 0.5,
//                                             ),
//                                           ),
//                                       ],
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )).animateOnPageLoad(animationsMap[
//                     'imageOnPageLoadAnimation2']!),
//
//                     Column(
//                       children: [
//                         Container(
//                           child: TextButton(
//                             onPressed: () {
//
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => const FindFriendProfile()),
//                               );
//
//                             },
//                             child: Container(
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   border: Border.all(
//                                       color: AppColors.primaryPinkColor , width: 2)),
//                               child:  Padding(
//                                 padding: EdgeInsets.all(10),
//                                 child: Text(
//                                   'Find A Mum',
//                                   style: (displayType == 'desktop' || displayType == 'tablet')
//                                       ? FTextStyle.askInfoStyleTablet : FTextStyle.askInfoStyle,
//                                   textAlign: TextAlign.center,
//                                 ).animateOnPageLoad(animationsMap[
//                                 'imageOnPageLoadAnimation2']!),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20, top: 10),
//                     child: Text(
//                       'Connected Mum',
//                       style: (displayType == 'desktop' || displayType == 'tablet')
//                           ? FTextStyle.appTitleStyleTablet
//                           : FTextStyle.appBarTitleStyle,
//                     ),
//                   )
//                 ],
//               ).animateOnPageLoad(animationsMap[
//               'imageOnPageLoadAnimation2']!),
//               Expanded(
//                 child: (displayType == 'desktop' || displayType == 'tablet')
//                     ? GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 2,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: findMumData.length,
//                   shrinkWrap: true,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//
//                       child: Card(
//                           margin: const EdgeInsets.only(bottom: 10),
//                           elevation: 0.5,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: InkWell(
//                             onTap: (){
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                   const MumDetails(),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.5),
//                                     spreadRadius: 2,
//                                     blurRadius: 3,
//                                     offset: const Offset(0, 1.5),
//                                   ),
//                                 ],
//                               ),
//                               child: Padding(
//                                 padding:
//                                 const EdgeInsets.symmetric(horizontal: 10),
//                                 child: Column(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 10),
//                                       child: Container(
//                                         height: 55.w,
//                                         width: 55.w,
//                                         decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 color: AppColors
//                                                     .filterBackroundColor,
//                                                 width: 3),
//                                             shape: BoxShape.circle),
//                                         child: Container(
//                                           clipBehavior: Clip.antiAlias,
//                                           decoration: const BoxDecoration(
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: Image(
//                                             image: AssetImage(
//                                                 findMumData[index]['image']),
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ).animateOnPageLoad(animationsMap[
//                                         'imageOnPageLoadAnimation2']!),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(15.0),
//                                       child: Align(
//                                         alignment: Alignment.topLeft,
//                                         child: Text(
//                                           findMumData[index]['name'],
//                                           style: (displayType == 'desktop' || displayType == 'tablet')
//                                               ? FTextStyle
//                                               .tabToStart2TextStyleTablet : FTextStyle
//                                               .tabToStart2TextStyle,
//                                         ).animateOnPageLoad(animationsMap[
//                                         'imageOnPageLoadAnimation2']!),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     findMumData[index]['trying'],
//                                                     style:
//                                                     (displayType == 'desktop' || displayType == 'tablet')
//                                                         ?  FTextStyle.findMum2StyleTablet : FTextStyle.findMum2Style,
//                                                   ).animateOnPageLoad(animationsMap[
//                                                   'imageOnPageLoadAnimation2']!),
//                                                 ],
//                                               ),
//                                               Padding(
//                                                 padding: EdgeInsets.only(top: 7),
//                                                 child: Row(
//                                                   children: [
//                                                     Text(
//                                                       findMumData[index]
//                                                       ['kidsDetails'],
//                                                       style:
//                                                       (displayType == 'desktop' || displayType == 'tablet')
//                                                           ?  FTextStyle.findMum2StyleTablet : FTextStyle.findMum2Style,
//                                                     ).animateOnPageLoad(animationsMap[
//                                                     'imageOnPageLoadAnimation2']!),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                   top: 7, bottom: 10,),
//                                                 child: Row(
//                                                   children: [
//                                                     Text(
//                                                       'Status: ',
//                                                       style:
//                                                       (displayType == 'desktop' || displayType == 'tablet')
//                                                           ?  FTextStyle.findMum2StyleTablet : FTextStyle.findMum2Style,
//                                                     ).animateOnPageLoad(animationsMap[
//                                                     'imageOnPageLoadAnimation2']!),
//                                                     Text(
//                                                       findMumData[index]['status'],
//                                                       style: (findMumData[index]
//                                                       ['status']==
//                                                           'Connected')
//                                                           ? (displayType == 'desktop' || displayType == 'tablet')
//                                                           ?  FTextStyle.findMumStatusStyleTablet :FTextStyle
//                                                           .findMumStatusStyle
//                                                           : (displayType == 'desktop' || displayType == 'tablet')
//                                                           ?  FTextStyle.findMumStatusblueStyleTablet : FTextStyle
//                                                           .findMumStatusblueStyle,
//                                                     ).animateOnPageLoad(animationsMap[
//                                                     'imageOnPageLoadAnimation2']!)
//                                                   ],
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                             children: [
//                                               InkWell(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) =>
//                                                       const MumDetails(),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Image(
//                                                   image: AssetImage(
//                                                       'assets/Images/nextIcon.png'),
//                                                   height: (displayType == 'desktop' || displayType == 'tablet')
//                                                       ? 50: 42,
//                                                   width: (displayType == 'desktop' || displayType == 'tablet')
//                                                       ? 50: 42,
//                                                 ),
//                                               ),
//                                               InkWell(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           ChatScreen(
//                                                             name: findMumData[index]['name'],
//                                                             image: findMumData[index]['image'],
//                                                           ),
//                                                     ),
//                                                   );
//
//                                                 },
//                                                 child: Image(
//                                                   image: AssetImage(
//                                                       'assets/Images/chat-bubble.png'),
//                                                   height:(displayType == 'desktop' || displayType == 'tablet')
//                                                       ? 50: 34,
//                                                   width:(displayType == 'desktop' || displayType == 'tablet')
//                                                       ? 50: 38,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ).animateOnPageLoad(animationsMap[
//                                         'imageOnPageLoadAnimation2']!)
//                                       ],
//                                     ),
//
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           )),
//                     );
//                   },
//                 )
//                     : ListView.builder(
//                   itemCount: findMumData.length,
//                   itemBuilder: (context, index) {
//
//                     return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
//
//                         child: Card(
//                           margin: const EdgeInsets.only(bottom: 10),
//                           elevation: 0.5,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: InkWell(
//                             onTap: (){
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                   const MumDetails(),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.5),
//                                     spreadRadius: 2,
//                                     blurRadius: 3,
//                                     offset: const Offset(0, 1.5),
//                                   ),
//                                 ],
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child:  Column(
//                                   children: [
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.symmetric(horizontal: 10),
//                                       child: Row(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(top: 10),
//                                             child: Container(
//                                               height: 72,
//                                               width: 72,
//                                               decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       color: AppColors
//                                                           .filterBackroundColor,
//                                                       width: 3),
//                                                   shape: BoxShape.circle),
//                                               child: Container(
//                                                 clipBehavior: Clip.antiAlias,
//                                                 decoration: const BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                                 child: Image(
//                                                   image: AssetImage(
//                                                       findMumData[index]['image']),
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ).animateOnPageLoad(animationsMap[
//                                               'imageOnPageLoadAnimation2']!),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                             EdgeInsets.only(top: 10, left: 14),
//                                             child: Column(
//                                               mainAxisAlignment: MainAxisAlignment.start,
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                       findMumData[index]['name'],
//                                                       style: FTextStyle
//                                                           .tabToStart2TextStyle,
//                                                     ).animateOnPageLoad(animationsMap[
//                                                     'imageOnPageLoadAnimation2']!),
//                                                   ],
//                                                 ),
//                                                 Padding(
//                                                   padding: EdgeInsets.only(top: 12),
//                                                   child: Row(
//                                                     children: [
//                                                       Text(
//                                                         findMumData[index]['trying'],
//                                                         style:
//                                                         FTextStyle.findMum2Style,
//                                                       ).animateOnPageLoad(animationsMap[
//                                                       'imageOnPageLoadAnimation2']!),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                   padding: EdgeInsets.only(top: 7),
//                                                   child: Row(
//                                                     children: [
//                                                       Text(
//                                                         findMumData[index]
//                                                         ['kidsDetails'],
//                                                         style:
//                                                         FTextStyle.findMum2Style,
//                                                       ).animateOnPageLoad(animationsMap[
//                                                       'imageOnPageLoadAnimation2']!),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(
//                                                       top: 7, bottom: 10,),
//                                                   child: Row(
//                                                     children: [
//                                                       const Text(
//                                                         'Status: ',
//                                                         style:
//                                                         FTextStyle.findMum2Style,
//                                                       ).animateOnPageLoad(animationsMap[
//                                                       'imageOnPageLoadAnimation2']!),
//                                                       Text(
//                                                         findMumData[index]['status'],
//                                                         style: (findMumData[index]
//                                                         ['status']==
//                                                             'Connected')
//                                                             ? FTextStyle
//                                                             .findMumStatusStyle
//                                                             : FTextStyle
//                                                             .findMumStatusblueStyle,
//                                                       ).animateOnPageLoad(animationsMap[
//                                                       'imageOnPageLoadAnimation2']!)
//                                                     ],
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                               CrossAxisAlignment.end,
//                                               children: [
//                                                 Padding(
//                                                   padding: const EdgeInsets.symmetric(
//                                                       vertical: 38),
//                                                   child: InkWell(
//                                                     onTap: () {
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) =>
//                                                           const MumDetails(),
//                                                         ),
//                                                       );
//                                                     },
//                                                     child: const Image(
//                                                       image: AssetImage(
//                                                           'assets/Images/nextIcon.png'),
//                                                       height: 42,
//                                                       width: 42,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 InkWell(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) =>
//                                                          ChatScreen(
//                                                           name: findMumData[index]['name'],
//                                                           image: findMumData[index]['image'],
//                                                         ),
//                                                       ),
//                                                     );
//
//                                                   },
//                                                   child: const Image(
//                                                     image: AssetImage(
//                                                         'assets/Images/chat-bubble.png'),
//                                                     height: 34,
//                                                     width: 38,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ).animateOnPageLoad(animationsMap[
//                                           'imageOnPageLoadAnimation2']!)
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           )),
//                     );
//                   },
//                 ),
//               )
//             ],
//           )),
//     );
//   }
// }
