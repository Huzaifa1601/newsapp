import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AppUser?> authStateChanges() => _remoteDataSource.authStateChanges();

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signInWithEmail(email: email, password: password);
  }

  @override
  Future<AppUser> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signUpWithEmail(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<AppUser> signInWithGoogle() => _remoteDataSource.signInWithGoogle();

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> signOut() => _remoteDataSource.signOut();
}
