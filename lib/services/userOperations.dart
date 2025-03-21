import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/couponModel.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/model/ngoModel.dart';
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
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: user.userMail!, password: user.userPassword!);

      User? user1 = userCredential.user;
      if (user1 == null) {
        return 0;
      }

      // Step 2: Check if the user exists in the NGO collection
      QuerySnapshot ngoSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("userMail", isEqualTo: user.userMail)
          .get();

      if (ngoSnapshot.docs.isEmpty) {
        await FirebaseAuth.instance.signOut(); // Sign out if not an NGO
        return 0;
      }
      print("Login successful");
      return 1;
    } catch (e) {
      print("error");
      return 0;
    }
  }

  Future<String?> signInAsNgo(Ngo ngo) async {
    try {
      // Step 1: Sign in with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: ngo.ngoMail, password: ngo.ngoPassword);

      print("8465864383468486${userCredential.user}");

      User? user = userCredential.user;
      if (user == null) {
        return "Authentication failed.";
      }

      // Step 2: Check if the user exists in the NGO collection
      QuerySnapshot ngoSnapshot = await FirebaseFirestore.instance
          .collection('ngo')
          .where("ngoMail", isEqualTo: ngo.ngoMail)
          .get();

      if (ngoSnapshot.docs.isEmpty) {
        await FirebaseAuth.instance.signOut(); // Sign out if not an NGO
        return "Access denied. Only NGOs can log in.";
      }

      // Step 3: Return success message (null means success)
      return null;
    } on FirebaseAuthException catch (e) {
      return "45478358468653746${e.message}"; // Return Firebase authentication errors
    } catch (e) {
      return "An error occurred: $e";
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

  Future<int> updateNgoDetails(
      String umail, String uname, String uphone) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ngo')
          .where('ngoMail', isEqualTo: umail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;

        await FirebaseFirestore.instance.collection('ngo').doc(docId).update({
          'ngoName': uname,
          'ngoPhone': uphone,
        });

        print('Ngo details updated successfully');
        return 1;
      } else {
        print('No Ngo found with the given email.');
        return 0;
      }
    } on FirebaseException catch (e) {
      print('Firebase error: ${e.code} - ${e.message}');
      return 0;
    } catch (e) {
      print('Error updating details: $e');
      return 0;
    }
  }

  Future<Ngo?> getNgo(String umail) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot snapshot = await firestore
          .collection("ngo")
          .where("ngoMail",
              isEqualTo: umail) // Ensure this field name matches Firestore
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Convert Firestore document to UserClass
        print(Ngo.fromJson(snapshot.docs.first.data() as Map<String, dynamic>));
        return Ngo.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
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

  Future<List<EventModel>> getNgoEvents(DocumentReference ngoRef) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection("events")
          .where("ngoRef", isEqualTo: ngoRef)
          .get();

      return snapshot.docs.map((doc) {
        return EventModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching events: $e");
      return [];
    }
  }

  Future<List<EventModel>> getAllEventsExcludingNgo(
      DocumentReference ngoRef) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("events").get();

      return snapshot.docs
          .map((doc) => EventModel.fromMap(doc.data() as Map<String, dynamic>))
          .where((event) =>
              event.ngoRef?.path != ngoRef.path) // Compare using paths
          .toList();
    } catch (e) {
      print("Error fetching events: $e");
      return [];
    }
  }

  Future<String> getNgoName(DocumentReference ngoRef) async {
    try {
      DocumentSnapshot ngoSnapshot = await ngoRef.get();

      if (ngoSnapshot.exists) {
        Map<String, dynamic>? data =
            ngoSnapshot.data() as Map<String, dynamic>?;
        return data?['ngoName'] ?? "Unknown NGO";
      } else {
        return "NGO not found";
      }
    } catch (e) {
      return "Error fetching NGO name:${e}";
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
        var userDocRef = userQuery.docs.first.reference; // Get user reference

        // Query Firestore for the event document
        DocumentSnapshot eventDoc = await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .get();

        if (eventDoc.exists) {
          List<dynamic> participants = eventDoc['eventParticipants'] ?? [];

          // Check if userRef exists in eventParticipants array
          return participants.any((participant) =>
              (participant['userRef'] as DocumentReference).id ==
              userDocRef.id);
        }
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
        DocumentReference eventDocRef =
            FirebaseFirestore.instance.collection('events').doc(eventId);

        // Define the new participant entry
        Map<String, dynamic> newParticipant = {
          'userRef': userDocRef,
          'status': "participated",
        };

        // Add participant to the event's eventParticipants array
        await eventDocRef.update({
          'eventParticipants': FieldValue.arrayUnion([newParticipant])
        });

        print("Participant added successfully!");
        return 1;
      } else {
        print("User not found.");
        return 0;
      }
    } catch (e) {
      print("Error adding participant: $e");
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
        DocumentReference eventDocRef =
            FirebaseFirestore.instance.collection('events').doc(eventId);

        // Retrieve event document
        DocumentSnapshot eventDoc = await eventDocRef.get();

        if (eventDoc.exists) {
          List<dynamic> participants = eventDoc['eventParticipants'] ?? [];

          // Find and remove the exact participant entry
          Map<String, dynamic>? participantToRemove;
          for (var participant in participants) {
            if ((participant['userRef'] as DocumentReference).id ==
                userDocRef.id) {
              participantToRemove = participant;
              break;
            }
          }

          if (participantToRemove != null) {
            await eventDocRef.update({
              'eventParticipants': FieldValue.arrayRemove([participantToRemove])
            });

            print("Participant removed successfully!");
            return 1;
          }
        }
      }
      print("User not found or not a participant.");
      return 0;
    } catch (e) {
      print("Error removing participant: $e");
      return 0;
    }
  }

  Future<int> markUserAsAttended(
      DocumentReference eventRef, DocumentReference userRef) async {
    try {
      // Get the event document
      DocumentSnapshot eventSnapshot = await eventRef.get();

      if (!eventSnapshot.exists) {
        print("Event not found");
        return 0;
      }

      // Extract existing participants
      Map<String, dynamic> eventData =
          eventSnapshot.data() as Map<String, dynamic>;
      List<dynamic> eventParticipants = eventData["eventParticipants"] ?? [];

      // Update the participant status
      List<dynamic> updatedParticipants = eventParticipants.map((participant) {
        if (participant["userRef"] == userRef) {
          return {"userRef": userRef, "status": "attended"};
        }
        return participant;
      }).toList();

      // Update Firestore
      await eventRef.update({"eventParticipants": updatedParticipants});

      print("User marked as attended successfully");
      return 1;
    } catch (e) {
      print("Error updating eventParticipants: $e");
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

  // sanidhya ka code
  // Fetch all users with their total points for the leaderboard
  Future<List<UserClass>> getAllUsersForLeaderboard() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .orderBy("totalPoints", descending: true) // Sort by points
          .get();

      return snapshot.docs
          .map((doc) => UserClass.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching leaderboard users: $e");
      return [];
    }
  }
}
