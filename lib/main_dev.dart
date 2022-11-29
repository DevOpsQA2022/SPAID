
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/main.dart';
import 'package:spaid/service/app_config.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/locator.dart';
import 'package:spaid/ui/add_event_screen/add_event_provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:workmanager/workmanager.dart';

void main() async{

  /*IdleTracker(
      timeout: const Duration(seconds: 15),
      periodicIdleCall: true,
      startsAsIdle: true,
      onIdle: onIdle,
      onActive: onActive);*/
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // MobileAds.instance.initialize();
  /*SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);*/
 /* SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);*/
  setupLocator();
/*
  WidgetsFlutterBinding.ensureInitialized(); //imp line need to be added first
  FlutterError.onError = (FlutterErrorDetails details) {
    //this line prints the default flutter gesture caught exception in console
    //FlutterError.dumpErrorToConsole(details);
    print("Error From INSIDE FRAME_WORK");
    print("----------------------");
    print("Error :  ${details.exception}");
    print("StackTrace :  ${details.stack}");
  };*/
  // setPathUrlStrategy();
  FlavorConfig(
      flavor: Flavor.DEV,
      color: Colors.deepPurpleAccent,
      values: FlavorValues(baseUrl: Endpoints.serverUrl));
  ResponsiveSizingConfig.instance.setCustomBreakpoints(
    ScreenBreakpoints(desktop: 800, tablet: 675, watch: 200),
  );
  if (kIsWeb) {
    // initialize the facebook javascript SDK
    FacebookAuth.instance.webInitialize(
      appId: "1760861724305829",//<-- YOUR APP_ID
      cookie: true,
      xfbml: true,
      version: "v1.0",
    );
  }
  runApp(MyApp());
}

/*
var count = 0;
final output = document.querySelector('#output');

void log(String message) {
  if (output.children.length >= 40) {
    output.innerHtml = '';
  }
  output.append(DivElement()..text = message);
}

void onActive() {
  count = 0;
  log('Welcome back!');
}

void onIdle() {
  if (count++ < 10) log('Hey, are you there?');
}*/
