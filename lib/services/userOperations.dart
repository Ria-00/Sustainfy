import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
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
      await _auth.signInWithEmailAndPassword(
          email: user.userMail!, password: user.userPassword!);
      print("Login successful");
      return 1;
    } catch (e) {
      print("error");
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
        .where("userMail", isEqualTo: umail) // Ensure this field name matches Firestore
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Convert Firestore document to UserClass
      print(UserClass.fromMap(snapshot.docs.first.data() as Map<String, dynamic>));
      return UserClass.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
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

  // Update cart
  Future<int> updateCart(
      String id, String name, String image, String email) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userQuery =
        firestore.collection('users').where('email', isEqualTo: email);

    return await firestore.runTransaction((transaction) async {
      final querySnapshot = await userQuery.get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("UserClass document does not exist!");
      }

      final userDoc = querySnapshot.docs.first;

      Map<String, dynamic> currentCart = userDoc.data()!['cart'] ?? {};

      String newProductId = id;
      Map<String, dynamic> newProductData = {
        'pname': name,
        'pimg': image,
        'pqty': 1,
      };

      currentCart[newProductId] = newProductData;

      // Update the cart field in the user document
      transaction.update(userDoc.reference, {'cart': currentCart});

      return 1; // Indicate successful update
    }).catchError((error) {
      print("Transaction failed: $error");
      return 0; // Indicate failure
    });
  }

  Future<int> updateProductQuantity(String productId, String userEmail) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    await firestore.runTransaction((transaction) async {
      final userRef =
          firestore.collection('users').where('email', isEqualTo: userEmail);
      final querySnapshot = await userRef.get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("UserClass document not found!");
      }

      final userDoc = querySnapshot.docs.first;
      final currentCart = userDoc.data()!['cart'] ?? {};

      if (!currentCart.containsKey(productId)) {
        throw Exception("Product not found in cart!");
      }

      currentCart[productId]['pqty'] += 1;
      int qty = currentCart[productId]['pqty'];

      transaction.update(userDoc.reference, {'cart': currentCart});
      return qty;
    }).catchError((error) {
      print("Error updating cart: $error");
      return 0;
    });
    return 0;
  }

  Future<int> decreaseProductQuantity(
      String productId, String userEmail) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    await firestore.runTransaction((transaction) async {
      final userRef =
          firestore.collection('users').where('email', isEqualTo: userEmail);
      final querySnapshot = await userRef.get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("UserClass document not found!");
      }

      final userDoc = querySnapshot.docs.first;
      final currentCart = userDoc.data()!['cart'] ?? {};

      if (!currentCart.containsKey(productId)) {
        throw Exception("Product not found in cart!");
      }

      currentCart[productId]['pqty'] -= 1;
      int qty = currentCart[productId]['pqty'];

      transaction.update(userDoc.reference, {'cart': currentCart});
      return qty;
    }).catchError((error) {
      print("Error updating cart: $error");
      return 0;
    });
    return 0;
  }

  Future<int> getCartQuantity(String productId, String email) async {
    final firestore = FirebaseFirestore.instance;

    final userRef =
        firestore.collection('users').where('email', isEqualTo: email);
    final querySnapshot = await userRef.get();

    final userDoc = querySnapshot.docs.first;
    final cartData = userDoc.data()!['cart'];

    if (cartData == null || !cartData.containsKey(productId)) {
      return 0; // Product not found in cart
    }

    return cartData[productId]['pqty'];
  }

  Future<void> removeProductFromCart(String productId, String email) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("UserClass not logged in!");
    }

    final userEmail = user.email;

    await firestore.runTransaction((transaction) async {
      final userRef =
          firestore.collection('users').where('email', isEqualTo: userEmail);
      final querySnapshot = await userRef.get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("UserClass document not found!");
      }

      final userDoc = querySnapshot.docs.first;
      final currentCart = userDoc.data()!['cart'] ?? {};

      if (!currentCart.containsKey(productId)) {
        throw Exception("Product not found in cart!");
      }

      currentCart.remove(productId); // Remove the product using remove

      transaction.update(userDoc.reference, {'cart': currentCart});
    }).catchError((error) {
      print("Error removing product from cart: $error");
    });
  }

  Future<int> getCartLength(String email) async {
    final firestore = FirebaseFirestore.instance;

    final userRef =
        firestore.collection('users').where('email', isEqualTo: email);
    final querySnapshot = await userRef.get();

    if (querySnapshot.docs.isEmpty) {
      return 0; // UserClass document not found
    }

    final userDoc = querySnapshot.docs.first;
    final cartData = userDoc.data()!['cart'];

    if (cartData == null) {
      return 0; // No cart data found
    }

    return cartData.length; // Get the length of the cart map
  }

  Future<List<Map<String, dynamic>>> getCartProducts(String email) async {
    final firestore = FirebaseFirestore.instance;

    final userRef =
        firestore.collection('users').where('email', isEqualTo: email);
    final querySnapshot = await userRef.get();

    if (querySnapshot.docs.isEmpty) {
      return []; // UserClass document not found
    }

    final userDoc = querySnapshot.docs.first;
    final cartData = userDoc.data()!['cart'] ?? {};

    final List<Map<String, dynamic>> cartProducts = [];
    cartData.forEach((productId, productData) {
      cartProducts.add(productData);
    });

    return cartProducts;
  }

  Future<List<String>> getCartProductIds(String email) async {
    final firestore = FirebaseFirestore.instance;

    final userRef =
        firestore.collection('users').where('email', isEqualTo: email);
    final querySnapshot = await userRef.get();

    if (querySnapshot.docs.isEmpty) {
      return []; // UserClass document not found
    }

    final userDoc = querySnapshot.docs.first;
    final cartData = userDoc.data()!['cart'] ?? {};

    // Instead of iterating over the entire product data, extract just the IDs
    final List<String> cartProductIds = cartData.keys.toList();

    return cartProductIds;
  }
}
