import 'package:demo_mobile_learning_app/core/errors/failures.dart';
import 'package:demo_mobile_learning_app/core/network/network_info.dart';
import 'package:demo_mobile_learning_app/data/datasources/course_local_datasource.dart';
import 'package:demo_mobile_learning_app/data/datasources/course_remote_datasource.dart';
import 'package:demo_mobile_learning_app/data/models/course_model.dart';
import 'package:demo_mobile_learning_app/data/models/lesson_model.dart';
import 'package:demo_mobile_learning_app/data/repositories/course_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements CourseRemoteDataSource {}

class MockLocal extends Mock implements CourseLocalDataSource {}

class MockNetwork extends Mock implements NetworkInfo {}

void main() {
  late MockRemote remote;
  late MockLocal local;
  late MockNetwork network;
  late CourseRepositoryImpl repo;

  final course = CourseModel(
    id: 1,
    title: 'Python',
    instructor: 'John',
    progress: 50,
    lessonCount: 2,
    lessons: const [
      LessonModel(id: 1, courseId: 1, title: 'Intro', isCompleted: true),
      LessonModel(id: 2, courseId: 1, title: 'Vars', isCompleted: false),
    ],
  );

  setUpAll(() {
    registerFallbackValue(<Map<String, dynamic>>[]);
  });

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    network = MockNetwork();
    repo = CourseRepositoryImpl(
        remote: remote, local: local, networkInfo: network);
  });

  test('online: fetches remote, caches it, and returns courses', () async {
    when(() => network.isConnected).thenAnswer((_) async => true);
    when(() => remote.fetchCourses()).thenAnswer((_) async => [course]);
    when(() => local.cacheCourses(any())).thenAnswer((_) async {});
    when(() => local.getCachedCourses()).thenAnswer((_) async => []);

    final (failure, courses) = await repo.getCourses();

    expect(failure, isNull);
    expect(courses, hasLength(1));
    verify(() => local.cacheCourses(any())).called(1);
  });

  test('offline: returns cached courses when remote unavailable', () async {
    when(() => network.isConnected).thenAnswer((_) async => false);
    when(() => local.getCachedCourses()).thenAnswer((_) async => [
          course.toCacheJson(),
        ]);

    final (failure, courses) = await repo.getCourses();

    expect(failure, isNull);
    expect(courses!.first.title, 'Python');
  });

  test('offline with empty cache returns CacheFailure', () async {
    when(() => network.isConnected).thenAnswer((_) async => false);
    when(() => local.getCachedCourses()).thenAnswer((_) async => []);

    final (failure, courses) = await repo.getCourses();

    expect(failure, isA<CacheFailure>());
    expect(courses, isNull);
  });

  test('markLessonCompleted updates progress to 100 when all done', () async {
    final doneCourse = CourseModel(
      id: 1,
      title: 'Python',
      instructor: 'John',
      progress: 100,
      lessonCount: 2,
      lessons: const [
        LessonModel(id: 1, courseId: 1, title: 'Intro', isCompleted: true),
        LessonModel(id: 2, courseId: 1, title: 'Vars', isCompleted: true),
      ],
    );
    when(() => local.markLessonCompleted(
          courseId: any(named: 'courseId'),
          lessonId: any(named: 'lessonId'),
          isCompleted: any(named: 'isCompleted'),
        )).thenAnswer((_) async {});
    when(() => local.getCachedCourses())
        .thenAnswer((_) async => [doneCourse.toCacheJson()]);

    final (failure, updated) =
        await repo.markLessonCompleted(courseId: 1, lessonId: 2);

    expect(failure, isNull);
    expect(updated!.progress, 100);
    expect(updated.lessons.every((l) => l.isCompleted), isTrue);
  });
}
