import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/request/select_drill_request/share_drill_request.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/select_team_response/new_select_team_response.dart';
import 'package:spaid/model/response/signin_response/signin_response.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/select_team_screen/select_team_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/menu_screen_card.dart';

class ShareDrillScreen extends StatefulWidget {
  //region Public Members

  ShareDrillRequest drill;

  ShareDrillScreen(this.drill);

//var data;
  //SelectTeamScreen(this.data);

  //endregion

  @override
  _ShareDrillScreenState createState() => _ShareDrillScreenState();
}

class _ShareDrillScreenState extends BaseState<ShareDrillScreen>
    with WidgetsBindingObserver {
  //region Private Members
  String? teamID;

  SelectTeamProvider? _selectTeamProvider;
  List<UserTeamList> userTeamList = [];
  SignInResponse? _signInResponse;

  // SignUpProvider? _signUpProvider;
  //endregion

  getTeamList() {
    //Future Purpose

    /*  WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressBar.instance.showProgressbar(context);
    });*/
    _selectTeamProvider!.getSelectTeamAsync(context);
  }

  /*
Return Type:
Input Parameters: SharedPrefManager used
Use: getRoleAsync with role getting.
 */
  getRoleAsync() async {
    try {
      teamID =
          await SharedPrefManager.instance.getStringAsync(Constants.teamID);
      print(teamID);
      getTeamList();
      setState(() {});
    } catch (e) {
      _selectTeamProvider!.listener
          .onFailure(ExceptionErrorUtil.handleErrors(e));
    } //
  }

  @override
  void onFailure(BaseResponse error) {
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }

  @override
  void onSuccess(any, {required int reqId}) {
    if (any == null) {
      setState(() {});
    } else {
      ProgressBar.instance.stopProgressBar(context);
      switch (reqId) {
        case ResponseIds.GET_USER_TEAM:
          setState(() {
            NewSelectTeamResponse _newSelectDrill =
                any as NewSelectTeamResponse;
            userTeamList = [];
            for (int i = 0; i < _newSelectDrill.result!.userTeamList!.length; i++) {
              if ((_newSelectDrill.result!.userTeamList![i].roleIDNo ==
                      Constants.coachorManager ||
                  _newSelectDrill.result!.userTeamList![i].roleIDNo ==
                      Constants.owner)) {
                userTeamList.add(_newSelectDrill.result!.userTeamList![i]);
              }
            }
          });
          /*if (response.status == Constants.success) {
            // _selectTeamProvider.setTeamList(response.user.team);
            print(_selectTeamProvider.getTeamList.length);
            setState(() {
              //Future Purpose

              // CodeSnippet.instance.showMsg(MyStrings.signInSuccess);
              // totalContact = _listContactProvider.getTotalContact.toString();
            });
          } else if (response.status == Constants.failed) {
            //CodeSnippet.instance.showMsg(MyStrings.verifySignIn);
          } else {
            // CodeSnippet.instance.showMsg(MyStrings.signInFailed);
          }*/
          break;
      }
    }
    super.onSuccess(any,reqId: 0);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _selectTeamProvider =
        Provider.of<SelectTeamProvider>(context, listen: false);
    // _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);

    _selectTeamProvider!.listener = this;
    /*if(widget.data != null){
      if(widget.data==0 || widget.data==1){
        widget.backScreenId=widget.data;
      }else if(widget.data.length>0){
        _selectTeamProvider.setTeamList(widget.data);

      }

    }*/
    getRoleAsync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  /*
Return Type:
Input Parameters: SharedPrefManager used
Use: Back button pressed Fancy dialog show .
 */
  /*Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => FancyDialog(
          gifPath: MyImages.team,
          okFun: () => {
           */ /* SharedPrefManager.instance
                .setStringAsync(Constants.userEmail, null),
            SharedPrefManager.instance
                .setStringAsync(Constants.rememberMe, null),
            SharedPrefManager.instance
                .setStringAsync(Constants.roleId, null),
            SharedPrefManager.instance
                .setStringAsync(Constants.teamName, null),
            SharedPrefManager.instance
                .setStringAsync(Constants.userIdNo, null),
           */ /* Navigator.of(context).pop(),
            SystemNavigator.pop(),
          },
          cancelColor: MyColors.red,
          cancelFun: () => {Navigator.of(context).pop()},
          title: MyStrings.conformExitApp,
        )) ??
        false;
  }*/

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TopBar(
      child: WebCard(
        marginVertical: 20,
        marginhorizontal: 40,
        child: Scaffold(
          backgroundColor: MyColors.white,
          appBar: CustomAppBar(
            // onClickLeftImage: null,
            leadingfalse: true,

            title: MyStrings.selectTeams,
            tooltipMessageRight: MyStrings.save,
            iconRight: MyIcons.done,
            iconLeft: MyIcons.backwardArrow,
            onClickLeftImage: () {
              Navigator.of(context).pop();
            },
            onClickRightImage: () {
              //NewSelectTeamResponse _newSelectDrill =  NewSelectTeamResponse();
              bool isSelect = false;
              for (int i = 0; i < userTeamList.length; i++) {
                if (userTeamList[i].isSelect!) {
                  isSelect = true;
                }
              }
              ;

              if (isSelect) {
                _selectTeamProvider!.shareDrillToTeams(
                    widget.drill, userTeamList);
                CodeSnippet.instance.showMsg("Shared Successfully");
                Navigator.of(context).pop();
              } else {
                CodeSnippet.instance.showMsg("Please select team");
              }
            },
            //removeArrow: widget.backScreenId != 1 ? true : false,
            /*onClickRightImage: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) => FancyDialog(
                          gifPath: MyImages.team,
                          okFun: () => {
                            SharedPrefManager.instance
                                .setStringAsync(Constants.userEmail, ""),
                            SharedPrefManager.instance
                                .setStringAsync(Constants.rememberMe, ""),
                            SharedPrefManager.instance
                                .setStringAsync(Constants.roleId, ""),
                            SharedPrefManager.instance
                                .setStringAsync(Constants.teamName, ""),
                            SharedPrefManager.instance
                                .setStringAsync(Constants.userIdNo, ""),
                            Navigator.of(context).pop(),
                            Navigation.navigatePushNamedAndRemoveAll(
                                context, MyRoutes.signIn),
                          },
                          cancelColor: MyColors.red,
                          cancelFun: () => {Navigator.of(context).pop()},
                          title: MyStrings.wantLogout,
                        ));
                  },*/
            tooltipMessageLeft: 'Back',
          ),
          body: SafeArea(
            child: Container(
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: MarginSize.headerMarginVertical1,
                          horizontal: MarginSize.headerMarginVertical1),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(children: [
                                Column(
                                  mainAxisAlignment:
                                      getValueForScreenType<bool>(
                                    context: context,
                                    mobile: false,
                                    tablet: true,
                                    desktop: true,
                                  )
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      getValueForScreenType<bool>(
                                    context: context,
                                    mobile: false,
                                    tablet: true,
                                    desktop: true,
                                  )
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.center,
                                  children: <Widget>[
                                    // if (isMobile(context))
                                    //Future Purpose

                                    //   SvgPicture.asset(
                                    //     MyImages.login,
                                    //     height: size.height * 0.3,
                                    //   ),
                                    // SizedBox(height: 30),
                                    // RichText(
                                    //     text: TextSpan(children: [
                                    //   TextSpan(
                                    //       text: "Select Team",
                                    //       style: TextStyle(
                                    //          fontSize: getValueForScreenType<bool>(
                                    // context: context,
                                    // mobile: false,
                                    // tablet: false,
                                    // desktop: true,) ? 40 : 22,
                                    //           fontWeight: FontWeight.w800,
                                    //           color: MyColors.kPrimaryColor)),
                                    // ])),
                                    userTeamList != null &&
                                            userTeamList.length > 0
                                        ? ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true, // new
                                            itemCount: userTeamList == null
                                                ? 0
                                                : userTeamList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return MenuScreenCard(
                                                icon: MyIcons.sport,
                                                trailing: SizedBox(
                                                  height: SizedBoxSize
                                                      .checkSizedBoxHeight,
                                                  width: SizedBoxSize
                                                      .checkSizedBoxWidth,
                                                  child: Theme(
                                                    data: ThemeData(
                                                      unselectedWidgetColor:
                                                          Colors.black,
                                                    ),
                                                    child: Checkbox(
                                                      hoverColor:
                                                          MyColors.transparent,
                                                      focusColor:
                                                          MyColors.transparent,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2.0),
                                                        side: BorderSide(
                                                          color: Colors.grey,
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      side: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.5,
                                                      ),
                                                      checkColor:
                                                          MyColors.black,
                                                      activeColor:
                                                          Colors.grey[400],
                                                      value: userTeamList[index]
                                                          .isSelect,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          userTeamList[index]
                                                              .isSelect = value!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                image: userTeamList[index]
                                                            .TeamProfileImage !=
                                                        null
                                                    ? base64Decode(
                                                        userTeamList[index]
                                                            .TeamProfileImage!)
                                                    : null,
                                                //role:_newSelectDrillResponse.userTeamList[index].roleName,
                                                title:
                                                    "${userTeamList[index].teamName}",
                                                onPressed: () async {
                                                  // context.vxNav.push(Uri.parse( MyRoutes.homeScreen),params: 0);
                                                  //Navigation.navigateWithArgument(context, MyRoutes.homeScreen,_selectTeamProvider.getTeamList[index].teamName);
                                                },
                                              );
                                            },
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                top: MarginSize
                                                    .headerMarginHeight1),
                                            child: Text(
                                              MyStrings.noTeamsAvailable,
                                              style: TextStyle(
                                                fontSize:
                                                    FontSize.headerFontSize4,
                                              ),
                                            )),
                                    //   SvgPicture.asset(
                                    //     MyImages.login,
                                    //     height: size.height * 0.3,
                                    //   ),
                                    // SizedBox(height: 30),
                                    // RichText(
                                    //     text: TextSpan(children: [
                                    //   TextSpan(
                                    //       text: "Select Team",
                                    //       style: TextStyle(
                                    //          fontSize: getValueForScreenType<bool>(
                                    //     context: context,
                                    //     mobile: false,
                                    //     tablet: false,
                                    //     desktop: true,) ? 40 : 22,
                                    //           fontWeight: FontWeight.w800,
                                    //           color: MyColors.kPrimaryColor)),
                                    // ])),
                                    //Future Purpose

                                    // : Center(child: Image.asset(MyImages.empty))
                                    //  : Center(child: Text("No Available Teams"))
                                  ],
                                ),
                              ]),
                            ),
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
    );
  }

  @override
  void onRefresh(String type) {
    // TODO: implement onRefresh
  }
}
