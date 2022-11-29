import 'dart:convert';

import 'package:dropdown_below/dropdown_below.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/game_availablity_response.dart';
import 'package:spaid/model/response/game_event_response/game_team_response.dart';
import 'package:spaid/model/response/game_event_response/player_availability_response.dart';
import 'package:spaid/model/response/game_event_response/volunteer_availability_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/availability_screen/availability_listview_provider.dart';
import 'package:spaid/ui/availability_screen/available_player_screen_ui.dart';
import 'package:spaid/ui/availability_screen/volunteer_player_screen_ui.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_availability_tabbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_volunteer_tabbar.dart';
import 'package:spaid/widgets/menu_screen_card.dart';

class VolunteerAvailabilityScreen extends StatefulWidget {
  GameOrEventList eventList;
  VolunteerAvailabilityScreen(this.eventList);



  @override
  _VolunteerAvailabilityScreenState createState() =>
      _VolunteerAvailabilityScreenState();
}

class _VolunteerAvailabilityScreenState extends BaseState<VolunteerAvailabilityScreen>
     {
  //region Private Members

  AvailabilityListviewProvider? _availabilityListviewProvider;
  VolunteerAvailabilityResponse? _volunteerAvailabilityResponse;
  String? _userRole = "0",teamName,fcm,userName,userMail,userIdNo;

//endregion
  @override
  void initState() {
    _availabilityListviewProvider =
        Provider.of<AvailabilityListviewProvider>(context, listen: false);
    _availabilityListviewProvider!.listener = this;
    _availabilityListviewProvider!.getVolunteerAvailabilityAsync(widget.eventList.eventId!);
    _getDataAsync();


  }

  @override
  void onRefresh(String type) {
    Future.delayed(Duration(seconds: 1), () async {
      _availabilityListviewProvider!.getVolunteerAvailabilityAsync(widget.eventList.eventId!);
    });
    super.onRefresh(type);
  }
       @override
       void onSuccess(any, {int? reqId}) {
         ProgressBar.instance.stopProgressBar(context);
         switch (reqId) {
           case ResponseIds.VOLUNTEER_AVAILABILITY_SCREEN:
             setState(() {
               _volunteerAvailabilityResponse = any as VolunteerAvailabilityResponse;

             });

             break;

         }
       }
       _getDataAsync() async {
         try {
           _userRole = await SharedPrefManager.instance.getStringAsync(Constants.roleId);
           teamName = await SharedPrefManager.instance.getStringAsync(Constants.teamName);
           fcm = await SharedPrefManager.instance.getStringAsync(Constants.FCM);
           userName = await SharedPrefManager.instance.getStringAsync(Constants.userName);
           userMail = await SharedPrefManager.instance.getStringAsync(Constants.userId);
           userIdNo = await SharedPrefManager.instance.getStringAsync(Constants.userIdNo);
           setState(() {

           });
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

         if (_availabilityListviewProvider!.selectedVolunteerValue == MyStrings.available) {
           return ListView.builder(
             scrollDirection: Axis.vertical,
             physics: NeverScrollableScrollPhysics(),
             shrinkWrap: true,
             // new
             itemCount: _volunteerAvailabilityResponse!.result!.availableVolunteerList!.length == null
                 ? 0
                 : _volunteerAvailabilityResponse!.result!.availableVolunteerList!.length,
             itemBuilder: (BuildContext context, int index) {
               return MenuScreenCard(
                 roleID:int.parse(_userRole!),
                 icon: Icon(Icons.person),
                 image: _volunteerAvailabilityResponse!.result!.availableVolunteerList![index].userProfileImage != null &&
                     _volunteerAvailabilityResponse!.result!.availableVolunteerList![index].userProfileImage!.isNotEmpty
                     ? base64Decode(
                     _volunteerAvailabilityResponse!.result!.availableVolunteerList![index].userProfileImage!)
                     : null,
                 title: _volunteerAvailabilityResponse!.result!.availableVolunteerList![index].userName,
                 subTitle: _volunteerAvailabilityResponse!.result!.availableVolunteerList![index].volunteerJobName,

               );
             },
           );
         } else if (_availabilityListviewProvider!.selectedVolunteerValue == MyStrings.notAvailable) {
           return ListView.builder(
             scrollDirection: Axis.vertical,
             physics: NeverScrollableScrollPhysics(),
             shrinkWrap: true,
             // new
             itemCount: _volunteerAvailabilityResponse!.result!.rejectVolunteerList!.length == null
                 ? 0
                 : _volunteerAvailabilityResponse!.result!.rejectVolunteerList!.length,
             itemBuilder: (BuildContext context, int index) {
               return MenuScreenCard(
                 roleID:int.parse(_userRole!),

                 icon: Icon(Icons.person),
                 trailing: widget.eventList.status==Constants.upcoming && (int.parse(_userRole!) == Constants.owner ||
                     int.parse(_userRole!) == Constants.coachorManager)
                     ? Icon(
                   Icons.outgoing_mail,
                   color: MyColors.black,
                 )
                     : null,
                 image: _volunteerAvailabilityResponse!.result!.rejectVolunteerList![index].userProfileImage != null &&
                     _volunteerAvailabilityResponse!.result!.rejectVolunteerList![index].userProfileImage!.isNotEmpty
                     ? base64Decode(_volunteerAvailabilityResponse!.result!.rejectVolunteerList![index].userProfileImage!)
                     : null,
                 title: _volunteerAvailabilityResponse!.result!.rejectVolunteerList![index].userName,
                 subTitle: _volunteerAvailabilityResponse!.result!.rejectVolunteerList![index].volunteerJobName,
                 index: index,
                 onResend: (position) {
                   if (widget.eventList.status==Constants.upcoming && (int.parse(_userRole!) == Constants.owner ||
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
                                   _volunteerAvailabilityResponse!.result!.rejectVolunteerList![position].userId!,
                                   widget.eventList.eventId!,
                                   _volunteerAvailabilityResponse!.result!.rejectVolunteerList![position].userName!,
                                   _volunteerAvailabilityResponse!.result!.rejectVolunteerList![position].email!,
                                   widget.eventList.name!,
                                   widget.eventList.type!,
                                   teamName!,
                                   fcm!,
                                   userName!,
                                   userMail!,
                                   userIdNo!,
                                   _volunteerAvailabilityResponse!.result!.rejectVolunteerList![index].userName!,
                                   _volunteerAvailabilityResponse!.result!.rejectVolunteerList![index].volunteerJobName!,
                                   _volunteerAvailabilityResponse!.result!.rejectVolunteerList![index].eventVolunteerTypeIDNo!,
                               ),

                               //Navigation.navigateTo(context, MyRoutes.introScreen)
                             },
                             cancelColor: MyColors.red,
                             cancelFun: () =>
                             {Navigator.of(context, rootNavigator: true).pop()},
                             //cancelFun: () => null,
                             title:
                             "Do you want to resend the email to " + _volunteerAvailabilityResponse!.result!.rejectVolunteerList![index].email! + "?"
                         ));
                   }
                 },
               );
             },
           );
         } else if (_availabilityListviewProvider!.selectedVolunteerValue == MyStrings.notResponded) {
           return ListView.builder(
             scrollDirection: Axis.vertical,
             physics: NeverScrollableScrollPhysics(),
             shrinkWrap: true,
             // new
             itemCount: _volunteerAvailabilityResponse!.result!.notRespondVolunteerList!.length == null
                 ? 0
                 : _volunteerAvailabilityResponse!.result!.notRespondVolunteerList!.length,
             itemBuilder: (BuildContext context, int index) {
               return MenuScreenCard(
                 roleID:int.parse(_userRole!),

                 icon: Icon(Icons.person),
                 trailing: widget.eventList.status==Constants.upcoming &&(int.parse(_userRole!) == Constants.owner ||
                     int.parse(_userRole!) == Constants.coachorManager)
                     ? Icon(Icons.outgoing_mail, color: MyColors.black)
                     : null,
                 image:
                 _volunteerAvailabilityResponse!.result!.notRespondVolunteerList![index].userProfileImage != null &&
                     _volunteerAvailabilityResponse!.result!.notRespondVolunteerList![index].userProfileImage!
                         .isNotEmpty
                     ? base64Decode(
                     _volunteerAvailabilityResponse!.result!.notRespondVolunteerList![index].userProfileImage!)
                     : null,
                 title: _volunteerAvailabilityResponse!.result!.notRespondVolunteerList![index].userName,
                 subTitle: _volunteerAvailabilityResponse!.result!.notRespondVolunteerList![index].volunteerJobName,
                 index: index,
                 onResend: (position) {
                   if (widget.eventList.status==Constants.upcoming && (int.parse(_userRole!) == Constants.owner ||
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
                                   _volunteerAvailabilityResponse!.result!.notRespondVolunteerList![position].userId!,
                                   widget.eventList.eventId!,
                                   _volunteerAvailabilityResponse!.result!.notRespondVolunteerList![position].userName!,
                                   _volunteerAvailabilityResponse!.result!.notRespondVolunteerList![position].email!,
                                   widget.eventList.name!,
                                   widget.eventList.type!,
                                   teamName!,
                                   fcm!,
                                   userName!,
                                   userMail!,
                                   userIdNo!, _volunteerAvailabilityResponse!.result!.notRespondVolunteerList![index].userName!,
                                 _volunteerAvailabilityResponse!.result!.notRespondVolunteerList![index].volunteerJobName!,
                                 _volunteerAvailabilityResponse!.result!.notRespondVolunteerList![index].eventVolunteerTypeIDNo!,
                               ),

                               //Navigation.navigateTo(context, MyRoutes.introScreen)
                             },
                             cancelColor: MyColors.red,
                             cancelFun: () =>
                             {Navigator.of(context, rootNavigator: true).pop()},
                             //cancelFun: () => null,
                             title:
                             "Do you want to resend the email to " + _volunteerAvailabilityResponse!.result!.notRespondVolunteerList![index].email! + "?"
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
      floatingActionButton: widget.eventList.status==Constants.upcoming && (int.parse(_userRole!) == Constants.owner ||
          int.parse(_userRole!) == Constants.coachorManager)? FloatingActionButton(
        tooltip: MyStrings.volunteer,
        onPressed: () {
          Navigation.navigateWithArgument(
              context,
              MyRoutes.updateVolunteerListviewScreen,
              widget.eventList);          //shareDrillPopupDialog();
        },
        backgroundColor: MyColors.kPrimaryColor,
        child: const Icon(Icons.edit,color: MyColors.white,),
      ):null,
      body:  Consumer<AvailabilityListviewProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: EdgeInsets.all(
                  getValueForScreenType<
                      bool>(
                    context: context,
                    mobile: false,
                    tablet: true,
                    desktop: true,
                  )
                      ? PaddingSize
                      .headerPadding1
                      : PaddingSize
                      .headerPadding1),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: Dimens
                          .standard_50,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,

                        focusColor: MyColors.white,
                          selectedItemHighlightColor: MyColors.white,
                          items: getAvailability.map((Availability
                          gen) {
                            return new DropdownMenuItem<
                                String>(value: gen.status,
                              child: new Text(gen.status, style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText2),
                            );
                          }).toList(),
                          value: provider.selectedVolunteerValue,
                          onChanged: (value) {
                            setState(() {
                              provider.selectedVolunteerValue = value.toString();
                            });
                          },
                          buttonWidth: getValueForScreenType<
                              bool>(
                            context: context,
                            mobile: true,
                            tablet: false,
                            desktop: false,
                          )
                              ? size.width-58
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
                          icon: MyIcons
                              .arrowdownIos,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: MyColors.white,
                          ),
                          buttonDecoration:
                          BoxDecoration(
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
                      //   itemWidth: getValueForScreenType<
                      //       bool>(
                      //     context: context,
                      //     mobile: true,
                      //     tablet: false,
                      //     desktop: false,
                      //   )
                      //       ? size.width-58
                      //       : getValueForScreenType<bool>(
                      //     context: context,
                      //     mobile: false,
                      //     tablet: true,
                      //     desktop: false,
                      //   )
                      //       ? size.width * 0.4
                      //       : size.width * 0.41,
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
                      //   value: provider.selectedVolunteerValue,
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
                      //       provider.selectedVolunteerValue = val;
                      //     });
                      //   },
                      // ),
                    ),
                    if(_volunteerAvailabilityResponse != null)
                      showPlayerList()!,

                  ],
                ),
              ),
            );
          }),
    );
  }

       void sendEmail(int userId, int eventId, String userName, String email, String eventName, String eventType, String teamName, String fcm, String name, String userMail, String userIdNo, String playerName,String volunteer, int eventVolunteerTypeIDNo) async {
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
             widget.eventList.locationAddress!)
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
                   widget.eventList.name!,
                   Constants.gameVolunteerInvite,
                   userId,
                   eventId,
                   ("Volunteer task has been assigned by "+userName+" for the "+
                       (widget.eventList.type!) +" "+
                       widget.eventList.name! +
                       " that is scheduled to commence on " +
                       widget.eventList.scheduleDate! + " " +
                       (widget.eventList.scheduleTime=="00:00"?"TBD":DateFormat("h:mma")
                       .format(DateFormat("h:mma").parse(widget.eventList.scheduleTime!))) +
                       " at " +
                       widget.eventList.locationAddress!+
                       "."),
                   email,
                   userName,
                   widget.eventList.name!,
                   acceptvalue,
                   maybevalue,
                   declainvalue,
                   widget.eventList.locationAddress!,
                   widget.eventList.scheduleDate!,
                   widget.eventList.scheduleTime=="00:00"?"TBD":DateFormat("h:mma")
                       .format(DateFormat("h:mma").parse(widget.eventList.scheduleTime!)),
                   "","",name,teamName,volunteer,userId.toString(),eventVolunteerTypeIDNo


               );
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
  // Availability(
  //   3,
  //   MyStrings.tentative,
  // ),
  Availability(
    3,
    MyStrings.notResponded,
  ),
];
