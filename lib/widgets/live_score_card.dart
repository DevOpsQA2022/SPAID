import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:screenshot/screenshot.dart';
import 'package:spaid/model/response/game_event_response/live_game_response.dart';
import 'package:spaid/service/rabbitmq_message_receive.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class LiveScoreCard extends StatelessWidget {
  /*final String title, body;
  final String buttonstatus;
  final Function(int) onClick;


  NotificationCard({
    @required this.title,
    @required this.body,
    @required this.buttonstatus,
    this.onClick,
  });*/
  ScreenshotController screenshotController = ScreenshotController();

  var messages;
  OnGoingGameList teamA;
  OnGoingGameList teamB;

  LiveScoreCard(this.teamA, this.teamB);

  void initRabbitMq(int matcheId) {
    ConnectionSettings settings = new ConnectionSettings(
        virtualHost: "/",
        port: Constants.port,
        authProvider: new AmqPlainAuthenticator(Constants.rabbitMQUsername, Constants.rabbitMQPassword),
        host: Constants.rabbitMQHost);
    Client client = new Client(settings: settings);
    client
        .channel()
        .then((Channel channel) =>
        channel.exchange(matcheId.toString(), ExchangeType.FANOUT, durable: true))
       /* .then((Channel channel) =>
        channel.exchange("10", ExchangeType.FANOUT, durable: true))*/
        .then((Exchange exchange) => exchange.bindPrivateQueueConsumer(null))
        .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
      /* // Get the payload as a string
              print("ll");
              // Get the payload as a string
              print(" [x] Received string: ${message.payloadAsString}");*/

      // Or unserialize to json
      print(" [x] Received json: ${message.payloadAsJson}");

      /* // Or just get the raw data as a Uint8List
              print(" [x] Received raw: ${message.payload}");
              // The message object contains helper methods for
              // replying, ack-ing and rejecting
*/
      //Map<String, dynamic> userMap = jsonDecode(message.payloadAsJson);
       messages = RabbitMQMessage.fromJson(message.payloadAsJson);
      print(messages.team1);
      print(messages.team2);


      //message.reply("world");
    }));
  }


  @override
  Widget build(BuildContext context) {
    initRabbitMq(teamA.matcheId!);
    return  ExpansionTile(
        title: Text(teamA.eventName!),
        initiallyExpanded: true,
        textColor: MyColors.kPrimaryColor,
        iconColor: MyColors.black,
        collapsedIconColor: MyColors.black,
        children: <Widget>[
          Screenshot(
            controller: screenshotController,
            child: Card(
              elevation: PaddingSize.cardElevation,
              child: Column(
                children: <Widget>[
                  ListTile(
                    /*onTap: () {
                      Navigation.navigateTo(
                          context, MyRoutes.scoreDetailsScreen);
                    },*/
                    leading: CircleAvatar(
                        radius: PaddingSize.circleRadius,
                        backgroundColor: MyColors.white,
                        child:teamA.teamImage!.isNotEmpty? Image.memory(
                          base64Decode(teamA.teamImage!),
                          width: MarginSize.headerMarginHorizontal1,
                          height: MarginSize.headerMarginHorizontal1,
                        ):Image.asset(
                          MyImages.team,
                          width: MarginSize.headerMarginHorizontal1,
                          height: MarginSize.headerMarginHorizontal1,
                        )),
                    title: CircleAvatar(
                        radius: PaddingSize.circleRadius,
                        backgroundColor: MyColors.white,
                        child: Image.asset(
                          MyImages.vsImg,
                          width: MarginSize.headerMarginHorizontal1,
                          height: MarginSize.headerMarginHorizontal1,
                        )),
                    trailing: CircleAvatar(
                        radius: PaddingSize.circleRadius,
                        backgroundColor: MyColors.white,
                        child: teamB.opponentTeamImage!.isNotEmpty?Image.memory(
                          base64Decode(teamB.opponentTeamImage!),
                          width: MarginSize.headerMarginHorizontal1,
                          height: MarginSize.headerMarginHorizontal1,
                        ):Image.asset(
                          MyImages.team,
                          width: MarginSize.headerMarginHorizontal1,
                          height: MarginSize.headerMarginHorizontal1,
                        )),
                  ),
                  ListTile(
                    onTap: null,
                    leading: Padding(
                      padding: const EdgeInsets.fromLTRB(PaddingSize.boxPaddingRight, 0, 0, 0),
                      child: Text(
                        teamA.teamName!,
                        style: TextStyle(fontSize:FontSize.headerFontSize4),
                      ),
                    ),
                    title:messages==null?null: Center(
                        child: Text(messages != null?
                          messages.team1:"0" + " : " + messages != null ? messages.team2:"0",
                          style: TextStyle(fontSize: FontSize.headerFontSize4),
                        )),
                    trailing: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Text(
                        teamB.opponentTeamName!,
                        style: TextStyle(fontSize: FontSize.headerFontSize4),
                      ),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        /*SizedBox(
                                        width:isMobile(context)? MediaQuery.of(context).size.width/3:getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: false,
                                        desktop: true,)?null:MediaQuery.of(context).size.width/5,
                                        height: Dimens.standard_35,
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigation.navigateTo(
                                                context, MyRoutes.VideoPlayerListScreen);
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(80.0)),
                                          padding: EdgeInsets.all(0.0),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    MyColors.kPrimaryColor,
                                                    MyColors.kPrimaryColor
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                borderRadius: BorderRadius.circular(PaddingSize.circleRadius)),
                                            child: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 250.0, minHeight: 50.0),
                                                alignment: Alignment.center,
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        child: Icon(
                                                          Icons.play_arrow,
                                                          size: 20,
                                                          color: MyColors.white,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: " Watch ",
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),*/
                        SizedBox(
                          width:getValueForScreenType<bool>(
                            context: context,
                            mobile: true,
                            tablet: false,
                            desktop: false,)? MediaQuery.of(context).size.width/3:getValueForScreenType<bool>(
                            context: context,
                            mobile: false,
                            tablet: false,
                            desktop: true,)?null:MediaQuery.of(context).size.width/5,
                          height: Dimens.standard_35,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom( backgroundColor:MyColors.kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0)),padding: EdgeInsets.all(0.0),
                            ),
                            onPressed: () {
                              screenshotController
                                  .capture()
                                  .then((Uint8List? image) {
                                Future.delayed(Duration.zero, () {
                                  _shareImageAndTextAsync(image);
                                });
                              });
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      MyColors.kPrimaryColor,
                                      MyColors.kPrimaryColor
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(PaddingSize.circleRadius)),
                              child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 250.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.share,
                                            size: 20,
                                            color: MyColors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " Share ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: Dimens.standard_16),
                                        ),
                                      ],
                                    ),
                                  ) /*Text(
                                            "Share",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white, fontSize: 15),
                                          ),*/
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                  SizedBox(height: SizedBoxSize.headerSizedBoxHeight,),
                ],
              ),
            ),
          ),

        ]
    );
  }
  /*
Return Type:
Input Parameters:
Use: To create Image Share Option.
 */
  Future<void> _shareImageAndTextAsync(image) async {
    try {
      //final ByteData bytes = await rootBundle.load('assets/wisecrab.png');
      if(kIsWeb){
        //Share.share("This is text",subject: "This is subject");
      }
      else {
        await WcFlutterShare.share(
            sharePopupTitle: 'SPAID',
            /*subject: 'This is subject',
            text: 'This is text',*/
            fileName: 'share.png',
            mimeType: 'image/png',
            bytesOfFile: image);
      }
    } catch (e) {
      print('error: $e');
    }
  }
}
