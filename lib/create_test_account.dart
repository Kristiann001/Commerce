import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Test account creation script
// Run this once to create a test user

void main() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Test account credentials
  const String email = 'test@shoplon.com';
  const String password = 'Test123!';
  const String name = 'Test User';

  try {
    // Create user
    UserCredential result = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = result.user;

    if (user != null) {
      // Create user document in Firestore
      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'role': 'customer',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // ignore: avoid_print
      print('✅ Test account created successfully!');
      // ignore: avoid_print
      print('Email: $email');
      // ignore: avoid_print
      print('Password: $password');
      // ignore: avoid_print
      print('Name: $name');
    }
  } catch (e) {
    // ignore: avoid_print
    print('❌ Error creating account: $e');
    // ignore: avoid_print
    print('Account may already exist. Try logging in with:');
    // ignore: avoid_print
    print('Email: $email');
    // ignore: avoid_print
    print('Password: $password');
  }
}
