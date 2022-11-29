import 'dart:convert';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/select_team_response/new_select_team_response.dart';
import 'package:spaid/model/response/select_team_response/select_team_response.dart';
import 'package:spaid/model/response/signin_response/signin_response.dart';
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
import 'package:spaid/ui/select_team_screen/select_team_screen_provider.dart';
import 'package:spaid/ui/signup_screen/signup_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_simple_appbar.dart';
import 'package:spaid/widgets/menu_screen_card.dart';

class SelectTeamScreen extends StatefulWidget {
  //region Public Members

  int backScreenId = 0;

//var data;
  //SelectTeamScreen(this.data);

  //endregion

  @override
  _SelectTeamScreenState createState() => _SelectTeamScreenState();
}

String? role;

class _SelectTeamScreenState extends BaseState<SelectTeamScreen> with WidgetsBindingObserver {
  //region Private Members

  SelectTeamProvider? _selectTeamProvider;
  NewSelectTeamResponse? _newSelectTeamResponse;
  SignInResponse? _signInResponse;
  bool? isLoading;
  SignUpProvider? _signUpProvider;
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
      role = await SharedPrefManager.instance.getStringAsync(Constants.roleId);
      getTeamList();
      setState(() {});
    } catch (e) {
      _selectTeamProvider!.listener
          .onFailure(ExceptionErrorUtil.handleErrors(e));
    } //
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
  void onSuccess(any, {required int reqId}) {
    setState(() {
      isLoading=false;
    });
    if(any==null) {
      setState(() {

      });
    }else {
      ProgressBar.instance.stopProgressBar(context);
      switch (reqId) {
        case ResponseIds.GET_USER_TEAM:
          setState(() {
            _newSelectTeamResponse = any as NewSelectTeamResponse;

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
    _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);

    _selectTeamProvider!.listener = this;
    isLoading=true;
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
      setState(() {

      });

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
  void _onBackPressed() {
     showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => FancyDialog(
          gifPath: MyImages.team,
          okFun: () async => {
            await SharedPrefManager.instance
                .setStringAsync(Constants.userEmail, ""),
            await SharedPrefManager.instance
                .setStringAsync(Constants.rememberMe, ""),
            await SharedPrefManager.instance
                .setStringAsync(Constants.roleId, ""),
            await SharedPrefManager.instance
                .setStringAsync(Constants.teamName, ""),
            await SharedPrefManager.instance
                .setStringAsync(Constants.userIdNo, ""),
            Navigator.of(context).pop(),
            Navigation.navigatePushNamedAndRemoveAll(
                context, MyRoutes.introScreen),
            await GoogleSignIn().signOut(),
          },
          cancelColor: MyColors.red,
          cancelFun: () => {Navigator.of(context).pop()},
          title: MyStrings.wantLogout,
        )) ;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        if (widget.backScreenId == 1) {
          Navigator.of(context).pop();
        } else {
          _onBackPressed();
        }
        //we need to return a future
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
        ) : null,
        body: TopBar(
          child:Row(
            children:<Widget> [
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
                  child:Scaffold(
                      backgroundColor: MyColors.white,
                      appBar: CustomAppBar(
                          onClickLeftImage: null,
                          leadingfalse: true,

                          title: MyStrings.selectTeam,
                          tooltipMessageRight: MyStrings.logOut,
                          iconRight: widget.backScreenId != 1 ? MyIcons.exitToApp : null,
                          iconLeft: widget.backScreenId == 1 ? MyIcons.backwardArrow : null,
                          removeArrow: widget.backScreenId != 1 ? true : false,
                          onClickRightImage: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => FancyDialog(
                                  gifPath: MyImages.team,
                                  okFun: () async => {
                                    await SharedPrefManager.instance
                                        .setStringAsync(Constants.userEmail, ""),
                                    await SharedPrefManager.instance
                                        .setStringAsync(Constants.rememberMe, ""),
                                    await SharedPrefManager.instance
                                        .setStringAsync(Constants.roleId, ""),
                                    await SharedPrefManager.instance
                                        .setStringAsync(Constants.teamName, ""),
                                    await SharedPrefManager.instance
                                        .setStringAsync(Constants.userIdNo, ""),
                                    Navigator.of(context).pop(),
                                    Navigation.navigatePushNamedAndRemoveAll(
                                        context, MyRoutes.introScreen),
                                    await GoogleSignIn().signOut(),
                                  },
                                  cancelColor: MyColors.red,
                                  cancelFun: () => {Navigator.of(context).pop()},
                                  title: MyStrings.wantLogout,
                                ));
                          }),
                      body: isLoading!?SkeletonListView():SafeArea(
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
                                              mainAxisAlignment: getValueForScreenType<bool>(
                                                context: context,
                                                mobile: false,
                                                tablet: true,
                                                desktop: true,)
                                                  ? MainAxisAlignment.start
                                                  : MainAxisAlignment.center,
                                              crossAxisAlignment: getValueForScreenType<bool>(
                                                context: context,
                                                mobile: false,
                                                tablet: true,
                                                desktop: true,)
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
                                                _newSelectTeamResponse !=
                                                    null &&
                                                    _newSelectTeamResponse!.result!.userTeamList!.length >
                                                        0
                                                    ? ListView.builder(
                                                  physics:
                                                  NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true, // new
                                                  itemCount: _newSelectTeamResponse!.result!.userTeamList!
                                                      .length ==
                                                      null
                                                      ? 0
                                                      :_newSelectTeamResponse!.result!.userTeamList!.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                      int index) {
                                                    return MenuScreenCard(
                                                      icon: MyIcons.sport,
                                                      trailing: Text(_newSelectTeamResponse!.result!.userTeamList![index].roleName == null ? " " : _newSelectTeamResponse!.result!.userTeamList![index].roleName!,style: TextStyle(
                                                          letterSpacing: Dimens.letterSpacing_25,
                                                          color: MyColors.kPrimaryColor)),
                                                      image:_newSelectTeamResponse!.result!.userTeamList![index].TeamProfileImage != null?base64Decode(_newSelectTeamResponse!.result!.userTeamList![index].TeamProfileImage!):null,
                                                      //role:_newSelectTeamResponse.userTeamList[index].roleName,
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
                                                          EmailService().inits("Invite Accepted","",Constants.gameEventAcceptManager,int.parse(await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)),_newSelectTeamResponse!.result!.userTeamList![
                                                          index]
                                                              .userId!,_newSelectTeamResponse!.result!.userTeamList![
                                                          index]
                                                              .teamId!,await SharedPrefManager.instance.getStringAsync(Constants.userName)+" has accepted your invite to join the team, "+_newSelectTeamResponse!.result!.userTeamList![
                                                          index]
                                                              .teamName!+".",_newSelectTeamResponse!.result!.userTeamList![
                                                          index]
                                                              .email!,"","","",await SharedPrefManager.instance.getStringAsync(Constants.userName)+" has accepted your invitation to join the team, "+_newSelectTeamResponse!.result!.userTeamList![
                                                          index]
                                                              .teamName!,_newSelectTeamResponse!.result!.userTeamList![
                                                          index]
                                                              .name!);





                                                          SendPushNotificationService().sendPushNotifications(
                                                        await SharedPrefManager.instance.getStringAsync(Constants.FCM),
                                                        "You have accepted the invite to join the team, "+_newSelectTeamResponse!.result!.userTeamList![
                                                        index]
                                                            .teamName!,"");

                                                          SendPushNotificationService().sendPushNotifications(
                                                              _newSelectTeamResponse!.result!.userTeamList![
                                                              index]
                                                                  .fcm!,
                                                              await SharedPrefManager.instance.getStringAsync(Constants.userName)+" has accepted your invite to join the team, "+_newSelectTeamResponse!.result!.userTeamList![
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
                                                    margin: EdgeInsets.only(
                                                        top: MarginSize
                                                            .headerMarginHeight1),
                                                    child: Text(
                                                      MyStrings.noTeamsAvailable,
                                                      style: TextStyle(
                                                        fontSize: FontSize
                                                            .headerFontSize4,
                                                      ),
                                                    )),
                                                SizedBox(height: 40,),
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
                      floatingActionButton: FloatingActionButton(
                        tooltip: MyStrings.createTeam,
                        backgroundColor: MyColors.kPrimaryColor,
                        onPressed: () =>
                        {
                          Navigation.navigateWithArgument(context, MyRoutes.createTeamScreen,0)
                        },
                        child:  MyIcons.add_white,
                      )

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
