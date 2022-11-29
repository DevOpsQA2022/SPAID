import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:introduction_screen/src/ui/intro_page.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/signup_response/signup_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/email_template.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/signup_screen/signup_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/calendar_cubit.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_raised_button.dart';


class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

//region Private Members
final List<String> items = [
  MyImages.introScreen_1,
  MyImages.introScreen_2,
  MyImages.introScreen_3,
];
int _current = 0;
final CarouselController _controller = CarouselController();
var _calendars;

//endregion


class _IntroScreenState extends BaseState<IntroScreen> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  SignUpProvider? _signUpProvider;
  FirebaseUser? firebaseUser;
  GoogleSignInAccount? googleSignInAccount;
  var userData;

  @override
  void initState() {
    super.initState();
    _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    _signUpProvider!.listener = this;
    if (!kIsWeb) {
      getCalendarPermission();
    }
  }

  /*
Return Type:Bool
Input Parameters:
Use: Handle BackPress Event.
 */

  void _onBackPressed() {
     showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            FancyDialog(
              gifPath: MyImages.team,
              okFun: () => {SystemNavigator.pop()},
              cancelFun: () => {Navigator.of(context).pop()},
              cancelColor: MyColors.red,
              title: MyStrings.conformExitApp,
            ));
  }


  Future<void> signup(BuildContext context) async {
    if(await FacebookAuth.instance.accessToken != null ){
      await FacebookAuth.instance.logOut();

    }
    _signUpProvider!.listener = this;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignin = await googleSignIn.signIn();
    if (googleSignin != null) {
      googleSignInAccount = googleSignin;
      ProgressBar.instance.showProgressbar(context);
      if (kIsWeb) {

        /* final ByteData imageData = await NetworkAssetBundle(
            Uri.parse(googleSignInAccount.photoUrl)).load("");
        final Uint8List bytes = imageData.buffer.asUint8List();*/
        _signUpProvider!.firstNameController!.text =
            googleSignInAccount!.displayName
                .split(" ")
                .first;
        _signUpProvider!.lastNameController!.text =
            googleSignInAccount!.displayName
                .split(" ")
                .last;
        _signUpProvider!.emailController!.text = googleSignInAccount!.email;
        // _signUpProvider.imageBytes = bytes;
        _signUpProvider!.putValidateUserAsync();

        /*if (googleSignInAccount != null) {
          String uid = await SharedPrefManager.instance.getStringAsync(
              Constants.googleID);
          String googleUserId = await SharedPrefManager.instance.getStringAsync(
              Constants.googleUserId);
          ProgressBar.instance.stopProgressBar(context);
          if (uid == googleSignInAccount.id) {
            SharedPrefManager.instance.setStringAsync(
                Constants.rememberMe, "true");
            SharedPrefManager.instance.setStringAsync(
                Constants.userEmail, googleSignInAccount.email);
            SharedPrefManager.instance.setStringAsync(
                Constants.userIdNo, googleUserId);
            SharedPrefManager.instance.setStringAsync(
                Constants.userName, googleSignInAccount.displayName);
            Navigation.navigateWithArgument(
                context, MyRoutes.selectTeamScreen, Constants.navigateIdZero);
          } else {
            Navigation.navigateWithArgument(
                context, MyRoutes.signUp, Constants.navigateIdOne);          }
        }*/
      } else {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

        // Getting users credential
        firebaseUser =
        await auth.signInWithGoogle(idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);


        final ByteData imageData = await NetworkAssetBundle(
            Uri.parse(firebaseUser!.photoUrl)).load("");
        final Uint8List bytes = imageData.buffer.asUint8List();
        _signUpProvider!.firstNameController!.text = firebaseUser!.displayName
            .split(" ")
            .first;
        _signUpProvider!.lastNameController!.text = firebaseUser!.displayName
            .split(" ")
            .last;
        _signUpProvider!.emailController!.text = firebaseUser!.email;
        _signUpProvider!.imageBytes = bytes;
        _signUpProvider!.putValidateUserAsync();

        /*if (firebaseUser != null) {
          String uid = await SharedPrefManager.instance.getStringAsync(
              Constants.googleID);
          String googleUserId = await SharedPrefManager.instance.getStringAsync(
              Constants.googleUserId);
          ProgressBar.instance.stopProgressBar(context);
          if (uid == firebaseUser.uid) {
            SharedPrefManager.instance.setStringAsync(
                Constants.rememberMe, "true");
            SharedPrefManager.instance.setStringAsync(
                Constants.userEmail, firebaseUser.email);
            SharedPrefManager.instance.setStringAsync(
                Constants.userIdNo, googleUserId);
            SharedPrefManager.instance.setStringAsync(
                Constants.userName, firebaseUser.displayName);
            Navigation.navigateWithArgument(
                context, MyRoutes.selectTeamScreen, Constants.navigateIdZero);
          } else {
            Navigation.navigateWithArgument(
                context, MyRoutes.signUp, Constants.navigateIdOne);
          }
        }*/
      }
    }
  }


  @override
  Future<void> onSuccess(any, {required int reqId}) async {
    ProgressBar.instance.stopProgressBar(context);
    super.onSuccess(any,reqId: 0);
    switch (reqId) {
      case ResponseIds.SIGNUP_SCREEN:
        SignUpResponse _response = any as SignUpResponse;
        if (_response.responseResult == Constants.success) {
          // if(_signUpProvider.RolechosenController.text=="")
          SharedPrefManager.instance.setStringAsync(
              Constants.rememberMe, "true");
          if (kIsWeb) {
            SharedPrefManager.instance.setStringAsync(
                Constants.googleID, googleSignInAccount!.id);
          } else {
            SharedPrefManager.instance.setStringAsync(
                Constants.googleID, firebaseUser!.uid);
          }
          SharedPrefManager.instance.setStringAsync(
              Constants.googleUserId, _response.result!.userIdNo.toString());
          SharedPrefManager.instance.setStringAsync(
              Constants.userEmail, _response.result!.userEmailID!);
          SharedPrefManager.instance.setStringAsync(
              Constants.userIdNo, _response.result!.userIdNo.toString());
          SharedPrefManager.instance.setStringAsync(
              Constants.userName,
              _signUpProvider!.firstNameController!.text + " " +
                  _signUpProvider!.lastNameController!.text);
          DynamicLinksService().createDynamicLink("signin_screen").then((
              value) {
            EmailService().initWelcome("Get Started with SPAID.",
                _signUpProvider!.firstNameController!.text + " " +
                    _signUpProvider!.lastNameController!.text,_signUpProvider!.firstNameController!.text + " " +
                  _signUpProvider!.lastNameController!.text,value,_response.result!.userEmailID!,Constants.welcome);
          });
          // sendMail();
          Navigation.navigateWithArgument(
              context, MyRoutes.selectTeamScreen, Constants.navigateIdZero);
        } else if (_response.responseResult == Constants.failed) {
          CodeSnippet.instance.showMsg(MyStrings.alreadyAccount);
        } else {
          CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
      case ResponseIds.SIGNUP_SCREEN_VALIDATE:
        ValidateUserResponse _response = any as ValidateUserResponse;
        if (_response.responseResult == Constants.success) {
          Navigation.navigateWithArgument(
              context, MyRoutes.signUp, Constants.navigateIdOne);
        } else if (_response.responseResult == Constants.failed) {
          String userID = _response.saveErrors![0].errorMessage!.split(":").last;
          String email = _response.saveErrors![0].messageType!.split(":").last;
          String calendar = _response.saveErrors![0].execeptionError!.split(":").last;
          SharedPrefManager.instance.setStringAsync(Constants.addToCalender,calendar.toString());

          print(userID);
          print(email);
          // _response.saveErrors[0].objectNames[0].userId;
          if(userData != null){
            ProgressBar.instance.stopProgressBar(context);
            SharedPrefManager.instance.setStringAsync(
                Constants.rememberMe, "true");
            SharedPrefManager.instance.setStringAsync(
                Constants.userEmail, email);
            SharedPrefManager.instance.setStringAsync(
                Constants.userIdNo, userID);
            SharedPrefManager.instance.setStringAsync(
                Constants.userName, userData["name"]);
            Navigation.navigateWithArgument(
                context, MyRoutes.selectTeamScreen, Constants.navigateIdZero);
          }
          else if (kIsWeb) {
            ProgressBar.instance.stopProgressBar(context);
            SharedPrefManager.instance.setStringAsync(
                Constants.rememberMe, "true");
            SharedPrefManager.instance.setStringAsync(
                Constants.userEmail, googleSignInAccount!.email);
            SharedPrefManager.instance.setStringAsync(
                Constants.userIdNo, userID);
            SharedPrefManager.instance.setStringAsync(
                Constants.userName, googleSignInAccount!.displayName);
            Navigation.navigateWithArgument(
                context, MyRoutes.selectTeamScreen, Constants.navigateIdZero);
          } else {
            ProgressBar.instance.stopProgressBar(context);
            SharedPrefManager.instance.setStringAsync(
                Constants.rememberMe, "true");
            SharedPrefManager.instance.setStringAsync(
                Constants.userEmail, firebaseUser!.email);
            SharedPrefManager.instance.setStringAsync(
                Constants.userIdNo, userID);
            SharedPrefManager.instance.setStringAsync(
                Constants.userName, firebaseUser!.displayName);
            Navigation.navigateWithArgument(
                context, MyRoutes.selectTeamScreen, Constants.navigateIdZero);
          }
          //showError(_response.saveErrors[0].errorMessage);
          // CodeSnippet.instance.showMsg(_response.saveErrors[0].errorMessage);
        } else {
          CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    List<PageViewModel> itemss = [
      PageViewModel(
        title: MyStrings.titleOne,
        decoration: PageDecoration(
            titleTextStyle: TextStyle(color: MyColors.kPrimaryColor)),
        body: MyStrings.bodyOne,
        image: Image.asset(MyImages.introScreen_1),
      ),
      PageViewModel(
        title: MyStrings.titleTwo,
        decoration: PageDecoration(
            titleTextStyle: TextStyle(color: MyColors.kPrimaryColor)),
        body: MyStrings.bodyTwo,
        image: Image.asset(MyImages.introScreen_2),
      ),
      PageViewModel(
        title: MyStrings.titleThree,
        decoration: PageDecoration(
            titleTextStyle: TextStyle(color: MyColors.kPrimaryColor)),
        body: MyStrings.bodyThree,
        image: Image.asset(MyImages.introScreen_3),
      ),
    ];

    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
        return Future.value(false);
      },
      child: TopBar(
        child: WebCard(
          height: size.height * 0.99,
          marginhorizontal: 200,
          marginVertical: 10,
          child: Scaffold(
            backgroundColor: MyColors.white,
            bottomNavigationBar: Container(
              height: 280,
              child: Column(children: [
                RaisedButtonCustom(
                  buttonColor: MyColors.kPrimaryColor,
                  splashColor: MyColors.splash_color,
                  buttonWidth: getValueForScreenType<bool>(
                    context: context,
                    mobile: true,
                    tablet: false,
                    desktop: false,
                  ) ? null : size.width * WidgetCustomSize.raisedButtonWebWidth,
                  onPressed: () =>
                  {
                    // context.vxNav.push(Uri(path: MyRoutes.signIn)),
                    // SessionTimer sessionTimer = SessionTimer(),
                    // sessionTimer.startTimer(),
                    Navigation.navigateTo(context, MyRoutes.signIn)
                  },
                  // Refer step 3
                  buttonText: MyStrings.signIn,
                ),
                SizedBox(
                  height: SizedBoxSize
                      .standardSizedBoxHeight,
                  width: SizedBoxSize
                      .standardSizedBoxWidth,
                ),
                RaisedButtonCustom(
                  buttonColor: MyColors.kPrimaryColor,
                  splashColor: MyColors.splash_color,
                  buttonWidth: getValueForScreenType<bool>(
                    context: context,
                    mobile: true,
                    tablet: false,
                    desktop: false,
                  ) ? null : size.width * WidgetCustomSize.raisedButtonWebWidth,
                  onPressed: () =>
                  {
                    /*  DynamicLinksService().createDynamicLink("signin_screen").then((value){
    print(value);
    EmailService().init("Marlen",WelcomeMessage.welcomeMessage.replaceAll("{{playername}}", "Marlen").replaceAll("{{signin}}", value));
    }),*/
                    Navigation.navigateWithArgument(
                        context, MyRoutes.signUp, Constants.navigateIdZero)
                    //Navigation.navigateTo(context, MyRoutes.signUp)
                  },
                  // Refer step 3
                  buttonText: MyStrings.signUp,
                ),
                //SizedBox(height: 10,),
                // if(!kIsWeb)
                Row(children: <Widget>[
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                        child: Divider(
                          color: Colors.black,
                          height: 30,
                        )),
                  ),
                  Text("Or"),
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                          height: 30,
                        )),
                  ),
                ]),
                //if(!kIsWeb)
                Container(

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                          color: MyColors.colorGray_666BC,
                          fontFamily: 'OswaldLight',
                          fontSize: FontSize.elevatedButtonSize,
                          fontWeight: FontWeight.bold),
                      onPrimary: MyColors.colorGray_666BC,
                      primary: MyColors.white,
                      fixedSize: Size(getValueForScreenType<bool>(
                        context: context,
                        mobile: true,
                        tablet: false,
                        desktop: false,
                      ) ? size.width / 1.1 : size.width *
                          WidgetCustomSize.raisedButtonWebWidth, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),),
                    onPressed: () {
                       signup(context);
                      //  _onAlertWithCustomContentPressed(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(MyImages.google, width: 30, height: 30,),
                          SizedBox(
                            width: 3,
                          ),
                          Text('Continue with Google'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizedBoxSize
                      .standardSizedBoxHeight,
                  width: SizedBoxSize
                      .standardSizedBoxWidth,
                ),
                Container(

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                          color: MyColors.colorGray_666BC,
                          fontFamily: 'OswaldLight',
                          fontSize: FontSize.elevatedButtonSize,
                          fontWeight: FontWeight.bold),
                      onPrimary: MyColors.colorGray_666BC,
                      primary: MyColors.white,
                      fixedSize: Size(getValueForScreenType<bool>(
                        context: context,
                        mobile: true,
                        tablet: false,
                        desktop: false,
                      ) ? size.width / 1.1 : size.width *
                          WidgetCustomSize.raisedButtonWebWidth, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),),
                    onPressed: () {
                      facebookLogOn(context);
                      // signup(context);
                      //  _onAlertWithCustomContentPressed(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(MyImages.facebook, width: 30, height: 30,),
                          SizedBox(
                            width: 3,
                          ),
                          Text('Continue with Facebook'),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),

              /* Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButtonCustom(
                    buttonColor: MyColors.kPrimaryColor,
                    splashColor: MyColors.splash_color,
                    buttonWidth: getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: true,
                                        desktop: true,)? size.width/6 :size.width * WidgetCustomSize.raisedButtonWidth,
                    onPressed: () => {
                  */ /*  DynamicLinksService().createDynamicLink("signin_screen").then((value){
                      print(value);
                      EmailService().init("Marlen",WelcomeMessage.welcomeMessage.replaceAll("{{playername}}", "Marlen").replaceAll("{{signin}}", value));
                    }),*/ /*
                      Navigation.navigateTo(context, MyRoutes.signUp)},
                    // Refer step 3
                    buttonText: MyStrings.signUp,
                  ),
                  SizedBox(width: size.width * SizedBoxSize.footerSizedBoxWidth),
                  RaisedButtonCustom(
                    buttonColor: MyColors.kPrimaryColor,
                    splashColor: MyColors.splash_color,
                    buttonWidth: getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: true,
                                        desktop: true,)? size.width/6 :size.width * WidgetCustomSize.raisedButtonWidth,
                    onPressed: () => {
                    // context.vxNav.push(Uri(path: MyRoutes.signIn)),

                      Navigation.navigateTo(context, MyRoutes.signIn)
                    },
                    // Refer step 3
                    buttonText: MyStrings.signIn,
                  ),
                ],
              ),*/
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 40,),
                  Image.asset(MyImages.spaid_logo, width: ImageSize.logoSmall,),

                  Builder(
                    builder: (context) {
                      return CarouselSlider(
                        carouselController: _controller,
                        options: CarouselOptions(
                          height: kIsWeb ? WidgetCustomSize
                              .CarouselSliderHeightWeb : Device
                              .get()
                              .isTablet ? WidgetCustomSize
                              .CarouselSliderHeightWeb : WidgetCustomSize
                              .CarouselSliderHeight,
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        items: itemss.map((p) => IntroPage(page: p, isTopSafeArea: true, isBottomSafeArea: false,)).toList(),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: itemss
                        .asMap()
                        .entries
                        .map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                                  .withOpacity(
                                  _current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                  //SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getCalendarPermission() async {
    final calendarCubit = context.read<CalendarCubit>();
    _calendars = await calendarCubit.loadCalendars();
    //calendarCubit.deleteCalendar(13);
    if (_calendars.length > 0) {
      bool isCalendarAvailable = false;
      for (int i = 0; i < _calendars.length; i++) {
        if (_calendars[i].name == "Spaid") {
          isCalendarAvailable = true;
          SharedPrefManager.instance.setStringAsync(
              Constants.calendarId, _calendars[i].id.toString());
        }
      }
      if (!isCalendarAvailable) {
        calendarCubit.createCalendar();
        _calendars = await calendarCubit.loadCalendars();
        for (int i = 0; i < _calendars.length; i++) {
          if (_calendars[i].name == "Spaid") {
            SharedPrefManager.instance.setStringAsync(
                Constants.calendarId, _calendars[i].id.toString());
          }
        }
      }
    }
  }

  Future<void> facebookLogOn(BuildContext context) async {
   // await FacebookAuth.instance.logOut();
    if(await GoogleSignIn().isSignedIn()){
      await GoogleSignIn().signOut();
    }
    final LoginResult result = await FacebookAuth.instance.login(permissions: ["email", "public_profile"]);

    if (result.status == LoginStatus.success) {
      // you are logged
      ProgressBar.instance.showProgressbar(context);
      final AccessToken accessToken = result.accessToken;
      userData = await FacebookAuth.instance.getUserData();
      print(userData["name"]);
      print(userData["email"]);
      _signUpProvider!.firstNameController!.text =
      userData["name"].split(" ")
              .first;
      _signUpProvider!.lastNameController!.text =
          userData["name"].split(" ")
              .last;
      if(userData["email"] != null){
        _signUpProvider!.emailController!.text = userData["email"];
      }else{
        _signUpProvider!.ssoLoginId!.text = userData["id"];

      }
      // _signUpProvider.imageBytes = bytes;
      _signUpProvider!.putValidateUserAsync();

    } else {
      print(result.status);
      print(result.message);
    }
   /* try {
      //await FacebookAuth.instance.logOut();
      // by default the login method has the next permissions ['email','public_profile']
      AccessToken accessToken = await FacebookAuth.instance.login();
      print(accessToken.toJson());
      final userData = await FacebookAuth.instance.getUserData();
      print(userData);
    } on FacebookAuthException catch (e) {
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          print("You have a previous login operation in progress");
          break;
        case FacebookAuthErrorCode.CANCELLED:
          print("login cancelled");
          break;
        case FacebookAuthErrorCode.FAILED:
          print("login failed");
          break;
      }
    }*/
  }
}
