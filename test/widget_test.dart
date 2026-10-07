import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:demo_mobile_learning_app/core/network/network_info.dart';
import 'package:demo_mobile_learning_app/core/storage/secure_token_storage.dart';
import 'package:demo_mobile_learning_app/data/datasources/auth_local_datasource.dart';
import 'package:demo_mobile_learning_app/data/datasources/course_local_datasource.dart';
import 'package:demo_mobile_learning_app/data/datasources/course_remote_datasource.dart';
import 'package:demo_mobile_learning_app/data/repositories/auth_repository_impl.dart';
import 'package:demo_mobile_learning_app/data/repositories/course_repository_impl.dart';
import 'package:demo_mobile_learning_app/database/app_database.dart';
import 'package:demo_mobile_learning_app/domain/repositories/auth_repository.dart';
import 'package:demo_mobile_learning_app/domain/repositories/course_repository.dart';
import 'package:demo_mobile_learning_app/domain/usecases/get_courses_usecase.dart';
import 'package:demo_mobile_learning_app/domain/usecases/login_usecase.dart';
import 'package:demo_mobile_learning_app/main.dart';
import 'package:demo_mobile_learning_app/presentation/viewmodels/course_dashboard_viewmodel.dart';
import 'package:demo_mobile_learning_app/presentation/viewmodels/login_viewmodel.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSecureStorage mockStorage;

  setUp(() async {
    Get.reset();
    mockStorage = MockSecureStorage();

    when(() => mockStorage.read(key: any(named: 'key')))
        .thenAnswer((_) async => null);
    when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});
    when(() => mockStorage.delete(key: any(named: 'key')))
        .thenAnswer((_) async {});

    final tokenStorage = SecureTokenStorage(storage: mockStorage);
    final db = AppDatabase();
    final networkInfo = NetworkInfoImpl();

    final authLocal = AuthLocalDataSource(tokenStorage);
    final courseLocal = CourseLocalDataSource(db);
    final courseRemote = CourseRemoteDataSource();

    final AuthRepository authRepository = AuthRepositoryImpl(authLocal);
    final CourseRepository courseRepository = CourseRepositoryImpl(
      remote: courseRemote,
      local: courseLocal,
      networkInfo: networkInfo,
    );

    final loginUseCase = LoginUseCase(authRepository);
    final getCoursesUseCase = GetCoursesUseCase(courseRepository);

    Get.put(tokenStorage);
    Get.put(loginUseCase);
    Get.put(getCoursesUseCase);
    Get.put(LoginViewModel(loginUseCase));
    Get.put(CourseDashboardViewModel(getCoursesUseCase));
  });

  testWidgets('App starts on login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const LearningDashboardApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Learning Dashboard — Login'), findsOneWidget);
  });
}
