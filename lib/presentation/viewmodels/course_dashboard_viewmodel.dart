import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/course.dart';
import '../../domain/usecases/get_courses_usecase.dart';

enum DashboardState { initial, loading, success, empty, error }

class CourseDashboardViewModel extends GetxController {
  CourseDashboardViewModel(this._getCourses);

  static const int pageSize = 20;

  final GetCoursesUseCase _getCourses;

  final state = DashboardState.initial.obs;
  final allCourses = <Course>[].obs;
  final courses = <Course>[].obs;
  final Rx<Failure?> failure = Rx<Failure?>(null);
  final isLoadingMore = false.obs;
  final scrollController = ScrollController();

  bool get hasMore => courses.length < allCourses.length;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    load();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      loadMore();
    }
  }

  Future<void> load() async {
    if (state.value == DashboardState.loading) return;
    state.value = DashboardState.loading;
    final (f, data) = await _getCourses();
    if (f != null) {
      failure.value = f;
      state.value = DashboardState.error;
      return;
    }
    allCourses.assignAll(data ?? const []);
    courses.assignAll(allCourses.take(pageSize));
    state.value = allCourses.isEmpty ? DashboardState.empty : DashboardState.success;
  }

  void updateCourse(Course updated) {
    final i = allCourses.indexWhere((c) => c.id == updated.id);
    if (i != -1) allCourses[i] = updated;
    final j = courses.indexWhere((c) => c.id == updated.id);
    if (j != -1) courses[j] = updated;
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore) return;
    isLoadingMore.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    final nextCount = courses.length + pageSize;
    courses.assignAll(allCourses.take(nextCount));
    isLoadingMore.value = false;
  }

  @override
  Future<void> refresh() async {
    state.value = DashboardState.initial;
    courses.clear();
    await load();
  }
}
