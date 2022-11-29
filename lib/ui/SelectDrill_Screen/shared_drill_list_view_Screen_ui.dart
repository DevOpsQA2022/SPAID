
import 'dart:convert';

import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
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
import 'package:spaid/widgets/custom_simple_appbar.dart';
import 'package:spaid/widgets/customize_text_field.dart';

import 'select_drill_screen_provider.dart';

class SharedDrillListViewScreen extends StatefulWidget {
  var drillPlans;
  SharedDrillListViewScreen( this.drillPlans);



  @override
  _SharedDrillListViewScreenState createState() => _SharedDrillListViewScreenState();
}

String? role;

class _SharedDrillListViewScreenState extends BaseState<SharedDrillListViewScreen>
    with WidgetsBindingObserver {
  //region Private Members

  SelectDrillProvider? _selectDrillProvider;


  getRoleAsync() async {
    try {
      role = await SharedPrefManager.instance.getStringAsync(Constants.roleId);
      setState(() {});
    } catch (e) {
      _selectDrillProvider!.listener
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
        case ResponseIds.GET_DRILL_PLAN_SCREEN:
          setState(() {
            GetAllDrillPlanResponse _newSelectDrillResponse = any as GetAllDrillPlanResponse;
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
                                        widget.drillPlans != null &&
                                            widget.drillPlans
                                                        .length >
                                                    0
                                            ? ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true, // new
                                                itemCount: widget.drillPlans
                                                            .length ==
                                                        null
                                                    ? 0
                                                    : widget.drillPlans
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
                                                            widget.drillPlans[
                                                                            index]
                                                                        .categoryDescription ==
                                                                    null
                                                                ? " "
                                                                : widget.drillPlans[
                                                                        index]
                                                                    .categoryDescription,
                                                            style: TextStyle(
                                                                letterSpacing:
                                                                    Dimens
                                                                        .letterSpacing_25,
                                                                color: MyColors
                                                                    .kPrimaryColor)),
                                                        Text(
                                                            widget.drillPlans[
                                                                            index]
                                                                        .planDescription ==
                                                                    null
                                                                ? " "
                                                                : widget.drillPlans[
                                                                        index]
                                                                    .planDescription,
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
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return Container(
                                                                  child: PhotoView(
                                                                      initialScale: PhotoViewComputedScale
                                                                          .contained * 0.8,
                                                                      imageProvider: MemoryImage(
                                                                        base64Decode(widget.drillPlans[
                                                                        index]
                                                                            .sharedDrillImage),
                                                                      )
                                                                  ));
                                                            },
                                                          );
                                                          // SharedPrefManager.instance.setStringAsync(
                                                          //     Constants.teamDrillPlanId, widget.drillPlans[
                                                          // index]
                                                          //     .teamDrillPlanId.toString());
                                                          // SharedPrefManager.instance.setStringAsync(
                                                          //     Constants.teamDrillCategoryId, widget.drillPlans[
                                                          // index]
                                                          //     .teamDrillCategoryId.toString());
                                                          // Navigation.navigateWithArgument(context, MyRoutes.coachHomeScreen,0);

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
                                                      .noTeamsAvailable,
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



  @override
  void onRefresh(String type) {
    // TODO: implement onRefresh
  }
}
