import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

import '../storage/secure_token_storage.dart';

class ApiClient {
  ApiClient({Dio? dio, SecureTokenStorage? tokenStorage})
      : _dio = dio ?? Dio(),
        _tokenStorage = tokenStorage {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );

    _dio.interceptors.add(AuthInterceptor(_dio, _tokenStorage));

    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 2,
        retryDelays: const [Duration(seconds: 1), Duration(seconds: 2)],
        retryEvaluator: (error, attempt) {
          final status = error.response?.statusCode;
          if (status != null && status >= 400 && status < 500) return false;
          return error.type == DioExceptionType.connectionError ||
              error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout;
        },
      ),
    );
    assert(() {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => print(o),
      ));
      return true;
    }());
  }

  final Dio _dio;
  final SecureTokenStorage? _tokenStorage;
  Dio get dio => _dio;
}

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio, this._tokenStorage);

  final Dio _dio;
  final SecureTokenStorage? _tokenStorage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_tokenStorage != null) {
      final token = await _tokenStorage!.readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _tokenStorage?.deleteToken();
    }
    handler.next(err);
  }
}
