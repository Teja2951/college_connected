// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class EventModel {
  final String id;
  final String title;
  final String shortDescription;
  final String venue;
  final String prizeMoney;
  final String description;
  final String rules;
  final DateTime startTime;
  final DateTime endTime;
  final String eligibility;
  final int registrationCount;
  final List<String> tracks;
  final String department; 
  final bool isTeamEvent;
  final int minTeamSize;
  final int maxTeamSize;
  final bool isRegistrationOpen;
  EventModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.venue,
    required this.prizeMoney,
    required this.description,
    required this.rules,
    required this.startTime,
    required this.endTime,
    required this.eligibility,
    required this.registrationCount,
    required this.tracks,
    required this.department,
    required this.isTeamEvent,
    required this.minTeamSize,
    required this.maxTeamSize,
    required this.isRegistrationOpen,
  });



  EventModel copyWith({
    String? id,
    String? title,
    String? shortDescription,
    String? venue,
    String? prizeMoney,
    String? description,
    String? rules,
    DateTime? startTime,
    DateTime? endTime,
    String? eligibility,
    int? registrationCount,
    List<String>? tracks,
    String? department,
    bool? isTeamEvent,
    int? minTeamSize,
    int? maxTeamSize,
    bool? isRegistrationOpen,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      venue: venue ?? this.venue,
      prizeMoney: prizeMoney ?? this.prizeMoney,
      description: description ?? this.description,
      rules: rules ?? this.rules,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      eligibility: eligibility ?? this.eligibility,
      registrationCount: registrationCount ?? this.registrationCount,
      tracks: tracks ?? this.tracks,
      department: department ?? this.department,
      isTeamEvent: isTeamEvent ?? this.isTeamEvent,
      minTeamSize: minTeamSize ?? this.minTeamSize,
      maxTeamSize: maxTeamSize ?? this.maxTeamSize,
      isRegistrationOpen: isRegistrationOpen ?? this.isRegistrationOpen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'shortDescription': shortDescription,
      'venue': venue,
      'prizeMoney': prizeMoney,
      'description': description,
      'rules': rules,
      'startTime': startTime,
      'endTime': endTime,
      'eligibility': eligibility,
      'registrationCount': registrationCount,
      'tracks': tracks,
      'department': department,
      'isTeamEvent': isTeamEvent,
      'minTeamSize': minTeamSize,
      'maxTeamSize': maxTeamSize,
      'isRegistrationOpen': isRegistrationOpen,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map,String id) {
    return EventModel(
      id: id,
      title: map['title'] as String,
      shortDescription: map['shortDescription'] as String,
      venue: map['venue'] as String,
      prizeMoney: map['prizeMoney'] as String,
      description: map['description'] as String,
      rules: map['rules'] as String,
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      eligibility: map['eligibility'] as String,
      registrationCount: map['registrationCount'] as int,
      tracks: List<String>.from(map['tracks'] ?? []),
      department: map['department'],
      isRegistrationOpen: map['isRegistrationOpen'],
      isTeamEvent: map['isTeamEvent'],
      maxTeamSize: map['maxTeamSize'],
      minTeamSize: map['minTeamSize'],
    );
  }
  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, shortDescription: $shortDescription, venue: $venue, prizeMoney: $prizeMoney, description: $description, rules: $rules, startTime: $startTime, endTime: $endTime, eligibility: $eligibility, registrationCount: $registrationCount, tracks: $tracks, department: $department, isTeamEvent: $isTeamEvent, minTeamSize: $minTeamSize, maxTeamSize: $maxTeamSize, isRegistrationOpen: $isRegistrationOpen)';
  }
}
