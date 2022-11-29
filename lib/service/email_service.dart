import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/email_request/send_email_request.dart';
import 'package:spaid/model/request/game_event_request/game_player_notification_request.dart';
import 'package:spaid/model/request/game_event_request/update_player_availablity_request.dart';
import 'package:spaid/model/response/game_event_response/player_availability_request.dart';
import 'package:spaid/model/response/game_event_response/player_availability_response.dart';
import 'package:spaid/model/response/game_event_response/player_email_list_response.dart';
import 'package:spaid/model/response/signup_response/player_mail_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/model/update_volunteer_availablity.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/service/send_push_notification_service.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/email_template.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/shared_pref_manager.dart';

class EmailService {
  init(String subject, String title, String messages, String toMail,
      int notificationId) async {
    try {
      List<String> to = [toMail];
      // List<String> to=["${await SharedPrefManager.instance.getStringAsync(Constants.userId)}"];
      //List<String> to=["marlenfranto0716@gmail.com","cyril.rocking@yahoo.in","sivabala@ciglobalsolutions.com","CITestMail@ciglobalsolutions.com"];
      SendNormalEmailRequest _sendEmail = SendNormalEmailRequest();
      _sendEmail.to = to;
      _sendEmail.title = title;
      _sendEmail.subject = subject;
      _sendEmail.notificationTypeID = notificationId.toString();
      _sendEmail.resetPassword = messages;

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverEmailUrl + Endpoints.sendMail, data: _sendEmail)
          .then((response) => print(response))
          .catchError((onError) {
        //listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      //listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
    /* if(!kIsWeb) {
      print(messages);
     */ /* final username = 'master.spaid.app@gmail.com';
      final password = '9vXsh5gPOS6LE8tJ';
      final smtpServer = SmtpServer(
        'smtp-relay.sendinblue.com',
        port: 587,
        username: username,
        password: password,
      );*/ /*
       String username = "master.spaid.app@gmail.com";
    String password = r"AdminSpaid$32";


    final smtpServer = gmail(username, password);
      // Use the SmtpServer class to configure an SMTP server:
      // final smtpServer = SmtpServer('smtp.domain.com');
      // See the named arguments of SmtpServer for further configuration
      // options.

      // Create our message.
      final message = b.Message()
        ..from = b.Address(username, title)
        ..recipients.add('marlenfranto0716@gmail.com')
      //..recipients.add(_signUpProvider.emailController.text)
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      //..bccRecipients.add(Address('bccAddress@example.com'))
      // ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
        ..subject = 'SPAID Team'
      //..text = 'This is the plain text.\nThis is line 2 of the text part.'
        ..html = messages;

      try {
        final sendReport = await b.send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on b.MailerException catch (e) {
        print('Message not sent.');
        print(e);
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    }*/
  }

  initWelcome(String subject, String title, String playerName, String signin,
      String toMail, int notificationId) async {
    try {
      List<String> to = [toMail];
      // List<String> to=["${await SharedPrefManager.instance.getStringAsync(Constants.userId)}"];
      //List<String> to=["marlenfranto0716@gmail.com","cyril.rocking@yahoo.in","sivabala@ciglobalsolutions.com","CITestMail@ciglobalsolutions.com"];
      SendNormalEmailRequest _sendEmail = SendNormalEmailRequest();
      _sendEmail.to = to;
      _sendEmail.title = title;
      _sendEmail.subject = subject;
      _sendEmail.notificationTypeID = notificationId.toString();
      _sendEmail.playerName = playerName;
      _sendEmail.signin = signin;

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverEmailUrl + Endpoints.sendMail, data: _sendEmail)
          .then((response) => print(response))
          .catchError((onError) {
        //listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      //listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }
  void updateVolunteerAvalAsync(String eventVolunteerTypeId, String volunteerTypeId, String volunteer, String refer, String userid, String status, ) async{
    UpdateVolunteerAvailability _updatePlayerRequest = UpdateVolunteerAvailability();
    _updatePlayerRequest.eventId=refer;
    _updatePlayerRequest.userId=userid;
    _updatePlayerRequest.availabilityStatusId=status;
    _updatePlayerRequest.volunteerTypeId=volunteerTypeId;
    _updatePlayerRequest.eventVoluenteerTypeIDNo=eventVolunteerTypeId;
    _updatePlayerRequest.volunteerTypeName=volunteer;



    try {
      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.updateVolunteerStatus, data: _updatePlayerRequest)
          .then((response) => print(response))
          .catchError((onError) {
        // listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      // listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void updatePlayerAvalAsync(
      String status, String refer, String userid, String note) async {
    print("Marlen Franto" + note);
    UpdatePlayerAvailability _updatePlayerRequest = UpdatePlayerAvailability();
    _updatePlayerRequest.referenceTableId = int.parse(refer);
    _updatePlayerRequest.userId = int.parse(userid);
    _updatePlayerRequest.availabilityStatusId = int.parse(status);
    _updatePlayerRequest.notificationTypeId = 5;
    _updatePlayerRequest.notes = note;
    _updatePlayerRequest.isDeleted = 1;

    try {
      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl + Endpoints.updatePlayerAvailability,
              data: _updatePlayerRequest)
          .then((response) => print(response))
          .catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }

  createAccountAsync(String userID, String teamID, String emailID, int status,
      bool updatePassword, int userRoleID) async {
    PlayerMailResponse _playerMailRequest = PlayerMailResponse();
    _playerMailRequest.teamId = int.parse(teamID);
    _playerMailRequest.userId = userID.isNotEmpty
        ? int.parse(userID)
        : int.parse(
            "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
    _playerMailRequest.userEmailId = emailID.isNotEmpty
        ? emailID
        : "${await SharedPrefManager.instance.getStringAsync(Constants.userEmail)}";
    _playerMailRequest.playerAvailabilityStatusId = status;
    _playerMailRequest.isUpdatePassword = updatePassword;
    _playerMailRequest.UserRoleID = userRoleID;

    try {
      await ApiManager()
          .getDio()!
          .post(Endpoints.playerRespondRequest, data: _playerMailRequest)
          .then((response) => debugPrint(response.toString()))
          .catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }

  inits(
      String subject,
      String title,
      int notificationid,
      int sendid,
      int recipientid,
      int referencetableid,
      String content,
      String emailID,
      String teamName,
      String playerMail,
      String signin,
      String playerName,
      String managerName) async {
    try {
      //List<String> to=["marlenfranto0716@gmail.com"];
      //List<String> to=["marlenfranto0716@gmail.com","cyril.rocking@yahoo.in","sivabala@ciglobalsolutions.com","CITestMail@ciglobalsolutions.com"];
      SendEmailRequest _sendEmail = SendEmailRequest();
      _sendEmail.to = emailID.isNotEmpty
          ? emailID
          : "${await SharedPrefManager.instance.getStringAsync(Constants.userId)}";
      _sendEmail.title = title;
      _sendEmail.subject = subject;
      _sendEmail.notificationTypeID = notificationid;
      _sendEmail.senderId = sendid;
      _sendEmail.recipientId = recipientid;
      _sendEmail.referenceTableId = referencetableid;
      _sendEmail.contentText = content;
      _sendEmail.teamName = teamName;
      _sendEmail.playerMail = playerMail;
      _sendEmail.signin = signin;
      _sendEmail.playerName = playerName;
      _sendEmail.managerName = managerName;

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverUrl + Endpoints.addTeamNotification,
              data: _sendEmail)
          .then((response) => print(response))
          .catchError((onError) {
        print(onError);
        //listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      print(e);
      //listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  updateStatus(
      String subject,
      String title,
      String messages,
      int notificationid,
      int sendid,
      int recipientid,
      int referencetableid,
      String content) async {
    try {
      //List<String> to=["marlenfranto0716@gmail.com"];
      //List<String> to=["marlenfranto0716@gmail.com","cyril.rocking@yahoo.in","sivabala@ciglobalsolutions.com","CITestMail@ciglobalsolutions.com"];
      SendEmailRequest _sendEmail = SendEmailRequest();
      _sendEmail.to = "";
      _sendEmail.title = title;
      _sendEmail.subject = subject;
      // _sendEmail.body = messages;
      _sendEmail.notificationTypeID = notificationid;
      _sendEmail.senderId = sendid;
      _sendEmail.recipientId = recipientid;
      _sendEmail.referenceTableId = referencetableid;
      _sendEmail.contentText = content;

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl + Endpoints.createEventNotification,
              data: _sendEmail)
          .then((response) => print(response))
          .catchError((onError) {
        print(onError);
        //listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      print(e);
      //listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  invitePlayer(
      String subject,
      String title,
      int notificationid,
      int sendid,
      int recipientid,
      int referencetableid,
      String content,
      String email,
      String playerName,
      String accept,
      String decline,
      String teamName,
      String managerName) async {
    try {
      //List<String> to=["marlenfranto0716@gmail.com"];
      //List<String> to=["marlenfranto0716@gmail.com","cyril.rocking@yahoo.in","sivabala@ciglobalsolutions.com","CITestMail@ciglobalsolutions.com"];
      SendEmailRequest _sendEmail = SendEmailRequest();
      // _sendEmail.to ="marlenfranto0716@gmail.com";
      _sendEmail.to = email;
      _sendEmail.title = title;
      _sendEmail.subject = subject;
      // _sendEmail.body = messages;
      _sendEmail.notificationTypeID = notificationid;
      _sendEmail.senderId = sendid;
      _sendEmail.recipientId = recipientid;
      _sendEmail.referenceTableId = referencetableid;
      _sendEmail.contentText = content;
      _sendEmail.playerName = playerName;
      _sendEmail.acceptLink = accept;
      _sendEmail.declineLink = decline;
      _sendEmail.teamName = teamName;
      _sendEmail.managerName = managerName;

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverUrl + Endpoints.addTeamNotification,
              data: _sendEmail)
          .then((response) => print(response))
          .catchError((onError) {
        print(onError);
        //listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      print(e);
      //listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  createEventNotification(
    String subject,
    String title,
    int notificationid,
    int sendid,
    int recipientid,
    int referencetableid,
    String content,
    String email,
    String coachName,
    String gameTitle,
    String acceptLink,
    String maybeLink,
    String declineLink,
    String address,
    String date,
    String time,
    String signin,
    String gameId,
      String playerName,
      String teamName,
      String volunteer,
      bool isNotesRequired,
  ) async {
    try {
      //List<String> to=["marlenfranto0716@gmail.com"];
      // List<String> to=["marlenfranto0716@gmail.com","cyril.rocking@yahoo.in","sivabala@ciglobalsolutions.com","CITestMail@ciglobalsolutions.com"];
      SendEmailRequest _sendEmail = SendEmailRequest();
      _sendEmail.to = email;
      _sendEmail.title = title;
      _sendEmail.subject = subject;
      // _sendEmail.body = messages;
      _sendEmail.notificationTypeID = notificationid;
      _sendEmail.senderId = sendid;
      _sendEmail.recipientId = recipientid;
      _sendEmail.referenceTableId = referencetableid;
      _sendEmail.contentText = content;
      _sendEmail.coachName = coachName;
      _sendEmail.gameTitle = gameTitle;
      _sendEmail.acceptLink = acceptLink;
      _sendEmail.maybeLink = maybeLink;
      _sendEmail.declineLink = declineLink;
      _sendEmail.address = address;
      _sendEmail.date = date;
      _sendEmail.time = time;
      _sendEmail.signin = signin;
      _sendEmail.playerName = playerName;
      _sendEmail.managerName = coachName;
      _sendEmail.teamName = teamName;
      _sendEmail.volunteer = volunteer;
      _sendEmail.gameNo = gameId;
      _sendEmail.isNotesRequired = isNotesRequired? 1 : 0;

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl + Endpoints.createEventNotification,
              data: _sendEmail)
          .then((response) => print(response))
          .catchError((onError) {
        print(onError);
        //listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      print(e);
      //listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  sendSpecificNotificationMail(
      String subject,
      String title,
      int notificationid,
      int recipientid,
      int referencetableid,
      String content,
      String email,
      String coachName,
      String gameTitle,
      String acceptLink,
      String maybeLink,
      String declineLink,
      String address,
      String date,
      String time,
      String signin,
      String gameId,
      String playerName,
      String teamName,
      String volunteer,
      String toID,
      ) async {
    try {
      //List<String> to=["marlenfranto0716@gmail.com"];
      // List<String> to=["marlenfranto0716@gmail.com","cyril.rocking@yahoo.in","sivabala@ciglobalsolutions.com","CITestMail@ciglobalsolutions.com"];
      SendEmailRequest _sendEmail = SendEmailRequest();
      _sendEmail.to = email;
      _sendEmail.title = title;
      _sendEmail.subject = subject;
      // _sendEmail.body = messages;
       _sendEmail.notificationTypeID = notificationid;
      _sendEmail.senderId =toID.isNotEmpty?int.parse(toID): int.parse(
          "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
      _sendEmail.recipientId = recipientid;
      _sendEmail.referenceTableId = referencetableid;
      _sendEmail.contentText = content;
      _sendEmail.coachName = coachName;
      _sendEmail.gameTitle = gameTitle;
      _sendEmail.acceptLink = acceptLink;
      _sendEmail.maybeLink = maybeLink;
      _sendEmail.declineLink = declineLink;
      _sendEmail.address = address;
      _sendEmail.date = date;
      _sendEmail.time = time;
      _sendEmail.signin = signin;
      _sendEmail.playerName = playerName;
      _sendEmail.managerName = coachName;
      _sendEmail.teamName = teamName;
      _sendEmail.volunteer = volunteer;

      await ApiManager()
          .getDio()!
          .post(
              Endpoints.serverGameUrl + Endpoints.sendSpecificNotificationMail,
              data: _sendEmail)
          .then((response) => print(response))
          .catchError((onError) {
        print(onError);
        //listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      print(e);
      //listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  reSendVolunteerNotificationMail(
      String subject,
      String title,
      int notificationid,
      int recipientid,
      int referencetableid,
      String content,
      String email,
      String coachName,
      String gameTitle,
      String acceptLink,
      String maybeLink,
      String declineLink,
      String address,
      String date,
      String time,
      String signin,
      String gameId,
      String playerName,
      String teamName,
      String volunteer,
      String toID, int eventVolunteerTypeIDNo,
      ) async {
    try {
      //List<String> to=["marlenfranto0716@gmail.com"];
      // List<String> to=["marlenfranto0716@gmail.com","cyril.rocking@yahoo.in","sivabala@ciglobalsolutions.com","CITestMail@ciglobalsolutions.com"];
      NotificationMailList _sendEmail = NotificationMailList();
      _sendEmail.to = email;
      _sendEmail.title = title;
      _sendEmail.subject = subject;
      // _sendEmail.body = messages;
      _sendEmail.notificationTypeID = notificationid;
      _sendEmail.senderId =toID.isNotEmpty?int.parse(toID): int.parse(
          "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
      _sendEmail.recipientId = recipientid;
      _sendEmail.referenceTableId = referencetableid;
      _sendEmail.contentText = content;
      _sendEmail.coachName = coachName;
      _sendEmail.gameTitle = gameTitle;
      _sendEmail.acceptLink = acceptLink;
      _sendEmail.maybeLink = maybeLink;
      _sendEmail.declineLink = declineLink;
      _sendEmail.address = address;
      _sendEmail.date = date;
      _sendEmail.time = time;
      _sendEmail.signin = signin;
      _sendEmail.playerName = playerName;
      _sendEmail.managerName = coachName;
      _sendEmail.teamName = teamName;
      _sendEmail.volunteer = volunteer;
      _sendEmail.playerMail = email;
      _sendEmail.eventId = referencetableid.toString();
      _sendEmail.volunteerTypeName = volunteer;
      // _sendEmail.volunteerTypeId = email;
      _sendEmail.eventVoluenteerTypeIDNo = eventVolunteerTypeIDNo.toString();

      await ApiManager()
          .getDio()!
          .post(
          Endpoints.serverGameUrl + Endpoints.resendVolunteerInvite,
          data: _sendEmail)
          .then((response) => print(response))
          .catchError((onError) {
        print(onError);
        //listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      print(e);
      //listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }


  sendSpecificNotificationForMail(
      String subject,
      String title,
      String messages,
      int notificationid,
      int recipientid,
      int referencetableid,
      String content,
      String email,
      String userid) async {
    try {
      //List<String> to=["marlenfranto0716@gmail.com"];
      // List<String> to=["marlenfranto0716@gmail.com","cyril.rocking@yahoo.in","sivabala@ciglobalsolutions.com","CITestMail@ciglobalsolutions.com"];
      SendEmailRequest _sendEmail = SendEmailRequest();
      _sendEmail.to = email;
      _sendEmail.title = title;
      _sendEmail.subject = subject;
      // _sendEmail.body = messages;
      _sendEmail.notificationTypeID=notificationid;
      _sendEmail.senderId = userid.isNotEmpty
          ? int.parse(userid)
          : int.parse(
              "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
      _sendEmail.recipientId = recipientid;
      _sendEmail.referenceTableId = referencetableid;
      _sendEmail.contentText = content;

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl + Endpoints.createEventNotification,
              data: _sendEmail)
          .then((response) => print(response))
          .catchError((onError) {
        print(onError);
        //listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      print(e);
      //listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }
  //
  // Future nonplayerEventNotification(
  //     String subject,
  //     String title,
  //     int notificationID,
  //     int sendID,
  //     int referencetableID,
  //     String content,
  //     List<UserMailList> playerMailList,
  //     List<String> message) async {
  //   try {
  //     List<NotificationMailList> notificationMailLists = [];
  //     //List<String> to=["marlenfranto0716@gmail.com"];
  //     //List<String> to=["marlenfranto0716@gmail.com","cyril.rocking@yahoo.in","sivabala@ciglobalsolutions.com","CITestMail@ciglobalsolutions.com"];
  //     EventPlayerNotificationRequest _sendEmail =
  //         EventPlayerNotificationRequest();
  //     _sendEmail.eventId = referencetableID;
  //     for (int i = 0; i < playerMailList.length; i++) {
  //       NotificationMailList notificationMailList = new NotificationMailList();
  //       notificationMailList.notificationTypeId = notificationID;
  //       notificationMailList.senderId = sendID;
  //       notificationMailList.recipientId = playerMailList[i].userIDNo;
  //       notificationMailList.referenceTableId = referencetableID;
  //       notificationMailList.contentText = content;
  //       notificationMailList.to = playerMailList[i].email;
  //       notificationMailList.title = title;
  //       notificationMailList.subject = subject;
  //       notificationMailList.body = message[i];
  //       notificationMailLists.add(notificationMailList);
  //     }
  //     _sendEmail.notificationMailList = notificationMailLists;
  //
  //     await ApiManager()
  //         .getDio()
  //         .post(Endpoints.serverGameUrl + Endpoints.sendEventNotificationMail,
  //             data: _sendEmail)
  //         .then((response) => print("Non Player" + response.toString()))
  //         .catchError((onError) {
  //       print(onError);
  //
  //       //listener.onFailure(DioErrorUtil.handleErrors(onError));
  //     });
  //   } catch (e) {
  //     print(e);
  //     //listener.onFailure(ExceptionErrorUtil.handleErrors(e));
  //   }
  // }

  void updateEventNotification(
      String subject,
      String title,
      int notificationID,
      int referencetableID,
      String content,
      List<UserMailList> playerMailList,
      String body) async {
    try {
      // List<NotificationMailList> notificationMailLists = [];
      // //List<String> to=["marlenfranto0716@gmail.com"];
      // //List<String> to=["marlenfranto0716@gmail.com","cyril.rocking@yahoo.in","sivabala@ciglobalsolutions.com","CITestMail@ciglobalsolutions.com"];
      // EventPlayerNotificationRequest _sendEmail =
      //     EventPlayerNotificationRequest();
      // _sendEmail.eventId = referencetableID;
      // for (int i = 0; i < playerMailList.length; i++) {
      //   if (playerMailList[i].FCMTokenID != null &&
      //       playerMailList[i].FCMTokenID.isNotEmpty) {
      //     SendPushNotificationService().sendPushNotifications(
      //         playerMailList[i].FCMTokenID, subject, content);
      //   }
      //   NotificationMailList notificationMailList = new NotificationMailList();
      //   notificationMailList.notificationTypeId = notificationID;
      //   notificationMailList.senderId = int.parse(
      //       "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
      //   notificationMailList.recipientId = playerMailList[i].userIDNo;
      //   notificationMailList.referenceTableId = referencetableID;
      //   notificationMailList.contentText = content;
      //   notificationMailList.to = playerMailList[i].email;
      //   notificationMailList.title = title;
      //   notificationMailList.subject = subject;
      //   notificationMailList.body = body;
      //   notificationMailLists.add(notificationMailList);
      // }
      // _sendEmail.notificationMailList = notificationMailLists;
      //
      // await ApiManager()
      //     .getDio()
      //     .post(Endpoints.serverGameUrl + Endpoints.updateEventNotificationMail,
      //         data: _sendEmail)
      //     .then((response) => print("update game" + response.toString()))
      //     .catchError((onError) {
      //   print(onError);
      //
      //   //listener.onFailure(DioErrorUtil.handleErrors(onError));
      // });
    } catch (e) {
      print(e);
      //listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }


  void updatePlayerAvalStatusAsync(int eventId, List<AvailablePlayerList> availablePlayerList) async {
    UpdatePlayerSelectionRequest _updatePlayerRequest = UpdatePlayerSelectionRequest();
    List<String> userIds=[];
    _updatePlayerRequest.eventId=eventId.toString();
    for(int i=0;i<availablePlayerList.length;i++){
      if(availablePlayerList[i].playerSelectionStatus!){
        userIds.add(availablePlayerList[i].userId.toString());
      }
    }
    _updatePlayerRequest.userId=userIds;

    try {
      await ApiManager()
          .getDio()!
          .post(Endpoints.serverTimeKeeperConsoleUrl + Endpoints.updatePlayerSelection,
          data: _updatePlayerRequest)
          .then((response) => {
      CodeSnippet.instance.showMsg("Updated Successfully"),

      })
          .catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }
}
