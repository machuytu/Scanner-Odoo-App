import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:odooscanner/models/sale_order_id.dart';
import 'package:odooscanner/models/user.dart';
import 'package:odooscanner/res/domain.dart';

class Data {
  Future<User> login(String username, String password) async {
    final http.Response response = await http.post(
      Domain.login + 'login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      User _user;
      _user = User.fromJson(json.decode(response.body));
      return _user;
    } else {
      print('lỗi');
    }
  }

  Future<SaleOrderId> getOrder(String partnerId) async {
    final http.Response response = await http.get(
      Domain.login + 'sale-order/$partnerId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      SaleOrderId saleOrderId = new SaleOrderId();
      saleOrderId = SaleOrderId.fromJson(json.decode(response.body));
      return saleOrderId;
    } else {
      print('lỗi');
    }
  }

  Future<bool> sendPartnerId(String partnerId) async {
    int partnerIdInt = int.tryParse(partnerId);
    final http.Response response = await http.post(
      Domain.login + 'fcm',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        "partner_id": partnerIdInt,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
