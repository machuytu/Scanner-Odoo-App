import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:odooscanner/res/string.dart';
import 'package:overlay_support/overlay_support.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

class RestDataSourcePushNotify {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static const BASE_URL = "https://fcm.googleapis.com/fcm/send";
  final String serverToken = StringName.serverToken;
  static const to = StringName.roomToken;
  static const toDivice = StringName.previousDeviceToken;

  Future<String> pushNotify(String hello) async {
    iosPermission();
    final http.Response response = await http.post(
      BASE_URL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(<String, dynamic>{
        "to": to,
        'priority': StringName.highPriority,
        "data": {
          "notification": {
            'message': 'Đăng nhập',
            // 'token': await _firebaseMessaging.getToken(),
            'id': await _firebaseMessaging.getToken(),
            'data': hello
          }
        },
      }),
    );

    if (response.statusCode == 200) {
      String temp = response.body;
      return temp;
    } else {
      throw Exception('Failed to call json');
    }
  }

  void retrieveMessage() {
    if (Platform.isIOS) iosPermission();

    _firebaseMessaging.getToken().then((token) {
      print('token: $token');
    });

    _firebaseMessaging.configure(
      // onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        showSimpleNotification(
          Text(
            '${message['notification']['title']}',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 10),
          slideDismiss: true,
          background: Colors.black,
        );
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        // await Future.delayed(Duration(minutes: 1));
        showSimpleNotification(
          Text(
            "this is a message from on resume notification",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 10),
          slideDismiss: true,
          background: Colors.black.withOpacity(0.3),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        // await Future.delayed(Duration(minutes: 1));
        showSimpleNotification(
          Text("this is a message from on launch notification"),
          duration: Duration(seconds: 10),
          slideDismiss: true,
          background: Colors.black.withOpacity(0.3),
        );
      },
    );
  }

  void iosPermission() async {
    await _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
