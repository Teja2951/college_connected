import 'dart:convert';
import 'package:college_connectd/model/couse_attendance_model.dart';

class AttendanceModel {
  final int totalPresent;
  final int totalAbsent;
  final int totalClasses;
  final double totalPercentage;
  final List<CouseAttendanceModel> courses;

  AttendanceModel({
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalClasses,
    required this.totalPercentage,
    required this.courses,
  });


  AttendanceModel copyWith({
    int? totalPresent,
    int? totalAbsent,
    int? totalClasses,
    double? totalPercentage,
    List<CouseAttendanceModel>? courses,
  }) {
    return AttendanceModel(
      totalPresent: totalPresent ?? this.totalPresent,
      totalAbsent: totalAbsent ?? this.totalAbsent,
      totalClasses: totalClasses ?? this.totalClasses,
      totalPercentage: totalPercentage ?? this.totalPercentage,
      courses: courses ?? this.courses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalPresent': totalPresent,
      'totalAbsent': totalAbsent,
      'totalClasses': totalClasses,
      'percentage': totalPercentage,
      'courses': courses.map((x) => x.toMap()).toList(),
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    // print('cousess length ${map[]}');
    print(map['courseAttendance']);
    return AttendanceModel(
      totalPresent: map['totalPresent'] as int,
      totalAbsent: map['totalAbsent'] as int,
      totalClasses: map['totalClasses'] as int,
      totalPercentage: map['percentage'] as double,
      courses: List<CouseAttendanceModel>.from((map['courseAttendance'] ?? []).map((course) => CouseAttendanceModel.fromMap(course))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceModel.fromJson(String source) => AttendanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AttendanceModel(totalPresent: $totalPresent, totalAbsent: $totalAbsent, totalClasses: $totalClasses, totalPercentage: $totalPercentage, courses: $courses)';
  }
}
