import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:spaid/model/request/add_player_request/dynamic_link_request.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/ui/home_screen/home_screen_ui.dart';
import 'package:spaid/ui/signin_screen/signin_screen_ui.dart';

class DynamicLinksService {

  Future<String> createDynamicLink(String parameter) async {
   // String dynamicLink=await compute(computeLink, parameter);
    String dynamicLink="";
    if (!kIsWeb) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      print(packageInfo.packageName);
      String uriPrefix = "https://spaid.page.link";

      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: uriPrefix,
        link: Uri.parse(Endpoints.emailUrl+"#/"+parameter),
        androidParameters: AndroidParameters(
          packageName: packageInfo.packageName,
          minimumVersion: 125,
        ),
        iosParameters: IosParameters(
          bundleId: packageInfo.packageName,
          minimumVersion: packageInfo.version,
          appStoreId: '123456789',
        ),
        /*googleAnalyticsParameters: GoogleAnalyticsParameters(
          campaign: 'example-promo',
          medium: 'social',
          source: 'orkut',
        ),
        itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
          providerToken: '123456',
          campaignToken: 'example-promo',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: 'Example of a Dynamic Link',
            description: 'This link works whether app is installed or not!',
            imageUrl: Uri.parse(
                "https://images.pexels.com/photos/3841338/pexels-photo-3841338.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260")),*/
      );

      /* final Uri dynamicUrl = await parameters.buildUrl();
       print(parameters);
       final ShortDynamicLink shortDynamicLink = await parameters
           .buildShortLink();
       print(shortDynamicLink);*/
      final link = await parameters.buildUrl();
      final ShortDynamicLink shortenedLink =
      await DynamicLinkParameters.shortenUrl(
        link,
        DynamicLinkParametersOptions(
            shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
      );
      //final Uri shortUrl = shortDynamicLink.shortUrl;
      final Uri shortUrl = shortenedLink.shortUrl;
      print(shortUrl);
      dynamicLink= shortUrl.toString();
    } else {
      Uri link=Uri.parse(Endpoints.emailUrl+"#/"+parameter);
      await ApiManager()
          .getDio()!
          .post('https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key='+Constants.WebAPIKey,data: {
        "dynamicLinkInfo": {
          "domainUriPrefix": "https://spaid.page.link",
          "link": "$link",
          "androidInfo": {
            "androidPackageName": "com.ciglobal.spaid"
          },
          "iosInfo": {
            "iosBundleId": "com.ciglobal.spaid"
          }
        }
      })
          .then((response) {
        print(response.data["shortLink"]);
        dynamicLink= response.data["shortLink"].toString();
      }).catchError((onError) {
        print(onError);
      });
    }
    return dynamicLink;
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDynamicLink(data);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      _handleDynamicLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data.link;

      if (deepLink != null) {
        if (Uri.parse(deepLink.fragment).queryParameters["username"] != null) {
          String? username =
              Uri.parse(deepLink.fragment).queryParameters["username"];
          //String password = Uri.parse(deepLink.fragment).queryParameters["pass"];
          DynamicLinksService()
              .createDynamicLink("create_Password_Screen")
              .then((value) {
            print(value);
            //   EmailService().init("Invitation",AcceptInvite.acceptInvite.replaceAll("{{playername}}", username).replaceAll("{{signinurl}}",value));
          });
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen(0)));
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SigninScreen()));
        }
      }

      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink.link;

        if (deepLink != null) {
          if (Uri.parse(deepLink.fragment).queryParameters["username"] !=
                  null &&
              Uri.parse(deepLink.fragment).queryParameters["pass"] != null) {
            String? username =
                Uri.parse(deepLink.fragment).queryParameters["username"];
            String? password =
                Uri.parse(deepLink.fragment).queryParameters["pass"];
            DynamicLinksService()
                .createDynamicLink("signin_screen")
                .then((value) {
              print(value);
              // EmailService().init("Invitation",AcceptInvite.acceptInvite.replaceAll("{{playername}}", username).replaceAll("{{signinurl}}",value));
            });
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeScreen(0)));
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SigninScreen()));
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _handleDynamicLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data.link;

    if (deepLink == null) {
      return;
    }
    if (deepLink.pathSegments.contains('refer')) {
      var title = deepLink.queryParameters['code'];
      if (title != null) {
        print("refercode=$title");
      }
    }
  }
}
