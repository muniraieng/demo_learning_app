import '../../domain/entities/course.dart';
import 'lesson_model.dart';
class CourseModel extends Course {
  const CourseModel({required super.id, required super.title, required super.instructor, required super.progress, required super.lessonCount, super.lessons});
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final rawLessons = json['lessons'] as List<dynamic>? ?? const [];
    return CourseModel(id: json['id'] as int, title: json['title'] as String, instructor: json['instructor'] as String, progress: json['progress'] as int, lessonCount: rawLessons.length, lessons: rawLessons.map((e) => LessonModel.fromJson(e as Map<String, dynamic>)).toList());
  }
  factory CourseModel.fromEntity(Course c) => CourseModel(id: c.id, title: c.title, instructor: c.instructor, progress: c.progress, lessonCount: c.lessonCount, lessons: c.lessons.map(LessonModel.fromEntity).toList());
  Course toEntity() => Course(id: id, title: title, instructor: instructor, progress: progress, lessonCount: lessonCount, lessons: lessons.map((l) => (l as LessonModel).toEntity()).toList());
  Map<String, dynamic> toCacheJson() => {'id': id, 'title': title, 'instructor': instructor, 'progress': progress, 'lessonCount': lessonCount, 'lessons': lessons.map((l) => LessonModel.fromEntity(l).toJson()).toList()};
}
