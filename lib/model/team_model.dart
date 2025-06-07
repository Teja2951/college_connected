// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
class Team {
  final String? id;           
  final String teamName;
  final String joinPin;          
  final List<String> memberIds;  
  final String teamLeaderId;   
  final bool isSubmitted;
  final int min;
  final int max;
  Team({
   this.id,
    required this.teamName,
    required this.joinPin,
    required this.memberIds,
    required this.teamLeaderId,
    required this.isSubmitted,
    required this.min,
    required this.max,
  });

  Team copyWith({
    required String id,
    String? teamName,
    String? joinPin,
    List<String>? memberIds,
    String? teamLeaderId,
    bool? isSubmitted,
    int? min,
    int? max,
  }) {
    return Team(
      id: id,
      teamName: teamName ?? this.teamName,
      joinPin: joinPin ?? this.joinPin,
      memberIds: memberIds ?? this.memberIds,
      teamLeaderId: teamLeaderId ?? this.teamLeaderId,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'teamName': teamName,
      'joinPin': joinPin,
      'memberIds': memberIds,
      'teamLeaderId': teamLeaderId,
      'isSubmitted': isSubmitted,
      'min': min,
      'max': max,
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'] as String,
      teamName: map['teamName'] as String,
      joinPin: map['joinPin'] as String,
      memberIds: List<String>.from(map['memberIds'] ?? []),
      teamLeaderId: map['teamLeaderId'] as String,
      isSubmitted: map['isSubmitted'] as bool,
      min: map['min'] as int,
      max: map['max'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Team.fromJson(String source) => Team.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Team(id: $id, teamName: $teamName, joinPin: $joinPin, memberIds: $memberIds, teamLeaderId: $teamLeaderId, isSubmitted: $isSubmitted, min: $min, max: $max)';
  }
}
