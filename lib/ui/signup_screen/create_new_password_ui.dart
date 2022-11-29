import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/signin_response/signin_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/send_push_notification_service.dart';
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
import 'package:spaid/ui/user_profile_screen/user_profile_screen_ui.dart';
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

class CreateNewPasswordScreen extends StatefulWidget {
  List<String> userDetails;
  CreateNewPasswordScreen( this.userDetails);

  @override
  _CreateNewPasswordScreenState createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends BaseState<CreateNewPasswordScreen> {
  @override
  //region Private Members
  SignUpProvider? _signUpProvider;

  bool submitValid = false;
  List? userdata;
  final _formKey = GlobalKey<FormState>();

  //endregion

  @override
  void initState() {
    super.initState();
    _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    _signUpProvider!.initialProvider();
    _signUpProvider!.listener=this;
   // _signUpProvider.emailController.text=widget.email;
  }

  @override
  void onSuccess(any, {required int reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.PLAYER_MAIL_RESPONSE:
        ValidateUserResponse _response = any as ValidateUserResponse;
        if (_response.responseResult == Constants.success) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => FancyDialog(
                gifPath: MyImages.team,
                okFun: () async => {
                EmailService().inits("Invite Accepted","",Constants.gameEventAccept,int.parse(widget.userDetails[0]),int.parse(widget.userDetails[0]),int.parse(widget.userDetails[1]),"You have accepted the invite to join the team, "+widget.userDetails[5]+".",widget.userDetails[2],widget.userDetails[5],"","",widget.userDetails[6],""),
                EmailService().inits("Invite Accepted","",Constants.gameEventAcceptManager,int.parse(widget.userDetails[0]),int.parse(widget.userDetails[9]),int.parse(widget.userDetails[1]),widget.userDetails[6]+" has accepted your invite to join the team, "+widget.userDetails[5]+".",widget.userDetails[8],"","","",widget.userDetails[6]+" has accepted your invitation to join the team, "+widget.userDetails[5],widget.userDetails[7]),

                  SendPushNotificationService().sendPushNotifications(
                  await SharedPrefManager.instance.getStringAsync(Constants.FCM),
              "You have accepted the invite to join the team, "+widget.userDetails[5],""),
                  SendPushNotificationService().sendPushNotifications(
                  widget.userDetails[4],
                      widget.userDetails[6]+" has accepted your invite to join the team, "+widget.userDetails[5],""),

                Navigation.navigateTo(context, MyRoutes.introScreen),

              },
                isCancelShow: false,

                title: MyStrings.conformloginApp,
              ));
        } else if (_response.responseResult == Constants.failed) {
           CodeSnippet.instance.showMsg(_response.saveErrors![0].errorMessage!);
        } else {
          CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
    }
    super.onSuccess(any,reqId: 0);
  }

  @override
  void onFailure(BaseResponse error) {
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }
  /*
Return Type:
Input Parameters:
Use: Validate user password inputs and make signup  server call.
 */
  void _putLogin() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ProgressBar.instance.showProgressbar(context);
      });
      _signUpProvider!.createAccountAsync(widget.userDetails[0],widget.userDetails[1],widget.userDetails[2],2,true,int.parse(widget.userDetails[3]));
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
              // autovalidateMode: !provider.getAutoValidate
              //     ? AutovalidateMode.disabled
              //     : AutovalidateMode.always,
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
                        children: [
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
                                      mobile: true,
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
                                            Text(MyStrings.createPassword,
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
                                            CustomPasswordTextField(
                                              labelText: MyStrings.newPassword+"*",
                                              prefixIcon: MyIcons.password,
                                              controller:
                                              provider.passwordController,
                                              validator:
                                              ValidateInput.validatePassword,
                                              onSave: (value) {
                                                provider.passwordController!.text =
                                                    value!;
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
                                              controller: provider.confirmPasswordController,
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
                                              buttonText: MyStrings.createAccount,
                                              onPressed: _putLogin),
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
              ));
        }),
      ),

    );

  }
}
