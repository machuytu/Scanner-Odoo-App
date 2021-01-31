import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:odooscanner/models/gobal.dart';

import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:odooscanner/res/string.dart';
import 'package:overlay_support/overlay_support.dart';

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

  void retrieveMessage() async {
    // if (Platform.isIOS) iosPermission();
    iosPermission();

    await _firebaseMessaging.setAutoInitEnabled(true);

    print('token: ${await _firebaseMessaging.getToken()}');

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        Get.dialog(
          AlertDialog(
            title: Text("${message['notification']['title']}"),
            content: Text("${message['notification']['body']}"),
            actions: <Widget>[
              FlatButton(
                child: Text("Go to order"),
                onPressed: () {
                  Get.back();
                  Glob().getServerUrl().loadUrl(
                      url:
                          'http://103.142.139.193:8069/web#id=${message['data']['so_id']}&action=291&model=sale.order&view_type=form&cids=1&menu_id=170');
                },
              ),
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
          barrierDismissible: false,
        );
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        Glob().getServerUrl().loadUrl(
            url:
                'http://103.142.139.193:8069/web#id=${message['data']['so_id']}&action=291&model=sale.order&view_type=form&cids=1&menu_id=170');
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
        Glob().getServerUrl().loadUrl(
            url:
                'http://103.142.139.193:8069/web#id=${message['data']['so_id']}&action=291&model=sale.order&view_type=form&cids=1&menu_id=170');
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
