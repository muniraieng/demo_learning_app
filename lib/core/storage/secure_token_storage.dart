import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
class SecureTokenStorage {
  SecureTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );
  final FlutterSecureStorage _storage;
  Future<void> saveToken(String token) => _storage.write(key: AppConstants.secureTokenKey, value: token);
  Future<String?> readToken() => _storage.read(key: AppConstants.secureTokenKey);
  Future<void> deleteToken() => _storage.delete(key: AppConstants.secureTokenKey);
  Future<void> saveRememberMe(bool value) => _storage.write(key: AppConstants.rememberMeKey, value: value.toString());
  Future<bool> readRememberMe() async {
    final value = await _storage.read(key: AppConstants.rememberMeKey);
    return value == 'true';
  }
  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'saved_email', value: email);
    await _storage.write(key: 'saved_password', value: password);
  }
  Future<(String?, String?)> readCredentials() async {
    return (await _storage.read(key: 'saved_email'), await _storage.read(key: 'saved_password'));
  }
  Future<void> deleteCredentials() async {
    await _storage.delete(key: 'saved_email');
    await _storage.delete(key: 'saved_password');
  }
}
