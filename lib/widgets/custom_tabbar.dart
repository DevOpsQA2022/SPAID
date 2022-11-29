import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/icons.dart';

class CustomTabBar extends StatelessWidget {
  final TabController? tabController;
  final int? selectedTab;
  final String? firstTabName;
  final String? secondTabName;
  final String? thirdTabName;
  // final String fourthTabName;
  final String? fifthTabName;
  final String? sixthTabName;
  final String? seventhTabName;
  final Icon? firsticon;

  CustomTabBar(
      { this.tabController,
       this.selectedTab,
       this.firstTabName,
       this.secondTabName,
       this.thirdTabName,
       // this.fourthTabName,
      this.fifthTabName,
       this.sixthTabName,
      this.seventhTabName,
       this.firsticon});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      unselectedLabelColor: MyColors.kPrimaryColor,
      labelColor: MyColors.controllerColor,
      indicatorColor: MyColors.controllerColor,
      controller: tabController,


      tabs:<Widget>[
        Tab(
          icon: MyIcons.home,
          child: Text(firstTabName!),
        ),
        Tab(
          icon: MyIcons.listView_menu,
          child: Text(secondTabName!),
        ),
        Tab(
          icon: MyIcons.calendar,
          child: Text(thirdTabName!),
        ),
        // Tab(icon:MyIcons.sport ,child: Text(fourthTabName),),
      /*  Tab(
          icon: MyIcons.chat,
          child: Text(fourthTabName),
        ),*/
        // Tab(
        //   icon: Icon(Icons.event_available),
        //   child: Text(fourthTabName),
        // ),
        Tab(
          icon: MyIcons.notification,
          child: Text(fifthTabName!),
        ),
        Tab(
          icon: Icon(
            Icons.sports_hockey,
          ),
          child: Text(sixthTabName!),
        ),
        Tab(
          icon: MyIcons.menu,
          child: Text(seventhTabName!),
        )

        // _getTab(0, Center(child: Text(firstTabName),),MyIcons.arrowIos),
        // _getTab(1, Center(child: Text(secondTabName),),MyIcons.arrowIos),
        // _getTab(2, Center(child: Text(firstTabName),),MyIcons.arrowIos),
        // _getTab(3, Center(child: Text(secondTabName),),MyIcons.arrowIos),
      ]
    );
  }

  _getTab(index, child, icon) {
    return Tab(
      icon: icon,
      child: SizedBox.expand(
        child: Container(
          child: child,
          decoration: BoxDecoration(
              color:
                  (selectedTab == index ? MyColors.activeColor : Colors.white),
              borderRadius: _generateBorderRadius(index)),
        ),
      ),
    );
  }

  _generateBorderRadius(index) {
    if ((index + 1) == selectedTab)
      return BorderRadius.only(bottomRight: Radius.circular(0.0));
    else if ((index - 1) == selectedTab)
      return BorderRadius.only(bottomLeft: Radius.circular(0.0));
    else
      return BorderRadius.zero;
  }
}
