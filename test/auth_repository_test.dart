import 'package:demo_mobile_learning_app/core/errors/failures.dart';
import 'package:demo_mobile_learning_app/data/datasources/auth_local_datasource.dart';
import 'package:demo_mobile_learning_app/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocal extends Mock implements AuthLocalDataSource {}

void main() {
  late MockAuthLocal local;
  late AuthRepositoryImpl repo;

  setUp(() {
    local = MockAuthLocal();
    repo = AuthRepositoryImpl(local);
    when(() => local.saveToken(any())).thenAnswer((_) async {});
    when(() => local.clearToken()).thenAnswer((_) async {});
  });

  test('login with correct credentials saves token and returns it', () async {
    final (failure, token) =
        await repo.login(email: 'test@demo.com', password: 'demo123');
    expect(failure, isNull);
    expect(token, isNotNull);
    verify(() => local.saveToken(token!)).called(1);
  });

  test('login with wrong credentials returns AuthFailure and saves nothing',
      () async {
    final (failure, token) =
        await repo.login(email: 'a@b.com', password: 'wrong');
    expect(failure, isA<AuthFailure>());
    expect(token, isNull);
    verifyNever(() => local.saveToken(any()));
  });
}
