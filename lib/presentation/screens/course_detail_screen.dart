import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../viewmodels/course_detail_viewmodel.dart';

class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(courseDetailViewModelProvider(courseId));
    final vm = ref.read(courseDetailViewModelProvider(courseId).notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: SafeArea(
        child: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.failure != null && state.course == null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, size: 48.sp, color: Colors.grey),
                        SizedBox(height: 12.h),
                        Text(
                          state.failure!.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15.sp),
                        ),
                        SizedBox(height: 16.h),
                        FilledButton(
                          onPressed: () => vm.load(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _buildContent(context, state, vm),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CourseDetailState state, CourseDetailViewModel vm) {
    final course = state.course!;
    return RefreshIndicator(
      onRefresh: () async => vm.load(),
      child: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Text(
            course.title,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6.h),
          Text(
            'Instructor: ${course.instructor}',
            style: TextStyle(fontSize: 15.sp, color: Colors.grey[700]),
          ),
          SizedBox(height: 4.h),
          Text(
            '${course.lessonCount} lessons',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: course.progress / 100,
                  minHeight: 10.h,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                '${course.progress}%',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            'Lessons',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          ...course.lessons.map((lesson) => Card(
                margin: EdgeInsets.only(bottom: 8.h),
                child: ListTile(
                  leading: Icon(
                    lesson.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: lesson.isCompleted ? Colors.green : Colors.grey,
                    size: 28.sp,
                  ),
                  title: Text(
                    lesson.title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      decoration: lesson.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(
                    lesson.isCompleted ? 'Completed' : 'Pending',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: lesson.isCompleted ? Colors.green : Colors.orange[700],
                    ),
                  ),
                  trailing: lesson.isCompleted
                      ? TextButton(
                          onPressed: () => vm.uncompleteLesson(lesson.id),
                          child: Text('Undo', style: TextStyle(fontSize: 13.sp)),
                        )
                      : TextButton(
                          onPressed: () => vm.completeLesson(lesson.id),
                          child: Text('Mark complete', style: TextStyle(fontSize: 13.sp)),
                        ),
                ),
              )),
        ],
      ),
    );
  }
}
