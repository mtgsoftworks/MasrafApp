import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masraf_app/auth/models/user.dart';
import 'package:flutter/foundation.dart';

class AuthState {
  final User? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  late final fb_auth.FirebaseAuth _auth;

  AuthNotifier() : super(const AuthState(isLoading: true)) {
    _auth = fb_auth.FirebaseAuth.instance;
    _auth.authStateChanges().listen((fb_auth.User? fbUser) {
      if (fbUser != null) {
        state = AuthState(
          user: User(
            id: fbUser.uid,
            email: fbUser.email!,
            name: fbUser.displayName ?? fbUser.email!.split('@')[0],
            photoUrl: fbUser.photoURL,
          ),
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = const AuthState(isAuthenticated: false, isLoading: false);
      }
    });
  }

  // Getters for direct access
  User? get user => state.user;
  bool get isAuthenticated => state.isAuthenticated;
  bool get isLoading => state.isLoading;
  String? get error => state.error;

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fbUser = credential.user!;
      await fbUser.reload();
      if (!fbUser.emailVerified) {
        await fbUser.sendEmailVerification();
        state = AuthState(isAuthenticated: false, isLoading: false, error: 'Hesabınız doğrulanmamış. Yeni doğrulama maili gönderildi. Lütfen mailinizi kontrol edin.');
        return;
      }
      state = AuthState(
        user: User(
          id: fbUser.uid,
          email: fbUser.email!,
          name: fbUser.displayName ?? fbUser.email!.split('@')[0],
          photoUrl: fbUser.photoURL,
        ),
        isAuthenticated: true,
        isLoading: false,
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      state = AuthState(isAuthenticated: false, isLoading: false, error: e.message);
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fbUser = credential.user!;
      await fbUser.updateDisplayName(name);
      await fbUser.sendEmailVerification();
      state = AuthState(isAuthenticated: false, isLoading: false, error: 'Doğrulama maili gönderildi. Lütfen e-posta adresinizi kontrol edin.');
    } on fb_auth.FirebaseAuthException catch (e) {
      state = AuthState(isAuthenticated: false, isLoading: false, error: e.message);
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      late fb_auth.User fbUser;
      if (kIsWeb) {
        final provider = fb_auth.GoogleAuthProvider();
        provider.setCustomParameters({'prompt': 'select_account'});
        final result = await _auth.signInWithPopup(provider);
        fbUser = result.user!;
      } else {
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          state = state.copyWith(isLoading: false, error: 'Google sign-in aborted');
          return;
        }
        final googleAuth = await googleUser.authentication;
        final credential = fb_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredential = await _auth.signInWithCredential(credential);
        fbUser = userCredential.user!;
      }
      state = AuthState(
        user: User(
          id: fbUser.uid,
          email: fbUser.email!,
          name: fbUser.displayName ?? fbUser.email!.split('@')[0],
          photoUrl: fbUser.photoURL,
        ),
        isAuthenticated: true,
        isLoading: false,
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      state = AuthState(isAuthenticated: false, isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);
      await _auth.signOut();
      state = const AuthState(isAuthenticated: false, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Şifre sıfırlama e-postası gönder
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final trimmedEmail = email.trim();
      if (trimmedEmail.isEmpty) {
        state = state.copyWith(isLoading: false, error: 'Lütfen e-posta adresinizi girin.');
        return;
      }
      await _auth.sendPasswordResetEmail(email: trimmedEmail);
      state = state.copyWith(isLoading: false, error: 'Şifre sıfırlama linki e-postanıza gönderildi. Lütfen kontrol edin.');
    } on fb_auth.FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// StateNotifierProvider tanımı
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Shorthand provider for the authState
final authStateProvider = Provider<AuthState>((ref) {
  return ref.watch(authProvider);
});

// Legacy provider için uyumluluk sağlayıcı
final myAuthProvider = Provider<AuthNotifier>((ref) {
  return ref.watch(authProvider.notifier);
});
