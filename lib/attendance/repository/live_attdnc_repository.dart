import 'dart:convert';

import 'package:college_connectd/auth/controller/auth_controller.dart';
import 'package:college_connectd/model/attendance_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final LiveAttdncRepositoryProvider = Provider((ref) {
  return LiveAttdncRepository(ref: ref);
});

class LiveAttdncRepository {
  final Ref _ref;

  LiveAttdncRepository({required Ref ref}) : _ref = ref;

  Future<AttendanceModel> getAttendance(int termNo, {bool retrying = false}) async {
  final token = _ref.read(userProvider)?.token;
  final ukid = _ref.read(userProvider)?.ukid;
  print('Token fetched from cache: $token');

  try {
    final response = await http.get(
      Uri.parse('https://gmrit.digiicampus.com/api/attendance/student/$ukid/term/$termNo'),
      headers: {'Auth-Token': token ?? ''},
    );

    if (response.statusCode != 200) {
      print('Error ${response.statusCode}. Token might be expired.');

      // Retry only once
      if (!retrying) {
        print('Trying to refresh token...');
        await _ref.read(authControllerProvider.notifier).refreshUser();
        return await getAttendance(termNo, retrying: true);
      } else {
        throw Exception('Request failed even after token refresh.');
      }
    }

    final body = jsonDecode(response.body);
    final aModel = AttendanceModel.fromMap(body);
    // print(body['courseAttendance'])
    return aModel;
  } catch (e, st) {
    print('Error in getAttendance: $e\n$st');
    rethrow;
  }
}

  Future<List<Map<String,dynamic>>> getTermData({bool retrying = false}) async{
    final token = _ref.read(userProvider)?.token;
    final year = DateTime.now().year - _ref.read(userProvider)!.year! + 1;
    try {
    final response = await http.get(
      Uri.parse('https://gmrit.digiicampus.com/rest/terms/programmeBatchTerms?batch=$year&programme=11'),
      headers: {'Auth-Token': token ?? ''},
    );

    if (response.statusCode != 200) {
      print('Error ${response.statusCode}. Token might be expired.');

      // Retry only once
      if (!retrying) {
        print('Trying to refresh token...');
        await _ref.read(authControllerProvider.notifier).refreshUser();
        return await getTermData(retrying: true);
      } else {
        throw Exception('Request failed even after token refresh.');
      }
    }

    final body = jsonDecode(response.body);
    final te = (body['terms'] as List).map((e) => e as Map<String,dynamic>).toList();
    List<Map<String,dynamic>> transformed = te.map((eachmap) {
      return {
        'id' : eachmap['id'],
        'termName' : eachmap['name']
      };
    }).toList();

    print(transformed);
    return transformed;


  } catch (e, st) {
    print('Error in getting term: $e\n$st');
    rethrow;
  }
  }
  
}
