import 'package:drift/drift.dart';
class Courses extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get instructor => text()();
  IntColumn get progress => integer()();
  IntColumn get lessonCount => integer()();
  TextColumn get lessonsJson => text()();
  @override
  Set<Column> get primaryKey => {id};
}
