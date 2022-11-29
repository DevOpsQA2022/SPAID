import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/menu_screen_card.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageHomeScreen extends StatefulWidget {
  @override
  _MessageHomeScreenState createState() => _MessageHomeScreenState();
}

class _MessageHomeScreenState extends State<MessageHomeScreen> {
/*
Return Type:
Input Parameters:
Use: Using Given details,it will create draft mail.
 */
  launchMailtoAsync() async {
    final mailtoLink = Mailto(
      to: ['to@example.com'],
      subject: 'Spaid example subject',
      body: 'Spaid example body',
    );
    await launch('$mailtoLink');
  }

/*
Return Type:
Input Parameters:
Use: To send SMS.
 */
  _textMeAsync() async {
    // Android
    const uri = 'sms:+39 348 060 888?body=hello there is spaid';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'sms:0039-222-060-888?body=hello%20there';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WebCard(
      marginVertical: WidgetCustomSize.marginVertical,
      marginhorizontal: WidgetCustomSize.marginhorizontal,
      child: Padding(
        padding: EdgeInsets.all( getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: true,
                                        desktop: true,) ? PaddingSize.headerPadding1 : PaddingSize.headerPadding2),
        child: Column(
          children: [
            MenuScreenCard(
              title: MyStrings.email,
              icon: Icon(Icons.email_outlined,color: MyColors.white,),
              color: MyColors.kPrimaryColor,
              onPressed: () {
                launchMailtoAsync();
              },
            ),
          /*  MenuScreenCard(
              title: MyStrings.chat,
              icon: Icon(Icons.chat),
              color: MyColors.kPrimaryMidiumColor,
              onPressed: () {
                // Navigation.navigateTo(context, MyRoutes.availabilityScreen);
              },
            ),
            MenuScreenCard(
              title: MyStrings.direct,
              icon: Icon(Icons.messenger_outlined),
              color: MyColors.kPrimaryMidiumColor,
              onPressed: () {
                // Navigation.navigateTo(context, MyRoutes.availabilityScreen);
              },
            ),
            MenuScreenCard(
              title: MyStrings.sms,
              icon: MyIcons.message,
              color: MyColors.kPrimaryMidiumColor,
              onPressed: () {
                _textMeAsync();
                // Navigation.navigateTo(context, MyRoutes.availabilityScreen);
              },
            ),*/
          ],
        ),
      ),
    );

  }
}
