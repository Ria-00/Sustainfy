import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/couponModel.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/model/userModel.dart';

class UserClassOperations {
  // Step 1: Create an instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //register
  Future<int> add(UserClass user) async {
    // If registration is successful
    try {
      if (user.userMail != null && user.userPassword != null) {
        await _auth.createUserWithEmailAndPassword(
            email: user.userMail!, password: user.userPassword!);
        print("done");
        return 1;
      } else {
        print("Email or password is null");
        return 0;
      }
      // throws exception in case of failure & returns registration failed message
    } catch (e) {
      print("no");
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            print("Email is already in use.");
            break;
          case 'invalid-email':
            print("Invalid email format.");
            break;
          case 'weak-password':
            print("Weak password.");
            break;
          case 'network-request-failed':
            print("network-request-failed.");
            break;
          case 'operation-not-allowed':
            print("operation-not-allowed.");
            break;
          default:
            print("Registration failed: ${e.message}");
        }
      }
      return 0;
    }
  }

  //login
  Future<int> login(UserClass user) async {
    try {
      print("before login");
      await _auth.signInWithEmailAndPassword(
          email: user.userMail!, password: user.userPassword!);
      print("Login successful");
      return 1;
    } catch (e) {
      print("error ${e}");
      return 0;
    }
  }

  Future<int> create(UserClass user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Check if a user with the same email already exists
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .where("usermail", isEqualTo: user.userMail)
          .get();

      if (snapshot.docs.isEmpty) {
        // If no user exists, create a new user
        await firestore.collection("users").add(user.toMap());
        print("User created successfully");
        return 1; // Success
      } else {
        // User already exists
        print("User already exists");
        return 0; // User exists
      }
    } catch (e) {
      print("Error: $e");
      return -1; // Error occurred
    }
  }

  Future<UserClass?> getUser(String umail) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .where("userMail",
              isEqualTo: umail) // Ensure this field name matches Firestore
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Convert Firestore document to UserClass
        print(UserClass.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>));
        return UserClass.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        print("nothing");
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  Future<List<EventModel>> getAllEvents() async {
    try {
      QuerySnapshot snapshot = await firestore.collection("events").get();

      return snapshot.docs.map((doc) {
        return EventModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching events: $e");
      return [];
    }
  }

  Future<String?> getCompanyImage(DocumentReference compRef) async {
    try {
      DocumentSnapshot companyDoc = await compRef.get();
      // print("Document Data: ${companyDoc.data()}");

      if (companyDoc.exists && companyDoc.data() != null) {
        var data = companyDoc.data() as Map<String, dynamic>;
        return data['compImg'];
      } else {
        print("Company document not found or no data!");
        return null;
      }
    } catch (e) {
      print("Error fetching company image: $e");
      return null;
    }
  }

  Future<bool> hasUserClaimedCoupon(
      String mail, DocumentReference couponRef) async {
    try {
      // Reference to the user document
      QuerySnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where("userMail", isEqualTo: mail)
          .limit(1)
          .get();

      if (userDoc.docs.isNotEmpty) {
        List<dynamic> claimedCoupons =
            userDoc.docs.first['claimedCoupons'] ?? [];

        // Check if the couponRef exists in claimedCoupons array
        return claimedCoupons.contains(couponRef);
      }
    } catch (e) {
      print("Error checking claimed coupon: $e");
    }
    return false; // Default to false if an error occurs or user doesn't exist
  }

  Future<DocumentReference?> getDocumentRef({
    required String collection,
    required String field,
    required dynamic value,
  }) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where(field, isEqualTo: value)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first
            .reference; // Return the first matched document's reference
      }
    } on Exception catch (e) {
      print("Error:${e}");
      return null;
    }
// Return null if no document matches
  }

  Future<List<CouponModel>> getAllCoupons() async {
    try {
      QuerySnapshot snapshot = await firestore.collection("coupons").get();

      return snapshot.docs.map((doc) {
        return CouponModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print("Error fetching coupons: $e");
      return [];
    }
  }

  Future<int> getUserPoints(String userEmail) async {
    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection("users")
          .where("userMail", isEqualTo: userEmail) // Querying by email
          .limit(1) // Limiting to 1 document for efficiency
          .get();

      if (userQuery.docs.isNotEmpty) {
        print(userQuery.docs.first["userPoints"]);
        return (userQuery.docs.first["userPoints"] ?? 0)
            as int; // Default to 0 if null
      } else {
        print("User not found!");
        return 0;
      }
    } catch (e) {
      print("Error fetching user points: $e");
      return 0;
    }
  }

  Future<bool> isUserParticipating(String userEmail, String eventId) async {
    try {
      // Query Firestore for the user document based on email
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('userMail', isEqualTo: userEmail)
          .limit(1) // Assuming email is unique
          .get();

      if (userQuery.docs.isNotEmpty) {
        var userDoc = userQuery.docs.first;
        List<dynamic> events = userDoc['eventParticipated'] ?? [];
        print("events${events}");
        print("8667878679798789");
        print(events.any(
            (event) => (event['eventRef'] as DocumentReference).id == eventId));

        // Check if any eventRef matches eventId
        return events.any(
            (event) => (event['eventRef'] as DocumentReference).id == eventId);
      }
    } catch (e) {
      print("Error checking participation: $e");
    }
    return false;
  }

  Future<int> addEventToUser(String userEmail, String eventId) async {
    try {
      // Query Firestore for the user document based on email
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('userMail', isEqualTo: userEmail)
          .limit(1) // Assuming email is unique
          .get();

      if (userQuery.docs.isNotEmpty) {
        DocumentReference userDocRef = userQuery.docs.first.reference;

        // Define the new event entry
        Map<String, dynamic> newEvent = {
          'eventRef':
              FirebaseFirestore.instance.collection('events').doc(eventId),
          'status': "participated",
        };

        // Add event to the user's eventParticipated array
        await userDocRef.update({
          'eventParticipated': FieldValue.arrayUnion([newEvent])
        });

        print("Event added successfully!");
        return 1;
      } else {
        print("User not found.");
        return 0;
      }
    } catch (e) {
      print("Error adding event: $e");
      return 0;
    }
  }

  Future<int> removeEventFromUser(String userEmail, String eventId) async {
    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('userMail', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        DocumentReference userDocRef = userQuery.docs.first.reference;

        await userDocRef.update({
          'eventParticipated': FieldValue.arrayRemove([
            {
              'eventRef':
                  FirebaseFirestore.instance.collection('events').doc(eventId),
              'status': 'participated'
            } // Must exactly match Firestore
          ])
        });

        print("Event removed successfully!");
        return 1;
      } else {
        print("User not found.");
        return 0;
      }
    } catch (e) {
      print("Error removing event: $e");
      return 0;
    }
  }

  Future<String?> sendOtp(String phoneNumber) async {
    try {
      String? verificationId;

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Optional: Auto-sign in functionality
          await _auth.signInWithCredential(credential);
          print("Phone number verified automatically");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.message}");
          throw Exception("Failed to send OTP: ${e.message}");
        },
        codeSent: (String id, int? resendToken) {
          verificationId = id;
          print("OTP sent successfully to $phoneNumber");
        },
        codeAutoRetrievalTimeout: (String id) {
          verificationId = id;
          print("Code auto-retrieval timeout");
        },
      );

      // Wait until the verification ID is set
      while (verificationId == null) {
        await Future.delayed(Duration(milliseconds: 100));
      }

      return verificationId;
    } catch (e) {
      print("Error sending OTP: $e");
      return null;
    }
  }

  Future<int> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      // Create a PhoneAuthCredential using the OTP and verification ID
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      // Sign in with the credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print(
          "OTP verification successful for user: ${userCredential.user?.uid}");
      return 1; // Success
    } catch (e) {
      print("OTP verification failed: $e");

      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-verification-code') {
          print("The OTP entered is invalid.");
        } else if (e.code == 'session-expired') {
          print("The verification session has expired.");
        }
      }

      return 0; // Failure
    }
  }
}
