import 'package:flutter/material.dart';
import 'package:sustainfy/model/couponModel.dart';
import 'package:sustainfy/model/eventModel.dart';

class userProvider extends ChangeNotifier {
  String? _email;
  int? points;
  List<CouponModel>? coupons;

  String? get email => _email;
  int? get userPoints => points;
  List<CouponModel>? get userCoupons => coupons;

  List<EventModel> _events = [];

  void addAttendedEvent() {}

  void setValue(String uemail) {
    _email = uemail;
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
