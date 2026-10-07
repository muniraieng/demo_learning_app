import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../data/datasources/course_local_datasource.dart';
import '../../data/datasources/course_remote_datasource.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../database/app_database.dart' hide Course;
import '../../domain/entities/course.dart';
import '../../domain/usecases/get_course_detail_usecase.dart';
import '../../domain/usecases/mark_lesson_completed_usecase.dart';
import 'course_dashboard_viewmodel.dart';

void _syncDashboard(Course? course) {
  if (course != null && Get.isRegistered<CourseDashboardViewModel>()) {
    Get.find<CourseDashboardViewModel>().updateCourse(course);
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) => Get.find<AppDatabase>());

final courseLocalDataSourceProvider = Provider<CourseLocalDataSource>(
  (ref) => CourseLocalDataSource(ref.watch(appDatabaseProvider)),
);

final courseRemoteDataSourceProvider = Provider<CourseRemoteDataSource>(
  (ref) => CourseRemoteDataSource(),
);

final networkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());

final courseRepositoryProvider = Provider<CourseRepositoryImpl>(
  (ref) => CourseRepositoryImpl(
    remote: ref.watch(courseRemoteDataSourceProvider),
    local: ref.watch(courseLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  ),
);

final getCourseDetailUseCaseProvider = Provider<GetCourseDetailUseCase>(
  (ref) => GetCourseDetailUseCase(ref.watch(courseRepositoryProvider)),
);

final markLessonCompletedUseCaseProvider =
    Provider<MarkLessonCompletedUseCase>(
  (ref) => MarkLessonCompletedUseCase(ref.watch(courseRepositoryProvider)),
);

class CourseDetailState {
  const CourseDetailState({
    this.isLoading = false,
    this.course,
    this.failure,
  });

  final bool isLoading;
  final Course? course;
  final Failure? failure;

  CourseDetailState copyWith({
    bool? isLoading,
    Course? course,
    Failure? failure,
  }) =>
      CourseDetailState(
        isLoading: isLoading ?? this.isLoading,
        course: course ?? this.course,
        failure: failure,
      );
}

class CourseDetailViewModel
    extends AutoDisposeFamilyNotifier<CourseDetailState, int> {
  @override
  CourseDetailState build(int courseId) {
    final getDetail = ref.watch(getCourseDetailUseCaseProvider);

    Future.microtask(() async {
      final (f, course) = await getDetail(courseId);
      state = CourseDetailState(
        isLoading: false,
        course: f == null ? course : state.course,
        failure: f,
      );
    });

    return const CourseDetailState(isLoading: true);
  }

  Future<void> load() async {
    final getDetail = ref.read(getCourseDetailUseCaseProvider);
    state = state.copyWith(isLoading: true, failure: null);
    final (f, course) = await getDetail(arg);
    state = CourseDetailState(
      isLoading: false,
      course: f == null ? course : state.course,
      failure: f,
    );
  }

  Future<void> uncompleteLesson(int lessonId) async {
    final markCompleted = ref.read(markLessonCompletedUseCaseProvider);
    final (f, course) = await markCompleted(courseId: arg, lessonId: lessonId, isCompleted: false);
    if (f == null && course != null) {
      state = CourseDetailState(isLoading: false, course: course);
      _syncDashboard(course);
    } else {
      state = CourseDetailState(isLoading: false, course: state.course, failure: f);
    }
  }

  Future<void> completeLesson(int lessonId) async {
    final courseId = arg;
    final markCompleted = ref.read(markLessonCompletedUseCaseProvider);
    final (f, course) =
        await markCompleted(courseId: courseId, lessonId: lessonId);
    if (f == null && course != null) {
      state = CourseDetailState(isLoading: false, course: course);
      _syncDashboard(course);
    } else {
      state =
          CourseDetailState(isLoading: false, course: state.course, failure: f);
    }
  }
}

final courseDetailViewModelProvider = NotifierProvider.autoDispose.family<
    CourseDetailViewModel, CourseDetailState, int>(
  CourseDetailViewModel.new,
);
