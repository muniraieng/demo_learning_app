import '../../core/errors/failures.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';
class GetCourseDetailUseCase {
  GetCourseDetailUseCase(this._repository);
  final CourseRepository _repository;
  Future<(Failure?, Course?)> call(int courseId) => _repository.getCourseDetail(courseId);
}
