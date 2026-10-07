import 'package:get/get.dart';
import '../../core/errors/failures.dart';
import '../../domain/usecases/login_usecase.dart';
class LoginViewModel extends GetxController {
  LoginViewModel(this._loginUseCase);
  final LoginUseCase _loginUseCase;
  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final Rx<Failure?> error = Rx<Failure?>(null);
  Future<bool> login() async {
    if (isLoading.value) return false;
    isLoading.value = true;
    error.value = null;
    try {
      final (failure, token) = await _loginUseCase(email: email.value.trim(), password: password.value);
      if (failure != null || token == null) {
        error.value = failure ?? const AuthFailure();
        return false;
      }
      return true;
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() => error.value = null;
}
