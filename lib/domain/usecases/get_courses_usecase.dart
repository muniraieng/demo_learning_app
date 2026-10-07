import '../../core/errors/failures.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';
class GetCoursesUseCase {
  GetCoursesUseCase(this._repository);
  final CourseRepository _repository;
  Future<(Failure?, List<Course>?)> call() => _repository.getCourses();
}
