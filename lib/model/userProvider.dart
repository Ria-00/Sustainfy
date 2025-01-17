import 'package:flutter/material.dart';

class userProvider extends ChangeNotifier {
  String? _email;
  String? _name;

  String? get email => _email;
  String? get name => _name;
  void setValue(String uemail, String uname) {
    _email=uemail;
    _name = uname;
    notifyListeners();
  }

  void removeValue() {
    _email = null;
    _name = null;
    notifyListeners();
  }
}
