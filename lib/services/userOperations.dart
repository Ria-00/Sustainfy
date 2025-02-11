import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/userModel.dart';

class UserClassOperations {
  // Step 1: Create an instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //register
  Future<int> add(UserClass user) async {
    // If registration is successful
    try {
      if (user.usermail != null && user.password != null) {
        await _auth.createUserWithEmailAndPassword(
            email: user.usermail!, password: user.password!);
        print("done");
        return 1;
      } else {
        print("Email or password is null");
        return 0;
      }
      // throws exception in case of failure & returns registration failed message
    } catch (e) {
      print("no");
      return 0;
    }
  }

  //login
  Future<int> login(UserClass user) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: user.usermail!, password: user.password!);
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
      await firestore.collection("users").add(user.toMap());
      print("Created");
      return 1;
    } catch (e) {
      print("Noo");
      return 0;
    }
  }

  // Update cart
  Future<int> updateCart(String id, String name, String image, String email) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final userQuery = firestore.collection('users').where('email', isEqualTo: email);

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
    final userRef = firestore.collection('users').where('email', isEqualTo: userEmail);
    final querySnapshot = await userRef.get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception("UserClass document not found!");
    }

    final userDoc = querySnapshot.docs.first;
    final currentCart = userDoc.data()!['cart'] ?? {};

    if (!currentCart.containsKey(productId)) {
      throw Exception("Product not found in cart!");
    }

    currentCart[productId]['pqty'] +=1 ;
    int qty=currentCart[productId]['pqty'];


    transaction.update(userDoc.reference, {'cart': currentCart});
    return qty;
  }).catchError((error) {
    print("Error updating cart: $error");
    return 0;
    
  });
  return 0;
}

Future<int> decreaseProductQuantity(String productId, String userEmail) async {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;


  await firestore.runTransaction((transaction) async {
    final userRef = firestore.collection('users').where('email', isEqualTo: userEmail);
    final querySnapshot = await userRef.get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception("UserClass document not found!");
    }

    final userDoc = querySnapshot.docs.first;
    final currentCart = userDoc.data()!['cart'] ?? {};

    if (!currentCart.containsKey(productId)) {
      throw Exception("Product not found in cart!");
    }

    currentCart[productId]['pqty'] -=1 ;
    int qty=currentCart[productId]['pqty'];


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

  final userRef = firestore.collection('users').where('email', isEqualTo: email);
  final querySnapshot = await userRef.get();


  final userDoc = querySnapshot.docs.first;
  final cartData = userDoc.data()!['cart'];

  if (cartData == null || !cartData.containsKey(productId)) {
    return 0; // Product not found in cart
  }

  return cartData[productId]['pqty'];
}

Future<void> removeProductFromCart(String productId,String email) async {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception("UserClass not logged in!");
  }

  final userEmail = user.email;

  await firestore.runTransaction((transaction) async {
    final userRef = firestore.collection('users').where('email', isEqualTo: userEmail);
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

  final userRef = firestore.collection('users').where('email', isEqualTo: email);
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

  final userRef = firestore.collection('users').where('email', isEqualTo: email);
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

  final userRef = firestore.collection('users').where('email', isEqualTo: email);
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