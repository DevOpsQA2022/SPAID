import 'dart:convert';

import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/edit_players_details_response/family_members_response.dart';
import 'package:spaid/model/response/player_profile_response/player_profile_response.dart';
import 'package:spaid/model/response/roaster_listview_response/team_members_details_response.dart';
import 'package:spaid/model/response/select_team_response/select_team_response.dart';
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
import 'package:spaid/ui/home_screen/roasters_listview/roasters_listview_screen_provider.dart';
import 'package:spaid/ui/player_profile_screen/player_profile_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_simple_appbar.dart';
import 'package:spaid/widgets/player_profile_detail_card.dart';

class PlayerProfileScreen extends StatefulWidget {
  final int userId;

  PlayerProfileScreen(this.userId);

  @override
  _PlayerProfileScreenState createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends BaseState<PlayerProfileScreen> {
  List? userdata;
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  bool _isShowDial = false;
  String _userRole="0",userid="0";
  String? userProfile,playerRoleId;
int? roleID;
  PlayerProfileProvider? _playerProfileProvider;
  RoasterListViewProvider? _roasterListViewProvider;
  FamilyMembersResponse? _familyMembersResponse;
  TeamMembersDetailsResponse? _playerProfileResponse;
  String? _firstNameController,
      _lastNameController,
      _dobController,
      _phoneController,
      _addressController,
      _genderController,
      _emailController;
  String? dateformat, first , profileName;

  getTeamList() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressBar.instance.showProgressbar(context);
    });
    _playerProfileProvider!.listener = this;
    _playerProfileProvider!.getSelectTeamAsync(widget.userId,"player");
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
  void onFailure(BaseResponse error) {
    ProgressBar.instance.stopProgressBar(context);
    //CodeSnippet.instance.showMsg(error.errorMessage);
  }

  @override
  void onSuccess(any, {required int reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.GET_USER_PROFILE:
        TeamMembersDetailsResponse _response = any as TeamMembersDetailsResponse;
        if (_response.result != null && _response.result!.userIdNo != Constants.success) {
          _playerProfileProvider!.getFamilyMembers(widget.userId,playerRoleId!);
          setState(() {
            // _playerProfileResponse=_response;
            _firstNameController = _response.result!.userFirstName;
            _lastNameController = _response.result!.userLastName;
            _genderController = _response.result!.userGender == null?"":_response.result!.userGender;
            _emailController = _response.result!.userEmailID;
            roleID=_response.result!.roleIdNo;
            DateFormat formatter = new DateFormat('yyyy-MM-dd');
            if(_response.result!.userDOB != null){
              DateTime dateTime = formatter.parse(_response.result!.userDOB!);
              _dobController = dateformat == "US"
                  ? DateFormat("MM/dd/yyyy").format((DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(dateTime))))
                  : dateformat == "CA"
                  ? DateFormat("yyyy/MM/dd").format((DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(dateTime))))
                  : DateFormat("dd/MM/yyyy").format((DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(dateTime))));
            }else{
              _dobController ="";
            }
            _phoneController = _response.result!.userPrimaryPhone != "0"?_response.result!.userPrimaryPhone.toString():"";
            _addressController =(_response.result!.userAddress1!.isNotEmpty? _response.result!.userAddress1!+",":"")+(_response.result!.userAddress2!.isNotEmpty?_response.result!.userAddress2!+",":"")+(_response.result!.userCity!.isNotEmpty?_response.result!.userCity!+",":"")+(_response.result!.userState!.isNotEmpty?_response.result!.userState!+",":"")+(_response.result!.userZip!.isNotEmpty?_response.result!.userZip!:"");
            userProfile = _response.result!.userProfileImage;

            // CodeSnippet.instance.showMsg(MyStrings.signInSuccess);
            // totalContact = _listContactProvider.getTotalContact.toString();
          });
        } /*else if (_response.status == Constants.failed) {
          //CodeSnippet.instance.showMsg(MyStrings.verifySignIn);
        } */else {
          //CodeSnippet.instance.showMsg(MyStrings.signInFailed);
        }
        break;
      case ResponseIds.REMOVE_PLAYER:
        ValidateUserResponse _validateUserResponse = any as ValidateUserResponse;
        if (_validateUserResponse.responseResult == Constants.success) {
          Navigation.navigateWithArgument(context, MyRoutes.homeScreen,Constants.navigateIdOne);


        } else if (_validateUserResponse.responseResult == Constants.failed) {
          // showError(_response.saveErrors[0].errorMessage);
          CodeSnippet.instance.showMsg(_validateUserResponse.saveErrors![0].errorMessage!);
        } else {
          //  CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
      case ResponseIds.GET_FAMILY_MEMBERS:
        FamilyMembersResponse _familyMembersResponse = any as FamilyMembersResponse;
        if (_familyMembersResponse.responseResult == Constants.success) {
          setState(() {
            this._familyMembersResponse=_familyMembersResponse;

          });

        }
        break;
    }
    super.onSuccess(any,reqId: 0);
  }

  @override
  void initState() {
    super.initState();
    _playerProfileProvider =
        Provider.of<PlayerProfileProvider>(context, listen: false);
    _roasterListViewProvider =
        Provider.of<RoasterListViewProvider>(context, listen: false);
    // _roasterListViewProvider.listener = this;

    _getDataAsync();
    getCountryCodeAsync();
  }
  _getDataAsync() async {
    try {
      _userRole = await SharedPrefManager.instance.getStringAsync(Constants.roleId);
      userid = await SharedPrefManager.instance.getStringAsync(Constants.userIdNo);
      playerRoleId = await SharedPrefManager.instance.getStringAsync(Constants.playerRoleId);
      getTeamList();

    } catch (e) {
      print(e);
    }
  }


  @override
  void dispose() {
    super.dispose();
  }
  /*
Return Type: bool
Input Parameters:
Use: Handle backpress action.
 */


// [SliverAppBar]s are typically used in [CustomScrollView.slivers], which in
// turn can be placed in a [Scaffold.body].
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        _roasterListViewProvider!.setRefreshScreen();
        Navigator.of(context).pop();
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
        )
            : null,
        body: TopBar(
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
                  child: Scaffold(
                    backgroundColor: MyColors.white,
                    body: CustomScrollView(

                                  slivers: <Widget>[
                                    SliverAppBar(
                                      pinned: _pinned,
                                      snap: _snap,
                                      floating: _floating,
                                      expandedHeight: 200.0,
                                      leading: IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        tooltip: 'Back',
                                        onPressed: () {
                                          _roasterListViewProvider!.setRefreshScreen();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      flexibleSpace: FlexibleSpaceBar(
                                        centerTitle: true,
                                        background:
                                        Container(
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
                                                          padding: const EdgeInsets.only(top: 15.0),
                                                          child: Column(
                                                            children: <Widget>[
                                                              SizedBox(height: 110/2,),

                                                              Text(_firstNameController == null ? "" : _firstNameController! +" "+ _lastNameController!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),overflow: TextOverflow.ellipsis),


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
                                                      child:userProfile != null && userProfile!.isNotEmpty? DecoratedBox(
                                                        decoration: ShapeDecoration(
                                                            shape: CircleBorder(),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: MemoryImage(base64Decode(userProfile!),)
                                                            )),
                                                      ):
                                                      DecoratedBox(
                                                        decoration: ShapeDecoration(
                                                            shape: CircleBorder(),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:AssetImage(
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
                                              ),
                                      // FlexibleSpaceBar(
                                      //   title: Text(
                                      //       _firstNameController == null ? "" : _firstNameController),
                                      // ),
                                    ),
                                    SliverList(
                                      delegate: SliverChildListDelegate([
                                        Container(
                                          margin: EdgeInsets.all(24),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              PlayerProfileDetailCard(
                                                height: Dimens.standard_100,
                                                calendarImageString: MyIcons.cake,
                                                groupText: MyStrings.dob,
                                                titleText: _dobController,
                                              ),
                                              PlayerProfileDetailCard(
                                                height: Dimens.standard_100,
                                                calendarImageString: MyIcons.face,
                                                groupText: MyStrings.gender,
                                                titleText: _genderController == "M"
                                                    ? MyStrings.male
                                                    : _genderController == "F"? MyStrings.female:_genderController == "O"?MyStrings.others:"",
                                              ),
                                              Text(
                                                MyStrings.contactPlayerInfo,
                                                style: TextStyle(
                                                    fontSize: 22, fontWeight: FontWeight.w500),
                                              ),
                                              PlayerProfileDetailCard(
                                                height: Dimens.standard_100,
                                                calendarImageString: MyIcons.phone,
                                                groupText: MyStrings.contactPhone,
                                                titleText: _phoneController,
                                              ),
                                              PlayerProfileDetailCard(
                                                height: Dimens.standard_100,
                                                calendarImageString: MyIcons.mail,
                                                groupText: MyStrings.email,
                                                titleText: _emailController,
                                              ),
                                              PlayerProfileDetailCard(
                                                height: Dimens.standard_180,
                                                calendarImageString: MyIcons.cancelj,
                                                groupText: MyStrings.address,
                                                titleText: _addressController,
                                              ),

                                              SizedBox(height: 20,),
                                              if(roleID!=Constants.familyMember)
                                              Text(
                                                MyStrings.contactFamilyInfo,
                                                style: TextStyle(
                                                    fontSize: 22, fontWeight: FontWeight.w500),
                                              ),
                                              roleID!=Constants.familyMember && _familyMembersResponse != null&& _familyMembersResponse!.result!.familyMemberList != null
                                                  ? ListView.builder(
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: _familyMembersResponse!.result!.familyMemberList!.length == null?0: _familyMembersResponse!.result!.familyMemberList!.length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        return FamilyProfileDetailCard(
                                                          calendarImageString: MyIcons.mail,
                                                          groupText:
                                                              '${_familyMembersResponse!.result!.familyMemberList![index].userEmailID}',
                                                          titleText:
                                                              '${_familyMembersResponse!.result!.familyMemberList![index].userFirstName}'+" "+'${_familyMembersResponse!.result!.familyMemberList![index].userLastName}',
                                                          profileImageString: MyImages.team,
                                                          descriptionText:
                                                              '${_familyMembersResponse!.result!.familyMemberList![index].userFirstName}',
                                                          sponsorshipCountText: MyStrings.teamName,
                                                          addressText:
                                                          (_familyMembersResponse!.result!.familyMemberList![index].userAddress1!.isNotEmpty?_familyMembersResponse!.result!.familyMemberList![index].userAddress1!+",":"")+(_familyMembersResponse!.result!.familyMemberList![index].userCity!.isNotEmpty?_familyMembersResponse!.result!.familyMemberList![index].userCity!+",":"")+(_familyMembersResponse!.result!.familyMemberList![index].userState!.isNotEmpty?_familyMembersResponse!.result!.familyMemberList![index].userState!+",":"")+(_familyMembersResponse!.result!.familyMemberList![index].userZip!.isNotEmpty?_familyMembersResponse!.result!.familyMemberList![index].userZip!+",":""),
                                                          phoneText:
                                                              '${_familyMembersResponse!.result!.familyMemberList![index].userPrimaryPhone}',
                                                          userImageString: MyImages.team,
                                                        );
                                                      },
                                                    )
                                                  : SizedBox(),
                                              SizedBox(height: 50,),
                                            ],
                                          ),
                                        )
                                      ]),
                                    ),
                                  ],
                                ),



                      floatingActionButton:(int.parse(_userRole)==Constants.owner || int.parse(_userRole)==Constants.coachorManager || widget.userId==int.parse(userid)) && (roleID != Constants.owner && (int.parse(_userRole)==Constants.owner || int.parse(_userRole)==Constants.coachorManager))?_getFloatingActionButton() :int.parse(_userRole)==Constants.owner || int.parse(_userRole)==Constants.coachorManager || widget.userId==int.parse(userid)? _getFloatingActionButtonOwner():Container(),

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _getFloatingActionButtonOwner() {
    return  FloatingActionButton(
      child: MyIcons.edit,
      tooltip: MyStrings.editPlayer,
      foregroundColor:MyColors.white ,
      backgroundColor: MyColors.kPrimaryColor,
      onPressed: () {
        setState(() {
          _isShowDial=false;
          if(Constants.familyIds.length>0) {
            Constants.familyIds.clear();
          }
          for(int i=0;i<_familyMembersResponse!.result!.familyMemberList!.length;i++){
            Constants.familyIds.add(_familyMembersResponse!.result!.familyMemberList![i].userRoleID!);
          }
        });
        Navigator.of(context).pop();
        Navigation.navigateWithArgument(
            context, MyRoutes.editPlayersScreen, widget.userId);
      },
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
          child: MyIcons.more_vert,
          foregroundColor:MyColors.white ,
          onPressed: () {},
          backgroundColor: MyColors.kPrimaryColor,
          closeMenuChild: Icon(Icons.close,color: MyColors.white,),
          closeMenuForegroundColor: MyColors.white,
          closeMenuBackgroundColor: MyColors.kPrimaryColor),
      floatingActionButtonWidgetChildren: <FloatingActionButton>[
        FloatingActionButton(
          mini: true,
          child: MyIcons.edit,
          tooltip: MyStrings.editPlayer,
          foregroundColor:MyColors.white ,
          backgroundColor: MyColors.kPrimaryColor,
          onPressed: () {
            setState(() {
              _isShowDial=false;
              if(Constants.familyIds.length>0) {
                Constants.familyIds.clear();
              }
              for(int i=0;i<_familyMembersResponse!.result!.familyMemberList!.length;i++){
                  Constants.familyIds.add(_familyMembersResponse!.result!.familyMemberList![i].userRoleID!);
              }
            });
            Navigator.of(context).pop();
            Navigation.navigateWithArgument(
                context, MyRoutes.editPlayersScreen, widget.userId);
          },
        ),
        if(roleID != Constants.owner && (int.parse(_userRole)==Constants.owner || int.parse(_userRole)==Constants.coachorManager))
        FloatingActionButton(
          mini: true,
          heroTag: null,
          foregroundColor:MyColors.white ,
          backgroundColor: MyColors.kPrimaryColor,
          disabledElevation: 3,
          child: MyIcons.delete,
          tooltip: MyStrings.delete,
          onPressed: () {
            setState(() {
              _isShowDial=false;

              });
              _onPressed();
              //Navigation.navigateTo(context, MyRoutes.teamSetupScreen);
            },
          ),
        ],
        isSpeedDialFABsMini: true,

        paddingBtwSpeedDialButton: 50.0,
      );
  }

  /*
Return Type:
Input Parameters:
Use:To handle backpress action.
 */
  void _onPressed() {
    FocusScope.of(context).requestFocus(FocusNode());
     showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => FancyDialog(
          gifPath: MyImages.team,
          okFun: () async => {
            Navigator.of(context).pop(),
            if(_familyMembersResponse!.result!.familyMemberList!.length != null && _familyMembersResponse!.result!.familyMemberList!.isNotEmpty){
              for(int i=0;i<_familyMembersResponse!.result!.familyMemberList!.length;i++){
                await _playerProfileProvider!.deleteMemberAsync(_familyMembersResponse!.result!.familyMemberList![i].userIdNo!,_familyMembersResponse!.result!.familyMemberList![i].userRoleID!,0),
              }
            },
            await _playerProfileProvider!.deleteMemberAsync(widget.userId,int.parse(playerRoleId!),1),

          },
          cancelFun: () => {Navigator.of(context).pop()},
          cancelColor: MyColors.red,
          title: MyStrings.conformDelete,
        ));
  }
}


