import 'package:flutter/material.dart';

class userProvider extends ChangeNotifier {
  String? _email;

  String? get email => _email;
  
  void setValue(String uemail) {
    _email=uemail;
    notifyListeners();
  }

  void removeValue() {
    _email = null;
    notifyListeners();
  }
}
