
import 'dart:collection';

import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class SharedDrillScreen extends StatefulWidget {


  @override
  _SharedDrillScreenState createState() => _SharedDrillScreenState();
}

String? role;

class _SharedDrillScreenState extends BaseState<SharedDrillScreen>
    with WidgetsBindingObserver {
  //region Private Members
  bool? _isShowing;
  BuildContext? popupContext;

  SelectDrillProvider? _selectDrillProvider;
  SignInResponse? _signInResponse;
  final _formKey = GlobalKey<FormState>();
  Map<String, List<AllDrillPlanList>> drillPlans = HashMap();


  getTeamList() {
    // ProgressBar.instance.showProgressbar(context);
    showProgressbar();

    _selectDrillProvider!.getSelectTeamAsync(context);
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
  void onFailure(BaseResponse error) {
    // ProgressBar.instance.stopProgressBar(context);
    stopProgressBar();
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }

  @override
  void onSuccess(any, {int? reqId}) {
    stopProgressBar();
    // ProgressBar.instance.stopProgressBar(context);
    if (any == null) {
      setState(() {});
    } else {
      switch (reqId) {
        case ResponseIds.GET_DRILL_PLAN_SCREEN:
          setState(() {
            GetAllDrillPlanResponse drillResponse = any as GetAllDrillPlanResponse;
            if(drillResponse.result != null && drillResponse.result!.allDrillPlanList!.isNotEmpty){
              String name=" ";
              for(int i=0;i<drillResponse.result!.allDrillPlanList!.length;i++){
                if(drillResponse.result!.allDrillPlanList![i].sharedDrillPlan!=name){
                  name=drillResponse.result!.allDrillPlanList![i].sharedDrillPlan!;
                  drillPlans.addAll({drillResponse.result!.allDrillPlanList![i].sharedDrillPlan!:[]});
                }
              }
              for(int i=0;i<drillPlans.length;i++){
                List<AllDrillPlanList> allDrillPlanList=[];
                for(int j=0;j<drillResponse.result!.allDrillPlanList!.length;j++){
                  if(drillResponse.result!.allDrillPlanList![j].sharedDrillPlan==drillPlans.keys.elementAt(i)){
                    allDrillPlanList.add(drillResponse.result!.allDrillPlanList![j]);
                  }
                }
                drillPlans.update(drillPlans.keys.elementAt(i), (value) => allDrillPlanList);
              }

            }
          });

          break;
      }
    }
    super.onSuccess(any,reqId: 0);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _selectDrillProvider =
        Provider.of<SelectDrillProvider>(context, listen: false);
    // _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);

    _selectDrillProvider!.listener = this;

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
                tooltipMessageLeft: "Back",
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
                                        drillPlans != null &&
                                            drillPlans.length > 0
                                            ? ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true, // new
                                                itemCount: drillPlans
                                                            .length ==
                                                        null
                                                    ? 0
                                                    : drillPlans
                                                        .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return DrillScreenCard(

                                                    icon: MyIcons.sport,


                                                    title: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            drillPlans.keys.elementAt(index),
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

                                                          Navigation.navigateWithArgument(context, MyRoutes.sharedDrillListScreen,drillPlans.values.elementAt(index));

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
                                                      .noDrillsAvailable,
                                                  style: TextStyle(
                                                    fontSize: FontSize
                                                        .headerFontSize4,
                                                  ),
                                                )),

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
