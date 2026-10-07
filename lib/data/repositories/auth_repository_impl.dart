import '../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._local);
  final AuthLocalDataSource _local;
  @override
  Future<(Failure?, String?)> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (email == 'test@demo.com' && password == 'demo123') {
      const token = 'mock-jwt-token-abc123';
      await _local.saveToken(token);
      return (null, token);
    }
    return (const AuthFailure('Invalid email or password.'), null);
  }
  @override
  Future<void> logout() => _local.clearToken();
  @override
  Future<bool> hasSession() async {
    final token = await _local.readToken();
    return token != null && token.isNotEmpty;
  }
}
