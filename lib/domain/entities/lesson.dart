import 'package:equatable/equatable.dart';
class Lesson extends Equatable {
  const Lesson({required this.id, required this.courseId, required this.title, required this.isCompleted});
  final int id;
  final int courseId;
  final String title;
  final bool isCompleted;
  Lesson copyWith({bool? isCompleted}) => Lesson(id: id, courseId: courseId, title: title, isCompleted: isCompleted ?? this.isCompleted);
  @override
  List<Object?> get props => [id, courseId, title, isCompleted];
}
