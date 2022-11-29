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

  FlavorConfig(
      flavor: Flavor.QA,
      color: Colors.deepPurpleAccent,
      values: FlavorValues(baseUrl: Endpoints.serverUrl));
  runApp(MyApp());
}
