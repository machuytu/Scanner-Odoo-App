import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:odooscanner/res/domain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:odooscanner/models/gobal.dart';

import 'api/res_data.dart';
import 'main.dart';

import 'models/user.dart';

class InAppWebViewExampleScreen extends StatefulWidget {
  @override
  _InAppWebViewExampleScreenState createState() =>
      new _InAppWebViewExampleScreenState();
}

class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {
  Glob glob = new Glob();
  InAppWebViewController webview;
  ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  bool _scanning = false;

  FlutterScanBluetooth _bluetooth = FlutterScanBluetooth();
  String username, password, partnerIdshare;
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  String _data;

  bool isTrue = false;

  String partnerId;

  var html3;

  @override
  void initState() {
    super.initState();
    // In webview
    callShare();

    // Bluetooth scanner
    _bluetooth.devices.listen((device) async {
      if (device.address == 'DC:53:60:86:1E:A5') {
        print('Tim thay1');
        Data data = new Data();

        await data.sendPartnerId(partnerId).then((value1) async {
          if (value1 == true) {
            print('gui thanh cong');
          } else {
            print('gui that bai');
          }
        });
        print('Tim thay');
        _scanning = true;
        _bluetooth.stopScan();
      } else {
        _scanning = false;
      }
    });
    _bluetooth.scanStopped.listen((device) async {
      if (_scanning == false) {
        setState(() {
          _bluetooth.startScan(pairedDevices: false);
          debugPrint("chay lai");
        });
      }
    });
  }

  Future<void> callShare() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('username') != null &&
        prefs.getString('password') != null &&
        prefs.getString('partnerId') != null) {
      username = prefs.getString('username');
      password = prefs.getString('password');
      partnerIdshare = prefs.getString('partnerId');
      print('partnerId shared_preferences: ' + partnerIdshare);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: myDrawer(context: context),
      body: SafeArea(
        child: Column(children: <Widget>[
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: InAppWebView(
                initialUrl: Domain.domain,
                initialHeaders: {},
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      debuggingEnabled: true,
                      useShouldOverrideUrlLoading: true,
                    ),
                    android:
                        AndroidInAppWebViewOptions(useHybridComposition: true)),
                onWebViewCreated: (InAppWebViewController controller) {
                  glob.account = controller;
                  print("onWebViewCreated");
                },
                onLoadStart:
                    (InAppWebViewController controller, String url) async {
                  print("onLoadStart $url");
                  if (url == (Domain.domain + 'shop/payment') ||
                      url == (Domain.domain + 'vi/shop/payment') ||
                      url == (Domain.domain + 'en/shop/payment')) {
                    if (partnerId != null) {
                      try {
                        await _bluetooth.startScan(pairedDevices: false);
                        debugPrint("scanning started");
                        setState(() {
                          _scanning = true;
                        });
                      } on PlatformException catch (e) {
                        debugPrint(e.toString());
                      }
                    }

                    // await data.getOrder(partnerId).then((value1) async {
                    //   if (value1 != null) {
                    //     SaleOrderId orderId = value1;
                    //     print("order id: " + orderId.soId.toString());
                    //   }
                    // });
                  } else if (partnerId == null) {
                    if (partnerIdshare != null) {
                      partnerId = partnerIdshare;
                    } else {
                      return;
                    }

                    try {
                      if (_scanning) {
                        await _bluetooth.stopScan();
                        debugPrint("scanning stoped");
                        setState(() {
                          _data = '';
                        });
                      } else {
                        await _bluetooth.startScan(pairedDevices: false);
                        debugPrint("scanning started");
                        setState(() {
                          _scanning = true;
                        });
                      }
                    } on PlatformException catch (e) {
                      debugPrint(e.toString());
                    }
                  }
                  setState(() {
                    this.url = url;
                  });
                },
                shouldOverrideUrlLoading:
                    (controller, shouldOverrideUrlLoadingRequest) async {
                  var url = shouldOverrideUrlLoadingRequest.url;
                  var uri = Uri.parse(url);

                  if (![
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about"
                  ].contains(uri.scheme)) {
                    if (await canLaunch(url)) {
                      // Launch the App
                      await launch(
                        url,
                      );
                      // and cancel the request
                      return ShouldOverrideUrlLoadingAction.CANCEL;
                    }
                  }

                  return ShouldOverrideUrlLoadingAction.ALLOW;
                },
                onLoadStop:
                    (InAppWebViewController controller, String url) async {
                  String html1, html2;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  if (await controller.evaluateJavascript(
                          source: "window.document.getElementById('login');") !=
                      null) {
                    html1 = await controller.evaluateJavascript(
                        source:
                            "window.document.getElementById('login').value;");
                    html2 = await controller.evaluateJavascript(
                        source:
                            "window.document.getElementById('password').value;");
                  }

                  if (await controller.evaluateJavascript(
                          source: "window.phantomVar") !=
                      null) {
                    await prefs.setString('username', null);
                    await prefs.setString('password', null);
                    await prefs.setString('partnerId', null);
                    _firebaseMessaging.unsubscribeFromTopic('admin');
                  }

                  if (await controller.evaluateJavascript(
                          source: "window.phantomVar") !=
                      null) {
                    await prefs.setString('username', null);
                    await prefs.setString('password', null);
                    await prefs.setString('partnerId', null);
                    _firebaseMessaging.unsubscribeFromTopic('admin');
                  }

                  if (url == (Domain.domain + 'web/login') ||
                      url == (Domain.domain + 'vi/web/login') ||
                      url == (Domain.domain + 'en/web/login')) {
                    await prefs.setString('username', null);
                    await prefs.setString('password', null);
                    await prefs.setString('partnerId', null);
                    _firebaseMessaging.unsubscribeFromTopic('admin');
                  }

                  print("onLoadStop $url");
                  if ((html1 != null && html2 != null)) {
                    if (html1 != "" && html2 != "") {
                      await prefs.setString('username', html1);
                      await prefs.setString('password', html2);
                    }
                    Data data = new Data();
                    await data.login(html1, html2).then((value1) async {
                      if (value1 != null) {
                        User user = value1;
                        if (user.id == 2) {
                          _firebaseMessaging.subscribeToTopic('admin');
                        }
                        partnerId = user.partnerId.toString();
                        await prefs.setString('partnerId', partnerId);
                        print('partnerId: ' + partnerId);
                      }
                    });
                  }

                  // await data.getOrder(partnerId).then((value1) async {
                  //   if (value1 != null) {
                  //     SaleOrderId orderId = value1;
                  //     print("order id: " + orderId.soId.toString());

                  //   }
                  // });
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onUpdateVisitedHistory: (InAppWebViewController controller,
                    String url, bool androidIsReload) {
                  print("onUpdateVisitedHistory $url");
                  setState(() {
                    this.url = url;
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
