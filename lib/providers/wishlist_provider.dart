import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class WishlistProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<ProductModel> _items = [];
  List<ProductModel> get items => _items;

  // Initialize/Fetch wishlist for current user
  void fetchWishlist() {
    User? user = _auth.currentUser;
    if (user != null) {
      _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .snapshots()
          .listen((snapshot) {
        _items = snapshot.docs
            .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
            .toList();
        notifyListeners();
      });
    } else {
      _items = [];
      notifyListeners();
    }
  }

  bool isInWishlist(String productId) {
    return _items.any((item) => item.id == productId);
  }

  Future<void> toggleWishlist(ProductModel product) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    final wishlistRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .doc(product.id);

    if (isInWishlist(product.id)) {
      await wishlistRef.delete();
    } else {
      await wishlistRef.set(product.toMap());
    }
  }
}
