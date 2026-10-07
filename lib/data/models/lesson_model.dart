import '../../domain/entities/lesson.dart';
class LessonModel extends Lesson {
  const LessonModel({required super.id, required super.courseId, required super.title, required super.isCompleted});
  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(id: json['id'] as int, courseId: json['courseId'] as int, title: json['title'] as String, isCompleted: json['isCompleted'] as bool? ?? false);
  Map<String, dynamic> toJson() => {'id': id, 'courseId': courseId, 'title': title, 'isCompleted': isCompleted};
  factory LessonModel.fromEntity(Lesson l) => LessonModel(id: l.id, courseId: l.courseId, title: l.title, isCompleted: l.isCompleted);
  Lesson toEntity() => Lesson(id: id, courseId: courseId, title: title, isCompleted: isCompleted);
}
