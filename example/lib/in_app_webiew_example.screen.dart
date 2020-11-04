import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_inappwebview_example/api/res_data.dart';
import 'package:flutter_inappwebview_example/models/user.dart';
import 'package:flutter_inappwebview_example/res/domain.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class InAppWebViewExampleScreen extends StatefulWidget {
  @override
  _InAppWebViewExampleScreenState createState() =>
      new _InAppWebViewExampleScreenState();
}

class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {
  InAppWebViewController webView;
  ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  bool _scanning = false;
  FlutterScanBluetooth _bluetooth = FlutterScanBluetooth();

  String _data;

  bool isTrue = false;

  @override
  void initState() {
    super.initState();
    // In webview
    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webView.getSelectedText());
                await webView.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: true),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webView.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    // Bluetooth scanner
    _bluetooth.devices.listen((device) {
      setState(() {
        if (device.address == 'DC:53:60:86:1E:A5') {
          print('Tim thay');
          _bluetooth.stopScan();
          _scanning = false;
        }
      });
    });
    _bluetooth.scanStopped.listen((device) async {
      if (_scanning != false) {
        setState(() {
          _bluetooth.startScan(pairedDevices: false);
          debugPrint("chay lai");
          _scanning = true;
        });
      }
    });
  }

  // void bluetoothScanner() {
  //   _bluetooth.devices.listen((device) {
  //     setState(() {
  //       if (device.address == '50:EB:71:DD:E8:47') {
  //         print('Tim thay');

  //         setState(() {
  //           _scanning = false;
  //         });
  //       }
  //     });
  //   });
  //   _bluetooth.scanStopped.listen((device) async {
  //     _bluetooth.startScan(pairedDevices: false);
  //     print('chay tiep nha');
  //     debugPrint("scanning started");
  //     setState(() {
  //       _scanning = false;
  //     });
  //   });
  // }

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
                  webView = controller;
                  print("onWebViewCreated");
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  print("onLoadStart $url");
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

                  print("onLoadStop $url");
                  if ((html1 != null && html2 != null)) {
                    Data data = new Data();
                    await data.login(html1, html2).then((value1) async {
                      if (value1 != null) {
                        User user = value1;
                        isTrue = true;
                        print("user id: " + user.id.toString());
                      }
                    });
                  }
                  if (isTrue == true) {
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
