import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Glob {
  //One instance, needs factory
  static Glob _instance;
  factory Glob() => _instance ??= new Glob._();
  Glob._();
  //

  InAppWebViewController account;

  InAppWebViewController getServerUrl() {
    return account;
  }
}
