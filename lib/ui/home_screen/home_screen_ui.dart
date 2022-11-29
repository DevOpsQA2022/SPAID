import 'dart:math';

import 'package:cube_transition/cube_transition.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/model/request/select_drill_request/share_drill_request.dart';
import 'package:spaid/model/response/game_event_response/game_availablity_response.dart';
import 'package:spaid/model/response/game_event_response/game_team_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/SelectDrill_Screen/select_drill_Screen_ui.dart';
import 'package:spaid/ui/SelectDrill_Screen/share_drill_screen_ui.dart';
import 'package:spaid/ui/SelectDrill_Screen/shared_drill_list_Screen_ui.dart';
import 'package:spaid/ui/SelectDrill_Screen/shared_drill_list_view_Screen_ui.dart';
import 'package:spaid/ui/add_event_screen/add_event_screen_ui.dart';
import 'package:spaid/ui/add_event_screen/opponent_screen/opponent_add_screen_ui.dart';
import 'package:spaid/ui/add_event_screen/opponent_screen/opponent_listview_screen_ui.dart';
import 'package:spaid/ui/add_event_screen/repeat_sceen/repeat_screen_ui.dart';
import 'package:spaid/ui/add_event_screen/volunteer_screen/volunteer_listview_screen_ui.dart';
import 'package:spaid/ui/add_event_screen/volunteer_screen/volunteer_superadmin_screen_ui.dart';
import 'package:spaid/ui/add_player_screen/add_player_screen.dart';
import 'package:spaid/ui/availability_screen/availability_screen_ui.dart';
import 'package:spaid/ui/availability_screen/available_player_tab_screen_ui.dart';
import 'package:spaid/ui/availability_screen/available_tab_screen_ui.dart';
import 'package:spaid/ui/availability_screen/update_volunteer_listview_screen_ui.dart';
import 'package:spaid/ui/availability_screen/volunteer_available_player_tab_screen_ui.dart';
import 'package:spaid/ui/coaches_corner/coach_home_screen.dart';
import 'package:spaid/ui/coaches_corner/home_Screen_ui.dart';
import 'package:spaid/ui/edit_event_screen/edit_event_screen_ui.dart';
import 'package:spaid/ui/edit_team/edit_team_ui.dart';
import 'package:spaid/ui/home_screen/home_menu_screen/add_media_screen.dart';
import 'package:spaid/ui/home_screen/home_menu_screen/home_menu_screen_ui.dart';
import 'package:spaid/ui/home_screen/home_menu_screen/media_list_ui.dart';
import 'package:spaid/ui/home_screen/home_menu_screen/media_list_ui.dart';
import 'package:spaid/ui/home_screen/home_menu_screen/media_tab_screen_ui.dart';
import 'package:spaid/ui/home_screen/home_menu_screen/notification_preferences.dart';
import 'package:spaid/ui/home_screen/message_screen/message_home_screen_ui.dart';
import 'package:spaid/ui/home_screen/roasters_listview/roasters_listview_ui_screen.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/add_video_screen.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/score_Details_screen_ui.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/sportEvent_listview_ui_screen.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/video_player_list_ui.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/video_player_ui.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/video_player_ui.dart';
import 'package:spaid/ui/intro_screen/intro_screen_ui.dart';
import 'package:spaid/ui/reset_password_screen/reset_password_screen_ui.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/calendar_cubit.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/voluntter_screen_demo.dart';
import 'package:spaid/widgets/custom_tabbar.dart';
import 'package:spaid/widgets/home_eventSport_card.dart';
import 'package:spaid/ui/coaches_corner/home_screen_ui.dart' as coach;

import 'event_listview/event_listview_ui_screen.dart';
import 'home_menu_screen/remove_volunteer_screen_ui.dart';
import 'notification_screen/notification_screen_ui.dart';

class HomeScreen extends StatefulWidget {

//region Private Members
  final int tabId;

//endregion
  HomeScreen(this.tabId);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  //region Private Members
  TabController? _tabController;
  PageController? _pageController;
  int _selectedTab = 0;
  FocusNode _node = new FocusNode();
  String? teamName = "",calendarId,roleId;
  CalendarCubit? calendarCubit;
  bool isScroll=true;

//endregion
  @override
  void initState() {
    calendarCubit = Provider.of<CalendarCubit>(context, listen: false);
    _tabController = TabController(initialIndex: widget.tabId != null? widget.tabId:0 , length:6, vsync: this);
    _tabController!.addListener(() {

      if (_tabController!.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController!.index;

          // _pageController.jumpToPage(_tabController.index);
        });
      }
    });
    getTeamName();
    _pageController= PageController(initialPage:widget.tabId != null? widget.tabId:0 );
    /*Future.delayed(Duration(seconds: 10), () {
      setState(() {
        _pageController.jumpToPage(widget.tabId != null? widget.tabId:0);

      });
    });*/

    /* _pageController.addListener(() {
      setState(() {
        _selectedTab = _pageController.;
      });
    });*/

    /* setState(() {
      _selectedTab = widget.tabId;

    });*/
  }

  void getTeamName() async {
    teamName =
    await SharedPrefManager.instance.getStringAsync(Constants.teamName);
    calendarId = await SharedPrefManager.instance.getStringAsync(Constants.calendarId);
    roleId = await SharedPrefManager.instance.getStringAsync(Constants.roleId);


    setState(() {});
  }

/*
Return Type:Bool
Input Parameters:
Use: Handle BackPress Event.
 */

  void _onBackPressed() {
     showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => FancyDialog(
          gifPath: MyImages.team,
          okFun: () => {SystemNavigator.pop()},
          cancelFun: () => {Navigator.of(context).pop()},
          cancelColor: MyColors.red,
          title: MyStrings.conformExitApp,
        ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop:(){ _onBackPressed();
      return Future.value(false);

      },
      child: Scaffold(
        backgroundColor: MyColors.white,
        appBar: AppBar(
          leadingWidth: 100,
          backgroundColor: MyColors.kPrimaryColor,
          //foregroundColor: MyColors.kPrimaryColor,
          title: new Text(teamName!, textAlign: TextAlign.left,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          centerTitle: false,
          leading: kIsWeb? GestureDetector(
              onTap: (){
                Navigation.navigateTo(context, MyRoutes.homeScreen);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Image.asset(MyImages.spaid_logo,),
              ),
          )
          /*CircleAvatar(
            backgroundColor: MyColors.white,
              radius: 10.0,
              child: GestureDetector(
                onTap: (){
                  Navigation.navigateTo(context, MyRoutes.homeScreen);

                },
                child: Image.asset(
                  MyImages.spaid_logo,

                ),
              )
          )*/:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
                MyImages.spaid_logo,

            ),
          ),
          actions: <Widget>[

            PopupMenuButton(
              icon: MyIcons.listView,
              offset:  Offset(0, 60),
              tooltip: "Menu",
              shape: const TooltipShape(),
                onSelected: (value) {
                  if (value == 1) {
                    Navigation.navigateTo(context, MyRoutes.userProfileScreen);
                   // Navigation.navigateWithArgument(context, MyRoutes.userProfileScreen, Constants.navigateIdOne);
                  }
                  if(value ==2){
                    setState(() {
                      Navigation.navigateWithArgument(context, MyRoutes.teamProfileScreen, Constants.navigateIdOne);

                    });
                  }
                  if (value == 3) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) => FancyDialog(
                          gifPath: MyImages.team,
                          okFun: () async => {

                            await SharedPrefManager.instance
                                .setStringAsync(Constants.userEmail, ""),
                            await SharedPrefManager.instance
                              .setStringAsync(Constants.rememberMe, ""),
                            await SharedPrefManager.instance
                                .setStringAsync(Constants.roleId, ""),
                            await SharedPrefManager.instance
                                .setStringAsync(Constants.teamName, ""),
                            await SharedPrefManager.instance
                                .setStringAsync(Constants.userIdNo, ""),
                            if(!kIsWeb){
                              calendarCubit!.deleteCalendar(calendarId??""),
                            },
                            Navigator.of(context).pop(),
                            Navigation.navigatePushNamedAndRemoveAll(
                                context, MyRoutes.introScreen),
                            await GoogleSignIn().signOut(),

                          },
                          cancelFun: () => {Navigator.of(context).pop()},
                          cancelColor: MyColors.red,
                          title: MyStrings.wantLogout,
                        ));
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      leading: MyIcons.username,
                      title: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                            width:  getValueForScreenType<bool>(
                              context: context,
                              mobile: false,
                              tablet: false,
                              desktop: true,
                            )?  150 : 0, child: Text(MyStrings.userProfile)),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: ListTile(
                      leading: MyIcons.group,
                      title: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                            child: Text(MyStrings.teamProfile)),
                      ),
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    value: 3,
                    child: ListTile(
                      leading: MyIcons.logout,
                      title: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                            child: Text(MyStrings.logOut)),
                      ),
                    ),
                  ),


                ],


            )

          ],
          /*title: GestureDetector(
              onTap: () {
                getValueForScreenType<bool>(
                  context: context,
                  mobile: false,
                  tablet: false,
                  desktop: true,
                )?  Navigation.navigateTo(context, MyRoutes.homeScreen) : null;              },
              child: Text(MyStrings.appName)),*/
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * .1),
            child: getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: true,
                                        desktop: true,) ? Row(
              mainAxisAlignment:  MainAxisAlignment.start,
              children: <Widget>[
                Container(

                  color: Colors.grey.shade300,
                  child: CustomTabBar(
                    selectedTab: _selectedTab,
                    tabController: _tabController,
                    firstTabName: MyStrings.home,
                    secondTabName: MyStrings.viewRoster,
                    thirdTabName: MyStrings.addSportEvent,
                    // fourthTabName: MyStrings.availability,
                    fifthTabName: MyStrings.notification,
                    sixthTabName: MyStrings.coachescorner,
                    seventhTabName: MyStrings.others,
                  ),
                ),
                // SizedBox(width:  480),
              ],
            ) : Column(
              children: <Widget>[
                Container(
                  color: Colors.grey.shade300,
                  child: CustomTabBar(
                    selectedTab: _selectedTab,
                    tabController: _tabController,
                    firstTabName: MyStrings.home,
                    secondTabName: MyStrings.viewRoster,
                    thirdTabName: MyStrings.addSportEvent,
                    // fourthTabName: MyStrings.availability,
                    fifthTabName: MyStrings.notification,
                    sixthTabName: MyStrings.coachescorner,
                    seventhTabName: MyStrings.others,

                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height:  size.height -165,
            child: TopBar(
              child: Row(
                children: <Widget>[
                   if (getValueForScreenType<bool>(
                            context: context,
                            mobile: false,
                            tablet: true,
                            desktop: true,
                          ))
                     Expanded(
                       child: Image.asset(
                         MyImages.signin,
                         height: size.height * ImageSize.signInImageSize,
                       ),
                     ),

                  (getValueForScreenType<bool>(
                                          context: context,
                                          mobile: false,
                                          tablet: true,
                                          desktop: true,) ?  Expanded(
                                            child: TabBarView(
                                              // physics: !isScroll ? NeverScrollableScrollPhysics() : ClampingScrollPhysics(),
                                              // physics: NeverScrollableScrollPhysics(),
                                              controller: _tabController,
                                              children: <Widget>[
                                                SportEventNavigator(),
                                                RoastersListviewScreen(),
                                                eventNavigator(),
                                                //MessageHomeScreen(),
                                                // AvailabilityNavigator(),
                                                NotificationListviewScreen(),
                                                CoachesNavigator(),
                                                // CoachHomeScreen(),
                                                // CoachesHomeScreen(),
                                                HomeMenuNavigator(),
                                                // SabhaListEvent(_tabController)
                                              ],
                                            ),
                                          ) :  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        SportEventListviewScreen(),
                        RoastersListviewScreen(),
                        EventListviewScreen(),
                        //MessageHomeScreen(),
                        // AvailabilityScreen(),
                        NotificationListviewScreen(),
                        CoachHomeScreen(),
                        // CoachesHomeScreen(),
                        HomeMenuScreen(),
                        // SabhaListEvent(_tabController)
                      ],
                    ))),

                ],
              ),
            ),
          ),
        ),

      ),
    );
  }

}
// class volunteernavi extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       onGenerateRoute: (RouteSettings settings) {
//         return MaterialPageRoute(
//             settings: settings,
//             builder: (BuildContext context) {
//               switch (settings.name) {
//                 case "/":
//                   return AvailabilityScreen();
//                 case MyRoutes.volunteerListviewScreen:
//                   return VolunteerListviewScreen();
//                 case MyRoutes.updateVolunteerListviewScreen:{
//                   GameOrEventList eventList = ModalRoute.of(context).settings.arguments;
//                   return UpdateVolunteerListviewScreen(eventList);}
//                 case MyRoutes.availablePlayerScreen:{
//                   TeamEventList teamList = ModalRoute.of(context).settings.arguments;
//                   return AvailablePlayerTabScreen(teamList);}
//                 case MyRoutes.volunteerAvailablityScreen:{
//                   TeamEventList teamList = ModalRoute.of(context).settings.arguments;
//                   return VolunteerAvailablePlayerTabScreen(teamList);
//                 }
//               }
//             });
//       },
//     );
//   }
// }


class HomeMenuNavigator extends StatefulWidget {
  @override
  _HomeMenuNavigatorState createState() => _HomeMenuNavigatorState();
}

class _HomeMenuNavigatorState extends State<HomeMenuNavigator> {


  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        if(settings.name == MyRoutes.coachHomeScreen){
          int tabId = ModalRoute
              .of(context)!
              .settings
              .arguments as int;
          print("Marlen"+tabId.toString());
          Navigation.navigateWithArgument(context, MyRoutes.coachHomeScreen,tabId);
        }else {
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) {
                switch (settings.name) {
                  case "/":
                    return HomeMenuScreen();
                  case MyRoutes.VideoPlayerListScreen:
                    return VideoPlayerListScreen();
                  case MyRoutes.videoPlayerScreen:
                    String? url = ModalRoute
                        .of(context)!
                        .settings
                        .arguments as String;
                    return VideoPlayerScreen(url);
                  case MyRoutes.addVideoScreen:
                    return AddVideoScreen();
                  case MyRoutes.NotificationPreferencesScreen:
                    return NotificationPreferencesScreen();
                  case MyRoutes.resetPasswordScreen:
                    List<String> userDetails = ModalRoute
                        .of(context)!
                        .settings
                        .arguments as List<String>;
                    return ResetPasswordScreen(userDetails);
                  case MyRoutes.editTeamScreen:
                    return EditTeamScreen();
                  case MyRoutes.mediaListScreen:
                    int tabId = ModalRoute
                        .of(context)!
                        .settings
                        .arguments as int;
                    return MediaPlayerTabScreen(tabId);
                  case MyRoutes.addMediaScreen:
                    int id = ModalRoute
                        .of(context)!
                        .settings
                        .arguments as int;
                    return AddMediaScreen(id);
                  case MyRoutes.selectDrillScreen:
                    return SelectDrillScreen();
                    case MyRoutes.sharedDrillScreen:
                    return SharedDrillScreen();
                  case MyRoutes.removeVolunteerScreen:
                    return RemoveVolunteerScreen();
                  case MyRoutes.VolunteerSuperAdminScreen:
                    return VolunteerSuperAdminScreen();

                  case MyRoutes.shareDrillScreen:
                    ShareDrillRequest drill = ModalRoute.of(context)!.settings.arguments as ShareDrillRequest;

                    return ShareDrillScreen(drill);
                case MyRoutes.sharedDrillListScreen:
                var drillPlans = ModalRoute.of(context)!.settings.arguments ;

                return SharedDrillListViewScreen(drillPlans);
                  case MyRoutes.coachHomeScreen:

                }
                return Container();
              });
        }
      },
    );
  }
}


class eventNavigator extends StatefulWidget {
  @override
  _eventNavigatorState createState() => _eventNavigatorState();
}

class _eventNavigatorState extends State<eventNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case "/":
                  return EventListviewScreen();
                case MyRoutes.addEventScreen:
                  return AddEventScreen();
                case MyRoutes.editEventScreen:
                  int gameID = ModalRoute.of(context)!.settings.arguments as int;
                  return EditEventScreen(gameID);
                case MyRoutes.opponentListviewScreen:
                  return OpponentListviewScreen();
                case MyRoutes.opponentAddScreen:
                  return OpponentAddScreen();
                case MyRoutes.volunteerListviewScreen:
                  return VolunteerListviewScreen();
                case MyRoutes.updateVolunteerListviewScreen:
                  GameOrEventList eventList = ModalRoute.of(context)!.settings.arguments as GameOrEventList;
                  return UpdateVolunteerListviewScreen(eventList);
                case MyRoutes.repeatScreen:
                  bool isEdit = ModalRoute.of(context)!.settings.arguments as bool;
                  return RepeatScreen(isEdit);
                case MyRoutes.homeScreen:
                  int tabId = ModalRoute.of(context)!.settings.arguments as int;
                  return HomeScreen(tabId);
                case MyRoutes.AvailableTabScreen:
                  GameOrEventList eventList = ModalRoute.of(context)!.settings.arguments as GameOrEventList;
                  return AvailableTabScreen(eventList);


              }
              return Container();
            });
      },
    );
  }
}

class SportEventNavigator extends StatefulWidget {
  @override
  _SportEventNavigatorState createState() => _SportEventNavigatorState();
}

class _SportEventNavigatorState extends State<SportEventNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case "/":
                  return SportEventListviewScreen();
                case MyRoutes.scoreDetailsScreen:
                  return ScoreDetailsScreen();
                case MyRoutes.AvailableTabScreen:
                  GameOrEventList eventList = ModalRoute.of(context)!.settings.arguments as GameOrEventList;
                  return AvailableTabScreen(eventList);
                case MyRoutes.updateVolunteerListviewScreen:
                  GameOrEventList eventList = ModalRoute.of(context)!.settings.arguments as GameOrEventList;
                  return UpdateVolunteerListviewScreen(eventList);
              }
              return Container();
            });
      },
    );
  }
}

class RoastersNavigator extends StatefulWidget {
  @override
  _RoastersNavigatorState createState() => _RoastersNavigatorState();
}

class _RoastersNavigatorState extends State<RoastersNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case "/":
                  return RoastersListviewScreen();
                case MyRoutes.addPlayerScreen:
                  var contact = ModalRoute.of(context)!.settings.arguments;
                  return AddPlayerScreen(contact);
              }
              return Container();
            });
      },
    );
  }
}



class CoachesNavigator extends StatefulWidget {
  @override
  _CoachesNavigatorState createState() => _CoachesNavigatorState();
}

class _CoachesNavigatorState extends State<CoachesNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
      if(settings.name == MyRoutes.coachHomeScreen){
        int tabId = ModalRoute
            .of(context)!
            .settings
            .arguments as int;
        print("Marlen"+tabId.toString());
        Navigation.navigateWithArgument(context, MyRoutes.coachHomeScreen,tabId);
      }else {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case "/":
                  return CoachHomeScreen();
                case MyRoutes.sharedDrillScreen:
                  return SharedDrillScreen();
                case MyRoutes.selectDrillScreen:
                  return SelectDrillScreen();
                case MyRoutes.shareDrillScreen:
                  ShareDrillRequest drill = ModalRoute.of(context)!.settings.arguments as ShareDrillRequest;

                  return ShareDrillScreen(drill);
                case MyRoutes.sharedDrillListScreen:
                  var drillPlans = ModalRoute.of(context)!.settings.arguments ;

                  return SharedDrillListViewScreen(drillPlans);
              }
              return Container();
            });}
      },
    );
  }
}

