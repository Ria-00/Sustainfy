import 'package:cloud_firestore/cloud_firestore.dart';

class UserClass {
  String? userName;
  String? userMail;
  String? userPassword;
  String? userPhone;
  String? userImg;
  int? userPoints;
  int? totalPoints;
  List<Map<dynamic,dynamic>>? eventParticipated; // Map of eventId -> status
  List<dynamic>? claimedCpn; // List of claimed coupon IDs
  List<dynamic>? userWishlist; // List of wished items

  UserClass({
    required this.userMail,
    this.userPassword,
    this.userName,
    this.userPhone,
    this.userImg,
    this.userPoints = 0,
    this.totalPoints = 0,
    this.eventParticipated = const [],
    this.claimedCpn = const [],
    this.userWishlist = const [],
  });

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
      "eventParticipated": eventParticipated, // Firestore stores maps natively
      "claimedCpn": claimedCpn,
      "userWishlist": userWishlist
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
      eventParticipated: List<Map<dynamic,dynamic>>.from(map["eventParticipated"] ?? {}),
      claimedCpn: List<dynamic>.from(map["claimedCpn"] ?? []),
      userWishlist: List<dynamic>.from(map["userWishlist"] ?? []),
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
