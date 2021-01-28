import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier {
  String token;
  DateTime expiryDate;
  String userId;

  Auth({
    @required this.token,
    @required this.expiryDate,
  });
}
