import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/game_availablity_response.dart';
import 'package:spaid/model/response/game_event_response/game_team_response.dart';
import 'package:spaid/model/response/game_event_response/player_availability_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/availability_screen/availability_listview_provider.dart';
import 'package:spaid/ui/availability_screen/available_player_screen_ui.dart';
import 'package:spaid/ui/availability_screen/player_availability_screen_ui.dart';
import 'package:spaid/ui/availability_screen/volunteer_availability_screen_ui.dart';
import 'package:spaid/ui/home_screen/event_listview/event_listview_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_availability_tabbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_new_availability_tabbar.dart';

class AvailableTabScreen extends StatefulWidget {
  GameOrEventList eventList;
  AvailableTabScreen(this.eventList);

  @override
  _AvailableTabScreenState createState() =>
      _AvailableTabScreenState();
}

class _AvailableTabScreenState extends BaseState<AvailableTabScreen>
    with SingleTickerProviderStateMixin
     {
  //region Private Members
  TabController? _tabController;
  int _selectedTab = 0;
  AvailabilityListviewProvider? _availabilityListviewProvider;
  GetPlayerAvailabilityResponse? _getPlayerAvailabilityResponse;
  String? _userRole = "",teamName,fcm,userName,userMail,userIdNo;
  EventListviewProvider? _eventListviewProvider;

//endregion
  @override
  void initState() {
    _availabilityListviewProvider =
        Provider.of<AvailabilityListviewProvider>(context, listen: false);
    _availabilityListviewProvider!.listener = this;
    _eventListviewProvider =
        Provider.of<EventListviewProvider>(context, listen: false);
    // _availabilityListviewProvider.getPlayerAvailabilityAsync(widget.teamList.eventId);
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _getDataAsync();

    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController!.index;
        });
      }
    });
  }
       @override
       void onSuccess(any, {required int reqId}) {
         ProgressBar.instance.stopProgressBar(context);
         switch (reqId) {
           case ResponseIds.GET_PLAYER_AVAILABILITY:
             setState(() {
               _getPlayerAvailabilityResponse = any as GetPlayerAvailabilityResponse;

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

  @override
  Widget build(BuildContext context) {
    return TopBar(
      child: WebCard(
        marginVertical: 20,
        marginhorizontal: 40,
        child: Scaffold(
          backgroundColor: MyColors.white,
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'Back',
              iconSize: ImageSize.standardIconSize,
              icon: Icon(
                Icons.arrow_back,
                color: MyColors.white,
              ),
              onPressed: () {
                _eventListviewProvider!.setRefreshScreen("");
                Navigator.of(context).pop();
                },
            ),
            centerTitle: true,
            title: Text(MyStrings.availability),
            bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height * .1),
              child: Column(
                children: <Widget>[
                  Material(
                    color: MyColors.kPrimaryColor,
                    child: Padding(
                    padding: EdgeInsets.all(PaddingSize.headerPadding2),
                      child: CustomNewAvailabilityTabBar(
                        tabController: _tabController,
                        selectedTab: _selectedTab,
                        firstTabName: "Player",
                        secondTabName: MyStrings.volunteer,

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      PlayerAvailabilityScreen(widget.eventList),
                      VolunteerAvailabilityScreen(widget.eventList),
                      // AvailablePlayerScreen(_getPlayerAvailabilityResponse.availablePlayerList,_getPlayerAvailabilityResponse.rejectPlayerList,_getPlayerAvailabilityResponse.mayBePlayerList,_getPlayerAvailabilityResponse.notRespondPlayerList, MyStrings.available,_getPlayerAvailabilityResponse.eventId,widget.teamList.eventName,_userRole,widget.teamList.eventType==Constants.event?"Event":"Game",widget.teamList.LocationAddress,widget.teamList.scheduleDate,widget.teamList.scheduleTime,teamName,fcm,userName,userMail,userIdNo),
                      // AvailablePlayerScreen(_getPlayerAvailabilityResponse.availablePlayerList,_getPlayerAvailabilityResponse.rejectPlayerList,_getPlayerAvailabilityResponse.mayBePlayerList,_getPlayerAvailabilityResponse.notRespondPlayerList, MyStrings.notAvailable,_getPlayerAvailabilityResponse.eventId,widget.teamList.eventName,_userRole,widget.teamList.eventType==Constants.event?"Event":"Game",widget.teamList.LocationAddress,widget.teamList.scheduleDate,widget.teamList.scheduleTime,teamName,fcm,userName,userMail,userIdNo),
                      // AvailablePlayerScreen(_getPlayerAvailabilityResponse.availablePlayerList,_getPlayerAvailabilityResponse.rejectPlayerList,_getPlayerAvailabilityResponse.mayBePlayerList,_getPlayerAvailabilityResponse.notRespondPlayerList, MyStrings.tentative,_getPlayerAvailabilityResponse.eventId,widget.teamList.eventName,_userRole,widget.teamList.eventType==Constants.event?"Event":"Game",widget.teamList.LocationAddress,widget.teamList.scheduleDate,widget.teamList.scheduleTime,teamName,fcm,userName,userMail,userIdNo),
                      // AvailablePlayerScreen(_getPlayerAvailabilityResponse.availablePlayerList,_getPlayerAvailabilityResponse.rejectPlayerList,_getPlayerAvailabilityResponse.mayBePlayerList,_getPlayerAvailabilityResponse.notRespondPlayerList, MyStrings.notResponded,_getPlayerAvailabilityResponse.eventId,widget.teamList.eventName,_userRole,widget.teamList.eventType==Constants.event?"Event":"Game",widget.teamList.LocationAddress,widget.teamList.scheduleDate,widget.teamList.scheduleTime,teamName,fcm,userName,userMail,userIdNo),
                      // SabhaListEvent(_tabController)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
