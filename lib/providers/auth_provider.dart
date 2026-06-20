import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _authService.authStateChanges().listen(_onAuthChanged);
  }

  final AuthService _authService = AuthService();

  AppUser? _user;
  bool _loading = true;
  String? _error;

  AppUser? get user => _user;
  bool get loading => _loading;
  bool get isLoggedIn => _user != null;
  String? get error => _error;

  Future<void> _onAuthChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
    } else {
      _user = await _authService.loadAppUser(firebaseUser);
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _error = null;
    try {
      await _authService.signIn(email.trim(), password);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? 'Login failed';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String faction,
  }) async {
    _error = null;
    try {
      await _authService.signUp(
        name: name.trim(),
        email: email.trim(),
        password: password,
        faction: faction,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? 'Signup failed';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() => _authService.signOut();
}
