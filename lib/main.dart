import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'background/sync_worker.dart';
import 'core/network/network_info.dart';
import 'core/storage/secure_token_storage.dart';
import 'data/datasources/auth_local_datasource.dart';
import 'data/datasources/course_local_datasource.dart';
import 'data/datasources/course_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/course_repository_impl.dart';
import 'database/app_database.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/course_repository.dart';
import 'domain/usecases/get_courses_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'presentation/screens/course_dashboard_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/viewmodels/course_dashboard_viewmodel.dart';
import 'presentation/viewmodels/login_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SyncWorker.register();

  final db = AppDatabase();
  final networkInfo = NetworkInfoImpl();
  final tokenStorage = SecureTokenStorage();

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
  Get.put(db);
  Get.put(loginUseCase);
  Get.put(getCoursesUseCase);
  Get.put(LoginViewModel(loginUseCase));
  Get.put(CourseDashboardViewModel(getCoursesUseCase));

  runApp(const ProviderScope(child: LearningDashboardApp()));
}

class LearningDashboardApp extends StatelessWidget {
  const LearningDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Learning Dashboard',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.blue,
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child: const _RootGate(),
    );
  }
}

class _RootGate extends StatefulWidget {
  const _RootGate();

  @override
  State<_RootGate> createState() => _RootGateState();
}

class _RootGateState extends State<_RootGate> {
  bool _resolved = false;
  bool _hasSession = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final storage = Get.find<SecureTokenStorage>();
    final token = await storage.readToken();
    final rememberMe = await storage.readRememberMe();
    _hasSession = token != null && rememberMe;
    if (mounted) setState(() => _resolved = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_resolved) {
      return const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }
    return _hasSession ? const CourseDashboardScreen() : const LoginScreen();
  }
}
