import 'package:college_connectd/attendance/repository/live_attdnc_repository.dart';
import 'package:college_connectd/model/attendance_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final termDataProvider = FutureProvider<List<Map<String, dynamic>>>((ref){
  return ref.read(LiveAttdncRepositoryProvider).getTermData();
});

final attendanceProvider = FutureProvider.family<AttendanceModel,int>((ref,termNo) {
   return ref.read(LiveAttdncRepositoryProvider).getAttendance(termNo);
});

final selectedTermProvider = StateProvider<int?>((ref) {
  final data = ref.read(termDataProvider);

  return null;
});