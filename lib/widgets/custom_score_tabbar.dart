import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/images.dart';

class CustomScoreTabBar extends StatelessWidget {
  final TabController? tabController;
  final int? selectedTab;
  final String? firstTabName;
  final String? secondTabName;
  List<int>? teamAImage=[];
  List<int>? teamBImage=[];

  CustomScoreTabBar({
    @required this.tabController,
    @required this.selectedTab,
    @required this.firstTabName,
    @required this.secondTabName,
    this.teamAImage,
    this.teamBImage
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      //isScrollable: true,
      unselectedLabelColor: MyColors.white,
      labelColor: MyColors.kPrimaryColor,
      indicatorColor: MyColors.kPrimaryColor,
      controller: tabController,
      /* indicator: ShapeDecoration(
          color: MyColors.kPrimaryColor,
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.white,
              )
          )
      ),*/
      /* indicator: BoxDecoration(
          gradient: LinearGradient(
              colors: [MyColors.kPrimaryColor, MyColors.primary]),
          borderRadius: BorderRadius.circular(50),
          color: Colors.redAccent),*/
      /* indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: MyColors.white),*/
      indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white),
      tabs: <Widget>[
        Container(
          height: 86,
          child: Tab(
            icon: teamAImage!.isNotEmpty? Image.memory(
              Uint8List.fromList(teamAImage!),
              width: 30,
              height: 30,
            ):Image.asset(
              MyImages.team,
              width: 30,
              height: 30,
            ),
            child: Text(
              firstTabName!,textAlign: TextAlign.center,
            ),
          ),
        ),
        //,style: TextStyle(color: Colors.white)
        Container(
          height: 86,
          child: Tab(
            icon: teamBImage!.isNotEmpty? Image.memory(
              Uint8List.fromList(teamBImage!),
              width: 30,
              height: 30,
            ): Image.asset(
              MyImages.team,
              width: 30,
              height: 30,
            ),
            child: Text(
              secondTabName!,textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
