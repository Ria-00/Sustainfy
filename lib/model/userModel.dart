import 'package:cloud_firestore/cloud_firestore.dart';

class UserClass {
  String? userName;
  String? userMail;
  String? userPassword;
  String? userPhone;
  String? userImg;
  int? userPoints;
  int? totalPoints;
  List<dynamic>? claimedCoupons; // List of claimed coupon IDs
  List<dynamic>? userWishlist; // List of wished items
  int? csHours; // Community service hours
  DocumentReference? orgRef; // Reference to the NGO
  

   UserClass({
    required this.userMail,
    this.userPassword,
    this.userName,
    this.userPhone,
    this.userImg,
    this.userPoints = 0,
    this.totalPoints = 0,
    this.claimedCoupons = const [],
    this.userWishlist = const [],
    this.csHours = 0,
    DocumentReference? orgRef,
  }) : orgRef = orgRef ?? FirebaseFirestore.instance.doc('organizations/none'); // Default to placeholder if not provided


    UserClass.register({
    required this.userName,
    required this.userMail,
    required this.userPassword,
    required this.userPhone
  });

  UserClass.withPhoto({
    required this.userName,
    required this.userImg
  });

  /// Converts the object to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "userMail": userMail,
      "userPassword": userPassword,
      "userPhone": userPhone,
      "userImg": userImg,
      "userPoints": userPoints,
      "totalPoints": totalPoints,
      "claimedCoupons": claimedCoupons,
      "userWishlist": userWishlist,
      "csHours": csHours,
      "orgRef": orgRef,
    };
  }

  /// Factory constructor to create a UserClass object from Firestore data
  factory UserClass.fromMap(Map<String, dynamic> map) {
    return UserClass(
      userName: map["userName"],
      userMail: map["userMail"],
      userPassword: map["userPassword"],
      userPhone: map["userPhone"],
      userImg: map["userImg"],
      userPoints: map["userPoints"] ?? 0,
      totalPoints: map["totalPoints"] ?? 0,
      claimedCoupons: List<dynamic>.from(map["claimedCoupons"] ?? []),
      userWishlist: List<dynamic>.from(map["userWishlist"] ?? []),
      csHours: map["csHours"] ?? 0,
      orgRef: map["orgRef"] ?? FirebaseFirestore.instance.doc('organizations/none'), // Use default if not present
    );
  }

  /// Getters and Setters
  String? get getUserMail => userMail;
  set setUserMail(String? mail) => userMail = mail;

  String? get getUserPassword => userPassword;
  set setUserPassword(String? pass) => userPassword = pass;

  int get getUserPoints => userPoints!;
  set setUserPoints(int points) => userPoints = points;

  int get getTotalPoints => totalPoints!;
  set setTotalPoints(int points) => totalPoints = points;
}
