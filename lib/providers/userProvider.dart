import 'package:flutter/material.dart';
import 'package:sustainfy/model/couponModel.dart';

class userProvider extends ChangeNotifier {
  String? _email;
  String? _password;
  int? points;
  List<CouponModel>? coupons;

  String? get email => _email;
  String? get password => _password;
  int? get userPoints => points;
  List<CouponModel>? get userCoupons => coupons;
  
  void setValue(String uemail) {
    _email=uemail;
    notifyListeners();
  }

  void setPass(String password) {
    _password = password;
    notifyListeners();
  }

  void setPoints(int upoints) {
    points = upoints;
    notifyListeners();
  }

  void setCoupon(List<CouponModel> ucoupons) {
    coupons = ucoupons;
    notifyListeners();
  }

  void removeValue() {
    _email = null;
    points = 0;
    coupons = null;
    notifyListeners();
  }
}
