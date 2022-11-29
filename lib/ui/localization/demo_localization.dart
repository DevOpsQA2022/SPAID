
//Future Purpose

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class DemoLocalization {
//   DemoLocalization(this.locale);
//
//   final Locale locale;
//   static DemoLocalization of(BuildContext context) {
//     return Localizations.of<DemoLocalization>(context, DemoLocalization);
//   }
//
//   Map<String, String> _localizedValues;
//
//   Future<void> load() async {
//     String jsonStringValues =
//     await rootBundle.loadString('lib/ui/lang/${locale.languageCode}.json');
//     Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
//     _localizedValues =
//         mappedJson.map((key, value) => MapEntry(key, value.toString()));
//   }
//
//   String translate(String key) {
//     return _localizedValues[key];
//   }
//
//   // static member to have simple access to the delegate from Material App
//   static const LocalizationsDelegate<DemoLocalization> delegate =
//   _DemoLocalizationsDelegate();
// }
//
// class _DemoLocalizationsDelegate
//     extends LocalizationsDelegate<DemoLocalization> {
//   const _DemoLocalizationsDelegate();
//
//   @override
//   bool isSupported(Locale locale) {
//     return ['en', 'fa', 'ar', 'hi'].contains(locale.languageCode);
//   }
//
//   @override
//   Future<DemoLocalization> load(Locale locale) async {
//     DemoLocalization localization = new DemoLocalization(locale);
//     await localization.load();
//     return localization;
//   }
//
//   @override
//   bool shouldReload(LocalizationsDelegate<DemoLocalization> old) => false;
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  //region Private Members

  static final AppLocalizations _singleton = new AppLocalizations._internal();
  AppLocalizations._internal();
  static AppLocalizations get instance => _singleton;
  Map<dynamic, dynamic>? _localisedValues;

  //endregion


  String translate(String key) {
    return _localisedValues![key];
  }

  /*
Return Type:
Input Parameters:jsonContent languageCode.json
Use: getLanguageAsync language code.
 */
  Future<AppLocalizations> getLanguageAsync(Locale locale) async {

    String jsonContent = await rootBundle
        .loadString("assets/json/lang/${locale.languageCode}.json");
    _localisedValues = json.decode(jsonContent);
    return this;
  }

  String text(String key) {
    return _localisedValues![key];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fa'].contains(locale.languageCode);

  @override

  /*
Return Type:
Input Parameters:
Use: AppLocalizations locale.
 */
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.instance.getLanguageAsync(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
