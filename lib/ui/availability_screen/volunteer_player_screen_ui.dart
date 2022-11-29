import 'dart:convert';

import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/game_event_response/player_availability_response.dart';
import 'package:spaid/model/response/game_event_response/volunteer_availability_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/email_template.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/widgets/menu_screen_card.dart';

class VolunteerPlayerScreen extends StatefulWidget {
  List<AvailableVolunteerList> availablePlayerList;
  List<NotRespondVolunteerList> notRespondPlayerList;
  List<RejectVolunteerList> rejectPlayerList;
  final String status;
  final String eventName;
  final String eventType;
  final String location;
  final String date;
  final String time;
  final int eventId;
  final String userRole;
  final String teamName;
  final String fcm;
  final String userName;
  final String userMail;
  final String userIdNo;

  VolunteerPlayerScreen(
      this.availablePlayerList,
      this.rejectPlayerList,
      this.notRespondPlayerList,
      this.status,
      this.eventId,
      this.eventName,
      this.userRole,
      this.eventType,
      this.location,
      this.date,
      this.time,
      this.teamName,
      this.fcm,
      this.userName,
      this.userMail,
      this.userIdNo);


  @override
  _VolunteerPlayerScreenState createState() => _VolunteerPlayerScreenState();
}

class _VolunteerPlayerScreenState extends BaseState<VolunteerPlayerScreen> {
  /*
Return Type:Widget
Input Parameters:
Use: Create Listview items.
 */
  Widget? showPlayerList() {

    if (widget.status == MyStrings.available) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // new
        itemCount: widget.availablePlayerList.length == null
            ? 0
            : widget.availablePlayerList.length,
        itemBuilder: (BuildContext context, int index) {
          return MenuScreenCard(
            roleID:int.parse(widget.userRole),
            icon: Icon(Icons.person),
            image: widget.availablePlayerList[index].userProfileImage != null &&
                widget
                    .availablePlayerList[index].userProfileImage!.isNotEmpty
                ? base64Decode(
                widget.availablePlayerList[index].userProfileImage!)
                : null,
            title: widget.availablePlayerList[index].userName,
            subTitle: widget.availablePlayerList[index].volunteerJobName,

          );
        },
      );
    } else if (widget.status == MyStrings.notAvailable) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // new
        itemCount: widget.rejectPlayerList.length == null
            ? 0
            : widget.rejectPlayerList.length,
        itemBuilder: (BuildContext context, int index) {
          return MenuScreenCard(
            roleID:int.parse(widget.userRole),

            icon: Icon(Icons.person),
            trailing: int.parse(widget.userRole) == Constants.owner ||
                int.parse(widget.userRole) == Constants.coachorManager
                ? Icon(
              Icons.outgoing_mail,
              color: MyColors.black,
            )
                : null,
            image: widget.rejectPlayerList[index].userProfileImage != null &&
                widget.rejectPlayerList[index].userProfileImage!.isNotEmpty
                ? base64Decode(widget.rejectPlayerList[index].userProfileImage!)
                : null,
            title: widget.rejectPlayerList[index].userName,
            subTitle: widget.rejectPlayerList[index].volunteerJobName,
            index: index,
            onResend: (position) {
              if (int.parse(widget.userRole) == Constants.owner ||
                  int.parse(widget.userRole) == Constants.coachorManager) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => FancyDialog(
                        gifPath: MyImages.team,
                        isCancelShow: true,
                        okFun: () => {
                          Navigator.of(context).pop(),
                          endEmail(
                              widget.rejectPlayerList[position].userId!,
                              widget.eventId,
                              widget.rejectPlayerList[position].userName!,
                              widget.rejectPlayerList[position].email!,
                              widget.eventName,
                              widget.eventType,
                              widget.teamName,
                              widget.fcm,
                              widget.userName,
                              widget.userMail,
                              widget.userIdNo,
                              widget.rejectPlayerList[index].userName!,
                              widget.rejectPlayerList[index].eventVolunteerTypeIDNo!,
                          ),

                          //Navigation.navigateTo(context, MyRoutes.introScreen)
                        },
                        cancelColor: MyColors.red,
                        cancelFun: () =>
                        {Navigator.of(context, rootNavigator: true).pop()},
                        //cancelFun: () => null,
                        title:
                        "Do you want to resend the email to " + widget.rejectPlayerList[index].email! + "?"
                    ));
              }
            },
          );
        },
      );
    } else if (widget.status == MyStrings.notResponded) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // new
        itemCount: widget.notRespondPlayerList.length == null
            ? 0
            : widget.notRespondPlayerList.length,
        itemBuilder: (BuildContext context, int index) {
          return MenuScreenCard(
            roleID:int.parse(widget.userRole),

            icon: Icon(Icons.person),
            trailing: int.parse(widget.userRole) == Constants.owner ||
                int.parse(widget.userRole) == Constants.coachorManager
                ? Icon(Icons.outgoing_mail, color: MyColors.black)
                : null,
            image:
            widget.notRespondPlayerList[index].userProfileImage != null &&
                widget.notRespondPlayerList[index].userProfileImage!
                    .isNotEmpty
                ? base64Decode(
                widget.notRespondPlayerList[index].userProfileImage!)
                : null,
            title: widget.notRespondPlayerList[index].userName,
            subTitle: widget.notRespondPlayerList[index].volunteerJobName,
            index: index,
            onResend: (position) {
              if (int.parse(widget.userRole) == Constants.owner ||
                  int.parse(widget.userRole) == Constants.coachorManager) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => FancyDialog(
                        gifPath: MyImages.team,
                        isCancelShow: true,
                        okFun: () => {
                          Navigator.of(context).pop(),
                          endEmail(
                              widget.notRespondPlayerList[position].userId!,
                              widget.eventId,
                              widget.notRespondPlayerList[position].userName!,
                              widget.notRespondPlayerList[position].email!,
                              widget.eventName,
                              widget.eventType,
                              widget.teamName,
                              widget.fcm,
                              widget.userName,
                              widget.userMail,
                              widget.userIdNo, widget.notRespondPlayerList[index].userName!,
                            widget.notRespondPlayerList[index].eventVolunteerTypeIDNo!,
                          ),

                          //Navigation.navigateTo(context, MyRoutes.introScreen)
                        },
                        cancelColor: MyColors.red,
                        cancelFun: () =>
                        {Navigator.of(context, rootNavigator: true).pop()},
                        //cancelFun: () => null,
                        title:
                        "Do you want to resend the email to " + widget.notRespondPlayerList[index].email! + "?"
                    ));

              }
            },
          );
        },
      );
    }/* else if (widget.status == MyStrings.tentative) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // new
        itemCount: widget.mayBePlayerList.length == null
            ? 0
            : widget.mayBePlayerList.length,
        itemBuilder: (BuildContext context, int index) {
          return MenuScreenCard(
            roleID:int.parse(widget.userRole),

            icon: Icon(Icons.person),
            trailing: int.parse(widget.userRole) == Constants.owner ||
                int.parse(widget.userRole) == Constants.coachorManager
                ? Icon(Icons.outgoing_mail, color: MyColors.black)
                : null,
            image: widget.mayBePlayerList[index].userProfileImage != null &&
                widget.mayBePlayerList[index].userProfileImage.isNotEmpty
                ? base64Decode(widget.mayBePlayerList[index].userProfileImage)
                : null,
            title: widget.mayBePlayerList[index].userName,
            note: widget.mayBePlayerList[index].Notes,
            index: index,
            onResend: (position) {
              if (int.parse(widget.userRole) == Constants.owner ||
                  int.parse(widget.userRole) == Constants.coachorManager) {

                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => FancyDialog(
                        gifPath: MyImages.team,
                        isCancelShow: true,
                        okFun: () => {
                          Navigator.of(context).pop(),
                          endEmail(
                              widget.mayBePlayerList[position].userId,
                              widget.eventId,
                              widget.mayBePlayerList[position].userName,
                              widget.mayBePlayerList[position].email,
                              widget.eventName,
                              widget.eventType,
                              widget.teamName,
                              widget.fcm,
                              widget.userName,
                              widget.userMail,
                              widget.userIdNo,widget.mayBePlayerList[index].userName),

                          //Navigation.navigateTo(context, MyRoutes.introScreen)
                        },
                        cancelColor: MyColors.red,
                        cancelFun: () =>
                        {Navigator.of(context, rootNavigator: true).pop()},
                        //cancelFun: () => null,
                        title:
                        "Do you want to resend the email to " + widget.mayBePlayerList[index].email + "?"
                    ));
              }
            },
          );
        },
      );
    }*/
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            width: size.width,
            // constraints: BoxConstraints(minHeight: size.height -30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: MarginSize.headerMarginVertical3,
                      horizontal: MarginSize.headerMarginVertical1),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: getValueForScreenType<bool>(
                                  context: context,
                                  mobile: false,
                                  tablet: true,
                                  desktop: true,
                                )
                                    ? PaddingSize.headerPadding3
                                    : PaddingSize.headerPadding2),
                            child: Column(
                              mainAxisAlignment: getValueForScreenType<bool>(
                                context: context,
                                mobile: false,
                                tablet: true,
                                desktop: true,
                              )
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.center,
                              crossAxisAlignment: getValueForScreenType<bool>(
                                context: context,
                                mobile: false,
                                tablet: true,
                                desktop: true,
                              )
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.center,
                              children: <Widget>[
                                //if (isMobile(context))
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
                                //      fontSize: getValueForScreenType<bool>(
                                //           context: context,
                                //           mobile: false,
                                //           tablet: false,
                                //           desktop: true,) ? 40 : 22,
                                //           fontWeight: FontWeight.w800,
                                //           color: MyColors.kPrimaryColor)),
                                // ])),
                                /*_selectTeamProvider.getTeamList != null
                                    ?*/
                                showPlayerList()!,
                                /* :   Container(
                                    margin: EdgeInsets.only(top: 250),
                                    child:
                                    Text(MyStrings.noTeamsAvailable)),*/
                                // : Center(child: Image.asset(MyImages.empty))
                                //  : Center(child: Text("No Available Teams"))
                              ],
                            ),
                          )),
                      // if (getValueForScreenType<bool>(
                      //    context: context,
                      //    mobile: false,
                      //    tablet: true,
                      //    desktop: true,
                      //  ))
                      //   Expanded(
                      //     child: SvgPicture.asset(
                      //       MyImages.login,
                      //       height: size.height * ImageSize.headerImageSize,
                      //     ),
                      //   )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void endEmail(int userId, int eventId, String userName, String email, String eventName, String eventType, String teamName, String fcm, String name, String userMail, String userIdNo, String playerName, int eventVolunteerTypeIDNo) async {
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
          title: "An email has been sent to " +
              email +
              ".",
        ));
    await DynamicLinksService()
        .createDynamicLink("volunteer_availablity_screen?userid=" +
        userId.toString() +
        "&refer=" +
        eventId.toString() +
        "&status=2" + "&eventname=" +
        eventName +
        // "&volunteer=" + gameResponse.volunteerTypeName +
        "&eventVolunteerTypeId=" + eventVolunteerTypeIDNo.toString() +
        // "&volunteerTypeId=" + gameResponse.volunteerTypeId.toString() +
        "&teamname=" +
        teamName + "&type=" +
        eventType + "&fcm=" + (fcm != null ? fcm : "") +
        "&name=" + userName + "&mail=" +
        email +
        "&toMail=" + userMail + "&toID=" + userIdNo + "&userName=" +
        playerName +
        "&location=" +
        widget.location/* + "&date=" +
        widget.date + " " + widget.time=="00:00"?"TBD":DateFormat("h:mma")
        .format(DateFormat("hh:mm").parse(widget.time))*/)
        .then((acceptvalue) async {
      await DynamicLinksService()
          .createDynamicLink("volunteer_availablity_screen?userid=" +
          userId.toString() +
          "&refer=" +
          eventId.toString() +
          "&status=3" + "&eventname=" +
          eventName +
          // "&volunteer=" + gameResponse.volunteerTypeName +
          "&eventVolunteerTypeId=" + eventVolunteerTypeIDNo.toString() +
          // "&volunteerTypeId=" + gameResponse.volunteerTypeId.toString() +
          "&teamname=" + teamName + "&type=" +
          eventType + "&fcm=" +
          (fcm != null ? fcm : "") + "&name=" + userName +
          "&mail=" +
          email +
          "&toMail=" +
          userMail +
          "&toID=" + userIdNo + "&userName=" +
          playerName)
          .then((declainvalue) async {
        await DynamicLinksService()

            .createDynamicLink("volunteer_availablity_screen?userid=" +
            userId.toString()+
            "&refer=" +
            eventId.toString() +
            "&status=4" + "&eventname=" +
            eventName+
            // "&volunteer=" + gameResponse.volunteerTypeName +
            "&eventVolunteerTypeId=" + eventVolunteerTypeIDNo.toString() +
            // "&volunteerTypeId=" + gameResponse.volunteerTypeId.toString() +
            "&teamname=" + teamName + "&type=" +
            eventType + "&fcm=" +
            (fcm != null ? fcm : "") + "&name=" + userName +
            "&mail=" +
            email +
            "&toMail=" +
            userMail +
            "&toID=" + userIdNo + "&userName=" +
            playerName)
            .then((maybevalue) {
          EmailService().reSendVolunteerNotificationMail(
              " Assigned Volunteer",
              widget.eventName,
              Constants.gameVolunteerInvite,
              userId,
              eventId,
              "Volunteer task has been assigned by "+userName+" for the "+
                  widget.eventType +" "+
                  widget.eventName +
                  " that is scheduled to commence on " +
                  widget.date + " " +
                  widget.time=="00:00"?"TBD":DateFormat("h:mma")
                  .format(DateFormat("hh:mm").parse(widget.time)) +
                  " at " +
                  widget.location+
                  ".",
              email,
              userName,
              widget.eventName,
              acceptvalue,
              maybevalue,
              declainvalue,
              widget.location,
              widget.date,
              widget.time=="00:00"?"TBD":DateFormat("h:mma")
                  .format(DateFormat("hh:mm").parse(widget.time)),
              "","",name,teamName,"",userId.toString(),eventVolunteerTypeIDNo


          );
        });
      });
    });
  }
}
