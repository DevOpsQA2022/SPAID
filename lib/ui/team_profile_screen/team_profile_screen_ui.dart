import 'dart:convert';
import 'dart:typed_data';

import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smart_select/smart_select.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/select_team_response/new_select_team_response.dart';
import 'package:spaid/model/response/select_team_response/select_team_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/service/send_push_notification_service.dart';
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
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/add_player_screen/add_player_screen.dart';
import 'package:spaid/ui/player_profile_screen/player_profile_screen_provider.dart';
import 'package:spaid/ui/select_team_screen/select_team_screen_provider.dart';
import 'package:spaid/ui/signup_screen/signup_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_datepicker.dart';
import 'package:spaid/widgets/custom_editable_text.dart';
import 'package:spaid/widgets/custom_simple_appbar.dart';
import 'package:spaid/widgets/menu_screen_card.dart';
import 'package:spaid/widgets/player_profile_detail_card.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TeamProfileScreen extends StatefulWidget {
  final int userId;

  TeamProfileScreen(this.userId);

  @override
  _TeamProfileScreenState createState() => _TeamProfileScreenState();
}

String role = "";
String initialText = "";

class _TeamProfileScreenState extends BaseState<TeamProfileScreen> {
  @override
  List? userdata;
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  bool _isShowDial = false;
  bool _webDatePicker = false;
  bool _isEditingText = false;
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  PlayerProfileProvider? _playerProfileProvider;
  SignUpProvider? _signUpProvider;
  String? _firstNameController,
      _dobController,
      _phoneController,
      _addressController,
      _genderController;
  String? dateformat, first;
  FocusNode _node = new FocusNode();
  String? gender;
String? teamName,teamID,_roleController;
  Uint8List? teamImage;
  bool? isLoading;

  void _putProfile() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigation.navigateWithArgument(
          context,
          MyRoutes.homeScreen,
          0);
      // _signUpProvider.performSignup();
    }
  }

  @override
  void onFailure(BaseResponse error) {
    setState(() {
      isLoading = false;
    });
    // ProgressBar.instance.stopProgressBar();
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }

  SelectTeamProvider? _selectTeamProvider;
  ScrollController? _scrollController;
  NewSelectTeamResponse? _newSelectTeamResponse;

  //endregion

  getTeamsList() {
    //Future Purpose


    _selectTeamProvider!.listener = this;
    _selectTeamProvider!.getSelectTeamAsync(context);
  }

  /*
Return Type:
Input Parameters: SharedPrefManager used
Use: getRoleAsync with role getting.
 */
  getRoleAsync() async {
    try {
      teamName="${await SharedPrefManager.instance.getStringAsync(Constants.teamName)}";
      teamID="${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}";
      _roleController =
      await SharedPrefManager.instance.getStringAsync(Constants.roleId);
      getTeamsList();
      setState(() {});
    } catch (e) {
      _selectTeamProvider!.listener
          .onFailure(ExceptionErrorUtil.handleErrors(e));
    } //
  }

  Future<void> getCountryCodeAsync() async {
    first =
    "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    setState(() {
      dateformat = first;
      print(dateformat);
    });
  }

  @override
  void onSuccess(any, {int? reqId}) {
    setState(() {
      isLoading = false;
    });
    // ProgressBar.instance.stopProgressBar();
    switch (reqId) {
      case ResponseIds.GET_USER_TEAM:
        setState(() {
          _newSelectTeamResponse = any as NewSelectTeamResponse;
          for (int i = 0; i < _newSelectTeamResponse!.result!.userTeamList!.length; i++) {
            if (_newSelectTeamResponse!.result!.userTeamList![i].teamId ==
                int.parse(teamID!)) {
              teamImage =
              _newSelectTeamResponse!.result!.userTeamList![i].TeamProfileImage != null &&
                  _newSelectTeamResponse!.result!.userTeamList![i].TeamProfileImage!
                      .isNotEmpty
                  ? base64Decode(
                  _newSelectTeamResponse!.result!.userTeamList![i].TeamProfileImage!)
                  : null;
            }
          }
        });
        break;

    }
    super.onSuccess(any,reqId: 0);
  }

  @override
  void initState() {
    super.initState();



    _selectTeamProvider =
        Provider.of<SelectTeamProvider>(context, listen: false);
    _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    _scrollController = new ScrollController();
    _scrollController!.addListener(() => setState(() {}));
    isLoading=true;
    getRoleAsync();
    getCountryCodeAsync();
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController!.dispose();
  }


  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height * .87;
    final double screenHeights = MediaQuery
        .of(context)
        .size
        .height ;

    _isEditingText == true && _webDatePicker == true
        ? _isShowDial = false
        : null;

    // final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    Size size = MediaQuery
        .of(context)
        .size;
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
          var form = Form(
            key: _formKey,
            //             //Future Purpose
            //             // autovalidateMode: !provider.getAutoValidate
            //             //     ? AutovalidateMode.disabled
            //             //     : AutovalidateMode.always,
            //             autovalidate: !provider.getAutoValidate ? false : true,
            child: SafeArea(
              child: SingleChildScrollView(
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
                            mobile: true,
                            tablet: false,
                            desktop: false,
                          ) ? screenHeights : getValueForScreenType<bool>(
                            context: context,
                            mobile: false,
                            tablet: false,
                            desktop: true,
                          ) ? screenHeight : null,
                          child: isLoading! ? SkeletonListView() : Scaffold(
                            backgroundColor: MyColors.white,
                            body: Stack(
                              children: [
                                CustomScrollView(
                                  controller: _scrollController,
                                  slivers: <Widget>[
                                    SliverAppBar(
                                      pinned: _pinned,
                                      snap: _snap,
                                      floating: _floating,
                                      expandedHeight: 245.0,
                                      flexibleSpace:

                                      FlexibleSpaceBar(
                                        centerTitle: true,
                                        background:          Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          color: MyColors.kPrimaryColor,
                                          child: Stack(children: <Widget>[

                                            Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Stack(
                                                alignment: Alignment.topCenter,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(top: 120 / 2.0, ),  ///here we create space for the circle avatar to get ut of the box
                                                    child: Container(
                                                      height: 300.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15.0),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black26,
                                                            blurRadius: 8.0,
                                                            offset: Offset(0.0, 5.0),
                                                          ),
                                                        ],
                                                      ),
                                                      width: double.infinity,
                                                      child: Padding(
                                                          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                                                          child: Column(
                                                            children: <Widget>[
                                                              SizedBox(height: 110/2,),
                                                              Text( teamName == null
                                                                  ? ""
                                                                  : teamName!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),overflow: TextOverflow.ellipsis),
                                                              Text( _roleController==null
                                                                  ? ""
                                                                  :_roleController==Constants.owner.toString()?MyStrings.ownerRole
                                                                  :_roleController==Constants.coachorManager.toString()?MyStrings.managerRole
                                                                  :_roleController==Constants.teamPlayer.toString()?MyStrings.playerRole
                                                                  :_roleController==Constants.nonPlayer.toString()?MyStrings.nonPlayerRole
                                                                  :_roleController==Constants.familyMember.toString()?MyStrings.familyRole:"", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),),


                                                            ],
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 140,
                                                    height: 140,
                                                    decoration:
                                                    ShapeDecoration(shape: CircleBorder(), color: Colors.white),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child:teamImage != null? DecoratedBox(
                                                        decoration: ShapeDecoration(
                                                            shape: CircleBorder(),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: MemoryImage(teamImage!,)
                                                            )),
                                                      ):DecoratedBox(
                                                        decoration: ShapeDecoration(
                                                            shape: CircleBorder(),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                MyImages.noImageData,
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                        // Container(
                                        //   child:teamImage != null? Image.memory(
                                        //     teamImage,
                                        //     fit: BoxFit.cover,
                                        //   ):Container(),
                                        // ),
                                        // title: Column(
                                        //   mainAxisAlignment:
                                        //   MainAxisAlignment.end,
                                        //   children: [
                                        //    /* Text(
                                        //         _firstNameController == null
                                        //             ? "CSK"
                                        //             : _firstNameController),*/
                                        //     Text(
                                        //         teamName == null
                                        //             ? ""
                                        //             : teamName,
                                        //         style: TextStyle(
                                        //           fontSize:
                                        //           getValueForScreenType<
                                        //               bool>(
                                        //             context: context,
                                        //             mobile: false,
                                        //             tablet: false,
                                        //             desktop: true,)
                                        //               ? FontSize
                                        //               .footerFontSize6
                                        //               : FontSize
                                        //               .footerFontSize6,
                                        //         )),
                                        //   ],
                                        // ),

                                        // background: Image.network("https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1331&q=80",fit: BoxFit.cover,
                                      ),
                                      /*actions: [
                                        _isEditingText == true ? IconButton(
                                          icon: Icon(Icons.done),
                                          tooltip: MyStrings.tooltipSaveTodo,
                                          onPressed: () {
                                            _putProfile();
                                          },
                                        ) : SizedBox()
                                      ],*/
                                    ),
                                    SliverList(
                                      delegate: SliverChildListDelegate([
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: MarginSize
                                                  .headerMarginVertical1,
                                              horizontal: MarginSize
                                                  .headerMarginVertical1),
                                          child: Column(
                                            children: <Widget>[




                                               Column(
                                                children: [
                                                  Text(
                                                    MyStrings.selectTeam,
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                  _newSelectTeamResponse !=
                                                      null &&
                                                      _newSelectTeamResponse!.result!.userTeamList!.length >
                                                          0
                                                      ? ListView.builder(
                                                    physics:
                                                    NeverScrollableScrollPhysics(),
                                                    shrinkWrap:
                                                    true, // new
                                                    itemCount: _newSelectTeamResponse!.result!.userTeamList!
                                                        .length ==
                                                        null
                                                        ? 0
                                                        :_newSelectTeamResponse!.result!.userTeamList!.length,
                                                    itemBuilder:
                                                        (BuildContext
                                                    context,
                                                        int index) {
                                                      return MenuScreenCard(
                                                        icon: MyIcons.sport,
                                                        trailing: Text(_newSelectTeamResponse!.result!.userTeamList![index].roleName == null ? " " : _newSelectTeamResponse!.result!.userTeamList![index].roleName!,style: TextStyle(
                                                            letterSpacing: Dimens.letterSpacing_25,
                                                            color: MyColors.kPrimaryColor)),
                                                        image:_newSelectTeamResponse!.result!.userTeamList![index].TeamProfileImage != null?base64Decode(_newSelectTeamResponse!.result!.userTeamList![index].TeamProfileImage!):null,
                                                       // role:_newSelectTeamResponse.userTeamList[index].roleName=="CoachorManager"?"Coach/Manager":_newSelectTeamResponse.userTeamList[index].roleName,
                                                        title:
                                                        "${_newSelectTeamResponse!.result!.userTeamList![index].teamName}",
                                                        onPressed: () async {
                                                          SharedPrefManager.instance
                                                              .setStringAsync(
                                                              Constants
                                                                  .teamName,
                                                              _newSelectTeamResponse!.result!.userTeamList![
                                                              index]
                                                                  .teamName!);
                                                          SharedPrefManager.instance
                                                              .setStringAsync(
                                                              Constants
                                                                  .teamID,
                                                              _newSelectTeamResponse!.result!.userTeamList![
                                                              index]
                                                                  .teamId.toString());
                                                          SharedPrefManager.instance
                                                              .setStringAsync(
                                                              Constants
                                                                  .roleId,
                                                              _newSelectTeamResponse!.result!.userTeamList![
                                                              index]
                                                                  .roleIDNo.toString());
                                                          SharedPrefManager.instance
                                                              .setStringAsync(
                                                              Constants
                                                                  .teamImage,
                                                              _newSelectTeamResponse!.result!.userTeamList![
                                                              index]
                                                                  .TeamProfileImage.toString());
                                                          SharedPrefManager.instance
                                                              .setStringAsync(
                                                              Constants
                                                                  .teamCountry,
                                                              _newSelectTeamResponse!.result!.userTeamList![
                                                              index]
                                                                  .country.toString());
                                                          SharedPrefManager.instance
                                                              .setStringAsync(
                                                              Constants
                                                                  .userRoleId,
                                                              _newSelectTeamResponse!.result!.userTeamList![
                                                              index]
                                                                  .UserRoleID.toString());
                                                          if(_newSelectTeamResponse!.result!.userTeamList![
                                                          index]
                                                              .PlayerAvailabilityStatusId==Constants.mailNotSend){
                                                            _signUpProvider!.createAccountAsync("",_newSelectTeamResponse!.result!.userTeamList![
                                                            index]
                                                                .teamId.toString(),"",2,false,_newSelectTeamResponse!.result!.userTeamList![
                                                            index]
                                                                .UserRoleID!);
                                                            if(_newSelectTeamResponse!.result!.userTeamList![
                                                            index]
                                                                .roleIDNo != Constants.owner) {
                                                            EmailService().inits("Invite Accepted","",Constants.gameEventAccept,int.parse(await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)),int.parse(await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)),_newSelectTeamResponse!.result!.userTeamList![
                                                            index]
                                                                .teamId!,"You have accepted the invite to join the team, "+_newSelectTeamResponse!.result!.userTeamList![
                                                            index]
                                                                .teamName!+".","",_newSelectTeamResponse!.result!.userTeamList![
                                                            index]
                                                                .teamName!,"","",await SharedPrefManager.instance.getStringAsync(Constants.userName),"");
                                                           /* EmailService().inits("Invite Accepted","",AcceptToManager.acceptManager.replaceAll("{{managername}}", "").replaceAll("{{playername}}", await SharedPrefManager.instance.getStringAsync(Constants.userName)).replaceAll("{{teamname}}", _newSelectTeamResponse.userTeamList[
                                                            index]
                                                                .teamName),Constants.createTeam,int.parse(await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)),int.parse(await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)),_newSelectTeamResponse.userTeamList[
                                                            index]
                                                                .teamId,_newSelectTeamResponse.userTeamList[
                                                            index]
                                                                .teamName+" has accepted your invite to join the team, "+_newSelectTeamResponse.userTeamList[
                                                            index]
                                                                .teamName+".");*/




                                                              SendPushNotificationService().sendPushNotifications(
                                                                  await SharedPrefManager.instance.getStringAsync(Constants.FCM),
                                                                  "You have accepted the invite to join the team, "+_newSelectTeamResponse!.result!.userTeamList![
                                                                  index]
                                                                      .teamName!,"");
                                                            }

                                                          }

                                                          Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 0);
                                                          // context.vxNav.push(Uri.parse( MyRoutes.homeScreen),params: 0);
                                                          //Navigation.navigateWithArgument(context, MyRoutes.homeScreen,_selectTeamProvider.getTeamList[index].teamName);
                                                        },
                                                      );
                                                    },
                                                  )
                                                      : Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          Text(
                                                            MyStrings
                                                                .noTeamsAvailable,
                                                            style: TextStyle(
                                                              fontSize: FontSize
                                                                  .headerFontSize4,
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  SizedBox(height: 70,),

                                                ],
                                              )

                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            floatingActionButton: getValueForScreenType<bool>(
                            context: context,
          mobile: false,
          tablet: true,
          desktop: true,
          ) ? (_roleController==Constants.coachorManager.toString()||_roleController==Constants.owner.toString())?_getFloatingActionButton(): FloatingActionButton(
                              backgroundColor: MyColors.kPrimaryColor,
                              tooltip: MyStrings.createTeam,
                              disabledElevation: 3,
                              child: MyIcons.add_white,
                              onPressed: () {
                                setState(() {
                                  _isShowDial = false;
                                });
                                Navigator.of(context).pop();
                                Navigation.navigateWithArgument(context, MyRoutes.createTeamScreen,1);
                              },
                            ) : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          return form;
        }),
      ),
      floatingActionButton:
      getValueForScreenType<bool>(
        context: context,
        mobile: true,
        tablet: false,
        desktop: false,
      ) ?(_roleController==Constants.coachorManager.toString()||_roleController==Constants.owner.toString())? _getFloatingActionButton():FloatingActionButton(
        backgroundColor: MyColors.kPrimaryColor,
        tooltip: MyStrings.createTeam,
        disabledElevation: 3,
        child: MyIcons.add_white,
        onPressed: () {
          setState(() {
            _isShowDial = false;
          });
          Navigator.of(context).pop();
          Navigation.navigateWithArgument(context, MyRoutes.createTeamScreen,1);
        },
      ) : null,
    );
  }

  Widget _getFloatingActionButton() {
    return SpeedDialMenuButton(
      isEnableAnimation: true,
      //if needed to close the menu after clicking sub-FAB
      isShowSpeedDial: _isShowDial,
      //manually open or close menu
      updateSpeedDialStatus: (isShow) {
        //return any open or close change within the widget
        this._isShowDial = isShow;
      },
      //general init
      isMainFABMini: false,
      mainMenuFloatingActionButton: MainMenuFloatingActionButton(
          mini: false,
          heroTag: null,
          child: MyIcons.more_vert,
          onPressed: () {},
          foregroundColor: MyColors.white,
          backgroundColor: MyColors.kPrimaryColor,
          closeMenuChild: Icon(Icons.close),
          closeMenuForegroundColor: MyColors.white,
          closeMenuBackgroundColor: MyColors.kPrimaryColor),
      floatingActionButtonWidgetChildren: <FloatingActionButton>[
    // if(_roleController==Constants.coachorManager.toString()||_roleController==Constants.owner.toString())
    FloatingActionButton(
          backgroundColor: MyColors.kPrimaryColor,
          tooltip: MyStrings.editTeam,
          mini: true,
          child: MyIcons.edit_white,
          onPressed: () {
            setState(() {
              _isEditingText = true;
              _isShowDial = false;
            });
            Navigator.of(context).pop();
            Navigation.navigateWithArgument(context, MyRoutes.editTeamScreen, widget.userId);
          },
        ),
         FloatingActionButton(
           backgroundColor: MyColors.kPrimaryColor,
          tooltip: MyStrings.createTeam,
          mini: true,
          disabledElevation: 3,
          child: MyIcons.add_white,
          onPressed: () {
            setState(() {
              _isShowDial = false;
            });
            Navigator.of(context).pop();
            Navigation.navigateWithArgument(context, MyRoutes.createTeamScreen,1);
          },
        )
      ],
      isSpeedDialFABsMini: true,
      paddingBtwSpeedDialButton: 50.0,
    );
  }
}

class Language {
  final int id;
  final String name;

  const Language(this.id,
      this.name,);
}

List<S2Choice<String>> _choiceRepeat = [
  S2Choice<String>(value: '-10001', title: MyStrings.managerRole),
  S2Choice<String>(value: '-10002', title: MyStrings.playerRole),

  //Future Purpose

  /* S2Choice<String>(value: '-10001', title: MyStrings.ownerRole),
   S2Choice<String>(value: '-10003', title: MyStrings.nonPlayerRole),
  S2Choice<String>(value: '-10004', title: MyStrings.familyRole),*/
];
const List<Language> getLanguages = <Language>[
  Language(
    -10001,
    'Coach/Manager',
  ),
  Language(
    -10002,
    'Player',
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
