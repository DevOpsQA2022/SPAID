import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/game_team_response.dart';
import 'package:spaid/model/response/game_event_response/player_availability_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/availability_screen/availability_listview_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/menu_screen_card.dart';

class PlayerAvailabilityScreen extends StatefulWidget {
  GameOrEventList eventList;

  PlayerAvailabilityScreen(this.eventList);

  @override
  _PlayerAvailablityScreenState createState() =>
      _PlayerAvailablityScreenState();
}

class _PlayerAvailablityScreenState
    extends BaseState<PlayerAvailabilityScreen> {
  //region Private Members
  AvailabilityListviewProvider? _availabilityListviewProvider;
  GetPlayerAvailabilityResponse? _getPlayerAvailabilityResponse;
  String? _userRole = "", teamName, fcm, userName, userMail, userIdNo;

//endregion
  @override
  void initState() {
    _availabilityListviewProvider =
        Provider.of<AvailabilityListviewProvider>(context, listen: false);
    _availabilityListviewProvider!.listener = this;
    _availabilityListviewProvider!
        .getPlayerAvailabilityAsync(widget.eventList.eventId!);
    _getDataAsync();
  }

  @override
  void onSuccess(any, {required int reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.GET_PLAYER_AVAILABILITY:
        setState(() {
          _getPlayerAvailabilityResponse = any as GetPlayerAvailabilityResponse;
        });

        break;
    }
  }

  _getDataAsync() async {
    try {
      _userRole =
          await SharedPrefManager.instance.getStringAsync(Constants.roleId);
      teamName =
          await SharedPrefManager.instance.getStringAsync(Constants.teamName);
      fcm = await SharedPrefManager.instance.getStringAsync(Constants.FCM);
      userName =
          await SharedPrefManager.instance.getStringAsync(Constants.userName);
      userMail =
          await SharedPrefManager.instance.getStringAsync(Constants.userId);
      userIdNo =
          await SharedPrefManager.instance.getStringAsync(Constants.userIdNo);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void onFailure(BaseResponse error) {
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }

  Widget? showPlayerList() {
    if (_availabilityListviewProvider!.selectedValue == MyStrings.available) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // new
        itemCount: _getPlayerAvailabilityResponse!
                    .result!.availablePlayerList!.length ==
                null
            ? 0
            : _getPlayerAvailabilityResponse!.result!.availablePlayerList!.length,
        itemBuilder: (BuildContext context, int index) {
          return MenuScreenCard(
            roleID: int.parse(_userRole!),
            icon: Icon(Icons.person),
            image: _getPlayerAvailabilityResponse!.result!
                            .availablePlayerList![index].userProfileImage !=
                        null &&
                    _getPlayerAvailabilityResponse!.result!
                        .availablePlayerList![index].userProfileImage!.isNotEmpty
                ? base64Decode(_getPlayerAvailabilityResponse!
                    .result!.availablePlayerList![index].userProfileImage!)
                : null,
            title: _getPlayerAvailabilityResponse!
                .result!.availablePlayerList![index].userName,
            note: _getPlayerAvailabilityResponse!
                .result!.availablePlayerList![index].Notes,
            trailing:
              (int.parse(_userRole!) == Constants.owner ||
              int.parse(_userRole!) == Constants.coachorManager) ?SizedBox(
              height: SizedBoxSize.checkSizedBoxHeight,
              width: SizedBoxSize.checkSizedBoxWidth,
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: Colors.black,
                ),
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

                  value: _getPlayerAvailabilityResponse!
                      .result!.availablePlayerList![index].playerSelectionStatus,
                  // value: true,
                  onChanged: (value) {
                    setState(() {
                      _getPlayerAvailabilityResponse!
                          .result!
                          .availablePlayerList![index]
                          .playerSelectionStatus = value!;
                    });
                  },
                ),
              ),
            ):null,
          );
        },
      );
    } else if (_availabilityListviewProvider!.selectedValue ==
        MyStrings.notAvailable) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // new
        itemCount: _getPlayerAvailabilityResponse!
                    .result!.rejectPlayerList!.length ==
                null
            ? 0
            : _getPlayerAvailabilityResponse!.result!.rejectPlayerList!.length,
        itemBuilder: (BuildContext context, int index) {
          return MenuScreenCard(
            roleID: int.parse(_userRole!),
            icon: Icon(Icons.person),
            trailing: widget.eventList.status == Constants.upcoming &&
                    (int.parse(_userRole!) == Constants.owner ||
                        int.parse(_userRole!) == Constants.coachorManager)
                ? Icon(
                    Icons.outgoing_mail,
                    color: MyColors.black,
                  )
                : null,
            image: _getPlayerAvailabilityResponse!
                            .result!.rejectPlayerList![index].userProfileImage !=
                        null &&
                    _getPlayerAvailabilityResponse!.result!
                        .rejectPlayerList![index].userProfileImage!.isNotEmpty
                ? base64Decode(_getPlayerAvailabilityResponse!
                    .result!.rejectPlayerList![index].userProfileImage!)
                : null,
            title: _getPlayerAvailabilityResponse!
                .result!.rejectPlayerList![index].userName,
            note: _getPlayerAvailabilityResponse!
                .result!.rejectPlayerList![index].Notes,
            index: index,
            onResend: (position) {
              if (widget.eventList.status == Constants.upcoming &&
                  (int.parse(_userRole!) == Constants.owner ||
                      int.parse(_userRole!) == Constants.coachorManager)) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => FancyDialog(
                        gifPath: MyImages.team,
                        isCancelShow: true,
                        okFun: () => {
                              Navigator.of(context).pop(),
                              sendEmail(
                                  _getPlayerAvailabilityResponse!
                                      .result!.rejectPlayerList![position].userId!,
                                  widget.eventList.eventId!,
                                  _getPlayerAvailabilityResponse!.result!
                                      .rejectPlayerList![position].userName!,
                                  _getPlayerAvailabilityResponse!
                                      .result!.rejectPlayerList![position].email!,
                                  widget.eventList.name!,
                                  widget.eventList.type!,
                                  teamName!,
                                  fcm!,
                                  userName!,
                                  userMail!,
                                  userIdNo!,
                                  _getPlayerAvailabilityResponse!
                                      .result!.rejectPlayerList![index].userName!),

                              //Navigation.navigateTo(context, MyRoutes.introScreen)
                            },
                        cancelColor: MyColors.red,
                        cancelFun: () =>
                            {Navigator.of(context, rootNavigator: true).pop()},
                        //cancelFun: () => null,
                        title: "Do you want to resend the email to " +
                            _getPlayerAvailabilityResponse!
                                .result!.rejectPlayerList![index].email! +
                            "?"));
              }
            },
          );
        },
      );
    } else if (_availabilityListviewProvider!.selectedValue ==
        MyStrings.notResponded) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // new
        itemCount: _getPlayerAvailabilityResponse!
                    .result!.notRespondPlayerList!.length ==
                null
            ? 0
            : _getPlayerAvailabilityResponse!
                .result!.notRespondPlayerList!.length,
        itemBuilder: (BuildContext context, int index) {
          return MenuScreenCard(
            roleID: int.parse(_userRole!),
            icon: Icon(Icons.person),
            trailing: widget.eventList.status == Constants.upcoming &&
                    (int.parse(_userRole!) == Constants.owner ||
                        int.parse(_userRole!) == Constants.coachorManager)
                ? Icon(Icons.outgoing_mail, color: MyColors.black)
                : null,
            image: _getPlayerAvailabilityResponse!.result!
                            .notRespondPlayerList![index].userProfileImage !=
                        null &&
                    _getPlayerAvailabilityResponse!.result!
                        .notRespondPlayerList![index].userProfileImage!.isNotEmpty
                ? base64Decode(_getPlayerAvailabilityResponse!
                    .result!.notRespondPlayerList![index].userProfileImage!)
                : null,
            title: _getPlayerAvailabilityResponse!
                .result!.notRespondPlayerList![index].userName,
            note: _getPlayerAvailabilityResponse!
                .result!.notRespondPlayerList![index].Notes,
            index: index,
            onResend: (position) {
              if (widget.eventList.status == Constants.upcoming &&
                  (int.parse(_userRole!) == Constants.owner ||
                      int.parse(_userRole!) == Constants.coachorManager)) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => FancyDialog(
                        gifPath: MyImages.team,
                        isCancelShow: true,
                        okFun: () => {
                              Navigator.of(context).pop(),
                              sendEmail(
                                  _getPlayerAvailabilityResponse!.result!
                                      .notRespondPlayerList![position].userId!,
                                  widget.eventList.eventId!,
                                  _getPlayerAvailabilityResponse!.result!
                                      .notRespondPlayerList![position].userName!,
                                  _getPlayerAvailabilityResponse!.result!
                                      .notRespondPlayerList![position].email!,
                                  widget.eventList.name!,
                                  widget.eventList.type!,
                                  teamName!,
                                  fcm!,
                                  userName!,
                                  userMail!,
                                  userIdNo!,
                                  _getPlayerAvailabilityResponse!.result!
                                      .notRespondPlayerList![index].userName!),

                              //Navigation.navigateTo(context, MyRoutes.introScreen)
                            },
                        cancelColor: MyColors.red,
                        cancelFun: () =>
                            {Navigator.of(context, rootNavigator: true).pop()},
                        //cancelFun: () => null,
                        title: "Do you want to resend the email to " +
                            _getPlayerAvailabilityResponse!
                                .result!.notRespondPlayerList![index].email! +
                            "?"));
              }
            },
          );
        },
      );
    } else if (_availabilityListviewProvider!.selectedValue ==
        MyStrings.tentative) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // new
        itemCount:
            _getPlayerAvailabilityResponse!.result!.mayBePlayerList!.length ==
                    null
                ? 0
                : _getPlayerAvailabilityResponse!.result!.mayBePlayerList!.length,
        itemBuilder: (BuildContext context, int index) {
          return MenuScreenCard(
            roleID: int.parse(_userRole!),
            icon: Icon(Icons.person),
            trailing: widget.eventList.status == Constants.upcoming &&
                    (int.parse(_userRole!) == Constants.owner ||
                        int.parse(_userRole!) == Constants.coachorManager)
                ? Icon(Icons.outgoing_mail, color: MyColors.black)
                : null,
            image: _getPlayerAvailabilityResponse!
                            .result!.mayBePlayerList![index].userProfileImage !=
                        null &&
                    _getPlayerAvailabilityResponse!.result!
                        .mayBePlayerList![index].userProfileImage!.isNotEmpty
                ? base64Decode(_getPlayerAvailabilityResponse!
                    .result!.mayBePlayerList![index].userProfileImage!)
                : null,
            title: _getPlayerAvailabilityResponse!
                .result!.mayBePlayerList![index].userName,
            note: _getPlayerAvailabilityResponse!
                .result!.mayBePlayerList![index].Notes,
            index: index,
            onResend: (position) {
              if (widget.eventList.status == Constants.upcoming &&
                  (int.parse(_userRole!) == Constants.owner ||
                      int.parse(_userRole!) == Constants.coachorManager)) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => FancyDialog(
                        gifPath: MyImages.team,
                        isCancelShow: true,
                        okFun: () => {
                              Navigator.of(context).pop(),
                              sendEmail(
                                  _getPlayerAvailabilityResponse!
                                      .result!.mayBePlayerList![position].userId!,
                                  widget.eventList.eventId!,
                                  _getPlayerAvailabilityResponse!.result!
                                      .mayBePlayerList![position].userName!,
                                  _getPlayerAvailabilityResponse!
                                      .result!.mayBePlayerList![position].email!,
                                  widget.eventList.name!,
                                  widget.eventList.type!,
                                  teamName!,
                                  fcm!,
                                  userName!,
                                  userMail!,
                                  userIdNo!,
                                  _getPlayerAvailabilityResponse!
                                      .result!.mayBePlayerList![index].userName!),

                              //Navigation.navigateTo(context, MyRoutes.introScreen)
                            },
                        cancelColor: MyColors.red,
                        cancelFun: () =>
                            {Navigator.of(context, rootNavigator: true).pop()},
                        //cancelFun: () => null,
                        title: "Do you want to resend the email to " +
                            _getPlayerAvailabilityResponse!
                                .result!.mayBePlayerList![index].email! +
                            "?"));
              }
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(size);

    return Scaffold(
      backgroundColor: MyColors.white,
      floatingActionButton: widget.eventList.status == Constants.upcoming &&
              _availabilityListviewProvider!.selectedValue ==
                  MyStrings.available &&
              _getPlayerAvailabilityResponse != null &&
              _getPlayerAvailabilityResponse!.result!.availablePlayerList !=
                  null &&
              _getPlayerAvailabilityResponse!
                      .result!.availablePlayerList!.length >
                  0 &&
          (int.parse(_userRole!) == Constants.owner ||
              int.parse(_userRole!) == Constants.coachorManager)
          ? FloatingActionButton(
              tooltip: MyStrings.save,
              onPressed: () {
                EmailService().updatePlayerAvalStatusAsync(
                    widget.eventList.eventId!,
                    _getPlayerAvailabilityResponse!.result!.availablePlayerList!);
                //shareDrillPopupDialog();
              },
              backgroundColor: MyColors.kPrimaryColor,
              child: const Icon(
                Icons.done,
                color: MyColors.white,
              ),
            )
          : null,
      body: SafeArea(
        child: Consumer<AvailabilityListviewProvider>(
            builder: (context, provider, _) {
          return Padding(
            padding: EdgeInsets.all(getValueForScreenType<bool>(
              context: context,
              mobile: false,
              tablet: true,
              desktop: true,
            )
                ? PaddingSize.headerPadding1
                : PaddingSize.headerPadding1),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: Dimens.standard_50,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,

                        focusColor: MyColors.white,
                        selectedItemHighlightColor: MyColors.white,
                        items: getAvailability.map((Availability gen) {
                          return new DropdownMenuItem<String>(
                            value: gen.status,
                            child: new Text(gen.status,
                                style: Theme.of(context).textTheme.bodyText2),
                          );
                        }).toList(),
                        value: provider.selectedValue,
                        onChanged: (value) {
                          setState(() {
                            provider.selectedValue = value.toString();
                          });
                        },
                        buttonWidth: getValueForScreenType<bool>(
                          context: context,
                          mobile: true,
                          tablet: false,
                          desktop: false,
                        )
                            ? size.width - 58
                            : getValueForScreenType<bool>(
                                context: context,
                                mobile: false,
                                tablet: true,
                                desktop: false,
                              )
                                ? size.width * 0.4
                                : size.width * 0.41,
                        buttonHeight: 20,
                        // buttonWidth: 140,
                        itemHeight: 40,
                        icon: MyIcons.arrowdownIos,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: MyColors.white,
                        ),
                        buttonDecoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black45,
                          ),
                        ),
                        buttonPadding:
                            const EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                    // child: DropdownBelow(
                    //
                    //   boxDecoration: BoxDecoration(
                    //     // color: MyColors.white,
                    //       border: Border.all(color: MyColors.colorGray_818181)),
                    //   itemWidth:200,
                    //   // itemWidth: getValueForScreenType<
                    //   //     bool>(
                    //   //   context: context,
                    //   //   mobile: true,
                    //   //   tablet: false,
                    //   //   desktop: false,
                    //   // )
                    //   //     ? size.width-58
                    //   //     : getValueForScreenType<bool>(
                    //   //   context: context,
                    //   //   mobile: false,
                    //   //   tablet: true,
                    //   //   desktop: false,
                    //   // )
                    //   //     ? size.width * 0.4
                    //   //     : size.width * 0.41,
                    //   icon: MyIcons
                    //       .arrowdownIos,
                    //   itemTextstyle: TextStyle(
                    //       wordSpacing: 4,
                    //       // fontSize: 34,
                    //       height: WidgetCustomSize.dropdownItemHeight,
                    //       // fontWeight: FontWeight.w400,
                    //       color: MyColors.colorGray_818181),
                    //   boxTextstyle: TextStyle(
                    //       decorationColor: MyColors.white,
                    //       //backgroundColor: MyColors.white,
                    //       // fontSize: 14,
                    //       // fontWeight: FontWeight.w400,
                    //       color: MyColors.colorGray_818181),
                    //   boxPadding: EdgeInsets.fromLTRB(
                    //       PaddingSize.boxPaddingLeft,
                    //       PaddingSize.boxPaddingTop,
                    //       PaddingSize.boxPaddingRight,
                    //       PaddingSize.boxPaddingBottom),
                    //   boxWidth:
                    //   size.width *
                    //       WidgetCustomSize.dropdownBoxWidth,
                    //   boxHeight:
                    //   WidgetCustomSize.dropdownBoxHeight,
                    //
                    //   value: provider.selectedValue,
                    //   items: getAvailability.map((Availability
                    //   gen) {
                    //     return new DropdownMenuItem<
                    //         String>(value: gen.status,
                    //       child: new Text(gen.status, style: Theme
                    //           .of(context)
                    //           .textTheme
                    //           .bodyText2),
                    //     );
                    //   }).toList(),
                    //   onChanged:
                    //       (val) {
                    //     setState(() {
                    //       provider.selectedValue = val;
                    //     });
                    //   },
                    // ),
                  ),
                  if (_getPlayerAvailabilityResponse != null) showPlayerList()!,
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void sendEmail(
      int userId,
      int eventId,
      String userName,
      String email,
      String eventName,
      String eventType,
      String teamName,
      String fcm,
      String name,
      String userMail,
      String userIdNo,
      String playerName) async {
    // print(("The " +
    //     (widget.eventList.type==Constants.event.toString()?"Event":"Game") +" "+
    //     widget.eventList.name +
    //     " is scheduled by " + name +
    //     " for the team " + teamName + ", on " +
    //     widget.eventList.scheduleDate + " " +
    //     (widget.eventList.scheduleTime=="00:00"?"TBD":DateFormat("h:mma")
    //     .format(DateFormat("hh:mm").parse(widget.eventList.scheduleTime)) )+
    //     " at " +
    //     widget.eventList.locationAddress+
    //     "."));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => FancyDialog(
              gifPath: MyImages.team,
              isCancelShow: false,
              okFun: () => {
                Navigator.of(context).pop()
                //Navigation.navigateTo(context, MyRoutes.introScreen)
              },

              //cancelFun: () => null,
              title: "An email has been sent to " + email + ".",
            ));
    DynamicLinksService()
        .createDynamicLink("splash_Screen?userid=" +
                userId.toString() +
                "&refer=" +
                eventId.toString() +
                "&status=2" +
                "&eventname=" +
                eventName +
                "&teamname=" +
                teamName +
                "&type=" +
                eventType +
                "&fcm=" +
                (fcm != null ? fcm : "") +
                "&name=" +
                name +
                "&mail=" +
                email +
                "&toMail=" +
                userMail +
                "&toID=" +
                userIdNo +
                "&userName=" +
                playerName +
                "&location=" +
                widget.eventList
                    .locationAddress! /*+ "&date=" + widget.date+" "+widget.time=="00:00"?"TBD":DateFormat("h:mma")
        .format(DateFormat("hh:mm").parse(widget.time))*/
            )
        .then((acceptvalue) {
      print(acceptvalue);
      DynamicLinksService()
          .createDynamicLink("splash_Screen?userid=" +
              userId.toString() +
              "&refer=" +
              eventId.toString() +
              "&status=3" +
              "&eventname=" +
              eventName +
              "&teamname=" +
              teamName +
              "&type=" +
              eventType +
              "&fcm=" +
              (fcm != null ? fcm : "") +
              "&name=" +
              name +
              "&mail=" +
              email +
              "&toMail=" +
              userMail +
              "&toID=" +
              userIdNo +
              "&userName=" +
              playerName)
          .then((declainvalue) {
        print(declainvalue);
        DynamicLinksService()
            .createDynamicLink("splash_Screen?userid=" +
                userId.toString() +
                "&refer=" +
                eventId.toString() +
                "&status=4" +
                "&eventname=" +
                eventName +
                "&teamname=" +
                teamName +
                "&type=" +
                eventType +
                "&fcm=" +
                (fcm != null ? fcm : "") +
                "&name=" +
                name +
                "&mail=" +
                email +
                "&toMail=" +
                userMail +
                "&toID=" +
                userIdNo +
                "&userName=" +
                playerName)
            .then((maybevalue) {
          print(maybevalue);
          DynamicLinksService()
              .createDynamicLink("signin_screen")
              .then((value) {
            EmailService().sendSpecificNotificationMail(
                "" + (widget.eventList.type!) + " Notification",
                widget.eventList.name!,
                Constants.gameOrEventRequest,
                userId,
                eventId,
                ("The " +
                    (widget.eventList.type!) +
                    " " +
                    widget.eventList.name! +
                    " is scheduled by " +
                    name +
                    " for the team " +
                    teamName +
                    ", on " +
                    widget.eventList.scheduleDate! +
                    " " +
                    (widget.eventList.scheduleTime == "00:00"
                        ? "TBD"
                        : DateFormat("h:mma").format(DateFormat("h:mma")
                            .parse(widget.eventList.scheduleTime!))) +
                    " at " +
                    widget.eventList.locationAddress! +
                    "."),
                email,
                userName,
                (widget.eventList.type! +
                    ", " +
                    widget.eventList.name! +
                    " has been Scheduled by " +
                    name +
                    " for the team, " +
                    teamName +
                    "."),
                acceptvalue,
                maybevalue,
                declainvalue,
                widget.eventList.locationAddress!,
                widget.eventList.scheduleDate!,
                widget.eventList.scheduleTime == "00:00"
                    ? "TBD"
                    : DateFormat("h:mma").format(DateFormat("h:mma")
                        .parse(widget.eventList.scheduleTime!)),
                value,
                "",
                "",
                "",
                "",
                "");
          });
        });
      });
    });
  }
}

class Availability {
  final int id;
  final String status;

  Availability(
    this.id,
    this.status,
  );
}

List<Availability> getAvailability = <Availability>[
  Availability(
    1,
    MyStrings.available,
  ),
  Availability(
    2,
    MyStrings.notAvailable,
  ),
  Availability(
    3,
    MyStrings.tentative,
  ),
  Availability(
    4,
    MyStrings.notResponded,
  ),
];
