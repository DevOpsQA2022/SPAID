import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/player_profile_response/player_profile_response.dart';
import 'package:spaid/model/response/signin_response/signin_response.dart';
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
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/signin_screen/signin_screen_provider.dart';
import 'package:spaid/ui/signup_screen/signup_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_raised_button.dart';
import 'package:spaid/widgets/custom_simple_appbar.dart';
import 'package:spaid/widgets/customize_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends BaseState<ForgotPasswordScreen> {
  @override
  //region Private Members

  bool submitValid = false;
  List? userdata;
  String? emailController;
  final _formKey = GlobalKey<FormState>();
  SignUpProvider? _signUpProvider;

  //endregion

  @override
  void initState() {
    super.initState();
    _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    _signUpProvider!.initialProvider();

    _signUpProvider!.listener = this;

  }

  @override
  void onSuccess(any, {required int reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.SIGNUP_SCREEN_VALIDATE:
        PlayerProfileResponse _response = any as PlayerProfileResponse;
        if (_response.result!.userIDNo != Constants.success) {
          _onPressed();
          DynamicLinksService().createDynamicLink("reset_Password_Screen?userid=" +
              _response.result!.userIDNo.toString() + "&email=" +
              _response.result!.userEmailID!).then((
              value) {
                print(value);
            EmailService().init("Reset your SPAID password.","donotreplay",value,_signUpProvider!.emailController!.text,Constants.forgetPassword);

          });
        } /*else if (_response.responseResult == Constants.failed) {
         // showError(_response.saveErrors[0].errorMessage);
           CodeSnippet.instance.showMsg(_response.saveErrors[0].errorMessage);
        } */else {
          CodeSnippet.instance.showMsg(" Enter valid registered mail");
        }
        break;
    }
    super.onSuccess(any,reqId: 0);
  }

  void sendMail() async {
    String username = "master.spaid.app@gmail.com";
    String password = r"AdminSpaid$32";
    print(emailController);
    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.
    // Create our message.
    final message = Message()
      ..from = Address(username, 'Marlen Franto')
    //  ..recipients.add(_signInProvider.emailController.text)
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      //..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.';
      // ..html = ForgotPassword.forgotPassword.replaceAll('{{name}}', 'Marlen Franto');

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      print(e);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
  /*
Return Type:
Input Parameters: SharedPrefManager used
Use: Back button pressed Fancy dialog show .
 */
  void _onPressed() {
     showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => FancyDialog(
          gifPath: MyImages.team,
          isCancelShow: false,
          okFun: () => {
            Navigation.navigateTo(context, MyRoutes.introScreen)
          },

          //cancelFun: () => null,
          title: "An email has been sent to "+_signUpProvider!.emailController!.text+". Check your inbox",
        )) ;
  }

  void _putPassword() {
    //sendMail();
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _signUpProvider!.putValidateForgetUserAsync(true);

      //_onPressed();
    //  DynamicLinksService().createDynamicLink("reset_Password_Screen").then((value){
      //EmailService().init("Reset your SPAID Password","donotreplay",ForgotPassword.forgotPassword);
     // });

      // Navigation.navigateTo(context, MyRoutes.createPassword);
      // _signInProvider.performSignin();
    }
  }


  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height * .80;
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
                              child: Column(
                                mainAxisAlignment: getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: true,
                                        desktop: true,)
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: false,
                                        desktop: true,)
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(MyImages.spaid_logo,width:ImageSize.logoSmall ,),
                                      SizedBox(
                                        height:
                                        SizedBoxSize.standardSizedBoxHeight,
                                        width:
                                        SizedBoxSize.standardSizedBoxWidth,
                                      ),
                                      Text(MyStrings.forgotPassword,
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
                                      SizedBox(
                                        height:
                                        SizedBoxSize.standardSizedBoxHeight,
                                        width:
                                        SizedBoxSize.standardSizedBoxWidth,
                                      ),
                                      Text(
                                        MyStrings.passwordReset,
                                        textAlign: getValueForScreenType<bool>(
                                        context: context,
                                        mobile: true,
                                        tablet: false,
                                        desktop: false,)
                                            ? TextAlign.center
                                            : TextAlign.start,
                                        style: TextStyle(
                                        //      fontSize: getValueForScreenType<bool>(
                                        // context: context,
                                        // mobile: false,
                                        // tablet: false,
                                        // desktop: true,) ? FontSize.headerFontSize3 : FontSize.headerFontSize4,
                                            fontWeight:
                                                FontWeights.headerFontWeight2),
                                      ),
                                      SizedBox(
                                        height:
                                        SizedBoxSize.standardSizedBoxHeight,
                                        width:
                                        SizedBoxSize.standardSizedBoxWidth,
                                      ),
                                      CustomizeTextFormField(
                                        labelText: MyStrings.email+"*",
                                        prefixIcon: MyIcons.username,
                                        keyboardType:TextInputType.emailAddress ,
                                        inputFormatter: [new LengthLimitingTextInputFormatter(100),],
                                        controller: provider.emailController,
                                        validator:
                                            ValidateInput.validateEmail,
                                        isLast: true,
                                        isEnabled: true,
                                        onSave: (value) {
                                          emailController = value;
                                          provider.emailController!.text = value!;
                                        },
                                      ),
                                      SizedBox(
                                        height:
                                            SizedBoxSize.standardSizedBoxHeight,
                                        width:
                                            SizedBoxSize.standardSizedBoxWidth,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    child: RaisedButtonCustom(
                                        buttonWidth: getValueForScreenType<bool>(
                                        context: context,
                                        mobile: true,
                                        tablet: false,
                                        desktop: false,)
                                            ? null
                                            : size.width *
                                                WidgetCustomSize
                                                    .raisedButtonWebWidth,
                                        buttonColor: MyColors.kPrimaryColor,
                                        textColor: MyColors.buttonTextColor,
                                        splashColor: MyColors.splash_color,
                                        buttonText: MyStrings.sendemail,
                                        onPressed: _putPassword),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
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
