import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart' as a;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/signin_response/signin_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/service/send_push_notification_service.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/email_template.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/internet_check.dart';
import 'package:spaid/support/locationJs.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/responsive.dart' as b;
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/signin_screen/signin_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_password_field.dart';
import 'package:spaid/widgets/custom_raised_button.dart';
import 'package:spaid/widgets/custom_simple_appbar.dart';
import 'package:spaid/widgets/custom_smart_button.dart';
import 'package:spaid/widgets/customize_text_field.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends BaseState<SigninScreen> {
  @override
  //region Private Members
  bool submitValid = false;
  bool _agree = false;
  SignInProvider? _signInProvider;
  List? userdata;
  final _formKey = GlobalKey<FormState>();
  String? countryCode;
  Location location = new Location();
  //endregion

  @override
  void initState() {
    super.initState();
    _signInProvider = Provider.of<SignInProvider>(context, listen: false);
    _signInProvider!.initialProvider();
    _signInProvider!.listener = this;
    getCountryNameAsync();
  }
   /*success(pos) {
    try {
      final coordinates =
      new Coordinates(pos.coords.latitude, pos.coords.longitude);

      print(pos.coords.latitude);
      print(pos.coords.longitude);
    } catch (ex) {
      print("Exception thrown : " + ex.toString());
    }
  }*/

  /*
Return Type:
Input Parameters:
Use: Getting the Country name.
 */

  Future<void> getCountryNameAsync() async {

    try {
      if (!kIsWeb) {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied || _permissionGranted == PermissionStatus.deniedForever) {
        _permissionGranted = await location.requestPermission();
      }


        a.Position position = await a.Geolocator()
            .getCurrentPosition(desiredAccuracy: a.LocationAccuracy.high);
        debugPrint('location: ${position.latitude}');
        final coordinates =
        new Coordinates(position.latitude, position.longitude);

        var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        /*countryCode = first.countryCode;
        SharedPrefManager.instance
            .setStringAsync(Constants.countryCode, countryCode);*/
      }
    } catch (e) {
      PermissionStatus _permissionGranted;

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied || _permissionGranted == PermissionStatus.deniedForever) {
        _permissionGranted = await location.requestPermission();
      }
     // _signInProvider.listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    } // this will return country name
  }


  @override
  void onFailure(BaseResponse error) {
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg("Please sign in with registered credentials");
  }

  @override
  void onSuccess(any, {required int reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.SIGNIN_SCREEN:
        ValidateUserResponse validSignIn = any as ValidateUserResponse;
        if (validSignIn.responseResult == Constants.success) {
          _agree == true
              ? SharedPrefManager.instance.setStringAsync(
              Constants.rememberMe, "true")
              : SharedPrefManager.instance
              .setStringAsync(Constants.rememberMe, "");
          SharedPrefManager.instance.setStringAsync(
              Constants.userEmail, _signInProvider!.emailController!.text);
          /*SharedPrefManager.instance.setStringAsync(
              Constants.userEmail, _signInProvider.emailController.text);*/
          /*DynamicLinksService().createDynamicLink("signin_screen").then((value){
            EmailService().init("Marlen",WelcomeMessage.welcomeMessage.replaceAll("{{playername}}", "Marlen").replaceAll("{{signin}}", value));
          });*/
          /*_agree == true
              ? SharedPrefManager.instance.setStringAsync(
              Constants.userIdNo, validSignIn.result.userIdNo.toString())
              : SharedPrefManager.instance
              .setStringAsync(Constants.userIdNo, null);*/

          //SharedPrefManager.instance.setStringAsync(Constants.roleId, validSignIn.user.roleIdNo.toString());
         // SharedPrefManager.instance.setStringAsync(Constants.roleId, "-10001");
          //SharedPrefManager.instance.setStringAsync(Constants.roleId, "-10002");
          SharedPrefManager.instance.setStringAsync(
              Constants.userIdNo, validSignIn.responseMessage.toString());
          // Navigation.navigateWithArgument(context, MyRoutes.otpScreen, validSignIn.user.userEmailID);//Future Purpose
          //SendPushNotificationService().sendPushNotifications();
          Navigation.navigateTo(context, MyRoutes.selectTeamScreen);
   /* Navigation.navigateWithArgument(
              context, MyRoutes.selectTeamScreen, validSignIn.result.teams);*/
          // context.vxNav.push(Uri.parse( MyRoutes.selectTeamScreen),params: validSignIn.result.teams);


          setState(() {});
        } else if (validSignIn.responseResult == Constants.responseFailed) {
          CodeSnippet.instance.showMsg(validSignIn.responseMessage!);
        } else {
          CodeSnippet.instance.showMsg(MyStrings.signInFailed);
        }
        break;
    }
    super.onSuccess(any,reqId: 0);
  }

/*
Return Type:
Input Parameters:
Use: Validate user inputs and make login server call.
 */
  void _putLogin() {

    FocusScope.of(context).requestFocus(FocusNode()) ;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Internet.checkInternet().then((value) {
        if(value){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ProgressBar.instance.showProgressbar(context);
          });
          _signInProvider!.putSigninAsync();
        }
        else{
          CodeSnippet.instance.showMsg(MyStrings.checkNetwork);
        }
      });
    }
  }
  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height * .80;
    // final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        await GoogleSignIn().signOut();
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: MyColors.white,
        appBar: getValueForScreenType<bool>(
          context: context,
          mobile: false,
          tablet: false,
          desktop: true,
        ) ? CustomSimpleAppBar(
          title: MyStrings.appName,
          iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
          iconRight: MyIcons.done,tooltipMessageRight: MyStrings.save,
          onClickRightImage: () {
            Navigator.of(context).pop();
          },
          onClickLeftImage: () {
            Navigator.of(context).pop();
          },
        ) : null,
        body: TopBar(
          child: Consumer<SignInProvider>(builder: (context, provider, _) {
            return Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    width: size.width,
                    constraints: BoxConstraints(minHeight: size.height -30),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: MarginSize.headerMarginVertical1,
                          horizontal: MarginSize.headerMarginVertical1),
                      child: Row(
                        children: <Widget>[
                          if (getValueForScreenType<bool>(
                            context: context,
                            mobile: false,
                            tablet: true,
                            desktop: true,
                          ))
                            Expanded(
                              child: Image.asset(
                                MyImages.signin,
                                height:
                                size.height * ImageSize.signInImageSize,
                              ),
                            ),
                          Expanded(
                              child: WebCard(
                                marginVertical:  20,
                                marginhorizontal: 40,
                                child: SizedBox(
                                  height: getValueForScreenType<bool>(
                                          context: context,
                                          mobile: false,
                                          tablet: false,
                                          desktop: true,) ? screenHeight : null,
                                  child: Padding(
                                    padding: EdgeInsets.all(getValueForScreenType<bool>(
                                          context: context,
                                          mobile: false,
                                          tablet: true,
                                          desktop: true,)
                                        ? PaddingSize.headerPadding1
                                        : PaddingSize.headerPadding2),
                                    // EdgeInsets.symmetric(horizontal: PaddingSize.headerCardPadding),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: getValueForScreenType<bool>(
                                            context: context,
                                            mobile: false,
                                            tablet: true,
                                            desktop: true,)
                                            ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: getValueForScreenType<bool>(
                                            context: context,
                                            mobile: false,
                                            tablet: false,
                                            desktop: true,)
                                                ? MainAxisAlignment.start
                                                : MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              //if (isMobile(context))
                                              Image.asset(MyImages.spaid_logo,width:ImageSize.logoSmall ,),
                                              SizedBox(
                                                height:
                                                SizedBoxSize.standardSizedBoxHeight,
                                                width:
                                                SizedBoxSize.standardSizedBoxWidth,
                                              ),
                                              Text(MyStrings.takeTheWork,
                                                  style: TextStyle(
                                                      fontSize:  getValueForScreenType<bool>(
                                                        context: context,
                                                        mobile: false,
                                                        tablet: false,
                                                        desktop: true,
                                                      ) ? FontSize.headerFontSize1
                                                          : FontSize.headerFontSize2,
                                                      fontWeight:
                                                      FontWeights.headerFontWeight1,
                                                      color: MyColors.kPrimaryColor)),
                                              Text(
                                                MyStrings.outOfPlay+"  "+MyStrings.onlineToday,
                                                style: TextStyle(
                                                    fontSize:  getValueForScreenType<bool>(
                                                      context: context,
                                                      mobile: false,
                                                      tablet: false,
                                                      desktop: true,
                                                    )
                                                        ? FontSize.headerFontSize1
                                                        : FontSize.headerFontSize2,
                                                    fontWeight: FontWeights
                                                        .headerFontWeight1),
                                              ),
                                              SizedBox(
                                                height:
                                                SizedBoxSize.standardSizedBoxHeight,
                                                width:
                                                SizedBoxSize.standardSizedBoxWidth,
                                              ),
                                              CustomizeTextFormField(
                                                key: ValueKey("email"),
                                                labelText: MyStrings.emailPhone+"*",
                                                prefixIcon: MyIcons.username,
                                                inputFormatter: [new LengthLimitingTextInputFormatter(100),],
                                                // hintText: MyStrings.noFormat,
                                                controller: provider.emailController,
                                                inputAction: TextInputAction.next,
                                                keyboardType: TextInputType.emailAddress,
                                                validator: ValidateInput.validateEmailMobiles,
                                                isEnabled: true,
                                                onSave: (value) {
                                                  SharedPrefManager.instance
                                                      .setStringAsync(
                                                      Constants.userId, value!);
                                                  provider.emailController!.text = value;
                                                },
                                              ),
                                              SizedBox(
                                                height:
                                                SizedBoxSize.standardSizedBoxHeight,
                                                width:
                                                SizedBoxSize.standardSizedBoxWidth,
                                              ),
                                              // CustomizeTextFormField(
                                              //   labelText: MyStrings.emailPhone+"*",
                                              //   prefixIcon: MyIcons.username,
                                              //   // hintText: MyStrings.noFormat,
                                              //   controller: provider.emailController,
                                              //   inputAction: TextInputAction.next,
                                              //   keyboardType: TextInputType.emailAddress,
                                              //   validator: ValidateInput.validateEmailMobiles,
                                              //   isEnabled: true,
                                              //   onSave: (value) {
                                              //     SharedPrefManager.instance
                                              //         .setStringAsync(
                                              //         Constants.userId, value);
                                              //     provider.emailController.text = value;
                                              //   },
                                              // ),
                                              // SizedBox(
                                              //   height:
                                              //   SizedBoxSize.standardSizedBoxHeight,
                                              //   width:
                                              //   SizedBoxSize.standardSizedBoxWidth,
                                              // ),
                                              CustomPasswordTextField(
                                                key: ValueKey("pass"),
                                                labelText: MyStrings.password+"*",
                                                prefixIcon: MyIcons.password,
                                                inputAction: TextInputAction.done,
                                                isLast: true,
                                                controller: provider.passwordController,
                                                validator: ValidateInput.requiredFieldPassword,
                                                onSave: (value) {
                                                  provider.passwordController!.text =
                                                      value!;
                                                },
                                              ),
                                              SizedBox(
                                                height:
                                                SizedBoxSize.standardSizedBoxHeight,
                                                width:
                                                SizedBoxSize.standardSizedBoxWidth,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: SizedBoxSize
                                                        .checkSizedBoxHeight,
                                                    width:
                                                    SizedBoxSize.checkSizedBoxWidth,
                                                    child: Theme(
                                                      data: ThemeData(unselectedWidgetColor: Colors.black,),
                                                      child: Checkbox(
                                                        hoverColor: MyColors.transparent,
                                                        focusColor: MyColors.transparent,

                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(2.0),
                                                          side: BorderSide(
                                                            color: Colors.grey,
                                                            width: 1.5,
                                                          ),

                                                        ),

                                                        side: BorderSide(

                                                          color: Colors.grey,
                                                          width: 1.5,
                                                        ),
                                                        checkColor: MyColors.black,
                                                        activeColor: Colors.grey[400],

                                                        value: _agree,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _agree = value!;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Text(MyStrings.keepMe),
                                                  SizedBox(width: 1),

                                                ],
                                              ),


                                              SizedBox(
                                                height: SizedBoxSize.standardSizedBoxHeight,
                                                width: SizedBoxSize.standardSizedBoxWidth,
                                              ),

                                            ],
                                          ),
                                          Container(
                                            child:  Column(
                                              children: [
                                                RaisedButtonCustom(
                                                  key:ValueKey("signin"),
                                                    buttonWidth:  getValueForScreenType<bool>(
                                                      context: context,
                                                      mobile: true,
                                                      tablet: false,
                                                      desktop: false,
                                                    ) ? null : size.width * WidgetCustomSize.raisedButtonWebWidth,
                                                    buttonColor: MyColors.kPrimaryColor,
                                                    textColor: MyColors.buttonTextColor,
                                                    splashColor: MyColors.splash_color,
                                                    buttonText: MyStrings.signIn,
                                                    onPressed: _putLogin),
                                                SizedBox(
                                                  height:
                                                  SizedBoxSize.standardSizedBoxHeight,
                                                  width:
                                                  SizedBoxSize.standardSizedBoxWidth,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {

                                                        Navigation.navigateTo(
                                                            context,
                                                            MyRoutes.forgotPasswordScreen);
                                                      },
                                                      child: Text(
                                                        MyStrings.forgotPassword,
                                                      ),
                                                    ),
                                                    SizedBox(width: 1),

                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(MyStrings.donotAccount),
                                                    /*Container(
                                                    width: 60,
                                                    child:TextButton(
                                                      onPressed: () {
                                                        Navigation.navigateTo(
                                                            context,
                                                            MyRoutes.signIn);
                                                      },
                                                      child: Text(
                                                        MyStrings.signIn,
                                                      ),
                                                    ),
                                                  ),*/
                                                    SizedBox(
                                                      width: 60,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigation.navigateWithArgument(
                                                              context, MyRoutes.signUp, Constants.navigateIdZero);
                                                        },
                                                        child: Text(
                                                          MyStrings.signUp,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
