
// Updated team_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_connectd/core/Firebase/firebase_providers.dart';
import 'package:college_connectd/model/team_model.dart';
import 'package:college_connectd/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final TeamRepositoryProvider = Provider.family<TeamRepository, String>((ref, eventId) {
  return TeamRepository(
    FirebaseFirestore: ref.read(firebaseFirestoreProvider),
    EventId: eventId
  );
});

class TeamRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String _eventId;

  TeamRepository({
    required FirebaseFirestore FirebaseFirestore,
    required String EventId,
  }) : _firebaseFirestore = FirebaseFirestore, _eventId = EventId;

  CollectionReference get _teams => 
      _firebaseFirestore.collection('events').doc(_eventId).collection('teams');

        CollectionReference get _events => _firebaseFirestore.collection('events');

  
  CollectionReference get _users => 
      _firebaseFirestore.collection('users');

  Future<void> createTeam(Team team,String userId) async {
    await _teams.doc(team.id).set(team.toMap());
    _events.doc(_eventId).update({'regIds': FieldValue.arrayUnion([userId]),});
    _events.doc(_eventId).update({'registrationCount':FieldValue.increment(1)});
        
  }

  Future<bool> deleteTeam(Team team,String userId) async{
    try{
      if (team.teamLeaderId == userId) {
        // If leader is leaving, delete the team
        await _teams.doc(team.id).delete();
         _events.doc(_eventId).update({'regIds': [],});
        return true;
      }
      else{
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future<bool> joinTeam(String joinPin, String userId) async {
    try {
      final querySnapshot = await _teams.where('joinPin', isEqualTo: joinPin).get();
      
      if (querySnapshot.docs.isEmpty) {
        return false;
      }

      final teamDoc = querySnapshot.docs.first;
      final teamData = teamDoc.data() as Map<String, dynamic>;
      final team = Team.fromMap(teamData);

      // Check if team is full
      if (team.memberIds.length >= team.max) {
        return false;
      }

      // Check if team is already submitted
      if (team.isSubmitted) {
        return false;
      }

      // Add user to team
      final updatedMemberIds = [...team.memberIds, userId];
      await teamDoc.reference.update({'memberIds': updatedMemberIds});
      _events.doc(_eventId).update({'regIds': FieldValue.arrayUnion([userId]),});
    _events.doc(_eventId).update({'registrationCount':FieldValue.increment(1)});
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> leaveTeam(Team team, String userId) async {
    try {
      if (team.teamLeaderId == userId) {
        // If leader is leaving, delete the team
        await _teams.doc(team.id).delete();
      } else {
        // Remove user from team
        final updatedMemberIds = team.memberIds.where((id) => id != userId).toList();
        await _teams.doc(team.id).update({'memberIds': updatedMemberIds});
      _events.doc(_eventId).update({'regIds': FieldValue.arrayRemove([userId]),});
    _events.doc(_eventId).update({'registrationCount':FieldValue.increment(-1)});
        
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeMember(Team team, String memberId) async {
    try {
      final updatedMemberIds = team.memberIds.where((id) => id != memberId).toList();
      await _teams.doc(team.id).update({'memberIds': updatedMemberIds});
      _events.doc(_eventId).update({'regIds': FieldValue.arrayRemove([memberId]),});
    _events.doc(_eventId).update({'registrationCount':FieldValue.increment(-1)});
        
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitTeam(Team team) async {
    try {
      await _teams.doc(team.id).update({'isSubmitted': true});
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<bool> isInTeamStream(String userId) {
    return _teams.snapshots().map((snapshot) {
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final List<dynamic> memberIds = data['memberIds'] ?? [];

        if (memberIds.contains(userId)) {
          return true;
        }
      }
      return false;
    });
  }

  Stream<Team?> userTeamStream(String userId) {
    return _teams.snapshots().map((snapshot) {
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final List<dynamic> memberIds = data['memberIds'] ?? [];

        if (memberIds.contains(userId)) {
          return Team.fromMap(data);
        }
      }
      return null;
    });
  }

  Future<bool> sameTeamName(String name) async {
    try {
      final querySnapshot = await _teams.where('teamName', isEqualTo: name).get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<List<int>> getMinMax() async{
    try{
      final doc = await _firebaseFirestore.collection('events').doc(_eventId).get();
      final data = doc.data();
      final a = data!['minTeamSize'];
      final b = data!['maxTeamSize'];

      final numbers = [a,b];
      print(numbers);
      return List<int>.from(numbers);
    }catch(e){
      throw e;
    }
  }

  Future<List<UserModel>> getTeamMembers(List<String> memberIds) async {
    try {
      final List<UserModel> members = [];
      
      for (String memberId in memberIds) {
        final userDoc = await _users.doc(memberId).get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          members.add(UserModel.fromMap(userData));
        }
      }
      
      return members;
    } catch (e) {
      return [];
    }
  }

  
}