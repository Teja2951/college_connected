import 'package:college_connectd/attendance/controller/live_attdnc_controller.dart';
import 'package:college_connectd/attendance/repository/live_attdnc_repository.dart';
import 'package:college_connectd/model/attendance_model.dart';
import 'package:college_connectd/model/couse_attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class LiveAttendence extends ConsumerStatefulWidget {
  const LiveAttendence({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LiveAttendenceState();
}

class _LiveAttendenceState extends ConsumerState<LiveAttendence> {
  bool _isFirstBuild = true;
  double _targetPercentage = 75.0;

  @override
  Widget build(BuildContext context) {
    final termAsync = ref.watch(termDataProvider);
    final _selectedFilter = ref.watch(selectedTermProvider);

    // the drop down gets the values from termasync its list of map containing ids and termname dropdown should show all the term names and when user selects a particular term the selected term provider state will update and tht attendance will be shown

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Routemaster.of(context).pop(),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:  DropdownButtonHideUnderline(
    child: DropdownButton<int>(
      value: _selectedFilter,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
      dropdownColor: Colors.black,
      underline: Divider(color: Colors.white,thickness: 2,),
      borderRadius: BorderRadius.circular(16),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      items: termAsync.when(
      data: (terms) => terms.map((term) {
      return DropdownMenuItem<int>(
        value: term['id'],
        child: Text(term['termName']),
      );
    }).toList(),
      error: (a,sa) => [DropdownMenuItem(child: Text('null'))],
      loading: () => [],
      ),
      onChanged: (int? newTerm) {
        if (newTerm != null) {
          ref.read(selectedTermProvider.notifier).state = newTerm;
        }
      },
    ),
  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Smart Attendance',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A1A),
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Now decide maintain your attendance like a pro!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        
              termAsync.when(
              data: (t_data) {
                if (_isFirstBuild && t_data.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref.read(selectedTermProvider.notifier).state = t_data[0]['id'];
                  });
                  _isFirstBuild = false;
                }
                
                final attendanceAsync = ref.watch(attendanceProvider(ref.read(selectedTermProvider) ?? t_data[0]['id']));
                return attendanceAsync.when(
                  data: (a_data) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Overall Attendance Card
                          _buildOverallAttendanceCard(a_data),
                          
                          const SizedBox(height: 24),
                          
                          // Target Percentage Section
                          _buildTargetSection(),
                          
                          const SizedBox(height: 24),
                          
                          // Subjects Header
                          const Text(
                            'Subject-wise Attendance',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Subject Cards
                          ...a_data.courses.map((course) => _buildSubjectCard(course)),
                        ],
                      ),
                    );
                  },
                  error: (e, s) => _buildErrorState(),
                  loading: () => const Center(child: CircularProgressIndicator()),
                );
              },
              error: (e, s) => _buildErrorState(),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallAttendanceCard(AttendanceModel attendance) {
    final percentage = attendance.totalPercentage;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Overall', '${percentage.toStringAsFixed(1)}%', Icons.school),
          _buildStatItem('Present', '${attendance.totalPresent}', Icons.check),
          _buildStatItem('Total Classes', '${attendance.totalClasses}', Icons.calendar_today),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTargetSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Target Attendance:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 60,
                height: 35,
                child: TextFormField(
                  initialValue: _targetPercentage.toInt().toString(),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffix: const Text('%', style: TextStyle(fontSize: 12)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue[600]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    filled: true,
                    fillColor: Colors.blue[50],
                  ),
                  onChanged: (value) {
                    final newValue = double.tryParse(value);
                    if (newValue != null && newValue >= 0 && newValue <= 100) {
                      setState(() {
                        _targetPercentage = newValue;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Text('Set your desired Attendance to calculate the Bunks/Need to attend classes data instantly',
          style: TextStyle(
            fontSize: 13,
            color: Colors.blueGrey,
          ),)
        ],
      ),
    );
  }

  Widget _buildSubjectCard(CouseAttendanceModel course) {
    final percentage = course.percentage;
    final classesNeeded = _calculateClassesNeeded(course);
    final canBunk = _calculateCanBunk(course);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.book,
              color: Colors.blue[700],
            ),
          ),
          title: Text(
            course.courseName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            '${percentage.toStringAsFixed(1)}% • ${course.totalPresent}/${course.totalClasses} classes',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          children: [
            _buildSubjectDetails(course, classesNeeded, canBunk),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectDetails(CouseAttendanceModel course, int classesNeeded, int canBunk) {
    final percentage = course.percentage;
    final isAboveTarget = percentage >= _targetPercentage;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Bar
          Row(
            children: [
              const Text('Progress: ', style: TextStyle(fontWeight: FontWeight.w500)),
              Expanded(
                child: LinearProgressIndicator(
                  value: course.percentage / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(Colors.blue[600]),
                ),
              ),
              const SizedBox(width: 8),
              Text('${course.percentage.toStringAsFixed(1)}%'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Statistics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailStat('Present', '${course.totalPresent}', Colors.blue),
              _buildDetailStat('Absent', '${course.totalAbsent}', Colors.grey),
              _buildDetailStat('Scheduled', '${course.totalScheduledClasses}', Colors.indigo),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Bunk/Attend Information
          if (isAboveTarget && canBunk > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.green[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You can Bunk $canBunk more classes to maintain ${_targetPercentage.toInt()}%',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (!isAboveTarget && classesNeeded > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'you have to Attend $classesNeeded more classes to reach ${_targetPercentage.toInt()}%',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  int _calculateClassesNeeded(CouseAttendanceModel course) {
    final targetClasses = (course.totalScheduledClasses * _targetPercentage / 100).ceil();
    return (targetClasses - course.totalPresent).clamp(0, course.totalScheduledClasses);
  }

  int _calculateCanBunk(CouseAttendanceModel course) {
    final minRequiredClasses = (course.totalScheduledClasses * _targetPercentage / 100).ceil();
    return (course.totalPresent - minRequiredClasses).clamp(0, course.totalPresent);
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Attendance not released yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for updates',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}