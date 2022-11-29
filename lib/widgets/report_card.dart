import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/images.dart';

class ReportCard extends StatelessWidget {

  String jerseyNumber;
  String playerName;
  int scoreTypeId;
  String period;
  String time;

  ReportCard(this.jerseyNumber, this.playerName, this.scoreTypeId, this.period, this.time);



  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
        onTap: null,
      /*  leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: MyColors.white,
            child: Image.asset(
              MyImages.spaid,
              width: 30,
              height: 30,
            )),*/
        title: Row(children: <Widget>[
        //  Expanded(child: SizedBox()),
          Expanded(child: Text(jerseyNumber)),
          Expanded(child: Text(playerName.replaceAll(RegExp('[^A-Za-z ]'), '',),textAlign: TextAlign.center)),
          SizedBox(width: 10,),
          Expanded(child: Text(scoreTypeId== Constants.goal?"Goal":scoreTypeId == Constants.penalty?"Penalty":"Shot",)),
          SizedBox(width: 10,),
          Expanded(child: Text(period)),
          Expanded(child: Text(time)),
        ]),
      ),
    );
  }
}
