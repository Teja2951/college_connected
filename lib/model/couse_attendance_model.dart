import 'dart:convert';

class CouseAttendanceModel {
  final String courseName;
  final int totalPresent;
  final int totalAbsent;
  final int totalClasses;
  final double percentage;
  final int totalScheduledClasses;
  
  CouseAttendanceModel({
    required this.courseName,
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalClasses,
    required this.percentage,
    required this.totalScheduledClasses,
  });


  CouseAttendanceModel copyWith({
    String? courseName,
    int? totalPresent,
    int? totalAbsent,
    int? totalClasses,
    double? percentage,
    int? totalScheduledClasses,
  }) {
    return CouseAttendanceModel(
      courseName: courseName ?? this.courseName,
      totalPresent: totalPresent ?? this.totalPresent,
      totalAbsent: totalAbsent ?? this.totalAbsent,
      totalClasses: totalClasses ?? this.totalClasses,
      percentage: percentage ?? this.percentage,
      totalScheduledClasses: totalScheduledClasses ?? this.totalScheduledClasses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseName': courseName,
      'totalPresent': totalPresent,
      'totalAbsent': totalAbsent,
      'totalClasses': totalClasses,
      'percentage': percentage,
      'totalScheduledClasses': totalScheduledClasses,
    };
  }

  factory CouseAttendanceModel.fromMap(Map<String, dynamic> map) {
    print('------------------------------------------------------');
    int tital = 0;
    // print(map);
    final l = (map['components'][0]['attendance'] as List).forEach((e) {
      if(e['id']!= null){
        tital++;
      }
    });
    return CouseAttendanceModel(
      courseName: map['courseName'] as String,
      totalPresent: map['totalPresent'] as int,
      totalAbsent: map['totalAbsent'] as int,
      totalClasses: map['totalClasses'] as int,
      percentage: map['percentage'] as double,
      totalScheduledClasses: tital,
    );
  }

  String toJson() => json.encode(toMap());

  factory CouseAttendanceModel.fromJson(String source) => CouseAttendanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CouseAttendanceModel(courseName: $courseName, totalPresent: $totalPresent, totalAbsent: $totalAbsent, totalClasses: $totalClasses, percentage: $percentage, totalScheduledClasses: $totalScheduledClasses)';
  }

  @override
  bool operator ==(covariant CouseAttendanceModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.courseName == courseName &&
      other.totalPresent == totalPresent &&
      other.totalAbsent == totalAbsent &&
      other.totalClasses == totalClasses &&
      other.percentage == percentage &&
      other.totalScheduledClasses == totalScheduledClasses;
  }

  @override
  int get hashCode {
    return courseName.hashCode ^
      totalPresent.hashCode ^
      totalAbsent.hashCode ^
      totalClasses.hashCode ^
      percentage.hashCode ^
      totalScheduledClasses.hashCode;
  }
}
