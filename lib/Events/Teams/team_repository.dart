import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_connectd/core/Firebase/firebase_providers.dart';
import 'package:college_connectd/model/team_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final TeamRepositoryProvider = Provider.family<TeamRepository,String>((ref,eventId) {
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

  CollectionReference get _teams => _firebaseFirestore.collection('events').doc(_eventId).collection('teams');


  Future<void> createTeam(Team team) async{
    await _teams.doc().set(team.toMap());
  }

  Stream<bool> isInTeamStream(String userId) {
  return _teams.snapshots().map((snapshot) {
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final List<dynamic> memberIds = data['memberIds'];

      if (memberIds.contains(userId)) {
        return true;
      }
    }
    return false;
  });
}

 Stream<Team?> userTeamStream(String userId) {
  print('c');
  return _teams.snapshots().map((snapshot) {
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final List<dynamic> memberIds = data['memberIds'];
      print('f');

      if (memberIds.contains(userId)) {
        print('a');
        final doca =  doc.data() as Map<String,dynamic>;
                print(doca);

        final t =  Team.fromMap(doca);
        print('sa');
        print(t.toString());
        return t;
      }
    }
    print('n');
    return null;
  });
}


  Future<bool> sameTeamName(String name) async{
    final querySnapshot = await _teams.get();
    for(final doc in querySnapshot.docs) {
      final data = doc.data() as Map<String,dynamic>;
      final List<String> aa = data['teamName'];

      if(aa.contains(name)){
        return true;
      }
    }
    return false;
  }

}