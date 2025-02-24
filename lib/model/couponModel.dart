import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  String couponId;
  String couponDesc;
  int couponPoint;
  int totalClaims;
  DocumentReference compRef;
  Timestamp couponStart;
  Timestamp couponExp;

  CouponModel({
    required this.couponId,
    required this.couponDesc,
    required this.couponPoint,
    required this.totalClaims,
    required this.compRef,
    required this.couponStart,
    required this.couponExp,
  });

  // Convert Firestore document to CouponModel
  factory CouponModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CouponModel(
      couponId: data["couponId"] ?? "",
      couponDesc: data["couponDesc"] ?? "",
      couponPoint: data["couponPoint"] ?? 0,
      totalClaims: data["totalClaims"] ?? 0,
      compRef: data["compRef"],
      couponStart: data["couponStart"],
      couponExp: data["couponExp"],
    );
  }

  // Convert CouponModel to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      "couponId": couponId,
      "couponDesc": couponDesc,
      "couponPoint": couponPoint,
      "totalClaims": totalClaims,
      "compRef": compRef,
      "couponStart": couponStart,
      "couponExp": couponExp,
    };
  }
}
