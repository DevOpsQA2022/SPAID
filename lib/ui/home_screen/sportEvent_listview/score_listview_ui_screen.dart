import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/model/response/game_event_response/score_details_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/widgets/report_card.dart';

class ScoreListviewScreen extends StatefulWidget {
  List<ScoreList> teamScore;
  ScoreListviewScreen(this.teamScore);

  @override
  _ScoreListviewScreenState createState() => _ScoreListviewScreenState();
}

class _ScoreListviewScreenState extends State<ScoreListviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: SafeArea(
        child: Column(

          children:<Widget> [
            Card(
              color: MyColors.kPrimaryColor,
            elevation: 10,
            child: ListTile(
              onTap: null,
             /* leading: SizedBox(width:getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          tablet: true,
                          desktop: true,
                        )?50: 60,),*/
              title: Row(children: <Widget>[
                Expanded(child: Text(MyStrings.scoreJersey,style: TextStyle(color: MyColors.white))),
                Expanded(child: Text(MyStrings.scoreName,style: TextStyle(color: MyColors.white))),
                Expanded(child: Text(MyStrings.scoreType,style: TextStyle(color: MyColors.white))),
                SizedBox(width: 10,),
                Expanded(child: Text(MyStrings.scorePeriod,style: TextStyle(color: MyColors.white))),
                Expanded(child: Text(MyStrings.scoreTime,style: TextStyle(color: MyColors.white,),)),
              ]),
            ),
        ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.teamScore.length,
                itemBuilder: (context, index) {
                  return ReportCard(widget.teamScore[index].jerseyNumber!,widget.teamScore[index].playerName!,widget.teamScore[index].scoreTypeId!,widget.teamScore[index].period!,widget.teamScore[index].time!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
