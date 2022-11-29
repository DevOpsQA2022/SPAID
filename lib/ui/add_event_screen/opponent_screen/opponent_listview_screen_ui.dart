import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/opponent_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/add_event_screen/add_event_provider.dart';
import 'package:spaid/ui/add_event_screen/opponent_screen/opponent_provider.dart';
import 'package:spaid/ui/home_screen/event_listview/event_listview_ui_screen.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/menu_screen_card.dart';
import 'package:spaid/widgets/opponent_screen_card.dart';

class OpponentListviewScreen extends StatefulWidget {
  @override
  _OpponentListviewScreenState createState() => _OpponentListviewScreenState();
}

class _OpponentListviewScreenState extends BaseState<OpponentListviewScreen> {

  OpponentProvider? _opponentProvider;
  AddEventProvider? _addEventProvider;
  OpponentResponse? _opponentResponse;
  bool? isLoading;
  @override
  void initState() {
    super.initState();
    _opponentProvider =
        Provider.of<OpponentProvider>(context, listen: false);
    _addEventProvider =
        Provider.of<AddEventProvider>(context, listen: false);
    _opponentProvider!.listener = this;
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressBar.instance.showProgressbar(context);
    });*/
    isLoading=true;
    _opponentProvider!.getOpponentAsync();

    // if(_opponentProvider.opponentResponse != null){
    //   setState(() {
    //     _opponentResponse=_opponentProvider.opponentResponse;
    //     isLoading=false;
    //
    //   });
    // }else {
    //   _opponentProvider.getOpponentAsync();
    // }
  }


  @override
  void onSuccess(any, {required int reqId}) {
    setState(() {
      isLoading=false;
    });
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.GET_OPPONENT:
        setState(() {
          _opponentResponse = any as OpponentResponse;

        });
        /*if (_response.status == Constants.success) {

        } else if (_response.status == Constants.failed) {
         *//* CodeSnippet.instance.showMsg(MyStrings.createTeamFailed);
          print("400");*//*
        } else {
         *//* CodeSnippet.instance.showMsg(_response.errorMessage);
          print("else");*//*
        }*/
        break;
    }
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return TopBar(
      child: WebCard(
        marginVertical: 20,
        marginhorizontal: 40,
        child: Scaffold(
          backgroundColor: MyColors.white,
          appBar: CustomAppBar(
            title: MyStrings.opponent,
            // iconRight: MyIcons.done,
            iconLeft: MyIcons.backwardArrow,
           // tooltipmessage: MyStrings.save,

          ),
          /* appBar: */ /*getValueForScreenType<bool>(
                        context: context,
                        mobile: false,
                        tablet: true,
                        desktop: true,
                      )
                ? CustomAppBar(
                title: MyStrings.addSportEvent,
                iconRight: MyIcons.done,
                iconLeft: MyIcons.backwardArrow,
                onClickRightImage: () {
                  */ /**/ /*Navigation.navigatePushNamedAndRemoveAll(
                        context, MyRoutes.teamSetupScreen);*/ /**/ /*
                  Navigator.of(context).pop();
                })
                : */ /*getValueForScreenType<bool>(
                        context: context,
                        mobile: false,
                        tablet: true,
                        desktop: true,
                      )? null :CustomAppBar(
              title: MyStrings.opponent,
              iconRight: MyIcons.done,
              iconLeft: MyIcons.cancel,
              onClickRightImage: () {
                Navigator.of(context).pop();
              },
            ),*/
          body:isLoading!?SkeletonListView(): SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(getValueForScreenType<bool>(
                  context: context,
                  mobile: false,
                  tablet: true,
                  desktop: true,)
                    ? PaddingSize.headerPadding1
                    : PaddingSize.headerPadding2),
                child: Container(
                  /*width: size.width,
                      constraints: BoxConstraints(minHeight: size.height -30),*/
                  child: Column(
                    /*crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,*/
                    children: <Widget>[
                      Container(
                        /*  margin: EdgeInsets.symmetric(
                                vertical: MarginSize.headerMarginVertical3,
                                horizontal: MarginSize.headerMarginVertical3),*/
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: true,
                                        desktop: true,)
                                          ? PaddingSize.headerPadding2
                                          : PaddingSize.headerPadding2),
                                  child: Column(
                                    /* mainAxisAlignment: !isMobile(context)
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                    crossAxisAlignment: !isMobile(context)
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.center,*/
                                    children: <Widget>[
                                      // if (isMobile(context))

                                      /* WebCard(
                                        marginVertical: 20,
                                        marginhorizontal: 40,
                                        child: SizedBox(
                                         // height: 680,
                                          child: Padding(
                                            padding: EdgeInsets.all( !isMobile(context) ? PaddingSize.headerPadding1 : PaddingSize.headerPadding2),
                                              child: */
                                      Column(
                                        children: [
                                          /*     if (getValueForScreenType<bool>(
                        context: context,
                        mobile: false,
                        tablet: true,
                        desktop: true,
                      ))
                                                    CustomAppBar(
                                                    title: MyStrings.opponent,
                                                    iconRight: MyIcons.done,
                                                    iconLeft: MyIcons.cancel,
                                                    onClickRightImage: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),*/
                                          ListView.builder(
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            shrinkWrap: true, // new
                                            itemCount:_opponentResponse==null
                                                ? 0
                                                : _opponentResponse!.result!.opponentTeamList!.length,
                                            itemBuilder:
                                                (BuildContext context,
                                                int index) {
                                              return OpponentScreenCard(
                                                // icon: MyIcons.sport,
                                                image: _opponentResponse!.result!.opponentTeamList![index].teamProfileImage != null?base64Decode(_opponentResponse!.result!.opponentTeamList![index].teamProfileImage!):null,
                                                title: _opponentResponse!.result!.opponentTeamList![index].teamName,
                                                onPressed: () {

                                                  _addEventProvider!.opponentIDController!.text=_opponentResponse!.result!.opponentTeamList![index].teamId.toString();
                                                  _addEventProvider!.opponentNameController!.text=_opponentResponse!.result!.opponentTeamList![index].teamName!;
                                                  _addEventProvider!.setRefreshScreen();
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      /*  ),
                                        ),
                                        ),*/
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
         /* floatingActionButton: FloatingActionButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              Navigation.navigateTo(context, MyRoutes.opponentAddScreen),
            },
            backgroundColor: MyColors.kPrimaryColor,
            foregroundColor: MyColors.white,
            child: const Icon(Icons.add),
          ),*/
        ),
      ),
    );
  }
}
