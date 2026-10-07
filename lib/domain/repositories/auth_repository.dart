import '../../core/errors/failures.dart';
abstract class AuthRepository {
  Future<(Failure?, String?)> login({required String email, required String password});
  Future<void> logout();
  Future<bool> hasSession();
}
