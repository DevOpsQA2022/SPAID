import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';

class CustomAvailabilityTab extends StatelessWidget {
  final TabController? tabController;
  final int? selectedTab;
  final String? firstTabName;
  final String? secondTabName;

  CustomAvailabilityTab({
    @required this.tabController,
    @required this.selectedTab,
    @required this.firstTabName,
    @required this.secondTabName,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      unselectedLabelColor: MyColors.white,
      labelColor: MyColors.kPrimaryColor,
      indicatorColor: MyColors.kPrimaryColor,
      controller: tabController,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white),
      tabs: <Widget>[
        Tab(
          child: Text("Player"),
        ),
        //,style: TextStyle(color: Colors.white)
        Tab(
          child: Text(secondTabName!),
        ),
      ],
    );
  }
}
