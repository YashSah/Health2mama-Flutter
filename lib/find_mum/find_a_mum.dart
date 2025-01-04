// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
// import 'package:health2mama/Screen/find_mum/find_friend.dart';
// import 'package:health2mama/Screen/find_mum/find_mum.dart';
// import 'package:health2mama/Screen/find_mum/mum_details_screen.dart';
// import 'package:health2mama/Utils/constant.dart';
// import 'package:health2mama/Utils/flutter_colour_theams.dart';
// import 'package:health2mama/Utils/flutter_font_style.dart';
//
// class FindMum extends StatefulWidget {
//   const FindMum({super.key});
//
//   @override
//   State<FindMum> createState() => _FindMumState();
// }
//
// class _FindMumState extends State<FindMum> {
//   bool serviceVisible = false;
//   String servicesStage = "";
//   List<Map<String, dynamic>> serviceStages = [
//     {"title": "0-2 km", "value": "0-2 km", "selected": false},
//     {"title": "2-4 km ", "value": "2-4 km ", "selected": false},
//     {"title": "4-6 km", "value": "4-6 km", "selected": false},
//     {"title": "6-8 km", "value": "6-8 km", "selected": false},
//   ];
//
//   final List<Map<String, dynamic>> findMumData = [
//     {
//       'image': 'assets/Images/profileImg.png',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//     },
//     {
//       'image': 'assets/Images/profileImg.png',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//     },
//     {
//       'image': 'assets/Images/profileImg.png',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//     },
//     {
//       'image': 'assets/Images/profileImg.png',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//     },
//     {
//       'image': 'assets/Images/profileImg.png',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//     },
//     {
//       'image': 'assets/Images/profileImg.png',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//     },
//     {
//       'image': 'assets/Images/profileImg.png',
//       'name': 'Minakshi Singh',
//       'trying': 'Trying to Conceive',
//       'kidsDetails': 'Have Kids-Ages 3,4',
//     }
//   ];
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
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title:  Padding(
//             padding: EdgeInsets.only(left: 8.0),
//             child: Text(
//                "Find A Mum",
//                 style: FTextStyle.appBarTitleStyle)
//         ),
//         leading:
//
//         GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(left: 22.0),
//             child: Image.asset(
//               "assets/Images/back.png",
//               height: 14,
//               width: 14,
//             ),
//           ),
//         ),
//       ),
//       body: MediaQuery(
//         data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
//         child: Column(
//           children: [
//             Container(
//               height: 1,
//               color: AppColors.findMumBorderColor,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
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
//                                 hintStyle: TextStyle(color: servicesStage.isEmpty ? Colors.grey : Colors.black), // Set hint color to grey if userPregnancyStage is empty, otherwise black
//                               ),
//                               readOnly: true, // Making it read-only to show the selected value
//                               controller: TextEditingController(text: servicesStage), // Setting initial value
//                               style: FTextStyle.cardSubtitle,
//                               maxLines: 1,
//
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
//                                             Future.delayed(
//                                                 const Duration(
//                                                     microseconds:
//                                                     1500), () {
//                                               setState(() {
//                                                 serviceVisible =
//                                                 !serviceVisible;
//                                               });
//                                             });
//                                           },
//                                           child: Row(
//                                             children: [
//
//                                               GestureDetector(
//
//                                                       onTap: () {
//                                                         setState(() {
//                                                           servicesStage =
//                                                           stage['value']!;
//                                                           serviceStages
//                                                               .forEach((s) {
//                                                             s['selected'] =
//                                                             (s == stage);
//                                                           });
//                                                         });
//                                                         Future.delayed(
//                                                             const Duration(
//                                                                 microseconds:
//                                                                 1500), () {
//                                                           setState(() {
//                                                             serviceVisible =
//                                                             !serviceVisible;
//                                                           });
//                                                         });
//                                                       // setState(() {
//                                                       // // Toggle the 'selected' property of the tapped stage
//                                                       // stage['selected'] = !stage['selected'];
//                                                       //
//                                                       // // Update the servicesStage based on selected stages
//                                                       // List<String> selectedValues = [];
//                                                       // for (var s in serviceStages) {
//                                                       // if (s['selected']) {
//                                                       // selectedValues.add(s['value']);
//                                                       // }
//                                                       // }
//                                                       // if(selectedValues.length > 2) {
//                                                       // servicesStage = '${selectedValues.take(2).join(',')} +${selectedValues.length-2}';
//                                                       // } else {
//                                                       // servicesStage = selectedValues.join(', ');
//                                                       // }
//                                                       // // Join selected values with a comma
//                                                       // })
//                                                       // ;
//
//                                                       },
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
//                                                       size: 30,
//
//                                                     )
//                                                         : null, // No icon when unselected
//                                                   ),
//                                                 ),
//                                               ),
//
//
//                                               Expanded(
//                                                 child: Text(
//                                                   stage['title'],
//                                                   maxLines: 3,
//                                                   style: FTextStyle.rememberMeTextStyle,
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
//                         ),
//                       )).animateOnPageLoad(animationsMap[
//                   'imageOnPageLoadAnimation2']!),
//
//
//                 ],
//               ),
//             ),
//              Row(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(left: 20, top: 10),
//                   child: Text(
//                     'Connected Mum',
//                     style: FTextStyle.findMumStyle,
//                   ),
//                 ).animateOnPageLoad(animationsMap[
//                 'imageOnPageLoadAnimation2']!),
//               ],
//             ),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 child: ListView.builder(
//                   itemCount: findMumData.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
//
//                         child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => FindMumDetails()),
//                       );
//
//                     },
//                     child:Card(
//                           margin: const EdgeInsets.only(bottom: 10),
//                           elevation: 0.5,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.5),
//                                   spreadRadius: 2,
//                                   blurRadius: 3,
//                                   offset: const Offset(0, 1.5),
//                                 ),
//                               ],
//                             ),
//                             child: Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child:  Column(
//                                     children: [
//                                 Padding(
//                                 padding:
//                                 const EdgeInsets.symmetric(horizontal: 10),
//                                 child:  Column(
//                               children: [
//                                 Padding(
//                                   padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                                   child:
//
//                                   Row(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 10),
//                                         child: Container(
//                                           height: 72,
//                                           width: 72,
//                                           decoration: BoxDecoration(
//                                               shape: BoxShape.circle),
//                                           child: Container(
//                                             clipBehavior: Clip.antiAlias,
//                                             decoration: const BoxDecoration(
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: Image(
//                                               image: AssetImage(
//                                                   findMumData[index]['image']),
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ).animateOnPageLoad(animationsMap[
//                                           'imageOnPageLoadAnimation2']!),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         EdgeInsets.only(top: 10, left: 15),
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                     findMumData[index]['name'],
//                                                     style: FTextStyle.MumsTitle
//                                                 ).animateOnPageLoad(animationsMap[
//                                                 'imageOnPageLoadAnimation2']!),
//                                               ],
//                                             ),
//                                             Padding(
//                                               padding: EdgeInsets.only(top: 8),
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                       findMumData[index]['trying'],
//                                                       style:
//                                                       FTextStyle.MumsSubtitle
//                                                   ).animateOnPageLoad(animationsMap[
//                                                   'imageOnPageLoadAnimation2']!),
//                                                 ],
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding: EdgeInsets.only(top: 7),
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                       findMumData[index]
//                                                       ['kidsDetails'],
//                                                       style:
//                                                       FTextStyle.MumsSubtitle
//                                                   ).animateOnPageLoad(animationsMap[
//                                                   'imageOnPageLoadAnimation2']!),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
//                                       child: ElevatedButton(
//                                         onPressed: () {
//
//                                           // Navigator.push(
//                                           //   context,
//                                           //   MaterialPageRoute(
//                                           //     builder: (context) =>
//                                           //      FindMumData(),
//                                           //   ),
//                                           // );
//
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           minimumSize: Size(screenWidth * 0.66, screenHeight * 0.04),
//                                           backgroundColor: AppColors.pink,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(10.0),
//                                           ),
//                                         ),
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(vertical: screenHeight * 0.014),
//                                           child: Text(
//                                             "Connect",
//                                             style: FTextStyle.ForumsButtonStyling,
//                                           ),
//                                         ),
//                                       ),
//                                     ).animateOnPageLoad(animationsMap[
//                                     'imageOnPageLoadAnimation2']!),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 8.0),
//                                       child: InkWell(
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(builder: (context) => FindMumDetails()),
//                                           );
//
//                                         },
//                                         child: const Image(
//                                           image: AssetImage(
//                                               'assets/Images/IconNext.png'),
//                                           height: 45,
//                                           width: 45,
//                                         ),
//                                       ),
//                                     ).animateOnPageLoad(animationsMap[
//                                     'imageOnPageLoadAnimation2']!),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                        ] ))
//                     )
//                     )));
//                   },
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
