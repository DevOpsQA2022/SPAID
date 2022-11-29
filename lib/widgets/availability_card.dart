import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaid/model/response/game_event_response/game_availablity_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/widgets/custom_smart_button.dart';

class AvailabilityListCard extends StatefulWidget {
  final String? profileImageString;
  final String? titleText;
  final String? available;
  final String? reject;
  final String? notRespond;
  final String? mailNotSend;
  final String? mayBe;
  final String? date;
  final String? time;
  final String? address;
  final String? role;
  final String? dateformat;
  final VoidCallback? onTap;
  final int? gameid;
  final TeamEventList? teamEventList;

  AvailabilityListCard({
    this.profileImageString,
    this.titleText,
    this.available,
    this.reject,
    this.notRespond,
    this.mailNotSend,
    this.mayBe,
    this.date,
    this.time,
    this.onTap,
    this.gameid,
    this.role,
    this.address,
    this.dateformat,
    this.teamEventList,

  });

  @override
  _AvailabilityListCardState createState() => _AvailabilityListCardState();
}

class _AvailabilityListCardState extends State<AvailabilityListCard> {
  @override
  Widget build(BuildContext context) {
    print("Marlen"+ widget.time!);
    return Container(
      height: Dimens.standard_390,
      child: Card(
        elevation: 10,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                SizedBox(width: 20,),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(widget.profileImageString!),
                    radius: 60.0,
                    backgroundColor: Colors.white,
                    // foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 30,),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 25,),
                        Text(
                          widget.titleText!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: Dimens.letterSpacing_25,
                              color: MyColors.black),
                        ),
                        SizedBox(
                          height: Dimens.dp_8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(MyStrings.available,
                                style: TextStyle(color: MyColors.colorGray_818181)),
                            SizedBox(
                              width: Dimens.dp_81,
                            ),
                            Text(widget.available!,
                                style: TextStyle(color: MyColors.colorGray_818181)),
                          ],
                        ),
                        SizedBox(
                          height: Dimens.dp_8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(MyStrings.notAvailable,
                                style: TextStyle(color: MyColors.colorGray_818181)),
                            SizedBox(
                              width: Dimens.dp_60,
                            ),
                            Text(widget.reject!,
                                style: TextStyle(color: MyColors.colorGray_818181)),
                          ],
                        ),
                        SizedBox(
                          height: Dimens.dp_8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(MyStrings.tentative,
                                style: TextStyle(color: MyColors.colorGray_818181)),
                            SizedBox(
                              width: kIsWeb?Dimens.dp_91:93,
                            ),
                            Text(widget.mayBe!,
                                style: TextStyle(color: MyColors.colorGray_818181)),
                          ],
                        ),
                        SizedBox(
                          height: Dimens.dp_8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(MyStrings.notResponded,
                                style: TextStyle(color: MyColors.colorGray_818181)),
                            SizedBox(
                              width: Dimens.dp_50,
                            ),
                            Text((int.parse(widget.notRespond!)+int.parse(widget.mailNotSend!)).toString(),
                                style: TextStyle(color: MyColors.colorGray_818181)),
                          ],
                        ),
                        SizedBox(
                          height: Dimens.dp_15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizedBoxSize.headerSizedBoxHeight,
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SizedBox(
          height: 80,
          width: 240,
          child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'OswaldLight',
                        color: MyColors.textColor,
                      ),
                      children: [
                        WidgetSpan(
                          child:MyIcons.location,
                        ),
                        TextSpan(
                          text:" "+ widget.address!,
                          style: TextStyle(
                              letterSpacing: Dimens.letterSpacing_25,
                              color: MyColors.colorGray_818181),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ]
            ),
            SizedBox(height: SizedBoxSize.headerSizedBoxHeight),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               /* Row(
                  children: [
                    MyIcons.location,
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.address,
                        style: TextStyle(
                            letterSpacing: Dimens.letterSpacing_25,
                            color: MyColors.colorGray_818181),
                      ),
                    )
                  ],
                ),*/
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'OswaldLight',
                      color: MyColors.textColor,
                    ),
                    children: [
                      WidgetSpan(
                        child:MyIcons.calendar,
                      ),
                      TextSpan(
                        text:" "+ widget.dateformat! == "US"
                            ? DateFormat("MM/dd/yyyy").format((DateFormat('dd/MM/yyyy').parse(widget.date!)))
                            : widget.dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format((DateFormat('dd/MM/yyyy').parse(widget.date!)))
                            : DateFormat("dd/MM/yyyy").format((DateFormat('dd/MM/yyyy').parse(widget.date!))),
                        style: TextStyle(
                            letterSpacing: Dimens.letterSpacing_25,
                            color: MyColors.colorGray_818181),
                      ),
                    ],
                  ),
                ),
              /*  Row(
                  children: [
                    MyIcons.calendar,
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.date,
                        style: TextStyle(
                            letterSpacing: Dimens.letterSpacing_25,
                            color: MyColors.colorGray_818181),
                      ),
                    )
                  ],
                ),*/
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'OswaldLight',
                      color: MyColors.textColor,
                    ),
                    children: [
                      WidgetSpan(
                        child:MyIcons.timer,
                      ),
                      TextSpan(
                        text: (widget.time=="00:00")?" "+MyStrings.timeTbd:" "+DateFormat("h:mma")
                            .format(DateFormat("hh:mm").parse(widget.time!)),
                        style: TextStyle(
                            letterSpacing: Dimens.letterSpacing_25,
                            color: MyColors.colorGray_818181),
                      ),
                    ],
                  ),
                ),
                /*Row(
                  children: [
                    MyIcons.timer,
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.time=="00:00"?MyStrings.timeTbd:widget.time,
                        style: TextStyle(
                            letterSpacing: Dimens.letterSpacing_25,
                            color: MyColors.colorGray_818181),
                      ),
                    )
                  ],
                ),*/
              ],
            ),
            SizedBox(
              height: SizedBoxSize.headerSizedBoxHeight,
            ),
            int.parse(widget.role!) == Constants.owner ||
                    int.parse(widget.role!) == Constants.coachorManager
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SmallRaisedButton(
                          onPressed: () async {
                            await Navigation.navigateWithArgument(
                                context,
                                MyRoutes.updateVolunteerListviewScreen,
                                widget.teamEventList!);
                          },
                          buttonText: MyStrings.volunteer,
                          //buttonWidth: WidgetCustomSize.smallButtonWidth,
                          buttonColor: MyColors.kPrimaryColor),
                      SmallRaisedButton(
                          onPressed: () async {
                            Navigation.navigateWithArgument(
                                context,
                                MyRoutes.volunteerAvailablityScreen,
                                widget.teamEventList!);
                            /*await Navigation.navigateWithArgument(
                                context,
                                MyRoutes.updateVolunteerListviewScreen,
                                widget.gameid);*/
                          },
                          buttonText: MyStrings.volunteerAvailablity,
                         // buttonWidth: WidgetCustomSize.smallButtonWidth,
                          buttonColor: MyColors.kPrimaryColor),
                    ],
                  )
                : Container(),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  String? getAvailabePlayers(List<dynamic> players, String status) {
    int available = 0, notAvailable = 0, tentative = 0, notResponded = 0;
    for (int i = 0; i < players.length; i++) {
      if (players[i]["status"] == MyStrings.available) {
        available++;
      }
      if (players[i]["status"] == MyStrings.notAvailable) {
        notAvailable++;
      }
      if (players[i]["status"] == MyStrings.tentative) {
        tentative++;
      }
      if (players[i]["status"] == MyStrings.notResponded) {
        notResponded++;
      }
    }
    if (status == MyStrings.available) {
      return available.toString();
    }
    if (status == MyStrings.notAvailable) {
      return notAvailable.toString();
    }
    if (status == MyStrings.tentative) {
      return tentative.toString();
    }
    if (status == MyStrings.notResponded) {
      return notResponded.toString();
    }
  }
}
