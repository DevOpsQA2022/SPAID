

import 'dart:async';
import 'dart:io';

import 'package:device_calendar/device_calendar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:spaid/model/response/game_event_response/game_availablity_response.dart';
import 'package:spaid/model/response/select_drill_response/select_drill_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/notification_service.dart';
import 'package:spaid/service/push_notification_service.dart';
import 'package:spaid/service/send_push_notification_service.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/email_template.dart';
import 'package:spaid/support/navigator/navigator.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/ui/SelectDrill_Screen/select_drill_Screen_ui.dart';
import 'package:spaid/ui/SelectDrill_Screen/select_drill_screen_provider.dart';
import 'package:spaid/ui/SelectDrill_Screen/share_drill_screen_ui.dart';
import 'package:spaid/ui/SelectDrill_Screen/shared_drill_list_Screen_ui.dart';
import 'package:spaid/ui/SelectDrill_Screen/shared_drill_list_view_Screen_ui.dart';
import 'package:spaid/ui/add_event_screen/add_event_provider.dart';
import 'package:spaid/ui/add_event_screen/add_event_screen_ui.dart';
import 'package:spaid/ui/add_event_screen/opponent_screen/add_opponent_provider.dart';
import 'package:spaid/ui/add_event_screen/opponent_screen/opponent_add_screen_ui.dart';
import 'package:spaid/ui/add_event_screen/opponent_screen/opponent_listview_screen_ui.dart';
import 'package:spaid/ui/add_event_screen/opponent_screen/opponent_provider.dart';
import 'package:spaid/ui/add_event_screen/repeat_sceen/repeat_screen_ui.dart';
import 'package:spaid/ui/add_event_screen/volunteer_screen/volunteer_listview_screen_ui.dart';
import 'package:spaid/ui/add_event_screen/volunteer_screen/volunteer_provider.dart';
import 'package:spaid/ui/add_event_screen/volunteer_screen/volunteer_superadmin_screen_ui.dart';
import 'package:spaid/ui/add_player_screen/add_player_screen.dart';
import 'package:spaid/ui/add_player_screen/add_player_screen_provider.dart';
import 'package:spaid/ui/availability_screen/availability_listview_provider.dart';
import 'package:spaid/ui/availability_screen/availability_screen_ui.dart';
import 'package:spaid/ui/availability_screen/available_player_tab_screen_ui.dart';
import 'package:spaid/ui/availability_screen/available_tab_screen_ui.dart';
import 'package:spaid/ui/availability_screen/update_volunteer_listview_screen_ui.dart';
import 'package:spaid/ui/availability_screen/volunteer_available_player_tab_screen_ui.dart';
import 'package:spaid/ui/coaches_corner/home_Screen_provider.dart';
import 'package:spaid/ui/coaches_corner/home_Screen_ui.dart';
import 'package:spaid/ui/coaches_corner/home_screen_ui.dart' as coach;
import 'package:spaid/ui/create_team/create_team_provider.dart';
import 'package:spaid/ui/create_team/create_team_ui.dart';
import 'package:spaid/ui/edit_event_screen/edit_event_screen_ui.dart';
import 'package:spaid/ui/edit_player_screen/edit_players_screen_provider.dart';
import 'package:spaid/ui/edit_player_screen/edit_players_screen_ui.dart';
import 'package:spaid/ui/edit_team/edit_team_provider.dart';
import 'package:spaid/ui/edit_team/edit_team_ui.dart';
import 'package:spaid/ui/home_screen/event_listview/event_listview_provider.dart';
import 'package:spaid/ui/home_screen/event_listview/event_listview_ui_screen.dart';
import 'package:spaid/ui/home_screen/home_menu_screen/add_media_screen.dart';
import 'package:spaid/ui/home_screen/home_menu_screen/media_tab_screen_ui.dart';
import 'package:spaid/ui/home_screen/home_menu_screen/notification_preferences.dart';
import 'package:spaid/ui/home_screen/home_menu_screen/remove_volunteer_screen_ui.dart';
import 'package:spaid/ui/home_screen/home_screen_ui.dart';
import 'package:spaid/ui/home_screen/notification_screen/notification_screen_provider.dart';
import 'package:spaid/ui/home_screen/roasters_listview/add_existing_player_screen.dart';
import 'package:spaid/ui/home_screen/roasters_listview/edit_existing_players_screen_ui.dart';
import 'package:spaid/ui/home_screen/roasters_listview/player_contact_list_ui.dart';
import 'package:spaid/ui/home_screen/roasters_listview/roasters_listview_screen_provider.dart';
import 'package:spaid/ui/home_screen/roasters_listview/roasters_listview_ui_screen.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/add_video_screen.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/add_video_screen_provider.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/score_Details_screen_ui.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/sportEvent_listview_ui_screen.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/video_player_list_ui.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/video_player_ui.dart';
import 'package:spaid/ui/image_picker/image_picker_provider.dart';
import 'package:spaid/ui/image_picker/image_picker_screen.dart';
import 'package:spaid/ui/intro_screen/intro_screen_ui.dart';
import 'package:spaid/ui/localization/demo_localization.dart';
import 'package:spaid/ui/localization/language_constants.dart';
import 'package:spaid/ui/player_profile_screen/player_profile_screen_provider.dart';
import 'package:spaid/ui/player_profile_screen/player_profile_screen_ui.dart';
import 'package:spaid/ui/reset_password_screen/reset_password_provider.dart';
import 'package:spaid/ui/reset_password_screen/reset_password_screen_ui.dart';
import 'package:spaid/ui/select_team_screen/select_team_screen_provider.dart';
import 'package:spaid/ui/select_team_screen/select_team_screen_ui.dart';
import 'package:spaid/ui/signin_screen/create_password_screen/create_password_ui.dart';
import 'package:spaid/ui/signin_screen/forgot_password_screen/forgot_password_ui.dart';
import 'package:spaid/ui/signin_screen/signin_screen_provider.dart';
import 'package:spaid/ui/signin_screen/signin_screen_ui.dart';
import 'package:spaid/ui/signup_screen/create_new_password_ui.dart';
import 'package:spaid/ui/signup_screen/signup_next_screen_ui.dart';
import 'package:spaid/ui/signup_screen/signup_screen_provider.dart';
import 'package:spaid/ui/signup_screen/signup_screen_ui.dart';
import 'package:spaid/ui/splash_screen/splash_screen_provider.dart';
import 'package:spaid/ui/splash_screen/splash_screen_ui.dart';
import 'package:spaid/ui/team_profile_screen/team_profile_screen_ui.dart';
import 'package:spaid/ui/user_profile_screen/user_profile_screen_ui.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/calendar_cubit.dart';
import 'package:spaid/widgets/custom_smart_button.dart';
import 'package:universal_html/html.dart' as html;

import 'model/request/select_drill_request/share_drill_request.dart';
import 'model/response/game_event_response/game_team_response.dart';




class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final router = FluroRouter();

  static String? fcm,userName;
  Locale? _locale;
  Timer? _timer;
  List? userdata;
  int i = 10;
  static const _inactivityTimeout = Duration(seconds: 10);
  Timer? _keepAliveTimer;
  final _navKey = GlobalKey<NavigatorState>();
  final navigatorKey = GlobalKey<NavigatorState>();

  void _keepAlive(bool visible) {
    _keepAliveTimer?.cancel();
    if (visible) {
      _keepAliveTimer = null;
    } else {
      _keepAliveTimer = Timer(_inactivityTimeout, () => exit(0));
    }
  }

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeTimer();
    getSharedDataAsync();
    Routes.configureRoutes(router);


    final pushNotificationService = PushNotificationService(_firebaseMessaging);

    pushNotificationService.initialise();

    if (!kIsWeb) {
      NotificationService().inits(flutterLocalNotificationsPlugin);
    }
    // this.initDynamicLinksAsync();
    // initLocalNotificationAsync();
//scheduleNotificationAsync();

    if(kIsWeb){
      html.window.onBeforeUnload.listen((event) async{
        print("Marlen Franto");
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
        Future.delayed(Duration.zero, () {
          // Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 0);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen(0)));
        });
      });
    }
  }




  @override
  void didChangeDependencies() {
    getLanguageAsync().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }




  void _initializeTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    // setup action after 5 minutes
    _timer = Timer(const Duration(minutes: 15), () => timeOutCallBack());
  }

  testAlert(BuildContext context) {
    final context = navigatorKey.currentState!.overlay!.context;
    final dialog = AlertDialog(
      content: Text('Test'),
    );
    showDialog(context: context, builder: (x) => dialog);
  }

  timeOutCallBack() {
    final context = navigatorKey.currentState!.overlay!.context;
    //print(ModalRoute.of(navigatorKey.currentContext).settings.name);
    if (kIsWeb && !html.window.location.href.contains("intro_Screen") && !html.window.location.href.contains("signin_screen")) {
      showDialog(
        context: context,
        // context: navigatorKey.currentState.overlay.context,
        barrierDismissible: false,
        builder: (context) => new AlertDialog(

          title: Text(MyStrings.timeout),
          content:
          Row(
            children: [
              Text(MyStrings.sessionTimeout),
              RichText(

                text:  TextSpan(
                  /* text: 'Click',
                      style: TextStyle(fontFamily: 'OswaldLight',fontSize: 16,color:MyColors.colorGray_666BC,),
*/
                  children: <TextSpan>[

                    TextSpan(
                        recognizer: new TapGestureRecognizer()..onTap = ()  {
                          SharedPrefManager.instance
                              .setStringAsync(Constants.userEmail, "");
                          SharedPrefManager.instance
                              .setStringAsync(Constants.rememberMe, "");
                          SharedPrefManager.instance
                              .setStringAsync(Constants.roleId, "");
                          SharedPrefManager.instance
                              .setStringAsync(Constants.teamName, "");
                          SharedPrefManager.instance
                              .setStringAsync(Constants.userIdNo, "");
                          // Navigator.pushAndRemoveUntil<dynamic>(
                          //   context,
                          //   MaterialPageRoute<dynamic>(
                          //     builder: (BuildContext context) => SigninScreen(),
                          //   ),
                          //       (route) => false,
                          // );
                          router.navigateTo(context, MyRoutes.signIn, transition: TransitionType.fadeIn);
                        },
                        text: ' Click here ',
                        style:  TextStyle(color:MyColors.kPrimaryColor,)),
                    TextSpan(text: 'to sign in'),
                  ],
                ),
              ),
            ],
          ),



          // actions: <Widget>[
          //   SmallRaisedButton(
          //     buttonWidth: 70,
          //     onPressed: () {
          //       SharedPrefManager.instance
          //           .setStringAsync(Constants.userEmail, null);
          //       SharedPrefManager.instance
          //           .setStringAsync(Constants.roleId, null);
          //       SharedPrefManager.instance
          //           .setStringAsync(Constants.rememberMe, null);
          //       SharedPrefManager.instance
          //           .setStringAsync(Constants.teamName, null);
          //       SharedPrefManager.instance
          //           .setStringAsync(Constants.userIdNo, null);
          //       router.navigateTo(context, MyRoutes.signIn, transition: TransitionType.fadeIn);
          //
          //     },
          //
          //     buttonText: MyStrings.ok,
          //   ),
          //   // SmallRaisedButton(
          //   //   buttonWidth: 70,
          //   //   onPressed: () {
          //   //     Navigator.pop(context);
          //   //   },
          //   //
          //   //   buttonText: MyStrings.cancel,
          //   // ),
          // ],
        ),
      );
    }

  }




  @override
  Widget build(BuildContext context) {
    //DynamicLinksService().retrieveDynamicLink(context);
    return OverlaySupport(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SplashScreenProvider()),
          ChangeNotifierProvider(create: (context) => SignUpProvider()),
          ChangeNotifierProvider(create: (context) => SignInProvider()),
          ChangeNotifierProvider(create: (context) => SelectTeamProvider()),
          ChangeNotifierProvider(
              create: (context) => RoasterListViewProvider()),
          ChangeNotifierProvider(create: (context) => PlayerProfileProvider()),
          ChangeNotifierProvider(create: (context) => EditTeamProvider()),
          ChangeNotifierProvider(create: (context) => CreateTeamProvider()),
          ChangeNotifierProvider(create: (context) => NotificationProvider()),
          ChangeNotifierProvider(create: (context) => AddPlayerProvider()),
          ChangeNotifierProvider(create: (context) => AddVideoProvider()),
          ChangeNotifierProvider(create: (context) => EditPlayerProvider()),
          ChangeNotifierProvider(create: (context) => ImagePickerProvider()),
          ChangeNotifierProvider(create: (context) => OpponentProvider()),
          ChangeNotifierProvider(create: (context) => AddOpponentProvider()),
          ChangeNotifierProvider(create: (context) => AddEventProvider()),
          ChangeNotifierProvider(create: (context) => VolunteerProvider()),
          ChangeNotifierProvider(create: (context) => EventListviewProvider()),
          ChangeNotifierProvider(create: (context) => CalendarCubit(DeviceCalendarPlugin())),
          ChangeNotifierProvider(create: (context) => SelectDrillProvider()),
          ChangeNotifierProvider(
              create: (context) => AvailabilityListviewProvider()),
          ChangeNotifierProvider(create: (context) => ResetPasswordProvider()),

          ChangeNotifierProvider(create: (context) => HomeScreenProvider()),
          ChangeNotifierProvider(create: (context) => SelectDrillProvider()),

        ],
        child: GestureDetector(
          // onTap: sessionTimer.userActivityDetected,
          // onPanDown: sessionTimer.userActivityDetected,
          // onScaleStart: sessionTimer.userActivityDetected,
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (_) => _initializeTimer(),
          onPanDown: (_) => _initializeTimer(),

          child: MaterialApp(
            // builder: (context, child) =>
            //     MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
            navigatorKey: navigatorKey,
            title: MyStrings.appName,
            debugShowCheckedModeBanner: false,
            locale: _locale,

            // routeInformationParser: VxInformationParser(),
            // routerDelegate: VxNavigator(routes: {}),
            theme: ThemeData(
              hoverColor: Colors.transparent,
              // splashColor: Colors.transparent,
              // highlightColor: Colors.transparent,
              elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: MyColors.kPrimaryColor)),
              fontFamily: 'OswaldLight',
              primaryColor: MyColors.kPrimaryColor,

              accentColor: MyColors.kPrimaryLightColor,
              backgroundColor: MyColors.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            // textTheme: GoogleFonts.oswaldTextTheme(Theme.of(context).textTheme)),
            // home: HomeScreen(2),
            //home: SplashScreen(),
            initialRoute: NavUtils.initialUrl,
            onGenerateRoute: router.generator,

            //home: ResetPasswordScreen(null),
            /*onGenerateRoute: (settings) {
              // If you push the PassArguments route
              print('>>> ${settings.name} <<<');

              var fromEmail=Uri.parse(settings.name);
              if (settings.name == MyRoutes.signIn) {
                //navigatorKey.currentState.dispose();
              *//*  Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => SigninScreen(),
                  ),
                      (route) => false,
                );*//*
                return MaterialPageRoute(
                  builder: (context) {
                    return SigninScreen();
                  },
                );
              }
              if(fromEmail.path ==MyRoutes.resetPasswordScreen){
                List<String> userDetails=[];
                String userID = fromEmail.queryParameters["userid"];
                String emailID =fromEmail.queryParameters["email"];
                userDetails.add(userID);
                userDetails.add(emailID);
                *//*Navigator.pushNamed(
                  navigatorKey.currentContext,MyRoutes.resetPasswordScreen
                );*//*
                 *//* Navigator.pushAndRemoveUntil(
                    navigatorKey.currentContext,
                    MaterialPageRoute(
                      builder: ( context) => ResetPasswordScreen(userDetails),
                    ),
                        (route) => false,
                  );*//*
                //ModalRoute.withName(MyRoutes.resetPasswordScreen);
               *//* return MaterialPageRoute(
                  builder: (context) {
                    return ResetPasswordScreen(userDetails);
                  },
                );*//*
                  Navigator.pushAndRemoveUntil<dynamic>(
                    navigatorKey.currentContext,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => ResetPasswordScreen(userDetails),
                    ),
                        (route) => false,//if you want to disable back feature set to false
                  );
              }
              assert(false, 'Need to implement ${settings.name}');
              return null;
            },
            */routes: {
            MyRoutes.splashScreen: (context) => SplashScreen(),
            //MyRoutes.signUp: (context) => SignupScreen(),
            MyRoutes.signIn: (context) => SigninScreen(),
            MyRoutes.scoreDetailsScreen: (context) => ScoreDetailsScreen(),
            // MyRoutes.inviteCoachScreen: (context) => InviteCoachScreen(),
            MyRoutes.introScreen: (context) => IntroScreen(),
            // MyRoutes.createTeamScreen: (context) => CreateTeamScreen(),
            MyRoutes.editTeamScreen: (context) => EditTeamScreen(),
            // MyRoutes.repeatScreen: (context) => RepeatScreen(),
            //MyRoutes.videoPlayerScreen: (context) => VideoPlayerScreen(),
            //MyRoutes.resetPasswordScreen: (context) => ResetPasswordScreen(),
            MyRoutes.VideoPlayerListScreen: (context) =>
                VideoPlayerListScreen(),
            MyRoutes.addEventScreen: (context) => AddEventScreen(),
            MyRoutes.selectImage: (context) => ImagePicker(),
            MyRoutes.roastersListviewScreen: (context) =>
                RoastersListviewScreen(),
            MyRoutes.opponentAddScreen: (context) => OpponentAddScreen(),
            MyRoutes.opponentListviewScreen: (context) =>
                OpponentListviewScreen(),
            MyRoutes.eventListviewScreen: (context) => EventListviewScreen(),
            MyRoutes.sportEventListviewScreen: (context) =>
                SportEventListviewScreen(),
            MyRoutes.availabilityScreen: (context) => AvailabilityScreen(),
            MyRoutes.forgotPasswordScreen: (context) =>
                ForgotPasswordScreen(),
            MyRoutes.signUpNext: (context) => SignupNextScreen(),
            MyRoutes.createPassword: (context) => CreatePasswordScreen(),
            //MyRoutes.editEventScreen: (context) => EditEventScreen(),
            MyRoutes.volunteerListviewScreen: (context) =>
                VolunteerListviewScreen(),
            MyRoutes.addVideoScreen: (context) => AddVideoScreen(),
            //MyRoutes.addMediaScreen: (context) => AddMediaScreen(),
            // MyRoutes.mediaListScreen: (context) => MediaPlayerTabScreen(),
            MyRoutes.NotificationPreferencesScreen: (context) =>
                NotificationPreferencesScreen(),
            MyRoutes.selectTeamScreen: (context) => SelectTeamScreen(),
            MyRoutes.userProfileScreen: (context) => UserProfileScreen(),
            MyRoutes.VolunteerSuperAdminScreen: (context) => VolunteerSuperAdminScreen(),
            MyRoutes.addExistingPlayerScreen: (context) =>
                AddExistingPlayerScreen(),
            MyRoutes.removeVolunteerScreen: (context) =>
                RemoveVolunteerScreen(),

            MyRoutes.repeatScreen: (context) {
              bool isEdit = ModalRoute.of(context)!.settings.arguments as bool;
              print(ModalRoute.of(context)!.settings.arguments);
              return RepeatScreen(isEdit);
            },

            MyRoutes.addMediaScreen: (context) {
              int id = ModalRoute.of(context)!.settings.arguments as int;
              print(ModalRoute.of(context)!.settings.arguments);
              return AddMediaScreen(id);
            },

            MyRoutes.signUp: (context) {
              int id = ModalRoute.of(context)!.settings.arguments as int;
              print(ModalRoute.of(context)!.settings.arguments);
              return SignupScreen(id);
            },

            MyRoutes.videoPlayerScreen: (context) {
              String url = ModalRoute.of(context)!.settings.arguments as String;
              print(ModalRoute.of(context)!.settings.arguments);
              return VideoPlayerScreen(url);
            },

            MyRoutes.createTeamScreen: (context) {
              int id = ModalRoute.of(context)!.settings.arguments as int;
              print(ModalRoute.of(context)!.settings.arguments);
              return CreateTeamScreen(id);
            },

            MyRoutes.editEventScreen: (context) {
              int gameID = ModalRoute.of(context)!.settings.arguments as int;
              print(ModalRoute.of(context)!.settings.arguments);
              return EditEventScreen(gameID);
            },
            MyRoutes.updateVolunteerListviewScreen: (context) {
              GameOrEventList eventList = ModalRoute.of(context)!.settings.arguments as GameOrEventList;
              print(ModalRoute.of(context)!.settings.arguments);
              return UpdateVolunteerListviewScreen(eventList);
            },
            MyRoutes.createPasswordScreen: (context) {
              List<String> userDetails =
                  ModalRoute.of(context)!.settings.arguments as List<String>;
              print(ModalRoute.of(context)!.settings.arguments);
              return CreateNewPasswordScreen(userDetails);
            },
            MyRoutes.resetPasswordScreen: (context) {
              List<String> userDetails =
                  ModalRoute.of(context)!.settings.arguments as List<String>;
              print(ModalRoute.of(context)!.settings.arguments);
              return ResetPasswordScreen(userDetails);
            },
            MyRoutes.editPlayersScreen: (context) {
              int userId = ModalRoute.of(context)!.settings.arguments as int;
              print(ModalRoute.of(context)!.settings.arguments);
              return EditPlayersScreen(userId);
            },
            MyRoutes.editExistingPlayerScreen: (context) {
              int userId = ModalRoute.of(context)!.settings.arguments as int;
              print(ModalRoute.of(context)!.settings.arguments);
              return EditExistingPlayersScreen(userId);
            },
            MyRoutes.playerProfile: (context) {
              int userId = ModalRoute.of(context)!.settings.arguments as int;
              print(ModalRoute.of(context)!.settings.arguments);
              return PlayerProfileScreen(userId);
            },
            MyRoutes.homeScreen: (context) {
              int tabId = ModalRoute.of(context)!.settings.arguments as int;
              print(ModalRoute.of(context)!.settings.arguments);
              return HomeScreen(tabId);
            },
            MyRoutes.mediaListScreen: (context) {
              int tabId = ModalRoute.of(context)!.settings.arguments as int;
              print(ModalRoute.of(context)!.settings.arguments);
              return MediaPlayerTabScreen(tabId);
            },
            /* MyRoutes.selectTeamScreen: (context) {
                var data = ModalRoute.of(context).settings.arguments;
                print(ModalRoute.of(context).settings.arguments);
                return SelectTeamScreen(data);
              },*/
            /*MyRoutes.userProfileScreen: (context) {
                var data = ModalRoute.of(context).settings.arguments;
                print(ModalRoute.of(context).settings.arguments);
                return UserProfileScreen(data);
              },*/
            MyRoutes.teamProfileScreen: (context) {
              int data = ModalRoute.of(context)!.settings.arguments as int;
              print(ModalRoute.of(context)!.settings.arguments);
              return TeamProfileScreen(data);
            },
            // MyRoutes.availablePlayerScreen: (context) {
            //   TeamEventList teamList =
            //       ModalRoute.of(context).settings.arguments;
            //   print(ModalRoute.of(context).settings.arguments);
            //   return AvailablePlayerTabScreen(teamList);
            // },

            MyRoutes.AvailableTabScreen: (context) {
              GameOrEventList eventList =
                  ModalRoute.of(context)!.settings.arguments as GameOrEventList;
              print(ModalRoute.of(context)!.settings.arguments);
              return AvailableTabScreen(eventList);
            },
            // MyRoutes.volunteerAvailablityScreen: (context) {
            //   TeamEventList teamList =
            //       ModalRoute.of(context).settings.arguments;
            //   print(ModalRoute.of(context).settings.arguments);
            //   return VolunteerAvailablePlayerTabScreen(teamList);
            // },

            MyRoutes.playerContactListScreen: (context) {
              PlatformFile file = ModalRoute.of(context)!.settings.arguments as PlatformFile;
              print(ModalRoute.of(context)!.settings.arguments);
              return PlayerContactListScreen(file);
            },
            MyRoutes.addPlayerScreen: (context) {
              var contact = ModalRoute.of(context)!.settings.arguments;
              print(ModalRoute.of(context)!.settings.arguments);
              return AddPlayerScreen(contact);
            },
            MyRoutes.shareDrillScreen: (context) {
              ShareDrillRequest drill = ModalRoute.of(context)!.settings.arguments as ShareDrillRequest;
              print(ModalRoute.of(context)!.settings.arguments);
              return ShareDrillScreen(drill);
            },
            MyRoutes.sharedDrillListScreen: (context) {
              var drillPlans = ModalRoute.of(context)!.settings.arguments ;
              print(ModalRoute.of(context)!.settings.arguments);
              return SharedDrillListViewScreen(drillPlans);
            },
            MyRoutes.selectDrillScreen: (context) => SelectDrillScreen(),
            MyRoutes.sharedDrillScreen: (context) => SharedDrillScreen(),

            MyRoutes.coachHomeScreen: (context) {
              int tabId = ModalRoute.of(context)!.settings.arguments as int;
              print(ModalRoute.of(context)!.settings.arguments);
              return CoachesHomeScreen();
            },

          },
            localizationsDelegates: [
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''),
              const Locale('fa', ''),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale!.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
          ),
        ),
      ),
    );
  }

  void getSharedDataAsync() async{
    fcm=  (await SharedPrefManager.instance.getStringAsync(Constants.FCM)).toString();
    userName= await SharedPrefManager.instance.getStringAsync(Constants.userName);
  }
}







class Routes {
  static void configureRoutes(FluroRouter router) {
    /*  if(kIsWeb) {
      router.notFoundHandler = Handler(handlerFunc: (context, params) {
        debugPrint("ROUTE WAS NOT FOUND !!!");
        return RouteNotFound();
      });
    }*/
    router.define(
      MyRoutes.resetPasswordScreen,
      transitionType: TransitionType.materialFullScreenDialog,
      handler: Handler(handlerFunc: (_, params) {
        List<String> userDetails=[];
        String? userID = params["userid"]?.first;
        String? emailID =params["email"]?.first;
        userDetails.add(userID!);
        userDetails.add(emailID!);
        userDetails.add("true");
        return ResetPasswordScreen(userDetails);
      }),
    );
    router.define(
      MyRoutes.signIn,
      handler: Handler(handlerFunc: (_, params) => SigninScreen()),
    );

    router.define(
      MyRoutes.splashScreen,
      transitionType: TransitionType.materialFullScreenDialog,
      handler: Handler(handlerFunc: (_, params) {
        String? status = params["status"]?.first;
        String? refer = params["refer"]?.first;
        String? userid = params["userid"]?.first;
        String? eventname = params["eventname"]?.first;
        String? teamname = params["teamname"]?.first;
        String? type = params["type"]?.first;
        String? fcm = params["fcm"]?.first;
        String? name = params["name"]?.first;
        String? mail = params["mail"]?.first;
        String? toMail = params["toMail"]?.first;
        String? toID = params["toID"]?.first;
        String? userName = params["userName"]?.first;
        String? location = params["location"]?.first;
        String? date = params["date"]?.first;
        if(status==Constants.accept.toString()){
          EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAcceptManager,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" "+ "has accepted your invite of the "+type!+", "+eventname!+" for team "+teamname!+".",toMail!,name!,"","","","","","","","","",userName+" "+ "has accepted your invite of the "+type+", "+eventname+" for team "+teamname,"","",false);
          EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAccept,int.parse(userid),int.parse(userid),int.parse(refer),"You have accepted to join the "+type+", "+eventname+" for team "+teamname+".",mail!,userName,"","","","","","","","","","You have accepted to join the "+type+", "+eventname+" for team "+teamname,"","",false);

          SendPushNotificationService().sendPushNotifications(
              _MyAppState.fcm.toString(),
              "You have accepted to join the "+type+", "+eventname+" for team "+teamname,"");
          SendPushNotificationService().sendPushNotifications(
              fcm!,
              userName+" has accepted your invite of the "+type+", "+eventname+" for team "+teamname,"");
        }else if(status==Constants.maybe.toString()){
          EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAcceptManager,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" "+ "has responded to your invite as maybe the "+type!+", "+eventname!+" for team "+teamname!+".",toMail!,name!,"","","","","","","","","",userName+" "+ "has responded to your invite as maybe the "+type+", "+eventname+" for team "+teamname,"","",false);
          EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAccept,int.parse(userid!),int.parse(userid),int.parse(refer),"You have responded as maybe to join the "+type+", "+eventname+" for team "+teamname+".",mail!,userName,"","","","","","","","","","You have responded as maybe to join the "+type+", "+eventname+" for team "+teamname,"","",false);


          SendPushNotificationService().sendPushNotifications(
              _MyAppState.fcm.toString(),
              "You have responded as maybe to join the "+type+", "+eventname+" for team "+teamname,"");
          SendPushNotificationService().sendPushNotifications(
              fcm!,
              userName+" has responded to your invite as maybe the "+type+", "+eventname+" for team "+teamname,"");
        }else if(status==Constants.reject.toString()){
          EmailService().createEventNotification("Response to the Invite","",Constants.gameEventDeclineManger,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" "+ "has declined your invite of the "+type!+", "+eventname!+" for team "+teamname!+".",toMail!,name!,"","","","","","","","","",userName+" "+ "has declined your invite of the "+type+", "+eventname+" for team "+teamname,"","",false);
          EmailService().createEventNotification("Response to the Invite","",Constants.gameEventDecline,int.parse(userid),int.parse(userid),int.parse(refer),"You have declined to join the "+type+", "+eventname+" for team "+teamname+".",mail!,userName,"","","","","","","","","","You have declined to join the "+type+", "+eventname+" for team "+teamname,"","",false);


          SendPushNotificationService().sendPushNotifications(
              _MyAppState.fcm.toString(),
              "You have declined to join the "+type+", "+eventname+" for team "+teamname,"");
          SendPushNotificationService().sendPushNotifications(
              fcm!,
              userName+" has declined your invite of the "+type+", "+eventname+" for team "+teamname,"");
        }

        EmailService().updatePlayerAvalAsync(status!, refer!, userid!,"");

        return SplashScreen();
      }),
    );

    router.define(
      MyRoutes.volunteerAvailablityScreen,
      transitionType: TransitionType.materialFullScreenDialog,
      handler: Handler(handlerFunc: (_, params) {
        String? status = params["status"]?.first;
        String? refer = params["refer"]?.first;
        String? userid = params["userid"]?.first;
        String? eventname = params["eventname"]?.first;
        String? volunteer = params["volunteer"]?.first;
        String? eventVolunteerTypeId = params["eventVolunteerTypeId"]?.first;
        String? volunteerTypeId = params["volunteerTypeId"]?.first;
        String? teamname = params["teamname"]?.first;
        String? type = params["type"]?.first;
        String? fcm = params["fcm"]?.first;
        String? name = params["name"]?.first;
        String? mail = params["mail"]?.first;
        String? toMail = params["toMail"]?.first;
        String? toID = params["toID"]?.first;
        String? userName = params["userName"]?.first;
        String? location = params["location"]?.first;
        String? date = params["date"]?.first;
        if(status==Constants.accept.toString()){

          EmailService().createEventNotification("Response to the Invite",eventname!,Constants.gameVolunteerAccept,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" has accepted to be a volunteer for the assigned task  that has been Scheduled by "+ name!+ " for the team, "+teamname!,toMail!,name,eventname,"","","",location!,date??"","","","",userName,teamname,volunteer!,false);

          SendPushNotificationService().sendPushNotifications(
              fcm!,
              userName+" has accepted to be a volunteer for the assigned task  that has been Scheduled by "+ name+ " for the team, "+teamname,"");
        }else if(status==Constants.maybe.toString()){
         }else if(status==Constants.reject.toString()){
          EmailService().createEventNotification("Response to the Invite",eventname!,Constants.gameVolunteerDecline,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" has declined to be a volunteer for the assigned task  that has been Scheduled by "+ name!+ " for the team, "+teamname!,toMail!,name,eventname,"","","",location!,date!,"","","",userName,teamname,volunteer!,false);

           SendPushNotificationService().sendPushNotifications(
              fcm!,
              userName+" has declined to be a volunteer for the assigned task  that has been Scheduled by "+ name+ " for the team, "+teamname,"");
        }

        EmailService().updateVolunteerAvalAsync(eventVolunteerTypeId!,volunteerTypeId!,volunteer!,refer!,userid!,status!);

        return SplashScreen();
      }),
    );

    router.define(
      MyRoutes.introScreen,
      transitionType: TransitionType.materialFullScreenDialog,
      handler: Handler(handlerFunc: (_, params) {
        String? userID = params["userid"]?.first;
        String? teamID = params["teamid"]?.first;
        String? emailID = params["email"]?.first;
        String? fcm = params["fcm"]?.first;
        String? userRoleId = params["userRoleId"]?.first;
        String? team = params["team"]?.first;
        String? player = params["player"]?.first;
        String? manager = params["manager"]?.first;
        String? toMail = params["toMail"]?.first;
        String? toID = params["toID"]?.first;

        EmailService().createAccountAsync(userID!, teamID!, emailID!, 3,false,int.parse(userRoleId!));

        EmailService().inits("Invite Declined ","",Constants.gameEventDecline,int.parse(userID),int.parse(userID),int.parse(teamID),"You have declined the invite to join the team, "+team!+".",emailID,team,"","",player!,"");
        EmailService().inits("Invite Declined ","",Constants.gameEventDeclineManger,int.parse(userID),int.parse(toID!),int.parse(teamID),player!+" has declined your invite to join the team, "+team+".",toMail!,"","","",player+" has declined your invitation to join the team, "+team,manager!);

        SendPushNotificationService().sendPushNotifications(
            fcm!,"Invite Declined ",player!+" has declined your invite to join the team, "+team!);

        return SplashScreen();
      }),
    );
    router.define(
      MyRoutes.createPasswordScreen,
      transitionType: TransitionType.materialFullScreenDialog,
      handler: Handler(handlerFunc: (_, params) {
        List<String> userDetails = [];
        String? userID = params["userid"]?.first;
        String? teamID = params["teamid"]?.first;
        String? emailID = params["email"]?.first;
        String? fcm = params["fcm"]?.first;
        String? userRoleId = params["userRoleId"]?.first;
        String? team = params["team"]?.first;
        String? player = params["player"]?.first;
        String? manager = params["manager"]?.first;
        String? isMemberExist = params["isMemberExist"]?.first;
        String? toMail = params["toMail"]?.first;
        String? toID = params["toID"]?.first;
        userDetails.add(userID!);
        userDetails.add(teamID!);
        userDetails.add(emailID!);
        userDetails.add(userRoleId!);
        userDetails.add(fcm!);
        userDetails.add(team!);
        userDetails.add(player!);
        userDetails.add(manager!);
        userDetails.add(toMail!);
        userDetails.add(toID!);
        if(isMemberExist=="true"){
          EmailService().createAccountAsync(userID, teamID, emailID, 2,false,int.parse(userRoleId));
          EmailService().inits("Invite Accepted","",Constants.gameEventAccept,int.parse(userDetails[0]),int.parse(userDetails[0]),int.parse(userDetails[1]),"You have accepted the invite to join the team, "+userDetails[5]+".",emailID,userDetails[5],"","",userDetails[6],"");
          EmailService().inits("Invite Accepted","",Constants.gameEventAcceptManager,int.parse(userDetails[0]),int.parse(toID),int.parse(userDetails[1]),userDetails[6]+" has accepted your invite to join the team, "+userDetails[5]+".",toMail,"","","",userDetails[6]+" has accepted your invitation to join the team, "+userDetails[5],userDetails[7]);

          SendPushNotificationService().sendPushNotifications(
              _MyAppState.fcm.toString(),
              "You have accepted the invite to join the team, "+userDetails[5],"");
          SendPushNotificationService().sendPushNotifications(
              userDetails[4],
              userDetails[6]+" has accepted your invite to join the team, "+userDetails[5],"");

          return SplashScreen();
        }else{
          return CreateNewPasswordScreen(userDetails);
        }
      }),
    );
    router.define(
      MyRoutes.signIn,
      transitionType: TransitionType.materialFullScreenDialog,
      handler: Handler(handlerFunc: (_, params) {
        return SigninScreen();
      }),
    );
    /* router.define(
      MyRoutes.splashScreen,
      handler: Handler(handlerFunc: (_, params) => SplashScreen()),
    );*/
    /*router.define(
      MyRoutes.introScreen,
      transitionType: TransitionType.materialFullScreenDialog,
      handler: Handler(handlerFunc: (_, params) {
        return IntroScreen();
      }),
    );
    router.define(
      MyRoutes.signUp,
      transitionType: TransitionType.materialFullScreenDialog,
      handler: Handler(handlerFunc: (_, params) {
        return SignupScreen();
      }),
    );*/
    /* router.define(
      '/account/:id',
      transitionType: TransitionType.materialFullScreenDialog,
      handler: Handler(handlerFunc: (_, params) {
        String id = params["id"]?.first;
        return AccountScreen(id: id);
      }),
    );
    router.define(
      '/about',
      transitionType: TransitionType.materialFullScreenDialog,
      handler: Handler(handlerFunc: (_, params) {
        return AboutScreen();
      }),
    );
    router.define(
      '/settings',
      transitionType: TransitionType.materialFullScreenDialog,
      handler: Handler(handlerFunc: (_, params) {
        return SettingsScreen();
      }),
    );*/
  }
}

class RouteNotFound extends StatelessWidget {
  const RouteNotFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Center(
        child: Container(
          child: Text(
            '404',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }
}

