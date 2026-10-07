import '../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';
class LoginUseCase {
  LoginUseCase(this._repository);
  final AuthRepository _repository;
  Future<(Failure?, String?)> call({required String email, required String password}) => _repository.login(email: email, password: password);
}
