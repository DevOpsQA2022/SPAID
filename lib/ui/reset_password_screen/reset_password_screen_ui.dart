import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/signin_response/signin_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/reset_password_screen/reset_password_provider.dart';
import 'package:spaid/ui/signin_screen/signin_screen_provider.dart';
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

class ResetPasswordScreen extends StatefulWidget {
  List<String> userDetails;
  ResetPasswordScreen(this.userDetails);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends BaseState<ResetPasswordScreen> {
  @override
  //region Private Members

  bool submitValid = false;
  bool isFromMail=false;
  FocusNode _node = new FocusNode();
  List? userdata;
  final _formKey = GlobalKey<FormState>();
  ResetPasswordProvider? _resetPasswordProvider;

  //endregion

  @override
  void initState() {
    super.initState();
    _resetPasswordProvider =
        Provider.of<ResetPasswordProvider>(context, listen: false);
    _resetPasswordProvider!.listener = this;
    try {
      if(widget.userDetails != null && widget.userDetails[2] != null) {
            isFromMail = widget.userDetails[2] == "true" ? true : false;
          }
    } catch (e) {
      print(e);
    }
    // print(widget.userDetails.toString());
    _resetPasswordProvider!.initialProvider();
  }


  @override
  void onSuccess(any, {int? reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.CHANGE_PASSWORD:
        ValidateUserResponse _response = any as ValidateUserResponse;
        if (_response.responseResult == Constants.success) {
          isFromMail ?
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => FancyDialog(
                gifPath: MyImages.team,
                okFun: () => {
                SharedPrefManager.instance.setStringAsync(Constants.userEmail, ""),
                  SharedPrefManager.instance
                  .setStringAsync(Constants.rememberMe, ""),
              SharedPrefManager.instance.setStringAsync(Constants.roleId, ""),
          SharedPrefManager.instance.setStringAsync(Constants.teamName, ""),
          SharedPrefManager.instance.setStringAsync(Constants.userIdNo, ""),
          Navigator.of(context).pop(),
          Navigation.navigatePushNamedAndRemoveAll(
              context, MyRoutes.introScreen),
                },
                isCancelShow: false,

                title: MyStrings.conformReloginApp,
              )):
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => FancyDialog(
                gifPath: MyImages.team,
                okFun: () => {

                  Navigator.of(context).pop(),
diamissDialog(),
                },
                isCancelShow: false,

                title: MyStrings.conformResetPassword,
              ));


        } else if (_response.responseResult == Constants.failed) {
          //showError(_response.saveErrors[0].errorMessage);
          CodeSnippet.instance.showMsg(_response.saveErrors![0].errorMessage!);
        } else {
          //CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
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
      /*Navigation.navigateWithArgument(
          context, MyRoutes.selectTeamScreen, Constants.navigateIdZero);*/
      if(widget.userDetails != null){
        _resetPasswordProvider!.changePassword(widget.userDetails[0]);

      }else{
        _resetPasswordProvider!.changePassword("");

      }
    }
  }

  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height * .80;

    Size size = MediaQuery.of(context).size;
    print(size);
    return  Consumer<ResetPasswordProvider>(builder: (context, provider, _) {
      return Form(
          key: _formKey,
          // autovalidateMode: !provider.getAutoValidate
          //     ? AutovalidateMode.disabled
          //     : AutovalidateMode.always,
          autovalidateMode: AutovalidateMode.disabled,
          child: SafeArea(
            child: Container(
              width: size.width,
              constraints: BoxConstraints(minHeight: size.height -30),
              child: TopBar(
                child: Row(
                  children: [
                    if (getValueForScreenType<bool>(
                      context: context,
                      mobile: false,
                      tablet: false,
                      desktop: true,
                    ) && isFromMail)
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
                          child: Scaffold(
                            backgroundColor: MyColors.white,
                            appBar: CustomAppBar(
                              title: MyStrings.changePassword,
                              iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
                              iconRight:getValueForScreenType<bool>(
                                context: context,
                                mobile: false,
                                tablet: true,
                                desktop: true,)? MyIcons.done: null,
                              tooltipMessageRight: MyStrings.save,
                              onClickRightImage: () {
                                _putLogin();
                              },
                              onClickLeftImage: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            body: SizedBox(
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
                                        /*Text(MyStrings.createPassword,
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
                                                color: MyColors.kPrimaryColor)),*/

                                       /* SizedBox(
                                          height:
                                          SizedBoxSize.standardSizedBoxHeight,
                                          width:
                                          SizedBoxSize.standardSizedBoxWidth,
                                        ),*/
                                        CustomPasswordTextField(
                                          labelText: MyStrings.newPassword+"*",
                                          prefixIcon: MyIcons.password,
                                          controller:
                                          provider.passwordController,
                                          inputAction: TextInputAction.next,
                                          onFieldSubmit: (v){
                                            FocusScope.of(context).requestFocus(_node);
                                          },
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
                                          focusNode: _node,
                                          controller: provider.conformpasswordController,
                                          inputAction: TextInputAction.done,
                                          isLast: true,
                                          validator: (value) {
                                            return ValidateInput.verifyFields(
                                                value,
                                                provider.passwordController!.text);
                                          },
                                          onSave: (value) {
                                            provider.conformpasswordController!.text = value!;
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
                                    if (getValueForScreenType<bool>(
                                      context: context,
                                      mobile: true,
                                      tablet: false,
                                      desktop: false,
                                    ))
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
                                          buttonText: MyStrings.save,
                                          onPressed: _putLogin),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),

                  ],
                ),
              ),
            ),
          ));
    });

  }

  diamissDialog() {
    Navigator.of(context).pop();
  }
}


//
// Scaffold(
// resizeToAvoidBottomInset: true,
// backgroundColor: MyColors.white,
// appBar: getValueForScreenType<bool>(
// context: context,
// mobile: false,
// tablet: true,
// desktop: true,
// ) ? CustomSimpleAppBar(
// title: MyStrings.changePassword,
// iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
// // iconRight: MyIcons.done,
// /* onClickRightImage: () {
//           Navigator.of(context).pop();
//         },*/
// onClickLeftImage: () {
// Navigator.of(context).pop();
// },
// ) : null,
// bottomNavigationBar: getValueForScreenType<bool>(
// context: context,
// mobile: false,
// tablet: true,
// desktop: true,
// )
// ? Container(
// height: 120,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// RaisedButtonCustom(
// buttonColor: MyColors.kPrimaryColor,
// splashColor: Colors.grey,
// buttonText: MyStrings.save,
// buttonWidth: getValueForScreenType<bool>(
// context: context,
// mobile: true,
// tablet: false,
// desktop: false,
// )
// ? null
// : size.width *
// WidgetCustomSize.raisedButtonWebWidth,
// onPressed: () => {
// _putLogin(),
// // Navigation.navigateTo(context, MyRoutes.teamSetupScreen)
// }),
// ],
// ),
// )
//     : null,
// body: