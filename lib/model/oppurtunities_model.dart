// models/opportunity_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum OpportunityType { internship, hackathon }

class OpportunityModel {
  final String id;
  final String title;
  final String company;
  final String description;
  final String location;
  final String duration;
  final List<String> requirements;
  final List<String> skills;
  final String applicationLink;
  final DateTime deadline;
  final DateTime postedDate;
  final OpportunityType type;
  final String? logoUrl;
  final String? stipend;
  final bool isRemote;
  final bool isActive;

  OpportunityModel({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.location,
    required this.duration,
    required this.requirements,
    required this.skills,
    required this.applicationLink,
    required this.deadline,
    required this.postedDate,
    required this.type,
    this.logoUrl,
    this.stipend,
    this.isRemote = false,
    this.isActive = true,
  });

  // Convert from Firestore document
  factory OpportunityModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OpportunityModel(
      id: documentId,
      title: map['title'] ?? '',
      company: map['company'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      duration: map['duration'] ?? '',
      requirements: List<String>.from(map['requirements'] ?? []),
      skills: List<String>.from(map['skills'] ?? []),
      applicationLink: map['applicationLink'] ?? '',
      deadline: (map['deadline'] as Timestamp).toDate(),
      postedDate: (map['postedDate'] as Timestamp).toDate(),
      type: OpportunityType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => OpportunityType.internship,
      ),
      logoUrl: map['logoUrl'],
      stipend: map['stipend'],
      isRemote: map['isRemote'] ?? false,
      isActive: map['isActive'] ?? true,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'description': description,
      'location': location,
      'duration': duration,
      'requirements': requirements,
      'skills': skills,
      'applicationLink': applicationLink,
      'deadline': Timestamp.fromDate(deadline),
      'postedDate': Timestamp.fromDate(postedDate),
      'type': type.toString().split('.').last,
      'logoUrl': logoUrl,
      'stipend': stipend,
      'isRemote': isRemote,
      'isActive': isActive,
    };
  }

  OpportunityModel copyWith({
    String? id,
    String? title,
    String? company,
    String? description,
    String? location,
    String? duration,
    List<String>? requirements,
    List<String>? skills,
    String? applicationLink,
    DateTime? deadline,
    DateTime? postedDate,
    OpportunityType? type,
    String? logoUrl,
    String? stipend,
    bool? isRemote,
    bool? isActive,
  }) {
    return OpportunityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      description: description ?? this.description,
      location: location ?? this.location,
      duration: duration ?? this.duration,
      requirements: requirements ?? this.requirements,
      skills: skills ?? this.skills,
      applicationLink: applicationLink ?? this.applicationLink,
      deadline: deadline ?? this.deadline,
      postedDate: postedDate ?? this.postedDate,
      type: type ?? this.type,
      logoUrl: logoUrl ?? this.logoUrl,
      stipend: stipend ?? this.stipend,
      isRemote: isRemote ?? this.isRemote,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'OpportunityModel(id: $id, title: $title, company: $company, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OpportunityModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}