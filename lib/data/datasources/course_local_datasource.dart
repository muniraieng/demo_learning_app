import '../../database/app_database.dart';
class CourseLocalDataSource {
  CourseLocalDataSource(this._db);
  final AppDatabase _db;
  Future<void> cacheCourses(List<Map<String, dynamic>> courses) => _db.cacheCourses(courses);
  Future<List<Map<String, dynamic>>> getCachedCourses() => _db.getCachedCourses();
  Future<void> markLessonCompleted({required int courseId, required int lessonId, required bool isCompleted}) => _db.updateLessonCompletion(courseId: courseId, lessonId: lessonId, isCompleted: isCompleted);
}
