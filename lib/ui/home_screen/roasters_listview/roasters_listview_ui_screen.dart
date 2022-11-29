import 'package:contacts_service/contacts_service.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smart_select/smart_select.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/add_player_response/add_existing_player_response.dart' as a;
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/roaster_listview_response/roaster_listview_response.dart' as r;
import 'package:spaid/model/response/roaster_listview_response/user_roles_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/create_team/create_team_ui.dart';
import 'package:spaid/ui/edit_player_screen/edit_players_screen_provider.dart';
import 'package:spaid/ui/home_screen/roasters_listview/roasters_listview_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_smart_button.dart';
import 'package:spaid/widgets/home_player_card.dart';

class RoastersListviewScreen extends StatefulWidget {
  @override
  _RoastersListviewScreenState createState() => _RoastersListviewScreenState();
}

class _RoastersListviewScreenState extends BaseState<RoastersListviewScreen> {
  //region Private Members
  String? _rolechosenValue, _rolechosenName;
  bool _isShowDial = false;

  RoasterListViewProvider? _roasterListViewProvider;
  List<r.UserDetails> _roasterListViewResponse=[];
  List<r.UserDetails> _roasterListViewFamilyResponse=[];
  String? _roleController,userID;
  TextEditingController searchController = new TextEditingController();
  String? filter;
  List<Result> _userRolesResponse=[];
  List<String> selectedIDs = [];
  List<int> userRoles = [Constants.teamPlayer,Constants.owner,Constants.coachorManager,Constants.nonPlayer];
  FocusNode _node = new FocusNode();
  bool showFilter = false;
  bool selectAll = true;
  bool isFamilySelect = true;
  bool showButton = true;
  bool? isLoading;
  EditPlayerProvider? _editplayerProvider;

//endregion

  /*
Return Type:
Input Parameters:
Use: Get team Members details.
 */
  getTeamList() async {
    _roleController = await SharedPrefManager.instance.getStringAsync(Constants.roleId);
    userID = await SharedPrefManager.instance.getStringAsync(Constants.userIdNo);
    _roasterListViewProvider!.listener = this;
    _editplayerProvider!.listener = this;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ProgressBar.instance.showProgressbar(context);
    });
   // _editplayerProvider.getExistingPlayer(int.parse(userID));
    _roasterListViewProvider!.getSelectTeamAsync();
    _roasterListViewProvider!.getRolesAsync();
  }
  @override
  void onRefresh(String type) {
    setState(() {
      isLoading=true;
      _roasterListViewProvider!.getSelectTeamAsync();
    });
  }
  @override
  void onSuccess(any, {required int reqId}) {

    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.GET_USER_ROLES:
        UserRolesResponse _response = any as UserRolesResponse;
        List<Result> response=[];
        _userRolesResponse=[];
        if (_response.responseResult == Constants.success) {
          setState(() {
            for(int i=0;i<_response.result!.length;i++){
              if(_response.result![i].RoleName !="Family Member"){
                response.add(_response.result![i]);

              }
            }
            for(int i=response.length;i>0;i--){
              _userRolesResponse.add(response[i-1]);
            }

          });
        } else if (_response.responseResult == Constants.failed) {
          // CodeSnippet.instance.showMsg(MyStrings.verifySignIn);
        } else {
          //CodeSnippet.instance.showMsg(MyStrings.signInFailed);
        }
        break;
      case ResponseIds.GET_TEAM_MEMBER_SCREEN:
        setState(() {
          isLoading=false;
        });
        _roasterListViewResponse=[];
        _roasterListViewFamilyResponse=[];
        r.RoasterListViewResponse _response = any as r.RoasterListViewResponse;
        if (_response.result!.teamIDNo != null) {
          for(int i=0;i<_response.result!.userDetails!.length;i++){
            if(_response.result!.userDetails![i].familyUserIDNo != null){
              _roasterListViewFamilyResponse.add(_response.result!.userDetails![i]);
            }/*else{
              _roasterListViewResponse.add(_response.userDetails[i]);
            }*/
          }
          for(int i=0;i<userRoles.length;i++){
            for(int j=0;j<_response.result!.userDetails!.length;j++){
              if(userRoles[i] ==_response.result!.userDetails![j].roleIdNo){
                _roasterListViewResponse.add(_response.result!.userDetails![j]);
              }
            }
          }
          // _roasterListViewProvider.setMemberList(_response.user.members);
          // print(_roasterListViewProvider.getTeamList.length);
          setState(() {
            //  _roleController = _response.user.roleIdNo;
            // CodeSnippet.instance.showMsg(MyStrings.signInSuccess);
            // totalContact = _listContactProvider.getTotalContact.toString();
          });
        } else if (_response.result!.ResponseResult == Constants.failed) {
          // CodeSnippet.instance.showMsg(MyStrings.verifySignIn);
        } else {
          //CodeSnippet.instance.showMsg(MyStrings.signInFailed);
        }
        break;
      case ResponseIds.ADD_EXISTING_PLAYER:
        a.AddExistingPlayerResponse _response = any as a.AddExistingPlayerResponse;
        if (_response.result != null && _response.result!.userIDNo != Constants.success) {
          setState(() {
            SharedPrefManager.instance.setStringAsync(
                Constants.userName, _response.result!.userFirstName!+" "+_response.result!.userLastName!);

          });
        }
        break;
    }
    super.onSuccess(any,reqId: 0);
  }

  @override
  void onFailure(BaseResponse error) {
    setState(() {
      isLoading=false;
    });
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }

  @override
  void initState() {
    super.initState();
    _roasterListViewProvider =
        Provider.of<RoasterListViewProvider>(context, listen: false);
    _editplayerProvider = Provider.of<EditPlayerProvider>(context, listen: false);

    searchController.addListener(() {
      setState(() {
        filter = _rolechosenValue;
      });
    });
    isLoading=true;

    getTeamList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickContact() async {
    try {
      final Contact contact = await ContactsService.openDeviceContactPicker(
          iOSLocalizedLabels: false);
      Navigation.navigateWithArgument(
          context, MyRoutes.addPlayerScreen, contact);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      _pickContact();
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  selectFileAsync() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);

      Navigation.navigateWithArgument(
          context, MyRoutes.playerContactListScreen, file);
    } else {
      // User canceled the picker
    }
  }

  /*
Return Type:Widget
Input Parameters:
Use: To create Listview Items.
 */
  Widget selectedPlayers(int index) {
    for(int i=0;i<_userRolesResponse.length;i++){
       // if((_userRolesResponse[i].isSelect && _userRolesResponse[i].RoleIDNo==_roasterListViewResponse[index].roleIdNo)|| (_roasterListViewResponse[index].playerInd==1&&_roasterListViewResponse[index].roleIdNo==Constants.coachorManager &&  _userRolesResponse[i].RoleIDNo==_roasterListViewResponse[index].roleIdNo )){
        if((_userRolesResponse[i].isSelect! && _userRolesResponse[i].RoleIDNo==_roasterListViewResponse[index].roleIdNo)){
          return PlayerListCard(
            roasterListViewFamilyResponse:isFamilySelect? _roasterListViewFamilyResponse:null,
            onTap: () {
              SharedPrefManager.instance
                  .setStringAsync(
                  Constants
                      .playerRoleId,
                  _roasterListViewResponse[index]
                      .UserRoleId.toString());
              // print('${_roasterListViewResponse.userDetails[index].userLastName.toString()}');
              Navigation.navigateWithArgument(
                  context, MyRoutes.playerProfile,
                  _roasterListViewResponse[index]
                      .userIdNo!);
            },
            calendarImageString:
            MyImages.team,
            groupText: '${_roasterListViewResponse[index].roleIdNo}' ==
                "-10001"
                ? MyStrings.ownerRole
                : '${_roasterListViewResponse[index].roleIdNo}' ==
                "-10002"
                ? MyStrings.managerRole
                : '${_roasterListViewResponse[index].roleIdNo}' ==
                "-10003"
                ? MyStrings
                .playerRole
                : '${_roasterListViewResponse[index].roleIdNo}' ==
                "-10004"
                ? MyStrings
                .nonPlayerRole
                : MyStrings
                .familyRole,
            titleText:
            '${_roasterListViewResponse[index].userFirstName! + " " + _roasterListViewResponse[index].userLastName!}',
            profileImageString:
            '${_roasterListViewResponse[index].userProfileImage}',
            descriptionText:
            '${_roasterListViewResponse[index].userFirstName! + " " + _roasterListViewResponse[index].userLastName!}',
            sponsorshipCountText:
            MyStrings.teamName,
            status: _roasterListViewResponse[index].PlayerAvailabilityStatusId,
            roleID: _roasterListViewResponse[index].roleIdNo,
            totalMatchesPlayed: _roasterListViewResponse[index].totalMatchesPlayed,
            totalGoals: _roasterListViewResponse[index].totalGoals,
            playerAssists: _roasterListViewResponse[index].playerAssists,
            totalPenalty: _roasterListViewResponse[index].totalPenalty,
            userRoleId: _roasterListViewResponse[index].UserRoleId,
            userID: _roasterListViewResponse[index].userIdNo,
            jersey: _roasterListViewResponse[index].UserJerseyNumber==null?"":_roasterListViewResponse[index].UserJerseyNumber,
            position: _roasterListViewResponse[index].UserGamePosition==null?"":_roasterListViewResponse[index].UserGamePosition,
            isRoleShow: int.parse(
                _roleController == null ? "0" : _roleController!) ==
                Constants.owner ||
                int.parse(_roleController == null ? "0" : _roleController!) ==
                    Constants.coachorManager,
            // userImageString: MyImages.team,
          );
        }

    }
    return Container();

  }


  @override
  Widget build(BuildContext context) {

    return WebCard(
      marginVertical: WidgetCustomSize.marginVertical,
      marginhorizontal: WidgetCustomSize.marginhorizontal,
      child: Padding(
        padding: EdgeInsets.all(getValueForScreenType<bool>(
          context: context,
          mobile: false,
          tablet: false,
          desktop: false,
        )
            ? PaddingSize.headerPadding1
            : PaddingSize.headerPadding2),
        child:isLoading!?SkeletonListView(): Scaffold(
          backgroundColor: MyColors.white,
          body: SingleChildScrollView(
            child: SafeArea(
              child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: _userRolesResponse != null && showFilter
                                  ? DropdownBelow(
                                      boxDecoration: BoxDecoration(
                                          color: MyColors.white,
                                          border: Border.all(
                                              color:
                                                  MyColors.kPrimaryLightColor)),
                                      itemWidth:
                                          WidgetCustomSize.boxDecorationwidth,
                                      icon: MyIcons.arrowdownIos,
                                      itemTextstyle: TextStyle(
                                          wordSpacing: 4,
                                          fontSize: FontSize.headerFontSize2,
                                          height: WidgetCustomSize
                                              .dropdownItemHeight,
                                          fontWeight:
                                              FontWeights.headerFontWeight2,
                                          color: Colors.black),
                                      boxTextstyle: TextStyle(
                                          decorationColor: MyColors.white,
                                          backgroundColor: MyColors.white,
                                          fontSize: FontSize.footerFontSize5,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.black),
                                      boxPadding: EdgeInsets.fromLTRB(
                                          PaddingSize.boxPaddingLeft,
                                          PaddingSize.boxPaddingTop,
                                          PaddingSize.boxPaddingRight,
                                          PaddingSize.boxPaddingBottom),
                                      boxWidth:
                                          WidgetCustomSize.boxDecorationwidth,
                                      boxHeight:
                                          WidgetCustomSize.dropdownBoxHeight,
                                      hint: Text(MyStrings.chooseRole,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2),
                                      value:
                                          int.tryParse(_rolechosenValue ?? ''),
                                      items: _userRolesResponse.map((value) {
                                        return new DropdownMenuItem<int>(
                                          value: value.RoleIDNo,
                                          child: new Text(value.RoleName!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() =>
                                            _rolechosenValue = val.toString());
                                        print(_rolechosenValue);
                                      },
                                    )
                                  : SizedBox(),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 20.0, 0.0),
                              child: Stack(
                                children: [
                                  _userRolesResponse != null ?Positioned(
                                    child: SizedBox(
                                  width: 40,
                                  height: 30,
                                  child: PopupMenuButton(
                                    icon: Icon(
                                      Icons.filter_alt_outlined,
                                      color: MyColors.kPrimaryColor,
                                    ),
                                    //color: MyColors.kPrimaryColor,

                                     offset: Offset(0, 60),
                                    shape: const TooltipShape(),
                                    tooltip: (MyStrings.filter),
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry>[
                                      // PopupMenuDivider(),
                                          /*  PopupMenuItem(
                                        value: 1,
                                        child: SizedBox(
                                          height: 40,
                                          child: CustomAppBar(
                                              title: "",
                                              iconRight: MyIcons.done,
                                              iconLeft: MyIcons.cancel, tooltipMessageLeft: MyStrings.cancel,
                                              onClickRightImage: () {
                                               setState(() {
                                                 Navigator.of(context).pop();

                                               });
                                              }),
                                        ),
                                      ),*/
                                      PopupMenuItem(

                                        value: 2,
                                        child: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                child: CustomAppBar(
                                                    onClickLeftImage: null,
                                                    leadingfalse: true,
                                                    tooltipMessageRight: MyStrings.ok,
                                                    iconLeft: null,
                                                    removeArrow:  true,
                                                    title: MyStrings.filter,
                                                    iconRight:selectAll? Icon(Icons.done,color: MyColors.white):Icon(Icons.done,color: MyColors.black),
                                                    // iconLeft: MyIcons.cancel, tooltipMessageLeft: MyStrings.cancel,
                                                    onClickRightImage: () {
                                                        setState(() {
                                                          getRefresh();
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                    }),
                                              ),
                                              SizedBox(
                                                height: 160,
                                                width: 150,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(0.0,PaddingSize.boxPaddingAllSide,0.0,0.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: SizedBoxSize
                                                                .checkSizedBoxHeight,
                                                            width: SizedBoxSize
                                                                .checkSizedBoxWidth,
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
                                                                value: selectAll,
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    selectAll = value!;
                                                                    showButton = value;
                                                                    for (int i = 0;
                                                                        i <
                                                                            _userRolesResponse
                                                                                .length;
                                                                        i++) {
                                                                      if (value) {
                                                                        _userRolesResponse[i]
                                                                                .isSelect =
                                                                            true;
                                                                      } else {
                                                                        _userRolesResponse[i]
                                                                                .isSelect =
                                                                            false;
                                                                      }
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 2),
                                                          Text("Select all"),
                                                          SizedBox(width: 1),
                                                        ],
                                                      ),
                                                      Divider(),
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            ClampingScrollPhysics(),
                                                        itemCount: _userRolesResponse.length,
                                                        itemBuilder: (context, index) {
                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height: SizedBoxSize
                                                                    .checkSizedBoxHeight,
                                                                width: SizedBoxSize
                                                                    .checkSizedBoxWidth,
                                                                child: Checkbox(
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
                                                                  value:
                                                                      _userRolesResponse[index]
                                                                          .isSelect,
                                                                  onChanged: (value) {
                                                                    setState(() {
                                                                    /*  if(_userRolesResponse
                                                                          .result[index]
                                                                          .RoleName=="Family Member"){
                                                                        isFamilySelect=value;

                                                                      }*/
                                                                      _userRolesResponse[index].isSelect = value!;
                                                                      for(int i=0;i<_userRolesResponse.length;i++){
                                                                        /*if(_userRolesResponse.result[i].isSelect==true){
                                                                          showButton=true;
                                                                        }*/
                                                                        if(_userRolesResponse[i].isSelect==false){
                                                                          selectAll = false;
                                                                          return;
                                                                        }else{
                                                                          selectAll = true;

                                                                        }
                                                                      }
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              SizedBox(width: 5),
                                                              Text(_userRolesResponse[index]
                                                                  .RoleName!),
                                                              SizedBox(width: 1),
                                                            ],
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                    /*  PopupMenuItem(
                                        value: 2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SmallRaisedButton(
                                              onPressed: () {
                                                      Navigator.of(context).pop();
                                              },
                                              buttonText: MyStrings.cancel,
                                              buttonWidth: getValueForScreenType<
                                                      bool>(
                                                context: context,
                                                mobile: true,
                                                tablet: false,
                                                desktop: false,
                                              )
                                                  ? 80
                                                  : size.width *
                                                      WidgetCustomSize
                                                          .raisedButtonWebWidth,
                                              buttonColor:
                                                  MyColors.controllerColor,
                                            ),
                                            SmallRaisedButton(
                                              onPressed: () {
                                                setState(() {
                                                      Navigator.of(context).pop();
                                                });
                                              },
                                              buttonText: "Ok",
                                              buttonWidth: getValueForScreenType<
                                                      bool>(
                                                context: context,
                                                mobile: true,
                                                tablet: false,
                                                desktop: false,
                                              )
                                                  ? 80
                                                  : size.width *
                                                      WidgetCustomSize
                                                          .raisedButtonWebWidth,
                                              //  buttonColor: MyColors.green,
                                            ),
                                          ],
                                        ),
                                      ),*/
                                    ],
                                  ),

                                  /*setState(() {
                                        if(showFilter){
                                          _rolechosenValue=null;
                                        }
                                        showFilter=showFilter==false?true:false;

                                      });*/
                                )):Container()
              ]
                              ),
                            ),
                          ],
                        ),

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
                        //           CupertinoPageScaffold(
                        //             child: Center(
                        //               child: CupertinoButton(
                        //                 onPressed: () {
                        //                   showCupertinoModalPopup<void>(
                        //                     context: context,
                        //                     builder: (BuildContext
                        //                     context) =>
                        //                         CupertinoActionSheet(
                        //                           actions: _userRolesResponse.result.map((value) =>
                        //                                 CupertinoActionSheetAction(
                        //                                     child:
                        //                                     new Text(value.RoleName),
                        //                                     onPressed: () {
                        //                                       setState(() {
                        //                                         _rolechosenValue = value.RoleIDNo.toString();
                        //                                         _rolechosenName = value.RoleName.toString();
                        //                                       } );
                        //                                       print(_rolechosenValue);
                        //                                       Navigator.of(context).pop();
                        //                                     }))
                        //                                 .toList(),
                        //
                        //                         ),
                        //                   );
                        //                 },
                        //                 child:  MyIcons.arrowIos,
                        //               ),
                        //             ),
                        //           )
                        //
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SmartSelect<String>.single(
                        //   title: MyStrings.familyRole,
                        //   placeholder: MyStrings.selectOne,
                        //   value: _rolechosenValue,
                        //   modalType: S2ModalType.popupDialog,
                        //   choiceType: S2ChoiceType.checkboxes,
                        //   onChange: (state) =>
                        //       setState(() => _rolechosenValue = state.value),
                        //   choiceItems: _choiceRepeat,
                        //   choiceDivider: true,
                        // ),
                        // Container(
                        //   child: DropdownButtonFormField(
                        //       items: <String>[
                        //         MyStrings.managerRole,
                        //         MyStrings.playerRole,
                        //         MyStrings.familyRole
                        //       ].map((String value) {
                        //         return new DropdownMenuItem<String>(
                        //           value: value,
                        //           child: new Text(value),
                        //         );
                        //       }).toList(),
                        //       onChanged: (value) {
                        //         // onSearchTextChanged(_rolechosenValue);
                        //         setState(() => _rolechosenValue = value);
                        //       },
                        //       value: _rolechosenValue,
                        //       decoration: InputDecoration(
                        //         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        //         hintText: MyStrings.chooseRole,
                        //         hintStyle: TextStyle(color: MyColors.colorGray_818181),
                        //         helperStyle:TextStyle(color: MyColors.colorGray_818181),
                        //         filled: true,
                        //         enabledBorder: const OutlineInputBorder(
                        //           borderSide: const BorderSide(color: Colors.white, width: 0.0),
                        //         ),
                        //         labelStyle: TextStyle(color: MyColors.colorGray_818181),
                        //       )),
                        // ),
                      ],
                    ),
                    _roasterListViewResponse != null
                        ? Padding(
                            padding: const EdgeInsets.all(
                                PaddingSize.boxPaddingAllSide),
                            child: Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _roasterListViewResponse.length ==
                                          null
                                      ? 0
                                      : _roasterListViewResponse.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return selectAll == true && _roasterListViewResponse.isNotEmpty
                                        ? PlayerListCard(
                                      roasterListViewFamilyResponse: _roasterListViewFamilyResponse,
                                      onTap: () {
                                        if(Constants.familyIds.length>0) {
                                          Constants.familyIds.clear();
                                        }
                                        for(int i=0;i<_roasterListViewFamilyResponse.length;i++){
                                          if(_roasterListViewFamilyResponse[i].familyUserIDNo==_roasterListViewResponse[index].UserRoleId){
                                            Constants.familyIds.add(_roasterListViewFamilyResponse[i].UserRoleId!);
                                          }
                                        }
                                        SharedPrefManager.instance
                                            .setStringAsync(
                                            Constants
                                                .playerRoleId,
                                            _roasterListViewResponse[index]
                                                .UserRoleId.toString());
                                              Navigation.navigateWithArgument(
                                                  context,
                                                  MyRoutes.playerProfile,
                                                  _roasterListViewResponse[index]
                                                      .userIdNo!);
                                            },
                                            calendarImageString: MyImages.team,
                                            groupText: '${_roasterListViewResponse[index].roleIdNo}' ==
                                                    "-10001"
                                                ? MyStrings.ownerRole
                                                : '${_roasterListViewResponse[index].roleIdNo}' ==
                                                        "-10002"
                                                    ? MyStrings.managerRole
                                                    : '${_roasterListViewResponse[index].roleIdNo}' ==
                                                            "-10003"
                                                        ? MyStrings.playerRole
                                                        : '${_roasterListViewResponse[index].roleIdNo}' ==
                                                                "-10004"
                                                            ? MyStrings
                                                                .nonPlayerRole
                                                            : MyStrings
                                                                .familyRole,
                                            titleText:
                                                '${_roasterListViewResponse[index].userFirstName! + " " + _roasterListViewResponse[index].userLastName!}',
                                            profileImageString:
                                                '${_roasterListViewResponse[index].userProfileImage}',
                                            descriptionText:
                                                '${_roasterListViewResponse[index].userFirstName! + " " + _roasterListViewResponse[index].userLastName!}',
                                            sponsorshipCountText:
                                                MyStrings.teamName,
                                            userImageString: MyImages.team,
                                      status: _roasterListViewResponse[index].PlayerAvailabilityStatusId,
                                      roleID: _roasterListViewResponse[index].roleIdNo,
                                      userRoleId: _roasterListViewResponse[index].UserRoleId,
                                      userID: _roasterListViewResponse[index].userIdNo,
                                      totalMatchesPlayed: _roasterListViewResponse[index].totalMatchesPlayed,
                                      totalGoals: _roasterListViewResponse[index].totalGoals,
                                      playerAssists: _roasterListViewResponse[index].playerAssists,
                                      totalPenalty: _roasterListViewResponse[index].totalPenalty,
                                      jersey: _roasterListViewResponse[index].UserJerseyNumber==null?"":_roasterListViewResponse[index].UserJerseyNumber,
                                      position: _roasterListViewResponse[index].UserGamePosition==null?"":_roasterListViewResponse[index].UserGamePosition,
                                      isRoleShow: int.parse(
                                          _roleController == null ? "0" : _roleController!) ==
                                          Constants.owner ||
                                          int.parse(_roleController == null ? "0" : _roleController!) ==
                                              Constants.coachorManager,
                                          )
                                        :selectedPlayers(index);
                                        // '_rolechosenValue.contains("${_roasterListViewProvider.getMemberList[index].roleIdNo}")'

                                  }),
                            ),
                          )
                        : SizedBox()
                    //     _roasterListViewProvider.getMemberList != null
                    // ? ListView.builder(
                    //    physics: NeverScrollableScrollPhysics(),
                    //     shrinkWrap: true,
                    //     itemCount: _roasterListViewProvider.getMemberList.length,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return PlayerListCard(
                    //         onTap: () {
                    //           Navigation.navigateWithArgument(context, MyRoutes.playerProfile,_roasterListViewProvider.getMemberList[index].userIdNo);
                    //         },
                    //         calendarImageString: MyImages.team,
                    //         groupText: '${_roasterListViewProvider.getMemberList[index].roleIdNo}' == "-10001" ? MyStrings.ownerRole : '${_roasterListViewProvider.getMemberList[index].roleIdNo}' == "-10002" ? MyStrings.managerRole : '${_roasterListViewProvider.getMemberList[index].roleIdNo}' == "-10003" ? MyStrings.playerRole : '${_roasterListViewProvider.getMemberList[index].roleIdNo}' == "-10004" ? MyStrings.nonPlayerRole: MyStrings.familyRole,
                    //         titleText: '${_roasterListViewProvider.getMemberList[index].userFirstName}',
                    //         profileImageString: MyImages.team,
                    //         descriptionText:'${_roasterListViewProvider.getMemberList[index].userFirstName}',
                    //         sponsorshipCountText: MyStrings.teamName,
                    //         userImageString: MyImages.team,
                    //       );
                    //     },
                    //   )
                    // : SizedBox()
                  ]),
            ),
          ),
          floatingActionButton: int.parse(
                          _roleController == null ? "0" : _roleController!) ==
                      Constants.owner ||
                  int.parse(_roleController == null ? "0" : _roleController!) ==
                      Constants.coachorManager
              ? SpeedDial(
                  foregroundColor: MyColors.white,
                  overlayColor: MyColors.colorGray_818181,
                  overlayOpacity: 0.5,
            // animatedIcon: AnimatedIcons.menu_arrow,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
                  backgroundColor: MyColors.kPrimaryColor,
                  children: [
                    SpeedDialChild(
                        child: MyIcons.add_white,
                        label: MyStrings.newMember,
                        backgroundColor: MyColors.kPrimaryColor,
                        onTap: () => Navigation.navigateTo(
                            context, MyRoutes.addPlayerScreen)),
                    if (!kIsWeb)
                      SpeedDialChild(
                          backgroundColor: MyColors.kPrimaryColor,
                          child: MyIcons.perm_contact_cal_white,
                          label: MyStrings.addContact,
                          onTap: () {
                            _askPermissions();
                          }),
                    if (kIsWeb)
                      SpeedDialChild(
                          backgroundColor: MyColors.kPrimaryColor,
                          child: MyIcons.article_white,
                          label: MyStrings.importContact,
                          onTap: () {
                            selectFileAsync();
                          }),
                    SpeedDialChild(
                        backgroundColor: MyColors.kPrimaryColor,
                        child: MyIcons.group_white,
                        label: MyStrings.addFromOtherTeam,
                        onTap: () => Navigation.navigateTo(
                            context, MyRoutes.addExistingPlayerScreen)),
                  ],
                  // child: MyIcons.more_vert,

                )
              // : Container(),
          :null,

        ),
      ),
    );
  }

  void getRefresh() {
    setState(() {

    });
  }
}

//Static data for Role
class UserRole {
  final int id;
  final String name;

  const UserRole(
    this.id,
    this.name,
  );
}

List<S2Choice<String>> _choiceRepeat = [
  //S2Choice<String>(value: '-10001', title: MyStrings.ownerRole),
  S2Choice<String>(value: '-10001', title: MyStrings.managerRole),
  S2Choice<String>(value: '-10002', title: MyStrings.playerRole),
  S2Choice<String>(value: '-10003', title: MyStrings.nonPlayerRole),
  S2Choice<String>(value: '-10004', title: MyStrings.familyRole),
];
const List<UserRole> getUserRole = <UserRole>[
  UserRole(
    -10001,
    'Coach/Manager',
  ),
  UserRole(
    -10002,
    'Player',
  ),
  UserRole(
    -10003,
    'Nonplayer',
  ),
  UserRole(
    -10004,
    'Family',
  ),
];
