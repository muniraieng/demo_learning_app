import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../models/course_model.dart';
class CourseRemoteDataSource {
  Future<List<CourseModel>> fetchCourses() async {
    try {
      final raw = await rootBundle.loadString(AppConstants.mockCoursesAsset);
      final list = json.decode(raw) as List<dynamic>;
      return list.map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ServerFailure('Failed to load courses: $e');
    }
  }
}
