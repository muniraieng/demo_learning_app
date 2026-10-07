import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/lesson_model.dart';
import 'tables.dart';
part 'app_database.g.dart';
@DriftDatabase(tables: [Courses])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
  Future<void> cacheCourses(List<Map<String, dynamic>> coursesJson) async {
    await batch((b) {
      b.deleteAll(courses);
      b.insertAllOnConflictUpdate(courses, coursesJson.map((c) => CoursesCompanion(id: Value(c['id'] as int), title: Value(c['title'] as String), instructor: Value(c['instructor'] as String), progress: Value(c['progress'] as int), lessonCount: Value(c['lessonCount'] as int), lessonsJson: Value(jsonEncode(c['lessons'] ?? [])))).toList());
    });
  }
  Future<List<Map<String, dynamic>>> getCachedCourses() async {
    final rows = await select(courses).get();
    return rows.map((r) => {'id': r.id, 'title': r.title, 'instructor': r.instructor, 'progress': r.progress, 'lessonCount': r.lessonCount, 'lessons': jsonDecode(r.lessonsJson) as List<dynamic>}).toList();
  }
  Future<void> updateLessonCompletion({required int courseId, required int lessonId, required bool isCompleted}) async {
    final row = await (select(courses)..where((c) => c.id.equals(courseId))).getSingleOrNull();
    if (row == null) return;
    final lessons = (jsonDecode(row.lessonsJson) as List<dynamic>).map((e) => LessonModel.fromJson(e as Map<String, dynamic>)).toList();
    final updated = lessons.map((l) => l.id == lessonId ? l.copyWith(isCompleted: isCompleted) : l).toList();
    final total = updated.length;
    final done = updated.where((l) => l.isCompleted).length;
    final newProgress = total == 0 ? 0 : ((done / total) * 100).round();
    await (update(courses)..where((c) => c.id.equals(courseId))).write(CoursesCompanion(progress: Value(newProgress), lessonsJson: Value(jsonEncode(updated.map((l) => LessonModel.fromEntity(l).toJson()).toList()))));
  }
}
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/learning_dashboard.sqlite');
    return NativeDatabase.createInBackground(file);
  });
}
