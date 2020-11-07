import 'package:firebase_messaging/firebase_messaging.dart';

import 'base_bloc.dart';
import 'dart:async';

class LocationBloc implements Bloc {
  List<FirebaseMessaging> _listOrder = List<FirebaseMessaging>();
  List<FirebaseMessaging> get selectedFirebaseMessaging => _listOrder;

  // 1
  final _listOrderController = StreamController<List<FirebaseMessaging>>();

  // 2
  Stream<List<FirebaseMessaging>> get firebaseMessagingStream =>
      _listOrderController.stream;

  // 3
  void selectFirebaseMessaging(List<FirebaseMessaging> listOrder) {
    _listOrder = listOrder;
    _listOrderController.sink.add(listOrder);
  }

  // 4
  @override
  void dispose() {
    _listOrderController.close();
  }
}
