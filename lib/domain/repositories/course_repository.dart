import '../../core/errors/failures.dart';
import '../entities/course.dart';
abstract class CourseRepository {
  Future<(Failure?, List<Course>?)> getCourses();
  Future<(Failure?, Course?)> getCourseDetail(int courseId);
  Future<(Failure?, Course?)> markLessonCompleted({required int courseId, required int lessonId, bool isCompleted = true});
}
