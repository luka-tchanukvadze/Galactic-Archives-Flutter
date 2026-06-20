import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String faction,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user!;
    await user.updateDisplayName(name);
    await _db.collection('users').doc(user.uid).set({
      'email': email,
      'name': name,
      'faction': faction,
    });
  }

  Future<void> signOut() => _auth.signOut();

  // Reads the user profile stored in Firestore at signup.
  Future<AppUser> loadAppUser(User user) async {
    final doc = await _db.collection('users').doc(user.uid).get();
    final data = doc.data();
    if (doc.exists && data != null) {
      return AppUser.fromMap(user.uid, data);
    }
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'Commander',
      faction: 'jedi',
    );
  }
}
