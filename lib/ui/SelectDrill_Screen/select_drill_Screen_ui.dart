
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/select_drill_response/select_drill_response.dart';
import 'package:spaid/model/response/signin_response/signin_response.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/Drill_Screen_Card.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_loader.dart';
import 'package:spaid/widgets/custom_simple_appbar.dart';
import 'package:spaid/widgets/customize_text_field.dart';

import 'select_drill_screen_provider.dart';

class SelectDrillScreen extends StatefulWidget {
  //region Public Members

  int backScreenId = 0;

//var data;
  //SelectDrillScreen(this.data);

  //endregion

  @override
  _SelectDrillScreenState createState() => _SelectDrillScreenState();
}

String? role;

class _SelectDrillScreenState extends BaseState<SelectDrillScreen>
    with WidgetsBindingObserver {
  //region Private Members
  bool? _isShowing;
  BuildContext? popupContext;
  SelectDrillProvider? _selectDrillProvider;
  GetAllDrillPlanResponse? _newSelectDrillResponse;
  SignInResponse? _signInResponse;
  final _formKey = GlobalKey<FormState>();
  TextEditingController drillPlanNameController=TextEditingController();

  // SignUpProvider? _signUpProvider;
  //endregion

  getTeamList() {
    //Future Purpose

    /*  WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressBar.instance.showProgressbar(context);
    });*/
    // ProgressBar.instance.showProgressbar(context);

    showProgressbar();
    _selectDrillProvider!.getSelectUserAsync(context);
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
      _selectDrillProvider!.listener
          .onFailure(ExceptionErrorUtil.handleErrors(e));
    } //
  }

  @override
  void onFailure(BaseResponse error) {
    // ProgressBar.instance.stopProgressBar(context);
    stopProgressBar();
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }

  @override
  void onSuccess(any, {required int reqId}) {
    stopProgressBar();
    if (any == null) {
      setState(() {});
    } else {
      // ProgressBar.instance.stopProgressBar(context);
      switch (reqId) {
        case ResponseIds.GET_DRILL_PLAN_SCREEN:
          setState(() {
            _newSelectDrillResponse = any as GetAllDrillPlanResponse;
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
  void showProgressbar() {
    _isShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        popupContext = context;
        /*if(!_isShowing) {
          Navigator.of(context).pop();
        }*/
        return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CustomLoader());
      },
    );
  }

  void stopProgressBar() {
    if(popupContext != null)
      Navigator.of(popupContext!).pop();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _selectDrillProvider =
        Provider.of<SelectDrillProvider>(context, listen: false);
    // _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);

    _selectDrillProvider!.listener = this;
    drillPlanNameController=TextEditingController();
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

                title: MyStrings.selectDrill,
                tooltipMessageRight: MyStrings.save,
                iconRight: null,
                iconLeft: MyIcons.backwardArrow,
                onClickLeftImage: () {
                  Navigator.of(context).pop();
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
            floatingActionButton: FloatingActionButton(
              tooltip: MyStrings.tooltipShare,
              onPressed: () {
                bool isSelect=false;
                for(int i=0;i<_newSelectDrillResponse!.result!.allDrillPlanList!.length;i++){
                  if(_newSelectDrillResponse!.result!.allDrillPlanList![i].isSelected!){
                    isSelect=true;
                  }};
                if(isSelect){
                  shareDrillPopupDialog();
                }else{
                  CodeSnippet.instance.showMsg("Select drill");

                }
              },
              backgroundColor: MyColors.kPrimaryColor,
              child: const Icon(Icons.share,color: MyColors.white,),
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
                              horizontal:
                                  MarginSize.headerMarginVertical1),
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
                                        _newSelectDrillResponse != null &&
                                                _newSelectDrillResponse!
                                                        .result!.allDrillPlanList!
                                                        .length >
                                                    0
                                            ? ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true, // new
                                                itemCount: _newSelectDrillResponse!
                                                            .result!.allDrillPlanList!
                                                            .length ==
                                                        null
                                                    ? 0
                                                    : _newSelectDrillResponse!
                                                        .result!.allDrillPlanList!
                                                        .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return DrillScreenCard(

                                                    icon: MyIcons.sport,
                                                    trailing: SizedBox(
                                                      height: SizedBoxSize
                                                          .checkSizedBoxHeight,
                                                      width:
                                                      SizedBoxSize.checkSizedBoxWidth,
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

                                                          value: _newSelectDrillResponse!.result!.allDrillPlanList![index].isSelected,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _newSelectDrillResponse!.result!.allDrillPlanList![index].isSelected = value!;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    // image:_newSelectDrillResponse!.allDrillPlanList![index]! != null?base64Decode(_newSelectDrillResponse!.userTeamList![index].TeamProfileImage!):null,
                                                    // role:_newSelectDrillResponse.userTeamList[index].roleName,
                                                    title: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            _newSelectDrillResponse!.result!.allDrillPlanList![
                                                                            index]
                                                                        .categoryDescription ==
                                                                    null
                                                                ? " "
                                                                : _newSelectDrillResponse!
                                                                    .result!.allDrillPlanList![
                                                                        index]
                                                                    .categoryDescription!,
                                                            style: TextStyle(
                                                                letterSpacing:
                                                                    Dimens
                                                                        .letterSpacing_25,
                                                                color: MyColors
                                                                    .kPrimaryColor)),
                                                        Text(
                                                            _newSelectDrillResponse!
                                                                        .result!.allDrillPlanList![
                                                                            index]
                                                                        .planDescription ==
                                                                    null
                                                                ? " "
                                                                : _newSelectDrillResponse!
                                                                    .result!.allDrillPlanList![
                                                                        index]
                                                                    .planDescription!,
                                                            style: TextStyle(
                                                                letterSpacing:
                                                                    Dimens
                                                                        .letterSpacing_25,
                                                                color: MyColors
                                                                    .kPrimaryColor))
                                                      ],
                                                    ),
                                                    onPressed:
                                                        () {
                                                          SharedPrefManager.instance.setStringAsync(
                                                              Constants.teamDrillPlanId, _newSelectDrillResponse!
                                                              .result!.allDrillPlanList![
                                                          index]
                                                              .teamDrillPlanId.toString());
                                                          SharedPrefManager.instance.setStringAsync(
                                                              Constants.teamDrillCategoryId, _newSelectDrillResponse!
                                                              .result!.allDrillPlanList![
                                                          index]
                                                              .teamDrillCategoryId.toString());
                                                          Constant.isEditDrill = 0;
                                                          Navigation.navigateWithArgument(context, MyRoutes.coachHomeScreen,0);

                                                        },
                                                  );
                                                },
                                              )
                                            : Container(
                                                margin: EdgeInsets.only(
                                                    top: MarginSize
                                                        .headerMarginHeight1),
                                                child: Text(
                                                  MyStrings
                                                      .noDrill,
                                                  style: TextStyle(
                                                    fontSize: FontSize
                                                        .headerFontSize4,
                                                  ),
                                                )),

                                        SizedBox(height: 40,)
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
             /* floatingActionButton: new FloatingActionButton(
                  elevation: 0.0,
                  child: new Icon(
                    Icons.arrow_forward,
                    color: MyColors.white,
                  ),
                  backgroundColor: (MyColors.kPrimaryColor),
                  onPressed: () {
                    Navigation.navigateWithArgument(
                        context, MyRoutes.homeScreen, 1);
                  })*/),
        ),

    );
  }


  shareDrillPopupDialog() async {
    //bool valteam1 = false, valteam2 = false;
    bool isSelect =false;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctxt) => Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: SingleChildScrollView(
            child: new FancyDialog(
              appbar: AppBar(
                  backgroundColor:
                  MyColors.kPrimaryColor,
                  automaticallyImplyLeading:
                  false,
                  title: IntrinsicHeight(
                      child: new Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .start,
                        children: <Widget>[
                          Image.asset(
                            MyImages.spaid_logo,
                            width: 60,
                          ),
                          VerticalDivider(
                            color: Colors.grey,
                            thickness: 2,
                          ),
                          Expanded(
                              child: Text(
                                "Drills",
                                style: TextStyle(
                                    fontSize: 15),
                                overflow: TextOverflow
                                    .ellipsis,
                              )),
                        ],
                      ))),
              gifPath: MyImages.team,
              title: "",
              cancelColor: MyColors.red,
              cancelFun: (){
                Navigator.of(ctxt).pop();

              },
              okFun: () => {
                if (_formKey.currentState!
                    .validate())
                  {

                    _selectDrillProvider!.shareDrill(ctxt,drillPlanNameController.text,_newSelectDrillResponse!),
                    drillPlanNameController.clear(),
            Navigator.of(ctxt).pop(),

          }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: CustomizeTextFormField(
                      controller: drillPlanNameController,
                      labelText:MyStrings.drillPlanName+"*",
                      inputAction: TextInputAction.done,
                      inputFormatter: [new LengthLimitingTextInputFormatter(25),],
                      isLast: true,
                      validator: ValidateInput.requiredDrillPlanFields,
                      onSave: (value) {
                        drillPlanNameController.text = value!;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),



                ],
              ),
            ),
          ),
        ));

  }


  @override
  void onRefresh(String type) {
    // TODO: implement onRefresh
    setState(() {

      // showProgressbar();
      _selectDrillProvider!.getSelectUserAsync(context);
    });
  }
}
