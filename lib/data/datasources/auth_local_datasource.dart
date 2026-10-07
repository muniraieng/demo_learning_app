import '../../core/storage/secure_token_storage.dart';
class AuthLocalDataSource {
  AuthLocalDataSource(this._tokenStorage);
  final SecureTokenStorage _tokenStorage;
  Future<void> saveToken(String token) => _tokenStorage.saveToken(token);
  Future<String?> readToken() => _tokenStorage.readToken();
  Future<void> clearToken() => _tokenStorage.deleteToken();
}
