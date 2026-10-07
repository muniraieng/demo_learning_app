import 'package:demo_mobile_learning_app/domain/entities/lesson.dart';
import 'package:flutter_test/flutter_test.dart';

int calculateProgress(List<Lesson> lessons) {
  if (lessons.isEmpty) return 0;
  final done = lessons.where((l) => l.isCompleted).length;
  return ((done / lessons.length) * 100).round();
}

void main() {
  Lesson l(int id, bool done) =>
      Lesson(id: id, courseId: 1, title: 'L$id', isCompleted: done);

  test('progress is 0 when no lesson completed', () {
    expect(calculateProgress([l(1, false), l(2, false)]), 0);
  });

  test('progress updates when a lesson is marked complete', () {
    final before = [l(1, true), l(2, true), l(3, false), l(4, false)];
    expect(calculateProgress(before), 50);
    final after = before.map((e) => e.id == 3 ? e.copyWith(isCompleted: true) : e).toList();
    expect(calculateProgress(after), 75);
  });

  test('progress is 100 when all lessons completed', () {
    expect(calculateProgress([l(1, true), l(2, true)]), 100);
  });
}
