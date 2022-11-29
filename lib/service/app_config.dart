import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  AppConfig({
    @required this.appName,
    @required this.flavorName,
    @required this.apiBaseUrl,
    @required Widget? child,
  }) : super(child: child!);

  final String? appName;
  final String? flavorName;
  final String? apiBaseUrl;

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

class FlavorValues {
  FlavorValues({@required this.baseUrl});

  final String? baseUrl;
//Add other flavor specific values, e.g database name
}

enum Flavor { DEV, QA, PRODUCTION }

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color color;
  final FlavorValues values;
  static FlavorConfig? _instance;

  factory FlavorConfig(
      {@required Flavor? flavor,
      Color color: Colors.blue,
      @required FlavorValues? values}) {
    _instance ??=
        FlavorConfig._internal(flavor!, (flavor.toString()), color, values!);
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.name, this.color, this.values);

  static FlavorConfig get instance {
    return _instance!;
  }

  static bool isProduction() => _instance!.flavor == Flavor.PRODUCTION;

  static bool isDevelopment() => _instance!.flavor == Flavor.DEV;

  static bool isQA() => _instance!.flavor == Flavor.QA;
}
