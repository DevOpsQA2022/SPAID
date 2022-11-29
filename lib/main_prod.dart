import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spaid/main.dart';
import 'package:spaid/service/app_config.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  setupLocator();
  // var configuredApp = AppConfig(
  //   appName: 'Build flavors DEV',
  //   flavorName: 'development',
  //   apiBaseUrl: 'http://202.83.25.234:3393/Spaid/api/User/',
  //   child: MyApp(),
  // );

  FlavorConfig(
      flavor: Flavor.PRODUCTION,
      color: Colors.deepPurpleAccent,
      values: FlavorValues(baseUrl: Endpoints.serverUrl));
  runApp(MyApp());
}
