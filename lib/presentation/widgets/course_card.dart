import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/course.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course, required this.onContinue});

  final Course course;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Instructor: ${course.instructor}',
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
            ),
            Text(
              '${course.lessonCount} lessons',
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: course.progress / 100,
                    minHeight: 8.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '${course.progress}%',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 8.w),
                FilledButton(
                  onPressed: onContinue,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    textStyle: TextStyle(fontSize: 13.sp),
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
            if (course.lessons.any((l) => l.isCompleted)) ...[
              SizedBox(height: 8.h),
              Text(
                'Selected lessons:',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.grey[700]),
              ),
              SizedBox(height: 4.h),
              Wrap(
                spacing: 6.w,
                runSpacing: 4.h,
                children: course.lessons
                    .where((l) => l.isCompleted)
                    .map(
                      (l) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.green[300]!),
                        ),
                        child: Text(
                          l.title,
                          style: TextStyle(fontSize: 11.sp, color: Colors.green[800]),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
