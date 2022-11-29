import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spaid/model/response/roaster_listview_response/roaster_listview_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/widgets/home_eventSport_card.dart';

class PlayerListCard extends StatefulWidget {
  final String? profileImageString;
  final String? calendarImageString;
  final String? titleText;
  final String? groupText;
  final String? userImageString;
  final String? descriptionText;
  final String? jersey;
  final String? position;
  final int? status;
  final int? roleID;
  final int? userRoleId;
  final int? userID;
  final int? totalMatchesPlayed;
  final int? totalGoals;
  final int? playerAssists;
  final int? totalPenalty;
  final bool? isRoleShow;
  final String? sponsorshipCountText;
  final VoidCallback? onTap;
  List<UserDetails>? roasterListViewFamilyResponse;

  PlayerListCard({
    this.profileImageString,
    this.titleText,
    this.groupText,
    this.jersey,
    this.position,
    this.userImageString,
    this.descriptionText,
    this.status,
    this.roleID,
    this.isRoleShow,
    this.sponsorshipCountText,
    this.calendarImageString,
    this.onTap,
    this.userID,
    this.userRoleId,
    this.totalMatchesPlayed,
    this.totalGoals,
    this.playerAssists,
    this.totalPenalty,
    this.roasterListViewFamilyResponse,
  });

  @override
  _PlayerListCardState createState() => _PlayerListCardState();
}

class _PlayerListCardState extends State<PlayerListCard> {
  bool isHovering = false;

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
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        opaque: false,
        child: GestureDetector(
            onTap: widget.onTap,
            child: Stack(
              children: <Widget>[
                Container(
                  // height: 120,
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: Consts.padding,
                    //left: Dimens.standard_5,
                    right: Dimens.standard_1,
                  ),
                  margin: EdgeInsets.only(top: Dimens.standard_50),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(Consts.padding),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        // offset: Offset(0, 2),
                      ),
                    ],
                  ), //SizedBox(height: SizedBoxSize.headerSizedBoxHeight),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(width: kIsWeb?80:50,),
                            Expanded(
                              child: Text(
                              "Number: " + widget.jersey!,
                              style: TextStyle(
                                  //letterSpacing: Dimens.letterSpacing_25,
                                  color: MyColors.black),
                              ),
                            ),
                            Expanded(child: SizedBox(width: 20,)),
                            Expanded(
                              child: Text(
                                "Position: " + widget.position!,
                                style: TextStyle(
                                    // letterSpacing: Dimens.letterSpacing_25,
                                    color: MyColors.black),
                              ),
                            ),
                            SizedBox(width: 20,),

                          ]),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.titleText!,
                              style: TextStyle(
                                  //letterSpacing: Dimens.letterSpacing_25,
                                  color: MyColors.black),
                            ),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.groupText!,
                            style: TextStyle(
                                letterSpacing: Dimens.letterSpacing_25,
                                color: MyColors.kPrimaryColor),
                          ),
                        ],
                      ),
                      /*Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,

                             children: [
                               Text("Games Played: "+
                                   widget.jersey,
                                 style: TextStyle(
                                   letterSpacing: Dimens.letterSpacing_25,
                                     color: MyColors.black),
                               ),
                               //SizedBox(width: 40,),
                               Text("Plus Minus: "+
                                   widget.position,
                                 style: TextStyle(
                                    letterSpacing: Dimens.letterSpacing_25,
                                     color: MyColors.black),
                               ),
                             ]
                         ),
                         Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                             children: [
                               Text("Goals: "+
                                   widget.jersey,
                                 style: TextStyle(
                                   //letterSpacing: Dimens.letterSpacing_25,
                                     color: MyColors.black),
                               ),
                               //SizedBox(),
                               Text("SOA: "+
                                   widget.position,
                                 style: TextStyle(
                                   // letterSpacing: Dimens.letterSpacing_25,
                                     color: MyColors.black),
                               ),
                             ],
                         ),
                         Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                             children: [
                               Text("Assists: "+
                                   widget.jersey,
                                 style: TextStyle(
                                   //letterSpacing: Dimens.letterSpacing_25,
                                     color: MyColors.black),
                               ),
                               //SizedBox(),
                               Text("GAA: "+
                                   widget.position,
                                 style: TextStyle(
                                   // letterSpacing: Dimens.letterSpacing_25,
                                     color: MyColors.black),
                               ),
                             ]
                         ),*/
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Games Played: " +
                                      widget.totalMatchesPlayed.toString(),
                                  style: TextStyle(
                                      letterSpacing: Dimens.letterSpacing_25,
                                      color: MyColors.black),
                                ),

                                //SizedBox(width: 40,),
                                Text(
                                  "Goals: " + widget.totalGoals.toString(),
                                  style: TextStyle(
                                      letterSpacing: Dimens.letterSpacing_25,
                                      color: MyColors.black),
                                ),
                              ],
                            ),
                            //SizedBox(),
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Penalty: " +
                                        widget.totalPenalty.toString(),
                                    style: TextStyle(color: MyColors.black),
                                  ),
                                  Text(
                                    "Assists: " +
                                        widget.playerAssists.toString(),
                                    style: TextStyle(
                                        //letterSpacing: Dimens.letterSpacing_25,
                                        color: MyColors.black),
                                  ),
                                ]),
                          ]),
                    ],
                  ),
                ),
                Center(
                  child: Stack(
                    children: [
                      Positioned(
                        // left: 135,
                        // bottom: 120,
                        // left: Consts.padding,
                        //top: Dimens.standard_50,
                        // right: Consts.padding,
                        // bottom: Dimens.dp_65,
                        child: widget.profileImageString != "null" &&
                                widget.profileImageString!.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(
                                    base64Decode(widget.profileImageString!)),
                                radius: 40.0,
                                backgroundColor: Colors.white,
                                // foregroundColor: Colors.white,
                              )
                            : CircleAvatar(
                                radius: 40.0,
                                backgroundColor: MyColors.kPrimaryColor,
                                child: Text(
                                    widget.titleText!
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: MyColors.white, fontSize: 30)),
                              ),
                        //radius: 60,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 6,
                        child: widget.isRoleShow!
                            ? (widget.roleID != Constants.owner
                                ? widget.status == Constants.mailNotSend
                                    ? Icon(
                                        Icons.circle,
                                        color: Colors.orange,
                                        size: 15,
                                      )
                                    : widget.status == Constants.accept
                                        ? Icon(
                                            Icons.circle,
                                            color: Colors.green,
                                            size: 15,
                                          )
                                        : widget.status == Constants.reject
                                            ? Icon(
                                                Icons.circle,
                                                color: Colors.red,
                                                size: 15,
                                              )
                                            : SizedBox()
                                : SizedBox())
                            : SizedBox(),
                        //child:widget.isRoleShow?(widget.roleID!=Constants.owner? widget.status==Constants.mailNotSend?Image.asset(MyImages.notrespond,width: 15,height: 15,fit: BoxFit.fill,):widget.status==Constants.accept?Image.asset(MyImages.accept,width: 15,height: 15,fit: BoxFit.fill,):widget.status==Constants.reject?Image.asset(MyImages.decline,width: 15,height: 15,fit: BoxFit.fill,):"":SizedBox()):SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

/*   child: Container(
          //height: Dimens.standard_90,
          child: Card(
            semanticContainer: true,
            elevation: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  isThreeLine: true,
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Number: "+
                        widget.jersey,
                        style: TextStyle(
                          //letterSpacing: Dimens.letterSpacing_25,
                            color: MyColors.black),
                      ),
                 SizedBox(width: 30,),
                      Text("Position: "+
                        widget.position,
                        style: TextStyle(
                           // letterSpacing: Dimens.letterSpacing_25,
                            color: MyColors.black),
                      ),
                      //widget.isRoleShow?(widget.roleID!=Constants.owner? widget.status==Constants.mailNotSend?Icon(Icons.circle,color: Colors.orange,):widget.status==Constants.accept?Icon(Icons.circle,color: Colors.green,):widget.status==Constants.reject?Icon(Icons.circle,color: Colors.red,):"":SizedBox()):SizedBox(),
                    ],
                  ),
                  leading: Stack(
                      children: [ widget.profileImageString != "null" && widget.profileImageString.isNotEmpty?CircleAvatar(
                    backgroundImage:MemoryImage(base64Decode(widget.profileImageString)),
                    radius: 30.0,
                    backgroundColor: Colors.white,
                    // foregroundColor: Colors.white,
                  ):CircleAvatar(
                    radius: 30.0,
                    backgroundColor: MyColors.kPrimaryColor,
                    child: Text(widget.titleText.substring(0, 1).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: MyColors.white)),
                  ),
                        Positioned(
                          bottom: 1,
                          right: 2,
                          child:widget.isRoleShow?(widget.roleID!=Constants.owner? widget.status==Constants.mailNotSend?Icon(Icons.circle,color: Colors.orange,size: 15,):widget.status==Constants.accept?Icon(Icons.circle,color: Colors.green,size: 15,):widget.status==Constants.reject?Icon(Icons.circle,color: Colors.red,size: 15,):"":SizedBox()):SizedBox(),
                          //child:widget.isRoleShow?(widget.roleID!=Constants.owner? widget.status==Constants.mailNotSend?Image.asset(MyImages.notrespond,width: 15,height: 15,fit: BoxFit.fill,):widget.status==Constants.accept?Image.asset(MyImages.accept,width: 15,height: 15,fit: BoxFit.fill,):widget.status==Constants.reject?Image.asset(MyImages.decline,width: 15,height: 15,fit: BoxFit.fill,):"":SizedBox()):SizedBox(),
                        ),
                      ]),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.titleText,
                            style: TextStyle(
                                //letterSpacing: Dimens.letterSpacing_25,
                                color: MyColors.black),
                          ),
                          SizedBox(
                            height: Dimens.dp_8,
                          ),
                          Text(
                            widget.groupText,
                            style: TextStyle(
                                letterSpacing: Dimens.letterSpacing_25,
                                color: MyColors.kPrimaryColor),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                      // SizedBox(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Games Played: "),
                          Text("Goals              : "),
                          Text("Assists            : "),
                          Text("Penalty Min's  : "),
                          Text("Plus Minus      : "),
                          // Text("SOG: "),
                          // Text("GAA: "),
                        ],
                      ),
                    ],
                  ),

                 */ /* trailing:   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text("Games Played: ")),
                      Expanded(child: Text("Goals: ")),
                      Expanded(child: Text("Assists: ")),
                      Expanded(child: Text("Penalty Min's: ")),
                      Expanded(child: Text("Plus Minus: ")),
                     // Text("SOG: "),
                     // Text("GAA: "),
                    ],
                  ),*/ /*
                  //trailing:widget.isRoleShow?(widget.roleID!=Constants.owner? Text(widget.status==Constants.mailNotSend?MyStrings.notResponded:widget.status==Constants.accept?"Accepted":widget.status==Constants.reject?"Rejected":""):null):null,
                ),
               */ /* Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: selectedPlayers(),
                ),*/ /*
              ],
            ),
          ),
        ),*/
