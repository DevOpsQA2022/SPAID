import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaid/model/response/game_event_response/game_team_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/widgets/event_custom_button.dart';

class HomeEventSportCard extends StatefulWidget {
  final String? namecontroller;
  final bool? deletebuttoncontroller;
  final bool? cancelbuttoncontroller;
  final String? statuscontroller;
  final String? locationcontroller;
  final String? datecontroller;
  final String? timecontroller;
  final String? typecontroller;
  final String? userRole;
  final String? dateformat;
  final GameOrEventList? gameOrEventList;

  final int? index;
  final int? EventGroupId;
  final Function(int, String)? myDelete;
  final Function(int, String)? myCancel;
  final Function(int, int)? updateStatus;

  // final bool buttonEnable;
  // final void Function(String) onSave;
  // final Function onOk;
  // BuildContext context;

  HomeEventSportCard({
    // @required this.subtitle,
    // @required this.location,
    // @required this.sportName,
    // @required this.date,
    this.locationcontroller,
    this.datecontroller,
    this.timecontroller,
    this.typecontroller,
    this.index,
    this.EventGroupId,
    this.myDelete,
    this.myCancel,
    this.updateStatus,
    this.namecontroller,
    this.deletebuttoncontroller,
    this.cancelbuttoncontroller,
    this.statuscontroller,
    this.userRole,
    this.dateformat,
    this.gameOrEventList,
    // this.onSave,
    // this.onOk,
    // this.context,
  });

  @override
  _HomeEventSportCardState createState() => _HomeEventSportCardState();
}

class _HomeEventSportCardState extends State<HomeEventSportCard> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      insetPadding: EdgeInsets.all(10),
      elevation: 0.0,
      backgroundColor: MyColors.white,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(
      //   top:  Consts.padding,
      //   bottom: Consts.padding,
      //   left: Dimens.standard_5,
      //   right: Dimens.standard_1,
      // ),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Consts.padding),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 2),
            // spreadRadius: 7,
            // offset: const Offset(0.0, 10.0,),
          ),
        ],
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min, // To make the card compact
        // mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        kIsWeb ? EdgeInsets.all(20.0) : EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          child: ClipOval(
                            child: Image.asset(
                              widget.typecontroller == "Event"
                                  ? MyImages.eventImg
                                  : MyImages.gameImg,
                              width: 120,
                              height: 130,
                              fit: BoxFit.fill,
                            ),
                          ),
                          radius: 60,
                        ),
                        SizedBox(height: SizedBoxSize.headerSizedBoxHeight),
                        // SizedBox(height: SizedBoxSize.headerSizedBoxHeight),
                        // SizedBox(height: SizedBoxSize.headerSizedBoxHeight),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Image(image: AssetImage(MyImages.addRoster),height: Dimens.dp_18,),
                            // MyIcons.listView,
                            (int.parse(widget.userRole!) ==
                                            Constants.coachorManager ||
                                        int.parse(widget.userRole!) ==
                                            Constants.owner) &&
                                ((widget.timecontroller == "00:00"?(DateFormat('dd/MM/yyyy HH:mm').parse(
    widget.datecontroller! +
    " " +
    widget.timecontroller!)):(DateFormat('dd/MM/yyyy H:mma').parse(
                                                widget.datecontroller! +
                                                    " " +
                                                    widget.timecontroller!)))
                                            .compareTo(DateTime.now()) <=
                                        0) &&
                                    (widget.statuscontroller == "Upcoming" ||
                                        widget.statuscontroller == "Ongoing")
                                ? PopupMenuButton<int>(
                                    tooltip: "Edit",
                                    child: Icon(
                                      Icons.edit,
                                      // size: 18,
                                    ),
                                    onSelected: (value) {
                                      if (value == 1) {
                                        widget.updateStatus!(
                                            widget.index!, Constants.ongoing);

                                        // selectFileAsync();
                                      }
                                      if (value == 2) {
                                        widget.updateStatus!(
                                            widget.index!, Constants.completed);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: Text("Ongoing"),
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: Text("Completed"),
                                      ),
                                    ],
                                  )
                                : Container(),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              // "bkjfdsljfdshklsdjgkdsfvhgklmsdglsjdkl/dg;lkjsdgdfgdfgdfgdgdgd",
                              widget.statuscontroller!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  letterSpacing: Dimens.letterSpacing_25,
                                  color: MyColors.kPrimaryColor),
                            ),
                          ],
                        ),
                        SizedBox(height: SizedBoxSize.headerSizedBoxHeight),

                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'OswaldLight',
                              color: MyColors.textColor,
                            ),
                            children: [
                              WidgetSpan(
                                child: MyIcons.location,
                              ),
                              TextSpan(
                                text: " " + widget.locationcontroller!,
                                // text: "dgfdfjgkdhfj gksilghslhkfjks djhfdsguhsdkfg sdflgksdfgkdsfj lgdfgkhsjflgjdhfig " ,
                                style: TextStyle(
                                    letterSpacing: Dimens.letterSpacing_25,
                                    color: MyColors.colorGray_818181),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizedBoxSize.headerSizedBoxHeight),

                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'OswaldLight',
                              color: MyColors.textColor,
                            ),
                            children: [
                              /*  TextSpan(
                            text: "Date : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimens.standard_16),
                          ),*/
                              WidgetSpan(
                                child: MyIcons.calendar,
                              ),
                              TextSpan(
                                text: " " + widget.dateformat! == "US"
                                    ? DateFormat("MM/dd/yyyy").format(
                                        (DateFormat('dd/MM/yyyy')
                                            .parse(widget.datecontroller!)))
                                    : widget.dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                            (DateFormat('dd/MM/yyyy')
                                                .parse(widget.datecontroller!)))
                                        : DateFormat("dd/MM/yyyy").format(
                                            (DateFormat('dd/MM/yyyy')
                                                .parse(widget.datecontroller!))),
                                style: TextStyle(
                                    letterSpacing: Dimens.letterSpacing_25,
                                    color: MyColors.colorGray_818181),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizedBoxSize.headerSizedBoxHeight),

                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'OswaldLight',
                              color: MyColors.textColor,
                            ),
                            children: [
                              /*TextSpan(
                            text: "Time : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimens.standard_16),
                          ),*/
                              WidgetSpan(
                                child: MyIcons.timer,
                              ),
                              TextSpan(
                                text: (widget.timecontroller == "00:00")
                                    ? " " + MyStrings.timeTbd
                                    : " " +
    widget.timecontroller!,
                                style: TextStyle(
                                    letterSpacing: Dimens.letterSpacing_25,
                                    color: MyColors.colorGray_818181),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.namecontroller!,
                        style: TextStyle(
                            letterSpacing: Dimens.letterSpacing_25,
                            fontWeight: FontWeight.bold,
                            color: MyColors.colorGray_818181),
                      ),
                      SizedBox(height: SizedBoxSize.headerSizedBoxHeight),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("",
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                              SizedBox(
                                  height: SizedBoxSize.headerSizedBoxHeight),
                              Text(MyStrings.available,
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                              SizedBox(
                                  height: SizedBoxSize.headerSizedBoxHeight),
                              Text(MyStrings.notAvailable,
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                              SizedBox(
                                  height: SizedBoxSize.headerSizedBoxHeight),
                              Text(MyStrings.tentative,
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                              SizedBox(
                                  height: SizedBoxSize.headerSizedBoxHeight),
                              Text(MyStrings.notResponded,
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                            ],
                          ),
                          // SizedBox(
                          //   width: 30,
                          // ),
                          Column(
                            children: [
                              Text("Player",
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                              SizedBox(
                                  height: SizedBoxSize.headerSizedBoxHeight),
                              Text(
                                  widget.gameOrEventList!.teamEventList!.first
                                      .available
                                      .toString(),
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                              SizedBox(
                                  height: SizedBoxSize.headerSizedBoxHeight),
                              Text(
                                  widget.gameOrEventList!.teamEventList!.first
                                      .reject
                                      .toString(),
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                              SizedBox(
                                  height: SizedBoxSize.headerSizedBoxHeight),
                              Text(
                                  widget
                                      .gameOrEventList!.teamEventList!.first.mayBe
                                      .toString(),
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                              SizedBox(
                                  height: SizedBoxSize.headerSizedBoxHeight),
                              Text(
                                  (widget.gameOrEventList!.teamEventList!.first
                                              .notRespond! +
                                          widget.gameOrEventList!.teamEventList!
                                              .first.mailNotSend!)
                                      .toString(),
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                            ],
                          ),
                          // SizedBox(
                          //   width: 30 ,
                          // ),
                          Column(
                            children: [
                              Text("Volunteer",
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                              SizedBox(
                                  height: SizedBoxSize.headerSizedBoxHeight),
                              Text(
                                  widget
                                      .gameOrEventList!
                                      .volunteerTypeAvailabilityList!
                                      .first
                                      .available
                                      .toString(),
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                              SizedBox(
                                  height: SizedBoxSize.headerSizedBoxHeight),
                              Text(
                                  widget
                                      .gameOrEventList!
                                      .volunteerTypeAvailabilityList!
                                      .first
                                      .reject
                                      .toString(),
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                              SizedBox(
                                  height: SizedBoxSize.headerSizedBoxHeight),
                              Text(
                                  widget.gameOrEventList!
                                      .volunteerTypeAvailabilityList!.first.mayBe
                                      .toString(),
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                              SizedBox(
                                  height: SizedBoxSize.headerSizedBoxHeight),
                              Text(
                                  widget
                                      .gameOrEventList!
                                      .volunteerTypeAvailabilityList!
                                      .first
                                      .notRespond
                                      .toString(),
                                  style: TextStyle(
                                      color: MyColors.colorGray_818181)),
                            ],
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: Dimens.dp_8,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(MyStrings.notAvailable,
                      //         style: TextStyle(color: MyColors.colorGray_818181)),
                      //     // SizedBox(
                      //     //   width: 70,
                      //     // ),
                      //     Text("0",
                      //         style: TextStyle(color: MyColors.colorGray_818181)),
                      //     // SizedBox(
                      //     //   width: 60,
                      //     // ),
                      //     Text("0",
                      //         style: TextStyle(color: MyColors.colorGray_818181)),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: Dimens.dp_8,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(MyStrings.tentative,
                      //         style: TextStyle(color: MyColors.colorGray_818181)),
                      //     // SizedBox(
                      //     //   width: kIsWeb?50:93,
                      //     // ),
                      //     Text("0",
                      //         style: TextStyle(color: MyColors.colorGray_818181)),
                      //     // SizedBox(
                      //     //   width: kIsWeb?10:93,
                      //     // ),
                      //     Text("0",
                      //         style: TextStyle(color: MyColors.colorGray_818181)),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: Dimens.dp_8,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(MyStrings.notResponded,
                      //         style: TextStyle(color: MyColors.colorGray_818181)),
                      //     // SizedBox(
                      //     //   width: Dimens.dp_50,
                      //     // ),
                      //     Text((int.parse("0")+int.parse("0")).toString(),
                      //         style: TextStyle(color: MyColors.colorGray_818181)),
                      //     // SizedBox(
                      //     //   width: Dimens.dp_50,
                      //     // ),
                      //     Text((int.parse("0")+int.parse("0")).toString(),
                      //         style: TextStyle(color: MyColors.colorGray_818181)),
                      //   ],
                      // ),
                      SizedBox(height: SizedBoxSize.headerSizedBoxHeight),
                      SizedBox(height: SizedBoxSize.headerSizedBoxHeight),
                      // SizedBox(height: SizedBoxSize.headerSizedBoxHeight),

                      EventCustomButton(
                          buttonColor: MyColors.kPrimaryColor,
                          buttonHeight: Dimens.standard_35,
                          onPressed: () {
                            Navigation.navigateWithArgument(
                                context,
                                MyRoutes.AvailableTabScreen,
                                widget.gameOrEventList!);
                          },
                          buttonText: MyStrings.availability),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //
          // SizedBox(height: SizedBoxSize.headerSizedBoxHeight),
          // // ignore: unrelated_type_equality_checks
          // widget.cancelbuttoncontroller == true
          //     ? Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: <Widget>[
          //           /*EventCustomButton(
          //             buttonColor: MyColors.kPrimaryColor,
          //             buttonHeight: Dimens.standard_35,
          //             onPressed: () {
          //               showDialog(
          //                   context: context,
          //                   barrierDismissible: false,
          //                   builder: (BuildContext context) => FancyDialog(
          //                         gifPath: MyImages.team,
          //
          //
          //                         okFun: () => {
          //                           Navigator.of(context).pop(),
          //
          //                         },
          //                         cancelFun: () =>
          //                             {Navigator.of(context).pop()},
          //                         title: "Are you sure to cancel?",
          //                       ));
          //             },
          //             buttonText: MyStrings.notification),
          //     SizedBox(width: 4.0),*/
          //           widget.EventGroupId != null
          //               ? PopupMenuButton<int>(
          //                   child: Container(
          //                       height: Dimens.standard_35,
          //                       child: Text(MyStrings.cancel,
          //                           style: TextStyle(
          //                               color: MyColors.white,
          //                               letterSpacing:
          //                                   Dimens.letterSpacing_25,
          //                               fontWeight: FontWeight.bold,
          //                               fontSize: Dimens.standard_16)),
          //                       decoration: BoxDecoration(
          //                           color: MyColors.kPrimaryColor,
          //                           border: Border.all(
          //                               color: MyColors.kPrimaryColor),
          //                           borderRadius: BorderRadius.circular(
          //                               Dimens.standard_10)),
          //                       padding: EdgeInsets.only(
          //                           left: 18,
          //                           right: 20,
          //                           top: 3,
          //                           bottom: 2)),
          //                   onSelected: (value) {
          //                     if (value == 1) {
          //                       showDialog(
          //                           context: context,
          //                           barrierDismissible: false,
          //                           builder: (BuildContext context) =>
          //                               FancyDialog(
          //                                 gifPath: MyImages.team,
          //                                 cancelColor: MyColors.red,
          //                                 okFun: () => {
          //                                   widget.myCancel(
          //                                       widget.index, "All"),
          //                                   Navigator.of(context).pop(),
          //                                 },
          //                                 cancelFun: () =>
          //                                     {Navigator.of(context).pop()},
          //                                 title:
          //                                     "Are you sure you want to cancel?",
          //                               ));
          //
          //                       // selectFileAsync();
          //                     }
          //                     if (value == 2) {
          //                       showDialog(
          //                           context: context,
          //                           barrierDismissible: false,
          //                           builder: (BuildContext context) =>
          //                               FancyDialog(
          //                                 gifPath: MyImages.team,
          //                                 cancelColor: MyColors.red,
          //                                 okFun: () => {
          //                                   widget.myCancel(
          //                                       widget.index, "Occurrence"),
          //                                   Navigator.of(context).pop(),
          //                                 },
          //                                 cancelFun: () =>
          //                                     {Navigator.of(context).pop()},
          //                                 title:
          //                                     "Are you sure you want to cancel?",
          //                               ));
          //                     }
          //                   },
          //                   itemBuilder: (context) => [
          //                     PopupMenuItem(
          //                       value: 1,
          //                       child: Text("Cancel series"),
          //                     ),
          //                     PopupMenuItem(
          //                       value: 2,
          //                       child: Text("Cancel occurrence"),
          //                     ),
          //                   ],
          //                 )
          //               : EventCustomButton(
          //                   buttonColor: MyColors.kPrimaryColor,
          //                   buttonHeight: Dimens.standard_35,
          //                   onPressed: () {
          //                     showDialog(
          //                         context: context,
          //                         barrierDismissible: false,
          //                         builder: (BuildContext context) =>
          //                             FancyDialog(
          //                               gifPath: MyImages.team,
          //                               cancelColor: MyColors.red,
          //                               okFun: () => {
          //                                 widget.myCancel(widget.index, ""),
          //                                 Navigator.of(context).pop(),
          //                               },
          //                               cancelFun: () =>
          //                                   {Navigator.of(context).pop()},
          //                               title:
          //                                   "Are you sure you want to cancel?",
          //                             ));
          //                   },
          //                   buttonText: MyStrings.cancel),
          //         ],
          //       )
          //     : Container(),
          // widget.deletebuttoncontroller == true
          //     ? Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //
          //           EventCustomButton(
          //               buttonColor: MyColors.kPrimaryColor,
          //               buttonHeight: Dimens.standard_35,
          //               onPressed: () {
          //                 showDialog(
          //                     context: context,
          //                     barrierDismissible: false,
          //                     builder: (BuildContext context) =>
          //                         FancyDialog(
          //                           gifPath: MyImages.team,
          //                           cancelColor: MyColors.red,
          //                           cancelFun: () =>
          //                               {Navigator.of(context).pop()},
          //                           okFun: () => {
          //                             widget.myDelete(widget.index, ""),
          //                             Navigator.of(context).pop()
          //                           },
          //                           title:
          //                               "Are you sure you want to delete?",
          //                         ));
          //               },
          //               buttonText: MyStrings.delete)
          //         ],
          //       )
          //     : Container(),
          SizedBox(height: SizedBoxSize.headerSizedBoxHeight),
        ],
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
