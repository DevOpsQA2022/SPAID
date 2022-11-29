import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';

class CustomMediaTabBar extends StatelessWidget {
  final TabController? tabController;
  final int? selectedTab;
  final String? firstTabName;
  final String? secondTabName;
  final String? thirdTabName;

  CustomMediaTabBar({
    @required this.tabController,
    @required this.selectedTab,
    @required this.firstTabName,
    @required this.secondTabName,
    @required this.thirdTabName,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
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
        Tab(
          child: Text(firstTabName!),
        ),
        //,style: TextStyle(color: Colors.white)
        Tab(
          child: Text(secondTabName!),
        ),
        Tab(
          child: Text(thirdTabName!),
        ),
      ],
    );
  }
}
