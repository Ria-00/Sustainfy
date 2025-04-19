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

  Future<String> reAuthenticateAndDelete(String email, String password) async {
    User? user = _auth.currentUser;

    if (user == null) {
      return "No user is signed in.";
    }

    try {
      // Get current credentials
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

      // Re-authenticate user
      await user.reauthenticateWithCredential(credential);

      // Delete user data from Firestore
      await firestore
      .collection('users')
      .where('userMail', isEqualTo: user.email) // Filter by userMail
      .get()
      .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete(); // Delete each matching document
        }
      });



      // Delete account after re-authentication
      await user.delete();
      return "User account deleted successfully.";
    } on FirebaseAuthException catch (e) {
      print(e);
      return "Error: ${e.message}";
    } catch (e) {
      print(e);          
      return "Error deleting account. Please try again.";
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

  Future<int> updateUserDetails(
      String umail, String uname, String uphone) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userMail', isEqualTo: umail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;

        await FirebaseFirestore.instance.collection('users').doc(docId).update({
          'userName': uname,
          'userPhone': uphone,
        });

        print('User details updated successfully');
        return 1;
      } else {
        print('No User found with the given email.');
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
  
  Future<void> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    print("Password reset email sent.");
  } catch (e) {
    print("Error: $e");
  }
}

     

  Future<List<CouponModel>> fetchClaimedCoupons(String userEmail) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot userQuery = await firestore
          .collection('users')
          .where('userMail', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) return [];

      DocumentSnapshot userDoc = userQuery.docs.first;

      List<dynamic>? couponRefs =
          userDoc.get('claimedCoupons') as List<dynamic>?;
      if (couponRefs == null || couponRefs.isEmpty) return [];

      List<CouponModel> coupons = [];

      for (DocumentReference couponRef in couponRefs) {
        try {
          DocumentSnapshot couponDoc = await couponRef.get();
          if (couponDoc.exists) {
            coupons.add(CouponModel.fromFirestore(couponDoc));
          }
        } catch (e) {
          print("Error fetching coupon: $e");
        }
      }

      return coupons;
    } catch (e) {
      print("Error fetching claimed coupons by email: $e");
      return [];
    }
  }

  Future<List<CouponModel>> getUnclaimedCoupons(String userEmail) async {
    try {
      List<CouponModel>? fetchedCoupons = await getAllCoupons();
      if (fetchedCoupons == null || fetchedCoupons.isEmpty) return [];

      List<Future<DocumentReference?>> refFutures =
          fetchedCoupons.map((coupon) {
        return getDocumentRef(
            collection: "coupons", field: "couponId", value: coupon.couponId);
      }).toList();

      // Fetch all document references in parallel
      List<DocumentReference?> couponRefs = await Future.wait(refFutures);

      // Check if the user has claimed each coupon
      List<Future<bool>> claimCheckFutures = [];
      for (int i = 0; i < fetchedCoupons.length; i++) {
        if (couponRefs[i] != null) {
          claimCheckFutures
              .add(hasUserClaimedCoupon(userEmail, couponRefs[i]!));
        } else {
          claimCheckFutures.add(Future.value(false)); // Assume unclaimed
        }
      }

      // Get claim results
      List<bool> claimResults = await Future.wait(claimCheckFutures);

      // Filter only unclaimed coupons
      List<CouponModel> unclaimedCoupons = [];
      for (int i = 0; i < fetchedCoupons.length; i++) {
        if (!claimResults[i]) {
          unclaimedCoupons.add(fetchedCoupons[i]);
        }
      }

      return unclaimedCoupons;
    } catch (e) {
      print("Error fetching unclaimed coupons: $e");
      return [];
    }
  }

  Future<List<CouponModel>> fetchWishlistedCoupons(String userEmail) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot userQuery = await firestore
          .collection('users')
          .where('userMail', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) return [];

      DocumentSnapshot userDoc = userQuery.docs.first;

      List<dynamic>? couponRefs = userDoc.get('userWishlist') as List<dynamic>?;
      if (couponRefs == null || couponRefs.isEmpty) return [];

      List<CouponModel> coupons = [];

      for (DocumentReference couponRef in couponRefs) {
        try {
          DocumentSnapshot couponDoc = await couponRef.get();
          if (couponDoc.exists) {
            coupons.add(CouponModel.fromFirestore(couponDoc));
          }
        } catch (e) {
          print("Error fetching coupon: $e");
        }
      }

      return coupons;
    } catch (e) {
      print("Error fetching Wishlisted coupons by email: $e");
      return [];
    }
  }

  Future<void> toggleWishlist(String userEmail, String couponId) async {
    try {
      QuerySnapshot userQuery = await firestore
          .collection('users')
          .where('userMail', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) throw Exception("User not found");

      DocumentSnapshot userDoc = userQuery.docs.first;
      DocumentReference userRef = userDoc.reference;

      // Get Coupon Reference
      DocumentReference couponRef =
          firestore.collection('coupons').doc(couponId);

      // Retrieve user's wishlist
      List<dynamic> wishlist = List.from(userDoc.get('userWishlist') ?? []);

      // Convert to List<DocumentReference> for proper comparison
      List<DocumentReference> wishlistRefs =
          wishlist.map((item) => item as DocumentReference).toList();

      if (wishlistRefs.contains(couponRef)) {
        wishlistRefs.remove(couponRef); // Remove if already in wishlist
      } else {
        wishlistRefs.add(couponRef); // Add if not in wishlist
      }

      await userRef.update({'userWishlist': wishlistRefs});
    } catch (e) {
      print("Error updating wishlist: $e");
    }
  }

  Future<bool> checkIfWishlisted(String userEmail, String couponId) async {
    try {
      QuerySnapshot userQuery = await firestore
          .collection('users')
          .where('userMail', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) throw Exception("User not found");
      print("checkingng919020");

      DocumentSnapshot userDoc = userQuery.docs.first;

      // Get Coupon Reference
      DocumentReference couponRef =
          firestore.collection('coupons').doc(couponId);

      // Retrieve user's wishlist
      List<dynamic> wishlist = userDoc.get('userWishlist') ?? [];

      // Convert to List<DocumentReference> for proper comparison
      List<DocumentReference> wishlistRefs =
          wishlist.map((item) => item as DocumentReference).toList();

      return wishlistRefs.contains(couponRef);
    } catch (e) {
      print("Error checking wishlist status: $e");
      return false;
    }
  }

  Future<String> claimCoupon(String userEmail, String couponId) async {
    try {
      // Fetch user based on email
      QuerySnapshot userQuery = await firestore
          .collection('users')
          .where('userMail', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) throw Exception("User not found");

      DocumentSnapshot userDoc = userQuery.docs.first;
      DocumentReference userRef = userDoc.reference;

      //  Fetch coupon details
      DocumentSnapshot couponDoc =
          await firestore.collection('coupons').doc(couponId).get();

      if (!couponDoc.exists) throw Exception("Coupon not found");

      DocumentReference couponRef =
          firestore.collection('coupons').doc(couponId);

      int userPoints = userDoc['userPoints'];
      int couponPoint = couponDoc['couponPoint'];

      if (userPoints < couponPoint) {
        print("Not enough points to claim the coupon.");
        return "Insufficient points"; // Insufficient points
      }

      //  Fetch claimed coupons
      List<dynamic> claimed = List.from(userDoc.get('claimedCoupons') ?? []);
      List<DocumentReference> claimedRefs =
          claimed.map((item) => item as DocumentReference).toList();

      //  Fetch wishlisted coupons
      List<dynamic> wishlist = List.from(userDoc.get('userWishlist') ?? []);
      List<DocumentReference> wishlistRefs =
          wishlist.map((item) => item as DocumentReference).toList();

      //  Check if the coupon is already claimed
      if (claimedRefs.contains(couponRef)) {
        print(" Coupon already claimed.");
        return "Coupon already claimed."; // Already claimed
      }

      // Update claimed coupons
      claimedRefs.add(couponRef);
      await userRef.update({'claimedCoupons': claimedRefs});

      //  update wishlist coupons
      if (wishlistRefs.contains(couponRef)) {
        wishlistRefs.remove(couponRef); // Remove if already in wishlist
        await userRef.update({'userWishlist': wishlistRefs});
      } else {
        print("Coupon not in wishlist.");
      }

      //  Deduct points
      await userRef.update({'userPoints': userPoints - couponPoint});

      print(
          "Coupon claimed successfully! Remaining points: ${userPoints - couponPoint}");
      return "Coupon Code Copied!"; // Success
    } catch (e) {
      print(" Error claiming coupon: $e");
      return "Error claiming coupon: $e"; // Error occurred
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

  Future<void> checkAndUpdateEvents() async {
  final now = Timestamp.now();
  final events = await FirebaseFirestore.instance
      .collection('events')
      .where('eventEnd_date', isLessThanOrEqualTo: now)
      .get();

  for (var doc in events.docs) {
    await doc.reference.update({
      'eventStatus': 'closed',
    });
  }
  
  final upcomingEvents = await FirebaseFirestore.instance
      .collection('events')
    .where('eventStart_date', isLessThanOrEqualTo: now)
    .where('eventEnd_date', isGreaterThan: now)
    .orderBy('eventStart_date')
    .orderBy('eventEnd_date')
    .get();

  // print("85982749857982479874289769");
  // print(now);
  // print(upcomingEvents.docs);

  for (var doc in upcomingEvents.docs) {
    // print(doc.id);
    await doc.reference.update({
      'eventStatus': 'live',
    });
  }
}

  Future<List<Ngo>> getNgos() async {
        try {
          QuerySnapshot snapshot = await firestore.collection("ngo").get();

          return snapshot.docs.map((doc) {
            return Ngo.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();
        } catch (e) {
          print("Error fetching Ngo: $e");
          return [];
        }
    }


  Future<List<EventModel>> getAllEventsExcludingNgo(DocumentReference ngoRef) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("events")
        .where("eventStatus", whereIn: ["live", "upcoming"]) // Filter status
        .get();

    return snapshot.docs
        .map((doc) => EventModel.fromMap(doc.data() as Map<String, dynamic>))
        .where((event) => event.ngoRef?.path != ngoRef.path) // Exclude NGO's own events
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

  Future<String> getCompanyName(DocumentReference compRef) async {
    try {
      DocumentSnapshot compSnapshot = await compRef.get();

      if (compSnapshot.exists) {
        Map<String, dynamic>? data =
            compSnapshot.data() as Map<String, dynamic>?;
        return data?['compName'] ?? "Unknown";
      } else {
        return "Company not found";
      }
    } catch (e) {
      return "Error fetching Company name:${e}";
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

  Future<CouponModel?> getCouponById(String couponId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("coupons")
          .where("couponId", isEqualTo: couponId)
          .limit(1)
          .get();

      // print(querySnapshot.docs.first.data());

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first;
        return CouponModel.fromFirestore(data);
      }
    } catch (e) {
      print("Error fetching coupon: $e");
    }
    return null;
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
      DocumentSnapshot userSnapshot = await userRef.get();

      if (!eventSnapshot.exists) {
        print("Event not found");
        return 0;
      }

      // Extract existing participants
      Map<String, dynamic> eventData =
          eventSnapshot.data() as Map<String, dynamic>;
      List<dynamic> eventParticipants = eventData["eventParticipants"] ?? [];
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      int eventPoints = eventData["eventPoints"] ?? 0;
      int currPoints = (eventPoints + userData["userPoints"]).toInt();
      int total=(eventPoints + userData["totalPoints"]).toInt();

      // Update the participant status
      List<dynamic> updatedParticipants = eventParticipants.map((participant) {
        if (participant["userRef"] == userRef) {
          return {"userRef": userRef, "status": "attended"};
        }
        return participant;
      }).toList();

      // Update Firestore
      await eventRef.update({"eventParticipants": updatedParticipants});
      await userRef.update({
        "userPoints": currPoints,
        "totalPoints": total,
      });
      print("User points updated successfully!");

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

  Future<List<EventModel>> fetchClosedAttendedEvents(String userMail) async {
    try {
      // Step 1: Fetch user document to get userRef
      QuerySnapshot userSnapshot = await firestore
          .collection('users')
          .where('userMail', isEqualTo: userMail)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        print("User not found.");
        return [];
      }

      DocumentReference userRef =
          userSnapshot.docs.first.reference; // Get userRef

      // Step 2: Query events where eventStatus is "closed"
      QuerySnapshot eventSnapshot = await firestore
          .collection('events')
          .where('eventStatus', isEqualTo: 'closed')
          .get();

      List<EventModel> filteredEvents = [];

      // Step 3: Filter events based on userRef and status
      for (var event in eventSnapshot.docs) {
        var eventData = event.data() as Map<String, dynamic>;
        List<dynamic> participants = eventData['eventParticipants'] ?? [];

        // bool hasAttended = participants.any((participant) =>
        //     participant['userRef'] == userRef.path &&
        //     participant['status'] == "attended");
        bool hasAttended = participants.any((participant) {
          final DocumentReference ref = participant['userRef'];
          return ref.path == userRef.path &&
              participant['status'] == "attended";
        });

        if (hasAttended) {
          filteredEvents.add(EventModel.fromMap(eventData));
        }
      }

      return filteredEvents;
    } catch (e) {
      print("Error fetching events: $e");
      return [];
    }
  }
  
}


