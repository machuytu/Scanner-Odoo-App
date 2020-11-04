import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
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
}
