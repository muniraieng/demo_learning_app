import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_local_datasource.dart';
import '../datasources/course_remote_datasource.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
class CourseRepositoryImpl implements CourseRepository {
  CourseRepositoryImpl({required CourseRemoteDataSource remote, required CourseLocalDataSource local, required NetworkInfo networkInfo}) : _remote = remote, _local = local, _networkInfo = networkInfo;
  final CourseRemoteDataSource _remote;
  final CourseLocalDataSource _local;
  final NetworkInfo _networkInfo;
  @override
  Future<(Failure?, List<Course>?)> getCourses() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remote.fetchCourses();
        await _local.cacheCourses(models.map((m) => m.toCacheJson()).toList());
        return (null, models.map((m) => m.toEntity()).toList());
      } on Failure catch (f) {
        final cached = await _safeCache();
        if (cached != null) return (null, cached);
        return (f, null);
      } catch (_) {
        final cached = await _safeCache();
        if (cached != null) return (null, cached);
        return (const ServerFailure(), null);
      }
    }
    final cached = await _safeCache();
    if (cached != null) return (null, cached);
    return (const CacheFailure('No cached data. Connect to the internet once.'), null);
  }
  @override
  Future<(Failure?, Course?)> getCourseDetail(int courseId) async {
    final cached = await _safeCache();
    if (cached == null) return (const CacheFailure(), null);
    try {
      return (null, cached.firstWhere((c) => c.id == courseId));
    } catch (_) {
      return (const CacheFailure('Course not found.'), null);
    }
  }
  @override
  Future<(Failure?, Course?)> markLessonCompleted({required int courseId, required int lessonId, bool isCompleted = true}) async {
    await _local.markLessonCompleted(courseId: courseId, lessonId: lessonId, isCompleted: isCompleted);
    return getCourseDetail(courseId);
  }
  Future<List<Course>?> _safeCache() async {
    try {
      final rows = await _local.getCachedCourses();
      if (rows.isEmpty) return null;
      return rows.map((r) => CourseModel(id: r['id'] as int, title: r['title'] as String, instructor: r['instructor'] as String, progress: r['progress'] as int, lessonCount: r['lessonCount'] as int, lessons: (r['lessons'] as List<dynamic>).map((e) => LessonModel.fromJson(e as Map<String, dynamic>)).toList()).toEntity()).toList();
    } catch (_) {
      return null;
    }
  }
}
