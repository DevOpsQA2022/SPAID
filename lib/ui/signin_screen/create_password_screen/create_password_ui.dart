import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/signin_response/signin_response.dart';
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
import 'package:spaid/widgets/customize_text_field.dart';

class CreatePasswordScreen extends StatefulWidget {
  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends BaseState<CreatePasswordScreen> {
  @override
  //region Private Members

  bool submitValid = false;
  SignInProvider? _signInProvider;
  List? userdata;
  final _formKey = GlobalKey<FormState>();
  List<String> selected = [];
  var items =  ['Travis Dermott','Ryan Lomberg','Anton Lundell','Jason Spezza'];

  //endregion

  @override
  void initState() {
    super.initState();
    _signInProvider = Provider.of<SignInProvider>(context, listen: false);
    _signInProvider!.initialProvider();
  }

  @override
  void onSuccess(any, {required int reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.SIGNIN_SCREEN:
        SignInResponse validSignIn = any as SignInResponse;
        if (validSignIn.status == Constants.success) {
          Navigation.navigateWithArgument(
              context, MyRoutes.selectTeamScreen, Constants.navigateIdZero);
          setState(() {
            //Future Purpose
            //CodeSnippet.instance.showMsg(MyStrings.signInSuccess);
            // totalContact = _listContactProvider.getTotalContact.toString();
          });
        } else {
          CodeSnippet.instance.showMsg(validSignIn.errorMessage!);
        }
        break;
    }
    super.onSuccess(any,reqId: 0);
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
      Navigation.navigateWithArgument(
          context, MyRoutes.selectTeamScreen, Constants.navigateIdZero);
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
                                            //            fontSize: getValueForScreenType<bool>(
                                            // context: context,
                                            // mobile: false,
                                            // tablet: false,
                                            // desktop: true,) ? FontSize.headerFontSize3 : FontSize.headerFontSize4,
                                                        fontWeight:
                                                        FontWeights.headerFontWeight2),
                                                  ),
                                                  SizedBox(
                                                    height: SizedBoxSize.standardSizedBoxHeight,
                                                    width: SizedBoxSize.standardSizedBoxWidth,
                                                  ),
                                                  CustomPasswordTextField(
                                                    labelText: MyStrings.newPassword,
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
                                                    labelText: MyStrings.confirmPassword,
                                                    prefixIcon: MyIcons.password,
                                                    isLast: true,
                                                    // controller: provider.confirmPasswordController,
                                                    validator: (value) {
                                                      return ValidateInput.verifyFields(
                                                          value,
                                                          provider.passwordController!.text);
                                                    },
                                                    onSave: (value) {
                                                      // provider.confirmPasswordController.text = value;
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
                                                    buttonText: MyStrings.signIn,
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
