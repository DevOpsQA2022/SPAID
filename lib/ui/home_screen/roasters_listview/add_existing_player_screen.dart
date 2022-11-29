import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_below/dropdown_below.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/add_player_response/add_existing_player_response.dart';
import 'package:spaid/model/response/add_player_response/add_player_response.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/player_email_list_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/email_template.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/internet_check.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/add_event_screen/add_event_provider.dart';
import 'package:spaid/ui/home_screen/roasters_listview/roasters_listview_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_datepicker.dart';
import 'package:spaid/widgets/custom_raised_button.dart';
import 'package:spaid/widgets/custom_simple_appbar.dart';
import 'package:spaid/widgets/customize_text_field.dart';
import 'package:spaid/widgets/home_eventSport_card.dart';
import 'package:spaid/widgets/menu_screen_card.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddExistingPlayerScreen extends StatefulWidget {
  @override
  _AddExistingPlayerScreenState createState() =>
      _AddExistingPlayerScreenState();
}

class _AddExistingPlayerScreenState extends BaseState<AddExistingPlayerScreen> {
  //region Private Members
  final _formKey = GlobalKey<FormState>();
TextEditingController emailController=TextEditingController();
  AddExistingPlayerResponse? _addExistingPlayer;
  AddEventProvider? _addEventProvider;
  GetTeamMembersEmailResponse? _getTeamMembersEmailResponse;
  //endregion

  @override
  void initState() {

    _addEventProvider = Provider.of<AddEventProvider>(context, listen: false);
    _addEventProvider!.listener = this;
    _addEventProvider!.getTeamMembersEmailAsync();

    super.initState();
  }
/*
Return Type:
Input Parameters:
Use: Validate user inputs and make login server call.
 */
  void searchPlayer() {

    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Internet.checkInternet().then((value) {
        if(value){

          bool isExist=false;
          for(int i=0;i<_getTeamMembersEmailResponse!.result!.userMailList!.length;i++){
            if(_getTeamMembersEmailResponse!.result!.userMailList![i].email?.toLowerCase()==emailController.text.toLowerCase()){
              isExist=true;
              CodeSnippet.instance.showMsg("The member already exists in your team");
            }
          }
          if(!isExist) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ProgressBar.instance.showProgressbar(context);
            });
            _addEventProvider!.getExistingPlayer(emailController.text);
          }
        }
        else{
          CodeSnippet.instance.showMsg(MyStrings.checkNetwork);
        }
      });
    }
  }
  @override
  void onSuccess(any, {int? reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    super.onSuccess(any,reqId: 0);
    switch (reqId) {
      case ResponseIds.ADD_EXISTING_PLAYER:
         _addExistingPlayer = any as AddExistingPlayerResponse;
        if (_addExistingPlayer!.result != null && _addExistingPlayer!.result!.userIDNo != null && _addExistingPlayer!.result!.userIDNo != Constants.success) {
          showPlayers();
          //Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 1);
        } else if(_addExistingPlayer!.result == null || _addExistingPlayer!.result!.userIDNo==null){
          CodeSnippet.instance.showMsg("No Results were found");
        }
        break;
      case ResponseIds.TEAM_EMAIL_LIST:
        GetTeamMembersEmailResponse _response =
        any as GetTeamMembersEmailResponse;
        if (_response.result!.teamIDNo != Constants.success) {
          if (_response.result!.userMailList!.length > 0) {
            _getTeamMembersEmailResponse = _response;
          }
        }
        break;
    }
  }

  @override
  void onFailure(BaseResponse error) {
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }

  showPlayers() {
    showDialog(
        context: context,
        builder: (context) => Scaffold(
      appBar: getValueForScreenType<bool>(
        context: context,
        mobile: false,
        tablet: true,
        desktop: true,
      )
          ? CustomSimpleAppBar(
        title: MyStrings.appName,
        iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
        iconRight: null,

        onClickLeftImage: () {
          Navigator.of(context).pop();
        },
      )
          : null,
      body: TopBar(
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
                  height: MediaQuery.of(context).size.height * ImageSize.signInImageSize,
                ),
              ),
            Expanded(
              child: WebCard(
                marginVertical: 20,
                marginhorizontal: 40,
                child: Scaffold(
                    backgroundColor: MyColors.white,
                    appBar: CustomAppBar(
                      title: MyStrings.addPlayer,
                      iconRight:null,
                      iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
                      onClickRightImage: () {
                        /* Navigation.navigateWithArgument(
                            context, MyRoutes.editPlayersScreen, widget.userId);*/
                      },
                    ),
                    body: Consumer<RoasterListViewProvider>(
                        builder: (context, provider, _) {
                          return SafeArea(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              constraints:
                              BoxConstraints(minHeight: MediaQuery.of(context).size.height - 30),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                    MarginSize.headerMarginVertical1,
                                    horizontal:
                                    MarginSize.headerMarginVertical1),
                                child: Row(
                                  children: <Widget>[

                                    Expanded(
                                        child: SizedBox(
                                          height: getValueForScreenType<bool>(
                                            context: context,
                                            mobile: false,
                                            tablet: true,
                                            desktop: true,
                                          )
                                              ? MediaQuery.of(context).size.height * .80
                                              : null,
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                getValueForScreenType<bool>(
                                                  context: context,
                                                  mobile: false,
                                                  tablet: true,
                                                  desktop: true,
                                                )
                                                    ? PaddingSize.headerPadding1
                                                    : PaddingSize
                                                    .headerPadding2),
                                            // EdgeInsets.symmetric(horizontal: PaddingSize.headerCardPadding),
                                            child: Column(
                                              mainAxisAlignment:
                                              getValueForScreenType<bool>(
                                                context: context,
                                                mobile: false,
                                                tablet: true,
                                                desktop: true,
                                              )
                                                  ? MainAxisAlignment
                                                  .spaceBetween
                                                  : MainAxisAlignment
                                                  .start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                  getValueForScreenType<
                                                      bool>(
                                                    context: context,
                                                    mobile: false,
                                                    tablet: true,
                                                    desktop: true,
                                                  )
                                                      ? MainAxisAlignment
                                                      .start
                                                      : MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: <Widget>[

                                                    ListView.builder(
                                                      scrollDirection: Axis.vertical,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true, // new
                                                      itemCount:1,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        return MenuScreenCard(
                                                          icon: Icon(Icons.person),
                                                          trailing: null,
                                                          image:_addExistingPlayer!.result!.userProfileImage != null && _addExistingPlayer!.result!.userProfileImage!.isNotEmpty?base64Decode( _addExistingPlayer!.result!.userProfileImage!):null,
                                                          title: _addExistingPlayer!.result!.userFirstName,
                                                          onPressed: (){
                                                            Navigation.navigateWithArgument(
                                                                context, MyRoutes.editExistingPlayerScreen, _addExistingPlayer!.result!.userIDNo??0);
                                                          },

                                                        );
                                                      },
                                                    )
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
              ),
            ),
          ],
        ),
      ),
    ));
  }


  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height * .80;

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: getValueForScreenType<bool>(
        context: context,
        mobile: false,
        tablet: true,
        desktop: true,
      )
          ? CustomSimpleAppBar(
              title: MyStrings.appName,
              iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
              iconRight: MyIcons.done,tooltipMessageRight: MyStrings.save,
              onClickRightImage: () {
                Navigator.of(context).pop();
              },
              onClickLeftImage: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      body: TopBar(
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
                child: Scaffold(
                    backgroundColor: MyColors.white,
                    appBar: CustomAppBar(
                      title: MyStrings.addPlayer,
                      iconRight:null,
                      iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
                      onClickRightImage: () {
                       /* Navigation.navigateWithArgument(
                            context, MyRoutes.editPlayersScreen, widget.userId);*/
                      },
                      onClickLeftImage: () {
                        Navigator.of(context).pop();
                      }
                    ),
                    body: SingleChildScrollView(
                      child: Consumer<RoasterListViewProvider>(
                          builder: (context, provider, _) {
                        return Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: SafeArea(
                            child: Container(
                              width: size.width,
                              constraints:
                                  BoxConstraints(minHeight: getValueForScreenType<bool>(
                                    context: context,
                                    mobile: false,
                                    tablet: true,
                                    desktop: true,
                                  )?size.height - 30:size.height/2),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        MarginSize.headerMarginVertical1,
                                    horizontal:
                                        MarginSize.headerMarginVertical1),
                                child: Row(
                                  children: <Widget>[

                                    Expanded(
                                        child: SizedBox(
                                          height: getValueForScreenType<bool>(
                                            context: context,
                                            mobile: false,
                                            tablet: true,
                                            desktop: true,
                                          )
                                              ? screenHeight
                                              : null,
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                getValueForScreenType<bool>(
                                              context: context,
                                              mobile: false,
                                              tablet: true,
                                              desktop: true,
                                            )
                                                    ? PaddingSize.headerPadding1
                                                    : PaddingSize
                                                        .headerPadding2),
                                            // EdgeInsets.symmetric(horizontal: PaddingSize.headerCardPadding),
                                            child: Column(
                                              mainAxisAlignment:
                                                  getValueForScreenType<bool>(
                                                context: context,
                                                mobile: false,
                                                tablet: true,
                                                desktop: true,
                                              )
                                                      ? MainAxisAlignment
                                                          .spaceAround
                                                      : MainAxisAlignment
                                                          .center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      getValueForScreenType<
                                                              bool>(
                                                    context: context,
                                                    mobile: false,
                                                    tablet: true,
                                                    desktop: true,
                                                  )
                                                          ? MainAxisAlignment
                                                              .start
                                                          : MainAxisAlignment
                                                              .center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                   /* Text(
                                                        MyStrings
                                                            .forgotPassword,
                                                        style: TextStyle(
                                                            fontSize: getValueForScreenType<
                                                                    bool>(
                                                              context: context,
                                                              mobile: false,
                                                              tablet: false,
                                                              desktop: true,
                                                            )
                                                                ? FontSize
                                                                    .headerFontSize1
                                                                : FontSize
                                                                    .headerFontSize2,
                                                            fontWeight: FontWeights
                                                                .headerFontWeight1,
                                                            color: MyColors
                                                                .kPrimaryColor)),*/
                                                   /* SizedBox(
                                                      height: SizedBoxSize
                                                          .standardSizedBoxHeight,
                                                      width: SizedBoxSize
                                                          .standardSizedBoxWidth,
                                                    ),*/
                                                    Text(
                                                      "Search by Email",
                                                      textAlign:
                                                          getValueForScreenType<
                                                                  bool>(
                                                        context: context,
                                                        mobile: true,
                                                        tablet: false,
                                                        desktop: false,
                                                      )
                                                              ? TextAlign.center
                                                              : TextAlign.start,
                                                      style: TextStyle(
                                                          //      fontSize: getValueForScreenType<bool>(
                                                          // context: context,
                                                          // mobile: false,
                                                          // tablet: false,
                                                          // desktop: true,) ? FontSize.headerFontSize3 : FontSize.headerFontSize4,
                                                          fontWeight: FontWeights
                                                              .headerFontWeight2),
                                                    ),
                                                    SizedBox(
                                                      height: SizedBoxSize
                                                          .standardSizedBoxHeight,
                                                      width: SizedBoxSize
                                                          .standardSizedBoxWidth,
                                                    ),
                                                    CustomizeTextFormField(
                                                      labelText:
                                                          MyStrings.email + "*",
                                                      prefixIcon:
                                                          MyIcons.username,
                                                      inputFormatter: [new LengthLimitingTextInputFormatter(100),],
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      controller: emailController,
                                                      validator: ValidateInput
                                                          .validateEmail,
                                                      inputAction: TextInputAction.done,
                                                      isLast: true,
                                                      isEnabled: true,
                                                      onSave: (value) {
                                                        emailController.text = value!;

                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: SizedBoxSize
                                                          .standardSizedBoxHeight,
                                                      width: SizedBoxSize
                                                          .standardSizedBoxWidth,
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  child: RaisedButtonCustom(
                                                      buttonWidth:
                                                          getValueForScreenType<
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
                                                      buttonColor: MyColors
                                                          .kPrimaryColor,
                                                      textColor: MyColors
                                                          .buttonTextColor,
                                                      splashColor:
                                                          MyColors.splash_color,
                                                      buttonText:
                                                          MyStrings.search,
                                                      onPressed:searchPlayer
                                                  ),
                                                ),
                                              ],
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
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Gender {
  final int id;
  final String name;

  Gender(
    this.id,
    this.name,
  );
}

List<Gender> getGender = <Gender>[
  Gender(
    1,
    MyStrings.male,
  ),
  Gender(
    2,
    MyStrings.female,
  ),
  Gender(
    3,
    MyStrings.others,
  ),
];



