import '../../core/errors/failures.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';
class MarkLessonCompletedUseCase {
  MarkLessonCompletedUseCase(this._repository);
  final CourseRepository _repository;
  Future<(Failure?, Course?)> call({required int courseId, required int lessonId, bool isCompleted = true}) => _repository.markLessonCompleted(courseId: courseId, lessonId: lessonId, isCompleted: isCompleted);
}
