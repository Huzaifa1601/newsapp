import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  });
  Future<AppUser> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });
  Future<AppUser> signInWithGoogle();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
}
