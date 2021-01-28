import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  final apiKey = 'AIzaSyCPyT8APmxR2SExNm70qRRsLpJSupq5HvY';
  final signUpUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=';
  final signInUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=';

  String _token;
  DateTime _expiryDate;
  String _userId;

  Timer _autoLogoutTimer;

  String get token {
    print(_token);
    print(_expiryDate);
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    final response = await http.post(
      signUpUrl + apiKey,
      body: convert.jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
    if (json['idToken'] != null || json['error'] == null) {
      _token = json['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(json['expiresIn']),
        ),
      );
      _userId = json['localId'];
      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = convert.jsonEncode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);

      return json;
    }
    throw HttpException('Something went wrong!!');
  }

  Future<Map<String, dynamic>> signin(String email, String password) async {
    final response = await http.post(
      signInUrl + apiKey,
      body: convert.jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
    if (json['idToken'] != null || json['error'] == null) {
      _token = json['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(json['expiresIn']),
        ),
      );
      _userId = json['localId'];
      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = convert.jsonEncode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);

      return json;
    }
    throw HttpException('Incorrect username or password');
  }

  void _autoLogout() {
    if (_autoLogoutTimer != null) {
      _autoLogoutTimer.cancel();
    }
    final expiryTime = _expiryDate.difference(DateTime.now()).inSeconds;
    _autoLogoutTimer = Timer(Duration(seconds: expiryTime), logout);
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userData =
        convert.jsonDecode(prefs.getString('userData')) as Map<String, Object>;
    if (userData == null) {
      print('pref null');
      return false;
    }

    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = DateTime.parse(userData['expiryDate']);

    if (_expiryDate.isBefore(DateTime.now())) {
      print('expired token');
      return false;
    }
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_autoLogoutTimer != null) {
      _autoLogoutTimer.cancel();
      _autoLogoutTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
