import 'package:cloud_firestore/cloud_firestore.dart';

class Ngo {

  String? ngoId;
  String? ngoName;
  String ngoMail;
  String? ngoPhone;
  String? ngoAdd;
  String? ngoImg;
  String ngoPassword;
  GeoPoint? ngoLoc;

  Ngo({
    required this.ngoId,
    required this.ngoName,
    required this.ngoMail,
    required this.ngoPhone,
    required this.ngoAdd,
    this.ngoImg,
    required this.ngoPassword,
    required this.ngoLoc,
  });

  Ngo.log({
    required this.ngoMail,
    required this.ngoPassword,
  });
  
  // Factory constructor to create an instance from JSON
  factory Ngo.fromJson(Map<String, dynamic> json) {
    return Ngo(
      ngoId: json['ngoId'] ?? "",
      ngoName: json['ngoName'] ?? "",
      ngoMail: json['ngoMail'] ?? "",
      ngoPhone: json['ngoPhone'] ?? "",
      ngoAdd: json['ngoAdd'] ?? "",
      ngoImg: json['ngoImg'] ?? "",
      ngoPassword: json['ngoPassword'] ?? "",

      // ✅ Fix: Use `GeoPoint` directly if it's already a `GeoPoint`
      ngoLoc: json['ngoLoc'] is GeoPoint
          ? json['ngoLoc']
          : GeoPoint(json['ngoLoc']['latitude'], json['ngoLoc']['longitude']),
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'ngoId': ngoId,
      'ngoName': ngoName,
      'ngoMail': ngoMail,
      'ngoPhone': ngoPhone,
      'ngoAdd': ngoAdd,
      'ngoImg': ngoImg,
      'ngoPassword': ngoPassword,

      // ✅ No need to convert GeoPoint manually, Firestore supports it
      'ngoLoc': ngoLoc,
    };
  }
}
