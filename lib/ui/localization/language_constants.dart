import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaid/ui/localization/demo_localization.dart';


//region Private Members

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String FARSI = 'fa';
const String ARABIC = 'ar';
const String HINDI = 'hi';
//endregion


/*
Return Type: String
Input Parameters:
Use: setLanguageAsync Shared Pref.
 */
Future<Locale> setLanguageAsync(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

/*
Return Type:
Input Parameters:
Use: getLanguageAsync Shared Pref.
 */

Future<Locale> getLanguageAsync() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";
  return _locale(languageCode);
}

/*
Return Type:
Input Parameters:
Use: languageCode Switch case type.
 */
Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    case FARSI:
      return Locale(FARSI, "IR");
    case ARABIC:
      return Locale(ARABIC, "SA");
    case HINDI:
      return Locale(HINDI, "IN");
    default:
      return Locale(ENGLISH, 'US');
  }
}

/*
Return Type: String
Input Parameters:
Use: translate AppLocalizations.
 */
String getTranslated(BuildContext context, String key) {
  return AppLocalizations.of(context)!.translate(key);
}
