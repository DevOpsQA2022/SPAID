import 'package:devicelocale/devicelocale.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart' as a;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:smart_select/smart_select.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/roaster_listview_response/user_roles_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/home_screen/roasters_listview/roasters_listview_screen_provider.dart';
import 'package:spaid/ui/signup_screen/signup_screen_provider.dart';
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
import 'package:spaid/widgets/customize_text_field.dart';

class SignupScreen extends StatefulWidget {
  int fromId;
  SignupScreen(this.fromId);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends BaseState<SignupScreen> {
  @override
  //region Private Members

  SignUpProvider? _signUpProvider;
  String? countryCode;
  String? _rolechosenValue,_rolechosenName;
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  FocusNode _node = new FocusNode();
  FocusNode _passwordnode=new FocusNode();
  Location location = new Location();
  RoasterListViewProvider? _roasterListViewProvider;
List<Result>? _userRolesResponse;
  //endregion

  @override
  void initState() {
    super.initState();
    _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    _roasterListViewProvider = Provider.of<RoasterListViewProvider>(context, listen: false);
    _roasterListViewProvider!.listener = this;
    if(widget.fromId==Constants.navigateIdZero){
      _signUpProvider!.initialProvider();
    }
    //countryCode=_signUpProvider.getCountryCodeAsync().toString();
    //_signUpProvider.getCountryCodeAsync();
    _roasterListViewProvider!.getRolesAsync();
    getEventsList();
    getCountryNameAsync();
    //getCountryCodeAsync();
  }

  /*
Return Type:
Input Parameters:
Use: Getting the Country Code.
 */

  Future<void> getCountryCodeAsync() async {
    try {
      Locale? l = await Devicelocale.currentAsLocale;
      if (l != null) {
        setState(() {
          countryCode = l.countryCode;
        });
        SharedPrefManager.instance
            .setStringAsync(Constants.countryCode, countryCode!);
        print(
            "CurrentAsLocale result: Language Code: ${l.languageCode} , Country Code:" +
                countryCode!);
      } else {
        print('Unable to determine currentAsLocale');
      }
    } catch (e) {
      _signUpProvider!.listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    } //
  }

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
        print(first.countryCode);
       /* countryCode = first.countryCode;
        _signUpProvider.countryCode = first.countryCode;
        SharedPrefManager.instance
            .setStringAsync(Constants.countryCode, countryCode);*/
        // return first.countryCode!;
      }
    } catch (e) {
      PermissionStatus _permissionGranted;
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied || _permissionGranted == PermissionStatus.deniedForever) {
        _permissionGranted = await location.requestPermission();
      }
      //_signUpProvider.listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    } // this will return country name
  }

  /*
Return Type:
Input Parameters:
Use: Validate user inputs and make signup server call.
 */
  void _putSignUp() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ProgressBar.instance.showProgressbar(context);
    // });
      _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
      _signUpProvider!.listener=this;
      _signUpProvider!.putValidateUserAsync();

    }
  }


  @override
  void onFailure(BaseResponse error) {
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }

  @override
  void onSuccess(any, {required int reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    super.onSuccess(any,reqId: 0);
    switch (reqId) {
      case ResponseIds.GET_USER_ROLES:
        UserRolesResponse _response = any as UserRolesResponse;
        if (_response.responseResult == Constants.success) {

         /* setState(() {

            _userRolesResponse=_response;
          });*/
        } else if (_response.responseResult == Constants.failed) {
          // CodeSnippet.instance.showMsg(MyStrings.verifySignIn);
        } else {
          //CodeSnippet.instance.showMsg(MyStrings.signInFailed);
        }
        break;
      case ResponseIds.SIGNUP_SCREEN_VALIDATE:
        ValidateUserResponse _response = any as ValidateUserResponse;
        if (_response.responseResult == Constants.success) {
          _signUpProvider!.RolechosenController!.text ==
              "-10002"
          ? Navigation.navigateWithArgument(context, MyRoutes.inviteCoachScreen, Constants.navigateIdZero)
          : Navigation.navigateTo(context, MyRoutes.signUpNext);

        } else if (_response.responseResult == Constants.failed) {
          // showError("This email address is already being used.");
         CodeSnippet.instance.showMsg(_response.responseMessage!);
        } else {
          CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
    }
  }


  /*
Return Type:
Input Parameters:
Use: Getting the Event List.
 */

  getEventsList() {
    //Future Purpose
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressBar.instance.showProgressbar(context);
    });*/
    _signUpProvider!.listener = this;
  }

  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height * .80;
    // final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
        onClickLeftImage: () {
          Navigator.of(context).pop();
        },
      ) : null,
      body: TopBar(
        child: Consumer<SignUpProvider>(builder: (context, provider, _) {
          return Form(
            key: _formKey,
            //             //Future Purpose
            //             // autovalidateMode: !provider.getAutoValidate
            //             //     ? AutovalidateMode.disabled
            //             //     : AutovalidateMode.always,
            //             autovalidate: !provider.getAutoValidate ? false : true,
            child: SafeArea(
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
                            height: size.height * ImageSize.signInImageSize,
                          ),
                        ),
                      Expanded(
                        child: WebCard(
                          marginVertical: 20,
                          marginhorizontal: 40,
                          child: SizedBox(
                            height: getValueForScreenType<bool>(
                              context: context,
                              mobile: false,
                              tablet: false,
                              desktop: true,
                            )
                                ? screenHeight
                                : null,
                            child: Padding(
                              padding:
                                  EdgeInsets.all(getValueForScreenType<bool>(
                                context: context,
                                mobile: false,
                                tablet: true,
                                desktop: true,
                              )
                                      ? PaddingSize.headerPadding1
                                      : PaddingSize.headerPadding2),
                              // EdgeInsets.symmetric(horizontal: PaddingSize.headerCardPadding),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment:
                                      getValueForScreenType<bool>(
                                    context: context,
                                    mobile: false,
                                    tablet: true,
                                    desktop: true,
                                  )
                                          ? MainAxisAlignment.spaceBetween
                                          : MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: false,
                                        desktop: true,
                                      )
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        /* if(getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: false,
                                        desktop: true,))
                                        CustomAppBar(
                                          title: MyStrings.appName,
                                          iconLeft: MyIcons.hockey,
                                        ),*/
                                        // if (isMobile(context))

                                        //Future Purpose

                                        //   SvgPicture.asset(
                                        //     MyImages.login,
                                        //     height: size.height * 0.3,
                                        //   ),
                                        // SizedBox(height: 20),
                                        Image.asset(MyImages.spaid_logo,width:ImageSize.logoSmall ,),
                                        SizedBox(
                                          height:
                                          SizedBoxSize.standardSizedBoxHeight,
                                          width:
                                          SizedBoxSize.standardSizedBoxWidth,
                                        ),
                                        Text(MyStrings.takeTheWork,
                                            style: TextStyle(
                                                fontSize: getValueForScreenType<
                                                        bool>(
                                                  context: context,
                                                  mobile: false,
                                                  tablet: false,
                                                  desktop: true,
                                                )
                                                    ? FontSize.headerFontSize1
                                                    : FontSize.headerFontSize2,
                                                fontWeight: FontWeights
                                                    .headerFontWeight1,
                                                color: MyColors.kPrimaryColor)),
                                        Text(
                                          MyStrings.outOfPlay +
                                              "  " +
                                              MyStrings.onlineToday,
                                          style: TextStyle(
                                              fontSize:
                                                  getValueForScreenType<bool>(
                                                context: context,
                                                mobile: false,
                                                tablet: false,
                                                desktop: true,
                                              )
                                                      ? FontSize.headerFontSize1
                                                      : FontSize
                                                          .headerFontSize2,
                                              fontWeight: FontWeights
                                                  .headerFontWeight1),
                                        ),

                                        /* SizedBox(height: SizedBoxSize.headerSizedBoxHeight),
                    Text(
                      MyStrings.sportsOrFun,
                      textAlign: isMobile(context)
                                      ? TextAlign.center
                                      : TextAlign.start,
                      style: TextStyle(
                                      fontSize: getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: false,
                                        desktop: true,)
                                          ? FontSize.headerFontSize3
                                          : FontSize.headerFontSize4,
                                      fontWeight: FontWeights.headerFontWeight2),
                    ),*/
                                        SizedBox(
                                          height: SizedBoxSize
                                              .standardSizedBoxHeight,
                                          width: SizedBoxSize
                                              .standardSizedBoxWidth,
                                        ),
                                        CustomizeTextFormField(
                                          labelText: MyStrings.email+"*",
                                          prefixIcon: MyIcons.mail,
                                          inputFormatter: [new LengthLimitingTextInputFormatter(100),],
                                          controller: provider.emailController,
                                          validator:
                                              ValidateInput.validateEmail,
                                          inputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          isEnabled: true,
                                          onSave: (value) {
                                            SharedPrefManager.instance
                                                .setStringAsync(
                                                    Constants.userId, value!);
                                            provider.emailController!.text =
                                                value;
                                          },
                                        ),
                                        SizedBox(
                                          height: SizedBoxSize
                                              .standardSizedBoxHeight,
                                          width: SizedBoxSize
                                              .standardSizedBoxWidth,
                                        ),
                                        CustomPasswordTextField(
                                          labelText: MyStrings.createPassword+"*",
                                          prefixIcon: MyIcons.password,
                                          controller:
                                              provider.passwordController,
                                          inputAction: TextInputAction.next,
                                          onFieldSubmit: (v){
                                            FocusScope.of(context).requestFocus(_passwordnode);
                                          },
                                          validator:
                                              ValidateInput.validatePassword,
                                          onSave: (value) {
                                            SharedPrefManager.instance
                                                .setStringAsync(
                                                    Constants.passId, value!);
                                            provider.passwordController!.text =
                                                value;
                                          },
                                        ),
                                        SizedBox(
                                          height: SizedBoxSize
                                              .standardSizedBoxHeight,
                                          width: SizedBoxSize
                                              .standardSizedBoxWidth,
                                        ),
                                        CustomPasswordTextField(
                                          labelText:
                                          MyStrings.confirmPassword+"*",
                                          prefixIcon: MyIcons.password,
                                          isLast: true,
                                          inputAction: TextInputAction.done,
                                          controller: provider.confirmPasswordController,
                                          focusNode: _passwordnode,
                                          validator: (value) {
                                            return ValidateInput.verifyFields(
                                                value,
                                                provider.passwordController!.text);
                                          },
                                          onSave: (value) {
                                            provider.confirmPasswordController!.text = value!;
                                          },
                                        ),
                                        SizedBox(
                                          height: SizedBoxSize
                                              .standardSizedBoxHeight,
                                          width: SizedBoxSize
                                              .standardSizedBoxWidth,
                                        ),
                                        /*Container(
                                          alignment: Alignment.center,
                                          child: Focus(
                                            focusNode: _node,
                                            onFocusChange: (bool focus) {
                                              setState(() {});
                                            },
                                            child: Listener(
                                              onPointerDown: (_) {
                                                FocusScope.of(context)
                                                    .requestFocus(_node);
                                              },
                                              child: DropdownBelow(
                                                boxDecoration: BoxDecoration(
                                                    // color: MyColors.boxDecoration,
                                                    border: Border.all(
                                                        color: MyColors
                                                            .colorGray_818181)),
                                                itemWidth: getValueForScreenType<
                                                        bool>(
                                                  context: context,
                                                  mobile: true,
                                                  tablet: false,
                                                  desktop: false,
                                                )
                                                    ? size.width *
                                                        WidgetCustomSize
                                                            .dropdownItemWidth
                                                    : getValueForScreenType<
                                                            bool>(
                                                        context: context,
                                                        mobile: false,
                                                        tablet: true,
                                                        desktop: false,
                                                      )
                                                        ? size.width * 0.4
                                                        : size.width * 0.40,
                                                icon: MyIcons.arrowdownIos,
                                                itemTextstyle: TextStyle(
                                                    height: WidgetCustomSize
                                                        .dropdownItemHeight,
                                                    color: MyColors.textColor),
                                                boxTextstyle: TextStyle(
                                                    decorationColor:
                                                        MyColors.boxDecoration,
                                                    backgroundColor:
                                                        MyColors.boxDecoration,
                                                    color: MyColors.textColor),
                                                boxPadding: EdgeInsets.fromLTRB(
                                                    PaddingSize.boxPaddingLeft,
                                                    PaddingSize.boxPaddingTop,
                                                    PaddingSize.boxPaddingRight,
                                                    PaddingSize
                                                        .boxPaddingBottom),
                                                boxWidth: size.width *
                                                    WidgetCustomSize
                                                        .dropdownBoxWidth,
                                                boxHeight: WidgetCustomSize
                                                    .dropdownBoxHeight,
                                                hint: Text(MyStrings.chooseRole+"*",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2),
                                                value: int.tryParse(
                                                    _rolechosenValue ?? ''),
                                                items: getLanguages
                                                    .map((Language lang) {
                                                  return new DropdownMenuItem<
                                                      int>(
                                                    value: lang.id,
                                                    child: new Text(lang.name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2),
                                                  );
                                                }).toList(),
                                                onChanged: (val) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          new FocusNode());
                                                  setState(() {
                                                    if (val != -10000) {
                                                      _rolechosenName=val.toString();

                                                    }else{
                                                      _rolechosenName="";
                                                    }
                                                    _rolechosenValue =
                                                        val.toString();
                                                  });

                                                  SharedPrefManager.instance
                                                      .setStringAsync(
                                                          Constants.roleId,
                                                          val.toString());
                                                  provider.RolechosenController
                                                      .text = val.toString();
                                                  print(_rolechosenValue);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),*/

                                        // Container(
                                        //   decoration: BoxDecoration(
                                        //     // color: MyColors.boxDecoration,
                                        //       border: Border.all(
                                        //           color: MyColors
                                        //               .colorGray_818181)),
                                        //   child: Row(
                                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //     children: [
                                        //       Padding(
                                        //         padding: const EdgeInsets.all(
                                        //             PaddingSize.boxPaddingAllSide),
                                        //         child: Text(
                                        //           _rolechosenName == null ? MyStrings.chooseRole : _rolechosenName,
                                        //           style: TextStyle(
                                        //             fontSize: FontSize.headerFontSize4,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       Row(
                                        //         children: [
                                        //                 CupertinoPageScaffold(
                                        //                   child: Center(
                                        //                     child: CupertinoButton(
                                        //                       onPressed: () {
                                        //                         showCupertinoModalPopup<
                                        //                             void>(
                                        //                           context: context,
                                        //                           builder: (BuildContext
                                        //                                   context) =>
                                        //                               CupertinoActionSheet(
                                        //                             actions: <
                                        //                                 CupertinoActionSheetAction>[
                                        //                               ...getLanguages
                                        //                                   .map((Language
                                        //                                           lang) =>
                                        //                                       CupertinoActionSheetAction(
                                        //                                           child:
                                        //                                               new Text(lang.name),
                                        //
                                        //                                           onPressed: () {
                                        //                                             FocusScope.of(context).requestFocus(new FocusNode());
                                        //                                             setState(() {
                                        //                                               if (lang.id != -10000) {
                                        //                                                 _rolechosenValue = lang.id.toString();
                                        //                                                 _rolechosenName = lang.name.toString();
                                        //                                                 Navigator.of(context).pop();
                                        //                                               }
                                        //                                             });
                                        //
                                        //                                             SharedPrefManager.instance.setStringAsync(Constants.roleId, lang.id.toString());
                                        //                                             provider.RolechosenController.text = lang.id.toString();
                                        //                                             print(_rolechosenValue);
                                        //                                           }))
                                        //                                   .toList(),
                                        //                             ],
                                        //                           ),
                                        //                         );
                                        //                       },
                                        //                       child:  MyIcons.arrowIos,
                                        //                     ),
                                        //                   ),
                                        //                 )
                                        //
                                        //         ],
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        SizedBox(
                                          height: SizedBoxSize
                                              .standardSizedBoxHeight,
                                          width: SizedBoxSize
                                              .standardSizedBoxWidth,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          RaisedButtonCustom(
                                              buttonWidth: getValueForScreenType<
                                                      bool>(
                                                context: context,
                                                mobile: true,
                                                tablet: false,
                                                desktop: false,
                                              )
                                                  ? null
                                                  : size.width *
                                                      WidgetCustomSize
                                                          .raisedButtonWebWidth,
                                              buttonColor:
                                              MyColors.kPrimaryColor,
                                              splashColor:
                                                  MyColors.splash_color,
                                              buttonText: MyStrings.continues,
                                              textColor:
                                                  MyColors.buttonTextColor,
                                              onPressed:  _putSignUp
                                                  ),
                                          SizedBox(
                                            height: SizedBoxSize
                                                .standardSizedBoxHeight,
                                            width: SizedBoxSize
                                                .standardSizedBoxWidth,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(MyStrings.alreadyAccount),
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
                                                    Navigation.navigateTo(
                                                        context,
                                                        MyRoutes.signIn);
                                                  },
                                                  child: Text(
                                                    MyStrings.signIn,
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
          );
        }),
      ),
    );
  }
}

class Language {
  final int id;
  final String name;

  const Language(
    this.id,
    this.name,
  );
}

List<S2Choice<String>> _choiceRepeat = [
  S2Choice<String>(value: '-10001', title: MyStrings.managerRole),
  S2Choice<String>(value: '-10002', title: MyStrings.playerRole),


];
const List<Language> getLanguages = <Language>[
  Language(
    -10000,
    'Choose Role',
  ),
  Language(
    -10001,
    'Coach/Manager',
  ),
  Language(
    -10002,
    'Team Member',
  ),
  //Future Purpose

  /* Language(
    -10003,
    'Nonplayer',
  ),
  Language(
    -10004,
    'Family',
  ),*/
];
