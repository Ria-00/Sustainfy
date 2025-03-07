import 'package:cloud_firestore/cloud_firestore.dart';

class Ngo {
  final String ngoId;
  final String ngoName;
  final String ngoMail;
  final String ngoPhone;
  final String ngoAdd;
  final String ngoPassword;
  final GeoPoint ngoLoc;

  Ngo({
    required this.ngoId,
    required this.ngoName,
    required this.ngoMail,
    required this.ngoPhone,
    required this.ngoAdd,
    required this.ngoPassword,
    required this.ngoLoc,
  });

  // Factory constructor to create an instance from JSON
  factory Ngo.fromJson(Map<String, dynamic> json) {
    return Ngo(
      ngoId: json['ngoId'] ?? "",
      ngoName: json['ngoName'] ?? "",
      ngoMail: json['ngoMail'] ?? "",
      ngoPhone: json['ngoPhone'] ?? "",
      ngoAdd: json['ngoAdd'] ?? "",
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
      'ngoPassword': ngoPassword,

      // ✅ No need to convert GeoPoint manually, Firestore supports it
      'ngoLoc': ngoLoc,
    };
  }
}
