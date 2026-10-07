import 'package:equatable/equatable.dart';
import 'lesson.dart';
class Course extends Equatable {
  const Course({required this.id, required this.title, required this.instructor, required this.progress, required this.lessonCount, this.lessons = const []});
  final int id;
  final String title;
  final String instructor;
  final int progress;
  final int lessonCount;
  final List<Lesson> lessons;
  Course copyWith({int? progress, List<Lesson>? lessons}) => Course(id: id, title: title, instructor: instructor, progress: progress ?? this.progress, lessonCount: lessonCount, lessons: lessons ?? this.lessons);
  @override
  List<Object?> get props => [id, title, instructor, progress, lessonCount, lessons];
}
