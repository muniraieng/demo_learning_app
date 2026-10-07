// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CoursesTable extends Courses with TableInfo<$CoursesTable, Course> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoursesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _instructorMeta =
      const VerificationMeta('instructor');
  @override
  late final GeneratedColumn<String> instructor = GeneratedColumn<String>(
      'instructor', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lessonCountMeta =
      const VerificationMeta('lessonCount');
  @override
  late final GeneratedColumn<int> lessonCount = GeneratedColumn<int>(
      'lesson_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lessonsJsonMeta =
      const VerificationMeta('lessonsJson');
  @override
  late final GeneratedColumn<String> lessonsJson = GeneratedColumn<String>(
      'lessons_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, instructor, progress, lessonCount, lessonsJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courses';
  @override
  VerificationContext validateIntegrity(Insertable<Course> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('instructor')) {
      context.handle(
          _instructorMeta,
          instructor.isAcceptableOrUnknown(
              data['instructor']!, _instructorMeta));
    } else if (isInserting) {
      context.missing(_instructorMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    } else if (isInserting) {
      context.missing(_progressMeta);
    }
    if (data.containsKey('lesson_count')) {
      context.handle(
          _lessonCountMeta,
          lessonCount.isAcceptableOrUnknown(
              data['lesson_count']!, _lessonCountMeta));
    } else if (isInserting) {
      context.missing(_lessonCountMeta);
    }
    if (data.containsKey('lessons_json')) {
      context.handle(
          _lessonsJsonMeta,
          lessonsJson.isAcceptableOrUnknown(
              data['lessons_json']!, _lessonsJsonMeta));
    } else if (isInserting) {
      context.missing(_lessonsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Course map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Course(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      instructor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructor'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      lessonCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lesson_count'])!,
      lessonsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lessons_json'])!,
    );
  }

  @override
  $CoursesTable createAlias(String alias) {
    return $CoursesTable(attachedDatabase, alias);
  }
}

class Course extends DataClass implements Insertable<Course> {
  final int id;
  final String title;
  final String instructor;
  final int progress;
  final int lessonCount;
  final String lessonsJson;
  const Course(
      {required this.id,
      required this.title,
      required this.instructor,
      required this.progress,
      required this.lessonCount,
      required this.lessonsJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['instructor'] = Variable<String>(instructor);
    map['progress'] = Variable<int>(progress);
    map['lesson_count'] = Variable<int>(lessonCount);
    map['lessons_json'] = Variable<String>(lessonsJson);
    return map;
  }

  CoursesCompanion toCompanion(bool nullToAbsent) {
    return CoursesCompanion(
      id: Value(id),
      title: Value(title),
      instructor: Value(instructor),
      progress: Value(progress),
      lessonCount: Value(lessonCount),
      lessonsJson: Value(lessonsJson),
    );
  }

  factory Course.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Course(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      instructor: serializer.fromJson<String>(json['instructor']),
      progress: serializer.fromJson<int>(json['progress']),
      lessonCount: serializer.fromJson<int>(json['lessonCount']),
      lessonsJson: serializer.fromJson<String>(json['lessonsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'instructor': serializer.toJson<String>(instructor),
      'progress': serializer.toJson<int>(progress),
      'lessonCount': serializer.toJson<int>(lessonCount),
      'lessonsJson': serializer.toJson<String>(lessonsJson),
    };
  }

  Course copyWith(
          {int? id,
          String? title,
          String? instructor,
          int? progress,
          int? lessonCount,
          String? lessonsJson}) =>
      Course(
        id: id ?? this.id,
        title: title ?? this.title,
        instructor: instructor ?? this.instructor,
        progress: progress ?? this.progress,
        lessonCount: lessonCount ?? this.lessonCount,
        lessonsJson: lessonsJson ?? this.lessonsJson,
      );
  Course copyWithCompanion(CoursesCompanion data) {
    return Course(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      instructor:
          data.instructor.present ? data.instructor.value : this.instructor,
      progress: data.progress.present ? data.progress.value : this.progress,
      lessonCount:
          data.lessonCount.present ? data.lessonCount.value : this.lessonCount,
      lessonsJson:
          data.lessonsJson.present ? data.lessonsJson.value : this.lessonsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Course(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('instructor: $instructor, ')
          ..write('progress: $progress, ')
          ..write('lessonCount: $lessonCount, ')
          ..write('lessonsJson: $lessonsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, instructor, progress, lessonCount, lessonsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Course &&
          other.id == this.id &&
          other.title == this.title &&
          other.instructor == this.instructor &&
          other.progress == this.progress &&
          other.lessonCount == this.lessonCount &&
          other.lessonsJson == this.lessonsJson);
}

class CoursesCompanion extends UpdateCompanion<Course> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> instructor;
  final Value<int> progress;
  final Value<int> lessonCount;
  final Value<String> lessonsJson;
  const CoursesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.instructor = const Value.absent(),
    this.progress = const Value.absent(),
    this.lessonCount = const Value.absent(),
    this.lessonsJson = const Value.absent(),
  });
  CoursesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String instructor,
    required int progress,
    required int lessonCount,
    required String lessonsJson,
  })  : title = Value(title),
        instructor = Value(instructor),
        progress = Value(progress),
        lessonCount = Value(lessonCount),
        lessonsJson = Value(lessonsJson);
  static Insertable<Course> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? instructor,
    Expression<int>? progress,
    Expression<int>? lessonCount,
    Expression<String>? lessonsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (instructor != null) 'instructor': instructor,
      if (progress != null) 'progress': progress,
      if (lessonCount != null) 'lesson_count': lessonCount,
      if (lessonsJson != null) 'lessons_json': lessonsJson,
    });
  }

  CoursesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? instructor,
      Value<int>? progress,
      Value<int>? lessonCount,
      Value<String>? lessonsJson}) {
    return CoursesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      progress: progress ?? this.progress,
      lessonCount: lessonCount ?? this.lessonCount,
      lessonsJson: lessonsJson ?? this.lessonsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (instructor.present) {
      map['instructor'] = Variable<String>(instructor.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (lessonCount.present) {
      map['lesson_count'] = Variable<int>(lessonCount.value);
    }
    if (lessonsJson.present) {
      map['lessons_json'] = Variable<String>(lessonsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoursesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('instructor: $instructor, ')
          ..write('progress: $progress, ')
          ..write('lessonCount: $lessonCount, ')
          ..write('lessonsJson: $lessonsJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CoursesTable courses = $CoursesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [courses];
}

typedef $$CoursesTableCreateCompanionBuilder = CoursesCompanion Function({
  Value<int> id,
  required String title,
  required String instructor,
  required int progress,
  required int lessonCount,
  required String lessonsJson,
});
typedef $$CoursesTableUpdateCompanionBuilder = CoursesCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> instructor,
  Value<int> progress,
  Value<int> lessonCount,
  Value<String> lessonsJson,
});

class $$CoursesTableFilterComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructor => $composableBuilder(
      column: $table.instructor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lessonCount => $composableBuilder(
      column: $table.lessonCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonsJson => $composableBuilder(
      column: $table.lessonsJson, builder: (column) => ColumnFilters(column));
}

class $$CoursesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructor => $composableBuilder(
      column: $table.instructor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lessonCount => $composableBuilder(
      column: $table.lessonCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonsJson => $composableBuilder(
      column: $table.lessonsJson, builder: (column) => ColumnOrderings(column));
}

class $$CoursesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get instructor => $composableBuilder(
      column: $table.instructor, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<int> get lessonCount => $composableBuilder(
      column: $table.lessonCount, builder: (column) => column);

  GeneratedColumn<String> get lessonsJson => $composableBuilder(
      column: $table.lessonsJson, builder: (column) => column);
}

class $$CoursesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CoursesTable,
    Course,
    $$CoursesTableFilterComposer,
    $$CoursesTableOrderingComposer,
    $$CoursesTableAnnotationComposer,
    $$CoursesTableCreateCompanionBuilder,
    $$CoursesTableUpdateCompanionBuilder,
    (Course, BaseReferences<_$AppDatabase, $CoursesTable, Course>),
    Course,
    PrefetchHooks Function()> {
  $$CoursesTableTableManager(_$AppDatabase db, $CoursesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoursesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoursesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoursesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> instructor = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<int> lessonCount = const Value.absent(),
            Value<String> lessonsJson = const Value.absent(),
          }) =>
              CoursesCompanion(
            id: id,
            title: title,
            instructor: instructor,
            progress: progress,
            lessonCount: lessonCount,
            lessonsJson: lessonsJson,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String instructor,
            required int progress,
            required int lessonCount,
            required String lessonsJson,
          }) =>
              CoursesCompanion.insert(
            id: id,
            title: title,
            instructor: instructor,
            progress: progress,
            lessonCount: lessonCount,
            lessonsJson: lessonsJson,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CoursesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CoursesTable,
    Course,
    $$CoursesTableFilterComposer,
    $$CoursesTableOrderingComposer,
    $$CoursesTableAnnotationComposer,
    $$CoursesTableCreateCompanionBuilder,
    $$CoursesTableUpdateCompanionBuilder,
    (Course, BaseReferences<_$AppDatabase, $CoursesTable, Course>),
    Course,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CoursesTableTableManager get courses =>
      $$CoursesTableTableManager(_db, _db.courses);
}
