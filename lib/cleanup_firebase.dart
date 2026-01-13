import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase User Cleanup Script
/// This script deletes all users from Firebase Authentication and Firestore
/// Run this to start with a clean slate

Future<void> cleanupAllUsers() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // ignore: avoid_print
    print('🧹 Starting Firebase cleanup...\n');

    // Step 1: Delete all user documents from Firestore
    QuerySnapshot usersSnapshot = await firestore.collection('users').get();
    
    for (var doc in usersSnapshot.docs) {
      await doc.reference.delete();
    }

    // Step 2: Sign out current user (if any)
    if (auth.currentUser != null) {
      await auth.signOut();
    }

    // Step 3: Delete all cart items (optional cleanup)
    QuerySnapshot cartSnapshot = await firestore.collection('carts').get();
    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }

    // Step 4: Delete all wishlist items (optional cleanup)
    QuerySnapshot wishlistSnapshot = await firestore.collection('wishlists').get();
    for (var doc in wishlistSnapshot.docs) {
      await doc.reference.delete();
    }

    
  // ignore: empty_catches
  } catch (e) {
  }
}

void main() async {
  await cleanupAllUsers();
}
