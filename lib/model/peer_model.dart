import 'dart:convert';
import 'package:collection/collection.dart';

class PeerModel {
  final String? userId;
  final String name;
  final String profileLink;
  final List<String> skills;
  final String? gitHubLink;
  final String? linkedinLink;
  final List<String> traits;
  final String bio;
  final bool isPublic;
  final DateTime lastActive;

  PeerModel({
    this.userId,
    required this.name,
    required this.profileLink,
    required this.skills,
    this.gitHubLink,
    this.linkedinLink,
    this.traits = const [],
    required this.bio,
    required this.isPublic,
    required this.lastActive,
  });

  factory PeerModel.fromJson(Map<String, dynamic> json) {
    return PeerModel(
      userId: json['userId'],
      name: json['name'],
      profileLink: json['profileLink'],
      skills: List<String>.from(json['skills']),
      gitHubLink: json['gitHubLink'],
      linkedinLink: json['linkedinLink'],
      traits: List<String>.from(json['traits'] ?? []),
      bio: json['bio'],
      isPublic: json['isPublic'],
      lastActive: DateTime.parse(json['lastActive']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'skills': skills,
      'profileLink': profileLink,
      'gitHubLink': gitHubLink,
      'linkedinLink': linkedinLink,
      'traits': traits,
      'bio': bio,
      'isPublic': isPublic,
      'lastActive': lastActive.toIso8601String(),
    };
  }

  PeerModel copyWith({
    required String userId,
    String? name,
    String? profileLink,
    List<String>? skills,
    String? gitHubLink,
    String? linkedinLink,
    List<String>? traits,
    String? bio,
    bool? isPublic,
    DateTime? lastActive,
  }) {
    return PeerModel(
      userId: userId,
      name: name ?? this.name,
      profileLink: profileLink ?? this.profileLink,
      skills: skills ?? this.skills,
      gitHubLink: gitHubLink ?? this.gitHubLink,
      linkedinLink: linkedinLink ?? this.linkedinLink,
      traits: traits ?? this.traits,
      bio: bio ?? this.bio,
      isPublic: isPublic ?? this.isPublic,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'skills': skills,
      'profileLink': profileLink,
      'gitHubLink': gitHubLink,
      'linkedinLink': linkedinLink,
      'traits': traits,
      'bio': bio,
      'isPublic': isPublic,
      'lastActive': lastActive.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'PeerModel(userId: $userId, name: $name, skills: $skills, gitHubLink: $gitHubLink, linkedinLink: $linkedinLink, traits: $traits, bio: $bio, isPublic: $isPublic, lastActive: $lastActive)';
  }
}
