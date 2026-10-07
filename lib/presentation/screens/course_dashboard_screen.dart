import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/storage/secure_token_storage.dart';
import '../viewmodels/course_dashboard_viewmodel.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';
import 'login_screen.dart';

class CourseDashboardScreen extends GetView<CourseDashboardViewModel> {
  const CourseDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final storage = Get.find<SecureTokenStorage>();
              await storage.deleteToken();
              Get.offAll(() => const LoginScreen());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
        switch (controller.state.value) {
          case DashboardState.loading:
          case DashboardState.initial:
            return const Center(child: CircularProgressIndicator());
          case DashboardState.empty:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_outlined, size: 48.sp, color: Colors.grey),
                  SizedBox(height: 12.h),
                  Text('No courses available.', style: TextStyle(fontSize: 16.sp)),
                ],
              ),
            );
          case DashboardState.error:
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off, size: 48.sp, color: Colors.grey),
                    SizedBox(height: 12.h),
                    Text(
                      controller.failure.value?.message ?? 'Something went wrong',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    SizedBox(height: 16.h),
                    FilledButton.icon(
                      onPressed: controller.refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          case DashboardState.success:
            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: controller.courses.length + (controller.isLoadingMore.value ? 1 : 0),
                itemBuilder: (_, i) {
                  if (i >= controller.courses.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(
                        child: SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: const CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    );
                  }
                  final c = controller.courses[i];
                  return CourseCard(
                    course: c,
                    onContinue: () => Get.to(() => CourseDetailScreen(courseId: c.id)),
                  );
                },
              ),
            );
          }
        }),
      ),
    );
  }
}
