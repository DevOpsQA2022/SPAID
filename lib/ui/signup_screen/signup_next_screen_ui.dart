import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart' as a;
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart' as b;
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/signup_response/signup_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/email_template.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/internet_check.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/signup_screen/signup_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_datepicker.dart';
import 'package:spaid/widgets/custom_password_field.dart';
import 'package:spaid/widgets/custom_raised_button.dart';
import 'package:spaid/widgets/custom_simple_appbar.dart';
import 'package:spaid/widgets/custom_smart_button.dart';
import 'package:spaid/widgets/custom_web_datepicker.dart';
import 'package:spaid/widgets/customize_text_field.dart';
import 'package:spaid/widgets/phone_number_country_picker.dart';
import 'package:country_pickers/country.dart' as b;
import 'package:country_pickers/country_pickers.dart' as c;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SignupNextScreen extends StatefulWidget {
  @override
  _SignupNextScreenState createState() => _SignupNextScreenState();
}

String? role;

class _SignupNextScreenState extends BaseState<SignupNextScreen> {
  @override
  //region Private Members
  SignUpProvider? _signUpProvider;
  String countryCode="CA";
  bool _agree = false;
  bool _webDatePicker = false;
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  String? dateformat, first;
  String firstNameController="",lastNameController="",DatePickerController="",mobileNumberController="";
  bool changePosition=false;
  FocusNode _node = new FocusNode();
  FocusNode _phonenode = new FocusNode();

  TextEditingController DatepickerController = TextEditingController();
  //endregion

  @override
  void initState() {
    super.initState();
    _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
   // _signUpProvider.initialProvider();
   // countryCode=_signUpProvider.countryCode;
    firstNameController=_signUpProvider!.firstNameController!.text;
    lastNameController=_signUpProvider!.lastNameController!.text;

    //Intl.defaultLocale = "en_CA";
    getEventsList();
    //getCountryNameAsync();
    //getCountryCodeAsync();
    getRoleASync();
    getCountryCodeAsyncs();
  }

  /*
Return Type:
Input Parameters:
Use: Initiate value to the variable and create object with sharedpref.
 */
  getRoleASync() async {
    role = await SharedPrefManager.instance.getStringAsync(Constants.roleId);
   // countryCode=await SharedPrefManager.instance.getStringAsync(Constants.countryCode);
    setState(() {

    });
  }

  /*
Return Type:
Input Parameters:
Use: Getting the Country Code.
 */
  Future<void> getCountryCodeAsync() async {
    Locale? l = await Devicelocale.currentAsLocale;
    if (l != null) {
      setState(() {
        countryCode = l.countryCode!;
      });
      SharedPrefManager.instance
          .setStringAsync(Constants.countryCode, countryCode);

      print(
          "CurrentAsLocale result: Language Code: ${l.languageCode} , Country Code:" +
              countryCode);
    } else {
      print('Unable to determine currentAsLocale');
    }
  }

  /*
Return Type:
Input Parameters:
Use: Getting the Country Name.
 */
  Future<String?> getCountryNameAsync() async {
    try {
      a.Position position = await a.Geolocator()
          .getCurrentPosition(desiredAccuracy: a.LocationAccuracy.high);
      debugPrint('location: ${position.latitude}');
      final coordinates =
          new Coordinates(position.latitude, position.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print(first.countryCode);
      setState(() {
        countryCode=first.countryCode;
        SharedPrefManager.instance
            .setStringAsync(Constants.countryCode, countryCode);
      });

      return first.countryCode;
    } catch (e) {
      _signUpProvider!.listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    } // this will return country name
  }
  void _putSignUp() {
   // sendMail();
    FocusScope.of(context).requestFocus(FocusNode());
    if(ValidateInput.validateMobile(_signUpProvider!.mobileNumberController!.text) == null){
      setState(() {
        changePosition=false;

      });
    }else{
      setState(() {
        changePosition=true;
      });
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Internet.checkInternet().then((value) {
        if(value){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ProgressBar.instance.showProgressbar(context);
          });
          _signUpProvider!.putSignupAsync("");
        }
        else{
          CodeSnippet.instance.showMsg(MyStrings.checkNetwork);
        }
      });
    }
  }

  getEventsList() {
//Future Purpose
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressBar.instance.showProgressbar(context);
    });*/
    _signUpProvider!.listener = this;
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
      case ResponseIds.SIGNUP_SCREEN:
        SignUpResponse _response = any as SignUpResponse;
        if (_response.responseResult == Constants.success) {
          // if(_signUpProvider.RolechosenController.text=="")
          SharedPrefManager.instance.setStringAsync(
              Constants.userEmail,_response.result!.userEmailID!);
          SharedPrefManager.instance.setStringAsync(
              Constants.userIdNo, _response.result!.userIdNo.toString());
          SharedPrefManager.instance.setStringAsync(
              Constants.userName, _signUpProvider!.firstNameController!.text+" "+_signUpProvider!.lastNameController!.text);
          DynamicLinksService().createDynamicLink("signin_screen").then((value){
            EmailService().initWelcome("Get Started with SPAID.",_signUpProvider!.firstNameController!.text+" "+_signUpProvider!.lastNameController!.text,_signUpProvider!.firstNameController!.text+" "+_signUpProvider!.lastNameController!.text,value,_response.result!.userEmailID!,Constants.welcome);
          });
         // sendMail();
          Navigation.navigateWithArgument(
              context, MyRoutes.selectTeamScreen, Constants.navigateIdZero);


          //Future Purpose

          /* if(role ==  "-10001" ){
            Navigation.navigateTo(context, MyRoutes.createTeamScreen);

          }else{
            Navigation.navigateTo(context, MyRoutes.selectTeamScreen);

          }  */ //CodeSnippet.instance.showMsg(MyStrings.signUpSuccess);
        } else if (_response.responseResult == Constants.failed) {
          CodeSnippet.instance.showMsg(MyStrings.alreadyAccount);
        } else {
          CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
    }
  }
  Future<void> getCountryCodeAsyncs() async {
    first =
    "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    setState(() {
      dateformat = first;
      print(dateformat);
    });
  }
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args ) {

    setState(() {

      if (args.value is PickerDateRange) {
        _range =

            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {

        _selectedDate = args.value;
        // DatepickerController.text = _selectedDate.toString();
        _signUpProvider!.DatePickerController!
          ..text = dateformat == "US"
              ? DateFormat("MM/dd/yyyy").format(_selectedDate)
              :dateformat == "CA"?DateFormat("yyyy/MM/dd").format(_selectedDate)
              : DateFormat("dd/MM/yyyy").format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: _signUpProvider!.DatePickerController!.text.length,
              affinity: TextAffinity.upstream));

        print("ll"+_selectedDate.toString());
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
      _webDatePicker == true
          ?
      _webDatePicker = false
          : _webDatePicker = true;
    });
  }

  selectTermsAndConditions(bool value) {
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) => Scaffold(

              appBar: CustomAppBar(
                title: MyStrings.privacyPolicy,
                removeArrow: true,
                //Future Purpose
                /* iconLeft: MyIcons.cancel, tooltipMessageLeft: MyStrings.cancel,
            iconRight: MyIcons.done,
            onClickRightImage: (){
              Navigator.of(context).pop();

            },
            onClickLeftImage: (){
              Navigator.of(context).pop();

            },*/
              ),
              body: TopBar(
                child: SingleChildScrollView(
                  child: new Column(children: <Widget>[
                    WebCard(
                      marginVertical: 70,
                      marginhorizontal: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              RichText(
                                //Future Purpose

                                // overflow: TextOverflow.clip,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: FontSize.headerFontSize4,
                                    color: MyColors.textColor,
                                  ),
                                  //Future Purpose

                                  //style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Introduction\n\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text:
                                            'These Website Standard Terms and Conditions written on this webpage shall manage your use of our website, Webiste Name accessible at Website.com.\n\n'),
                                    TextSpan(
                                        text:
                                            'These Terms will be applied fully and affect to your use of this Website. By using this Website, you agreed to accept all terms and conditions written in here. You must not use this Website if you disagree with any of these Website Standard Terms and Conditions.\n\n'),
                                    TextSpan(
                                        text:
                                            'Minors or people below 18 years old are not allowed to use this Website.\n\n'),
                                    TextSpan(
                                        text: 'Intellectual Property Rights\n\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text:
                                        'These Website Standard Terms and Conditions written on this webpage shall manage your use of our website, Webiste Name accessible at Website.com.\n\n'),
                                    TextSpan(
                                        text:
                                        'These Terms will be applied fully and affect to your use of this Website. By using this Website, you agreed to accept all terms and conditions written in here. You must not use this Website if you disagree with any of these Website Standard Terms and Conditions.\n\n'),
                                    TextSpan(
                                        text:
                                        'Minors or people below 18 years old are not allowed to use this Website.\n\n'),
                                    TextSpan(
                                        text: 'Intellectual Property Rights\n\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text:
                                            'Other than the content you own, under these Terms, Company Name and/or its licensors own all the intellectual property rights and materials contained in this Website.\n\n'),
                                    TextSpan(
                                        text:
                                            'You are granted limited license only for purposes of viewing the material contained on this Website.\n\n'),
                                    TextSpan(
                                        text: 'Your Content\n\n',
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: 'In these Website Standard Terms and Conditions, “Your Content” shall mean any audio, video text, images or other material you choose to display on this Website. By displaying Your Content, you grant Company Name a non-exclusive, worldwide irrevocable, sub licensable license to use, reproduce, adapt, publish, translate and distribute it in any and all media.\n\n'),
                                    TextSpan(text: ''),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizedBoxSize.headerSizedBoxHeight),
                            /*  RaisedButtonCustom(
                                onPressed: () {
                                  setState(() {
                                    _agree = true;
                                    Navigator.of(context).pop();
                                  });
                                },
                                buttonText: MyStrings.ok,
                                buttonColor: MyColors.kPrimaryColor,
                                buttonWidth:  getValueForScreenType<bool>(
                                  context: context,
                                  mobile: true,
                                  tablet: false,
                                  desktop: false,
                                ) ? null : size.width * WidgetCustomSize.raisedButtonWebWidth,
                                //  buttonColor: MyColors.green,
                              ),
                              SizedBox(height: SizedBoxSize.headerSizedBoxHeight),

                              RaisedButtonCustom(
                                onPressed: () {
                                  setState(() {
                                    _agree = false;
                                    Navigator.of(context).pop();
                                  });
                                },
                                buttonText: MyStrings.cancel,
                                buttonWidth:  getValueForScreenType<bool>(
                                  context: context,
                                  mobile: true,
                                  tablet: false,
                                  desktop: false,
                                ) ? null : size.width * WidgetCustomSize.raisedButtonWebWidth,
                                buttonColor: Colors.red,
                              ),*/
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SmallRaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        _agree = false;
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    buttonText: MyStrings.cancel,
                                    buttonWidth:  getValueForScreenType<bool>(
                                      context: context,
                                      mobile: true,
                                      tablet: false,
                                      desktop: false,
                                    ) ? null : size.width * WidgetCustomSize.raisedButtonWebWidth,
                                    buttonColor: MyColors.controllerColor,
                                  ),
                                  SmallRaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        _agree = true;
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    buttonText: "Agree",
                                    buttonWidth:  getValueForScreenType<bool>(
                                      context: context,
                                      mobile: true,
                                      tablet: false,
                                      desktop: false,
                                    ) ? null : size.width * WidgetCustomSize.raisedButtonWebWidth,
                                  //  buttonColor: MyColors.green,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: SizedBoxSize.headerSizedBoxHeight1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ));
  }

  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height * .80;

    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: getValueForScreenType<bool>(
          context: context,
          mobile: false,
          tablet: true,
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
          child: Consumer<SignUpProvider>(builder: (context, provider, _) {
            return Form(
          key: _formKey,
          //Future Purpose
          // autovalidateMode: !provider.getAutoValidate
          //     ? AutovalidateMode.disabled
          //     : AutovalidateMode.always,
              autovalidateMode: AutovalidateMode.disabled,          child: SafeArea(
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
                      marginVertical: 20,
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
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
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
                                              fontSize: getValueForScreenType<bool>(
                                          context: context,
                                          mobile: false,
                                          tablet: false,
                                          desktop: true,)
                                                  ? FontSize.headerFontSize1
                                                  : FontSize.headerFontSize2,
                                              fontWeight:
                                                  FontWeights.headerFontWeight1,
                                              color: MyColors.kPrimaryColor)),
                                      Text(
                                        MyStrings.outOfPlay+"  "+MyStrings.onlineToday,                                      style: TextStyle(
                                            fontSize: getValueForScreenType<bool>(
                                          context: context,
                                          mobile: false,
                                          tablet: false,
                                          desktop: true,)
                                                ? FontSize.headerFontSize1
                                                : FontSize.headerFontSize2,
                                            fontWeight:
                                                FontWeights.headerFontWeight1),
                                      ),
                                      SizedBox(
                                        height:
                                            SizedBoxSize.standardSizedBoxHeight,
                                        width: SizedBoxSize.standardSizedBoxWidth,
                                      ),
                                      Column(
                                        children: [
                                          /*CustomPasswordTextField(
                                            labelText: MyStrings.createPassword,
                                            prefixIcon: MyIcons.password,
                                            controller:
                                            provider.passwordController,
                                            inputAction: TextInputAction.next,
                                            validator:
                                            ValidateInput.validatePassword,
                                            onSave: (value) {
                                              SharedPrefManager.instance
                                                  .setStringAsync(
                                                  Constants.passId, value);
                                              provider.passwordController.text =
                                                  value;
                                            },
                                          ),
                                          SizedBox(
                                            height: SizedBoxSize
                                                .standardSizedBoxHeight,
                                            width: SizedBoxSize
                                                .standardSizedBoxWidth,
                                          ),
*/

                                          Focus(
                                            focusNode: _node,
                                            onFocusChange:
                                                (bool focus) {
                                              setState(() {
                                                _webDatePicker ==
                                                    true
                                                    ? _webDatePicker =
                                                false
                                                    : _webDatePicker =
                                                false;
                                              });
                                            },
                                            child: Listener(
                                              onPointerDown:
                                                  (_) {
                                                FocusScope.of(
                                                    context)
                                                    .requestFocus(
                                                    _node);
                                              },
                                            child: CustomizeTextFormField(
                                              labelText: MyStrings.firstName+"*",
                                              prefixIcon: MyIcons.username,
                                              inputFormatter: [new LengthLimitingTextInputFormatter(25),],
                                              controller:
                                                  provider.firstNameController,
                                              isEnabled: true,
                                              inputAction: TextInputAction.next,
                                              validator:
                                                  ValidateInput.requiredFieldsFirstName,
                                              onSave: (value) {
                                                provider.firstNameController!.text =
                                                    value!;
                                              },
                                              onChange: (value){
                                                setState(() {
                                                  firstNameController =
                                                      value;
                                                });

                                              },
                                            ),
                                          ),
                                          ),
                                          SizedBox(
                                            height: SizedBoxSize
                                                .standardSizedBoxHeight,
                                            width: SizedBoxSize
                                                .standardSizedBoxWidth,
                                          ),
                                          //Future Purpose

                                          // CustomizeTextFormField(
                                          //   labelText: MyStrings.middleName,
                                          //   prefixIcon: MyIcons.username,
                                          //   controller:
                                          //   provider.middleNameController,
                                          //   // suffixImage: MyImages.dropDown,
                                          //   isEnabled: true,
                                          //
                                          //   onSave: (value) {
                                          //     provider.middleNameController.text =
                                          //         value;
                                          //   },
                                          // ),
                                          // SizedBox(
                                          //   height: SizedBoxSize.standardSizedBoxHeight,
                                          //   width: SizedBoxSize.standardSizedBoxWidth,
                                          // ),
                                          Focus(
                                            focusNode: _node,
                                            onFocusChange:
                                                (bool focus) {
                                              setState(() {
                                                _webDatePicker ==
                                                    true
                                                    ? _webDatePicker =
                                                false
                                                    : _webDatePicker =
                                                false;
                                              });
                                            },
                                            child: Listener(
                                              onPointerDown:
                                                  (_) {
                                                FocusScope.of(
                                                    context)
                                                    .requestFocus(
                                                    _node);
                                              },
                                            child: CustomizeTextFormField(
                                              labelText: MyStrings.lastName+"*",
                                              prefixIcon: MyIcons.username,
                                              inputFormatter: [new LengthLimitingTextInputFormatter(25),],
                                              inputAction: TextInputAction.next,
                                              validator:
                                              ValidateInput.requiredFieldsLastName,
                                              controller:
                                                  provider.lastNameController,
                                              isEnabled: true,
                                              onSave: (value) {
                                                provider.lastNameController!.text =
                                                    value!;
                                              },
                                              onChange: (value) {
                                                setState(() {
                                                  lastNameController =
                                                      value;
                                                });

                                              },
                                            ),
                                          ),
                                          ),
                                          SizedBox(
                                            height: SizedBoxSize.standardSizedBoxHeight,
                                            width: SizedBoxSize.standardSizedBoxWidth,
                                          ),
                                          DatePickerTextfieldWidget(
                                            prefixIcon: null,
                                            suffixIcon: MyIcons.calendar,
                                            labelText: MyStrings.dob+"*",
                                            controller:  provider.DatePickerController,
                                            inputAction: TextInputAction.next,
                                            validator: ValidateInput.verifyDOB,
                                            onFieldSubmit: (v){
                                              FocusScope.of(context).requestFocus(_phonenode);

                                            },
                                            onTab: (){
                                              setState(() {
                                                _webDatePicker == true ? _webDatePicker = false : _webDatePicker = true;
                                              });
                                            },
                                            onSave: (value) {
                                             provider.DatePickerController!.text = value!;
                                              // print(provider.startDateController.text);
                                              print(value);
                                            },
                                            onChange: (value) {
                                              setState(() {
                                                DatePickerController = value;

                                              });

                                            },
                                          ),

                                          Stack(
                                            children: [
                                              Column(
                                                children: [
                                                  getValueForScreenType<bool>(
                                                    context: context,
                                                    mobile: true,
                                                    tablet: true,
                                                    desktop: true,) ?
                                                  SizedBox(
                                                    height: SizedBoxSize.standardSizedBoxHeight,
                                                    width: SizedBoxSize.standardSizedBoxWidth,
                                                  ) : SizedBox(),

                                                  Focus(
                                                    focusNode: _node,
                                                    onFocusChange:
                                                        (bool focus) {
                                                      setState(() {
                                                        _webDatePicker ==
                                                            true
                                                            ? _webDatePicker =
                                                        false
                                                            : _webDatePicker =
                                                        false;
                                                      });
                                                    },
                                                    child: Listener(
                                                      onPointerDown:
                                                          (_) {
                                                        FocusScope.of(
                                                            context)
                                                            .requestFocus(
                                                            _node);
                                                      },
                                                    child: PhoneNumberCountryPicker(
                                                      hintText: MyStrings.noFormat,
                                                      countryCode: countryCode != null
                                                          ? countryCode
                                                          : "CA",
                                                      label: MyStrings.contactPhone+"*",
                                                      focusNode: _phonenode,
                                                      countryCodeController: provider.countryCodeController,
                                                      countryController: provider.mobileNumberController,
                                                      validator: ValidateInput.validateMobile,
                                                        changePosition:changePosition,

                                                      onSave: (value) {

                                                        provider.mobileNumberController!.text = value!;
                                                      },
                                                      onChange: (value){
                                                        setState(() {
                                                          mobileNumberController = value;

                                                        });

                                                      },
                                                    ),
                                                  ),
                                                  ),

                                                  // buildWeekDatePicker(),
                                                  getValueForScreenType<bool>(
                                                    context: context,
                                                    mobile: true,
                                                    tablet: true,
                                                    desktop: true,) ?
                                                  SizedBox(
                                                    height: SizedBoxSize.standardSizedBoxHeight,
                                                    width: SizedBoxSize.standardSizedBoxWidth,
                                                  ) : SizedBox(),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: SizedBoxSize
                                                            .checkSizedBoxHeight,
                                                        width: SizedBoxSize
                                                            .checkSizedBoxWidth,
                                                        child:Theme(
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
                                                                if(value==false){
                                                                  _agree=value!;
                                                                }else{
                                                                  selectTermsAndConditions(
                                                                      value!);}
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(MyStrings.iHaveRead),
                                                        ],
                                                      ),
                                                    ],
                                                  ),


                                                  getValueForScreenType<bool>(
                                                    context: context,
                                                    mobile: false,
                                                    tablet: true,
                                                    desktop: true,) ?
                                                  SizedBox(
                                                    height: SizedBoxSize.checkSizedBoxWidth,
                                                    width: SizedBoxSize.checkSizedBoxWidth,
                                                  ) : SizedBox(
                                                    height: SizedBoxSize
                                                        .standardSizedBoxHeight,
                                                    width: SizedBoxSize
                                                        .standardSizedBoxWidth,
                                                  ),
                                                  Column(
                                                    children: [
                                                      RaisedButtonCustom(
                                                        buttonWidth: getValueForScreenType<bool>(
                                                          context: context,
                                                          mobile: true,
                                                          tablet: false,
                                                          desktop: false,) ? null : size.width * WidgetCustomSize.raisedButtonWebWidth,
                                                        buttonColor: _agree == true && firstNameController.isNotEmpty && lastNameController.isNotEmpty && (DatePickerController.isNotEmpty || provider.DatePickerController!.text.isNotEmpty) && mobileNumberController.isNotEmpty
                                                            ? MyColors.kPrimaryColor
                                                            : MyColors.buttonColor,
                                                        splashColor: MyColors.splash_color,
                                                        textColor: MyColors.buttonTextColor,
                                                        buttonText: MyStrings.createAccount,
                                                        onPressed: _agree == true && firstNameController.isNotEmpty && lastNameController.isNotEmpty && (DatePickerController.isNotEmpty || provider.DatePickerController!.text.isNotEmpty) && mobileNumberController.isNotEmpty
                                                            ? _putSignUp
                                                            : () {},
                                                      ),
                                                    ],
                                                  ),

                                                ],
                                              ),

                                              _webDatePicker == true && getValueForScreenType<bool>(
                                                context: context,
                                                mobile: false,
                                                tablet: true,
                                                desktop: true,) ?
                                              Container(
                                                width :330,
                                                child: Card(
                                                  margin: const EdgeInsets.only(
                                                      right: 3.0,
                                                      left: 0.0,
                                                      top : 0.0,
                                                      bottom: 30.0),
                                                  elevation: 10,
                                                  shadowColor: MyColors.colorGray_666BC,
                                                  child: SfDateRangePicker(
                                                    initialDisplayDate: _selectedDate != null ? _selectedDate : DateTime.now(),
                                                    initialSelectedDate: _selectedDate,
                                                    view: DateRangePickerView.month,
                                                    todayHighlightColor: MyColors
                                                        .red,
                                                    allowViewNavigation: true,
                                                    showNavigationArrow: true,
                                                    navigationMode: DateRangePickerNavigationMode
                                                        .snap,
                                                    endRangeSelectionColor: MyColors
                                                        .kPrimaryColor,
                                                    rangeSelectionColor: MyColors
                                                        .kPrimaryColor,
                                                    selectionColor: MyColors
                                                        .kPrimaryColor,
                                                    startRangeSelectionColor: MyColors
                                                        .kPrimaryColor,
                                                    onSelectionChanged: _onSelectionChanged,
                                                    selectionMode: DateRangePickerSelectionMode
                                                        .single,
                                                    onSubmit: (value){
                                                     // print("Marlen"+value);
                                                      setState(() {
                                                       // provider.DatePickerController.text = value;

                                                      });

                                                    },

                                                    initialSelectedRange: PickerDateRange(
                                                        DateTime.now().subtract(const Duration(days: 4)),
                                                        DateTime.now().add(const Duration(days: 3))),
                                                  ),
                                                ),
                                              ) : SizedBox(),

                                            ],
                                          ),
                                          // DayPickerPage(
                                          //   selectedYear: provider.selectedYear,
                                          //   controller: provider.DatePickerController,
                                          // ) : SizedBox(),
                                        ],
                                      )
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),

                  ],
                ),
              ),
            ),
          ),
            );
          }),
        ));
  }
}


Widget buildWeekDatePicker (DateTime selectedDate, DateTime firstAllowedDate, DateTime lastAllowedDate, ValueChanged<DatePeriod> onNewSelected) {

  // add some colors to default settings
  DatePickerRangeStyles styles = DatePickerRangeStyles(
    selectedPeriodLastDecoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0))),
    selectedPeriodStartDecoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
    ),
    selectedPeriodMiddleDecoration: BoxDecoration(
        color: Colors.yellow, shape: BoxShape.rectangle),
  );

  return WeekPicker(
      selectedDate: selectedDate,
      onChanged: onNewSelected,
      firstDate: firstAllowedDate,
      lastDate: lastAllowedDate,
      datePickerStyles: styles
  );
}