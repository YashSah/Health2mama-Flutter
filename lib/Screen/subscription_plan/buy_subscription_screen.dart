import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health2mama/APIs/auth_flow/authentication_bloc.dart';
import 'package:health2mama/APIs/auth_flow/authentication_event.dart';
import 'package:health2mama/Screen/subscription_plan/payment_screen.dart';
import 'package:health2mama/Utils/api_constant.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/static_screen/privacy_policy.dart';
import 'package:health2mama/Screen/static_screen/subscription.dart';
import 'package:health2mama/Screen/static_screen/terms_and_conditions.dart';
import 'package:health2mama/Screen/subscription_plan/redeem_offer_screen.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_button_style.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/drawer/drawer_bloc.dart';
import 'package:health2mama/apis/subscription_plan/subscription_bloc.dart';
import 'package:health2mama/services/StripePaymentService.dart';
import 'package:url_launcher/url_launcher.dart';

class BuySubscriptionScreen extends StatefulWidget {
  const BuySubscriptionScreen({super.key});

  @override
  State<BuySubscriptionScreen> createState() => _BuySubscriptionScreenState();
}

class _BuySubscriptionScreenState extends State<BuySubscriptionScreen> {
  List<dynamic> listSubscriptions = [];
  bool _isSubscriptionActive = false;
  bool isLoading = false;
  bool isLoading1 = false;
  String userId = "";
  bool isProcessing = false;
  List<dynamic> activeSubscriptions = [];
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

  final List<Map<String, dynamic>> sectionTopicdata1 = [
    {
      'image': 'assets/Images/subscription_one.png',
      'text': 'Banana Chocolate',
    },
    {
      'image': 'assets/Images/subscription_two.png',
      'text': 'Berry Avocado',
    },
    {
      'image': 'assets/Images/subscription_three.png',
      'text': 'Banana Chocolate',
    },
    {
      'image': 'assets/Images/subscription_four.png',
      'text': 'Berry Avocado',
    },
    {
      'image': 'assets/Images/subscription_one.png',
      'text': 'Banana Chocolate',
    },
    {
      'image': 'assets/Images/subscription_two.png',
      'text': 'Berry Avocado',
    },
    {
      'image': 'assets/Images/subscription_three.png',
      'text': 'Banana Chocolate',
    },
    {
      'image': 'assets/Images/subscription_four.png',
      'text': 'Berry Avocado',
    },
    {
      'image': 'assets/Images/subscription_one.png',
      'text': 'Banana Chocolate',
    },
    {
      'image': 'assets/Images/subscription_two.png',
      'text': 'Berry Avocado',
    },
  ];

  String screenFlag = 'My_SUBSCRIPTION_SCREEN';
  List<Map<String, dynamic>> _filteredProgramData = [];
  List<Map<String, dynamic>> _programData = [];

  void _updateProgramData(dynamic apiResponse) {
    if (apiResponse is List) {
      _programData =
          apiResponse.map((item) => item as Map<String, dynamic>).toList();
      _filteredProgramData = List.from(_programData);
    } else {
      print('Unexpected API response type');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<SubscriptionBloc>(context).add(ListSubscriptionsData());
      BlocProvider.of<DrawerBloc>(context).add(LoadUserProfile());
      BlocProvider.of<AuthenticationBloc>(context).add(
        SelectStageRequested(stage: PrefUtils.getUserStage()),
      );
    });
    // BlocProvider.of<SubscriptionBloc>(context).add(ListSubscriptionsData());
    // BlocProvider.of<DrawerBloc>(context).add(LoadUserProfile());
    // BlocProvider.of<AuthenticationBloc>(context).add(SelectStageRequested(stage: PrefUtils.getUserStage()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Subscription",
                  style: (displayType == 'desktop' || displayType == 'tablet')
                      ? FTextStyle.appTitleStyleTablet
                      : FTextStyle.appBarTitleStyle)),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(
                  left: (displayType == 'desktop' || displayType == 'tablet')
                      ? 15.h
                      : 15,
                  top: (displayType == 'desktop' || displayType == 'tablet')
                      ? 3.h
                      : 3),
              child: Image.asset(
                'assets/Images/back.png',
                width: (displayType == 'desktop' || displayType == 'tablet')
                    ? 35.w
                    : 35,
                height: (displayType == 'desktop' || displayType == 'tablet')
                    ? 35.h
                    : 35,
              ),
            ),
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<SubscriptionBloc, SubscriptionState>(
              listener: (context, state) {
                if (state is GetSubscriptionLoading) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state is GetSubscriptionLoaded) {
                  setState(() {
                    isLoading = false;
                    listSubscriptions = state.listSubscriptions['docs'];
                    activeSubscriptions = listSubscriptions
                        .where((subscription) =>
                            subscription['status'] == 'ACTIVE')
                        .toList();
                  });
                } else if (state is GetSubscriptionError) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            ),
            BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
              if (state is SelectStageLoading) {
                setState(() {
                  isLoading = true;
                });
              }
              if (state is SelectStageSuccess) {
                setState(() {
                  isLoading = false;
                  if (_programData.isEmpty) {
                    _updateProgramData(state.SelectStageResponse['result']);
                  }
                });
              }
            }),
            BlocListener<DrawerBloc, DrawerState>(
              listener: (context, state) {
                if (state is UserProfileLoading) {
                  setState(() {
                    isLoading1 = true;
                  });
                } else if (state is UserProfileLoaded) {
                  setState(() {
                    isLoading1 = false;
                    final userProfile = state.successResponse;
                    userId = userProfile['_id']; // Capture the user ID here
                    String activePlan = userProfile['subscriptions']['plan']
                        .trim(); // Get active plan and trim
                    final subscriptionEndDate =
                        DateTime.parse(userProfile['subscriptions']['endDate']);
                    final isSubscriptionActive =
                        DateTime.now().isBefore(subscriptionEndDate);

                    // Match the active plan with listSubscriptions
                    for (int i = 0; i < listSubscriptions.length; i++) {
                      listSubscriptions[i]['active'] =
                          listSubscriptions[i]['subscriptionName'].trim() ==
                              activePlan;
                    }
                    setState(() {
                      _isSubscriptionActive = isSubscriptionActive;
                      // You can also store other relevant data from userProfile here if needed
                    });
                  });
                } else if (state is UserProfileError) {
                  setState(() {
                    isLoading1 = false;
                  });
                }
              },
            ),
          ],
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: AppColors.pink))
              : Stack(
                  children: [
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Divider(height: 1, color: AppColors.cardBack),
                        ),
                        Expanded(
                          child: Padding(
                            padding: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 25.w)
                                : const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    color: AppColors.cardBack,
                                    height: 225.h,
                                    child: activeSubscriptions.isNotEmpty
                                        ? ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: activeSubscriptions
                                                .length, // Use the filtered list length
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  if (isProcessing) return;
                                                  setState(() {
                                                    isProcessing = true;
                                                    for (int i = 0;
                                                        i <
                                                            activeSubscriptions
                                                                .length;
                                                        i++) {
                                                      activeSubscriptions[i]
                                                              ['active'] =
                                                          (i == index);
                                                    }
                                                  });
                                                  String priceId =
                                                      activeSubscriptions[index]
                                                          ['stripePriceId'];
                                                  String plan =
                                                      activeSubscriptions[index]
                                                          ['subscriptionName'];
                                                  int amount =
                                                      activeSubscriptions[index]
                                                          ['subscriptionPrice'];

                                                  try {
                                                    Map<String, dynamic> data =
                                                        {
                                                      'userId': userId,
                                                      'priceId': priceId,
                                                      'plan': plan,
                                                    };

                                                    final response =
                                                        await http.post(
                                                      Uri.parse(
                                                          '${APIEndPoints.stripePaymentSubscription}'),
                                                      headers: {
                                                        'Content-Type':
                                                            'application/json'
                                                      },
                                                      body: jsonEncode(data),
                                                    );

                                                    // Step 3: Handle the response from the backend
                                                    if (response.statusCode ==
                                                        200) {
                                                      final responseData =
                                                          jsonDecode(
                                                              response.body);
                                                      String stripeCheckoutUrl =
                                                          responseData['url'];

                                                      if (stripeCheckoutUrl
                                                          .isNotEmpty) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    PaymentScreen(
                                                                        url:
                                                                            stripeCheckoutUrl)));
                                                      }
                                                    } else {
                                                      throw 'Failed to create Stripe session';
                                                    }
                                                  } catch (error) {
                                                    // Handle error (e.g., show a snack bar or a dialog)
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Error: $error')),
                                                    );
                                                  } finally {
                                                    setState(() {
                                                      isProcessing =
                                                          false; // Reset processing state
                                                    });
                                                  }
                                                },
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.3,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: (index ==
                                                                activeSubscriptions
                                                                        .length -
                                                                    1)
                                                            ? null
                                                            : const Border(
                                                                right: BorderSide(
                                                                    color: Color(
                                                                        0xffD9D9D9),
                                                                    width: 0.5),
                                                              ),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          CustomRadio<bool>(
                                                            value: activeSubscriptions[
                                                                        index][
                                                                    'active'] ??
                                                                false,
                                                            groupValue: true,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                for (int i = 0;
                                                                    i <
                                                                        activeSubscriptions
                                                                            .length;
                                                                    i++) {
                                                                  activeSubscriptions[
                                                                              i]
                                                                          [
                                                                          'active'] =
                                                                      (i ==
                                                                          index);
                                                                }
                                                              });
                                                            },
                                                            activeImage:
                                                                "assets/Images/selected_radio.png",
                                                            inactiveImage:
                                                                "assets/Images/unselected_radio.png",
                                                            screenFlag:
                                                                screenFlag,
                                                          ).animateOnPageLoad(
                                                              animationsMap[
                                                                  'imageOnPageLoadAnimation2']!),
                                                          SizedBox(
                                                              height:
                                                                  width * 0.04),
                                                          (activeSubscriptions[
                                                                              index]
                                                                          [
                                                                          'subscriptionDiscount'] !=
                                                                      null &&
                                                                  activeSubscriptions[
                                                                              index]
                                                                          [
                                                                          'subscriptionDiscount'] >
                                                                      0)
                                                              ? SizedBox(
                                                                  height: (displayType ==
                                                                              'desktop' ||
                                                                          displayType ==
                                                                              'tablet')
                                                                      ? 30.h
                                                                      : 26.0,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {},
                                                                    style: index ==
                                                                            1
                                                                        ? FButtonStyle
                                                                            .subPink()
                                                                        : FButtonStyle
                                                                            .sub(),
                                                                    child:
                                                                        Padding(
                                                                      padding: (displayType == 'desktop' ||
                                                                              displayType ==
                                                                                  'tablet')
                                                                          ? const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal:
                                                                                  3.0)
                                                                          : EdgeInsets
                                                                              .zero,
                                                                      child:
                                                                          Text(
                                                                        '${activeSubscriptions[index]['subscriptionDiscount']}% off',
                                                                        style: (displayType == 'desktop' ||
                                                                                displayType == 'tablet')
                                                                            ? FTextStyle.offerTitleStyleTablet
                                                                            : FTextStyle.offerTitleStyle,
                                                                      ),
                                                                    ),
                                                                  ).animateOnPageLoad(
                                                                          animationsMap[
                                                                              'imageOnPageLoadAnimation2']!),
                                                                )
                                                              : const SizedBox(
                                                                  height: 30.0),
                                                          SizedBox(
                                                              height:
                                                                  width * 0.03),
                                                          Text(
                                                            activeSubscriptions[
                                                                    index][
                                                                'subscriptionName'],
                                                            style: (displayType ==
                                                                        'desktop' ||
                                                                    displayType ==
                                                                        'tablet')
                                                                ? FTextStyle
                                                                    .susbcriptionTitleStyleTablet
                                                                : FTextStyle
                                                                    .susbcriptionTitleStyle,
                                                          ).animateOnPageLoad(
                                                              animationsMap[
                                                                  'imageOnPageLoadAnimation2']!),
                                                          SizedBox(
                                                              height:
                                                                  width * 0.03),
                                                          Text(
                                                            '\$${activeSubscriptions[index]['subscriptionPrice']}',
                                                            style: (displayType ==
                                                                        'desktop' ||
                                                                    displayType ==
                                                                        'tablet')
                                                                ? FTextStyle
                                                                    .subscriptionPriceStyleTablet
                                                                : FTextStyle
                                                                    .subscriptionPriceStyle,
                                                          ).animateOnPageLoad(
                                                              animationsMap[
                                                                  'imageOnPageLoadAnimation2']!),
                                                          const SizedBox(
                                                              height: 10),
                                                          Text(
                                                            activeSubscriptions[
                                                                    index][
                                                                'subscriptionDuration'],
                                                            style: (displayType ==
                                                                        'desktop' ||
                                                                    displayType ==
                                                                        'tablet')
                                                                ? FTextStyle
                                                                    .generalTablet
                                                                : FTextStyle
                                                                    .general,
                                                          ).animateOnPageLoad(
                                                              animationsMap[
                                                                  'imageOnPageLoadAnimation2']!),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Center(
                                            child: Text(
                                                'No Subscription Found.',
                                                style: FTextStyle.editTitle)),
                                  ),
                                ),
                                SizedBox(
                                  height: width * 0.02,
                                ),
                                SizedBox(
                                  width: width,
                                  height: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? 40.h
                                      : 45.0,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style:
                                          FButtonStyle.subscriptionBtnStyle(),
                                      child: Text(
                                        'TRY 7 DAYS FOR FREE',
                                        style: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? FTextStyle.buttonSizeTablet
                                            : FTextStyle.buttonSize,
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!)),
                                ),
                                SizedBox(
                                  height: width * 0.05,
                                ),
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? 3
                                              : 2, // Number of columns
                                      crossAxisSpacing:
                                          4, // Spacing between columns
                                      mainAxisSpacing:
                                          4, // Spacing between rows
                                      childAspectRatio:
                                          (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? 1.2
                                              : 1.1, // Adjust the aspect ratio
                                    ),
                                    itemCount: _filteredProgramData
                                        .where((item) =>
                                            item['saveAs'] ==
                                            'LOCKED') // Filter only LOCKED items
                                        .length,
                                    physics:
                                        BouncingScrollPhysics(), // Enable scrolling with bouncing effect
                                    itemBuilder: (context, index) {
                                      final item = _filteredProgramData
                                          .where((item) =>
                                              item['saveAs'] ==
                                              'LOCKED') // Filter only LOCKED items
                                          .toList()[index];
                                      final text = item['categoryName'] ?? '';
                                      final image = item['image'] ?? '';
                                      final saveAs = item['saveAs'] ?? '';
                                      final categoryId = item['_id'] ?? '';

                                      if (saveAs == 'LOCKED' &&
                                          !_isSubscriptionActive)
                                      return Opacity(
                                        opacity: (_isSubscriptionActive &&
                                                saveAs == 'LOCKED')
                                            ? 1.0
                                            : 1.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Please subscribe to unlock'),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            elevation: 2,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            child: Container(
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                        child: Image.network(
                                                          image,
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.12,
                                                          errorBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Object error,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                            return Image.asset(
                                                              'assets/Images/defaultprogram.png',
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.12,
                                                            );
                                                          },
                                                        ).animateOnPageLoad(
                                                            animationsMap[
                                                                'imageOnPageLoadAnimation2']!),
                                                      ),
                                                      if (saveAs == 'LOCKED' &&
                                                          !_isSubscriptionActive)
                                                        Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.12,
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(20),
                                                            ),
                                                            gradient:
                                                                LinearGradient(
                                                              colors: [
                                                                AppColors
                                                                    .gradientColorLock1,
                                                                AppColors
                                                                    .gradientColorLock2,
                                                              ],
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Image.asset(
                                                              'assets/Images/symbolLock.png',
                                                              height: (displayType ==
                                                                          'desktop' ||
                                                                      displayType ==
                                                                          'tablet')
                                                                  ? 10.h
                                                                  : height *
                                                                      0.08,
                                                              width: (displayType ==
                                                                          'desktop' ||
                                                                      displayType ==
                                                                          'tablet')
                                                                  ? 10.h
                                                                  : width * 0.1,
                                                            ).animateOnPageLoad(
                                                                animationsMap[
                                                                    'imageOnPageLoadAnimation2']!),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                      text,
                                                      style: (displayType ==
                                                                  'desktop' ||
                                                              displayType ==
                                                                  'tablet')
                                                          ? FTextStyle
                                                              .programsGridStyleTab
                                                          : FTextStyle
                                                              .programsGridStyle,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                      return const Center(child: Text('No Subscription Locked',style: FTextStyle.editTitle));
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Stack(
                        children: [
                          Image.asset(
                            "assets/Images/Rectangle_shadow.png",
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 15,
                            child: Padding(
                              padding: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 25.w)
                                  : const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Action to open the Terms of Use screen
                                        // Replace Navigator.push with your navigation logic
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const TermsCondition()),
                                        );
                                      },
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Terms of Use',
                                              style: (displayType ==
                                                          'desktop' ||
                                                      displayType == 'tablet')
                                                  ? FTextStyle
                                                      .PolicyTextStyleTablet
                                                  : FTextStyle.PolicyTextStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              ' & ',
                                              style: (displayType ==
                                                          'desktop' ||
                                                      displayType == 'tablet')
                                                  ? FTextStyle
                                                      .subscriptionPolicyTextStyleTablet
                                                  : FTextStyle
                                                      .subscriptionPolicyTextStyleTablet, // Style for separator
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                // Action to open the Privacy Policy screen
                                                // Replace Navigator.push with your navigation logic
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const PrivacyPolicy()),
                                                );
                                              },
                                              child: MouseRegion(
                                                cursor:
                                                    SystemMouseCursors.click,
                                                child: Text(
                                                  'Privacy Policy',
                                                  style: (displayType ==
                                                              'desktop' ||
                                                          displayType ==
                                                              'tablet')
                                                      ? FTextStyle
                                                          .PolicyTextStyleTablet
                                                      : FTextStyle
                                                          .PolicyTextStyle,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation2']!),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SubscriptionPlan()),
                                        );
                                      },
                                      child: Text(
                                        'Subscription Term',
                                        style: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? FTextStyle.PolicyTextStyleTablet
                                            : FTextStyle.PolicyTextStyle,
                                        textAlign: TextAlign.center,
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class CustomRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final String activeImage;
  final String inactiveImage;
  final String screenFlag;

  const CustomRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.activeImage,
    required this.inactiveImage,
    required this.screenFlag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (screenFlag == "SUBSCRIPTION_SCREEN")
          ? null
          : () {
              onChanged(value);
            },
      child: Image.asset(
        groupValue == value ? activeImage : inactiveImage,
        width: 24,
        height: 24,
      ),
    );
  }
}
