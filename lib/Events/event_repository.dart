import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_connectd/core/Firebase/firebase_providers.dart';
import 'package:college_connectd/model/event_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventRepositoryProvider = Provider((ref){
  return EventRepository(firebaseFirestore: ref.read(firebaseFirestoreProvider));
});


class EventRepository {
  final FirebaseFirestore _firebaseFirestore;

  EventRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _events => _firebaseFirestore.collection('events');

  Future<void> addEvent(EventModel event) async{
    final docRef = _events.doc();
    final eventm = event.copyWith(id: docRef.id);
    await docRef.set(eventm.toMap());
  }

 Future<bool> isUserRegistered(String eventId, String userId) async {
  print('called');
  final doc = await FirebaseFirestore.instance
    .collection('events')
    .doc(eventId)
    .collection('registeredUsers')
    .doc('members')
    .get();

  final List<dynamic> userIds = doc.data()?['userIds'] ?? [];
  print('the getstatusrepo method says:  ${userIds} ${userIds.contains(userId)}');
  return userIds.contains(userId);
}

  Future<void> registerUser(String eventId, String userId) async{
    _events.doc(eventId).collection('registeredUsers').doc('members').set({'userIds': FieldValue.arrayUnion([userId]),});
    _events.doc(eventId).update({'registrationCount':FieldValue.increment(1)});
  }

  Stream<EventModel?> getEvent(String eventId) {
    return _events.doc(eventId).snapshots().map((doc)=> doc.exists ?EventModel.fromMap(doc.data() as Map<String,dynamic>, doc.id) : null );
  }


  Stream<List<EventModel>> getPastEvents() {
    final now = DateTime.now();
    return _events
        .where('startTime', isLessThan: Timestamp.fromDate(now))
        .orderBy('startTime')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

//   Future<List<EventModel>> getMyEvents(String userId) async {
//   try {
//     final List<EventModel> userEvents = [];
    
//     // Get all events in one query
//     final eventsSnapshot = await _events.get();
//     final batch = _firebaseFirestore.batch();
//     final Map<String, DocumentReference> registrationRefs = {};
    
//     // Prepare batch reads
//     for (final eventDoc in eventsSnapshot.docs) {
//       final ref = eventDoc.reference.collection('registeredUsers').doc('members');
//       registrationRefs[eventDoc.id] = ref;
//     }
    
//     // Execute batch reads
//     final futures = registrationRefs.entries.map((entry) async {
//       try {
//         final doc = await entry.value.get();
//         if (doc.exists) {
//           final data = doc.data() as Map<String, dynamic>?;
//           final List<dynamic> userIds = data?['userIds'] ?? [];
//           if (userIds.contains(userId)) {
//             return entry.key; // Return event ID
//           }
//         }
//       } catch (e) {
//         print('Error reading registration for ${entry.key}: $e');
//       }
//       return null;
//     });
    
//     final results = await Future.wait(futures);
//     final registeredEventIds = results.whereType<String>().toList();
    
//     // Get events for registered IDs
//     for (final eventDoc in eventsSnapshot.docs) {
//       if (registeredEventIds.contains(eventDoc.id)) {
//         final event = EventModel.fromMap(
//             eventDoc.data() as Map<String, dynamic>, eventDoc.id);
//         userEvents.add(event);
//       }
//     }
    
//     // Sort events by start time
//     userEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
    
//     return userEvents;
    
//   } catch (e) {
//     print('Error in getMyEventsOnce: $e');
//     return [];
//   }
// }

  Stream<List<EventModel>> getUpcomingEvents() {
    final now = DateTime.now();
    return _events
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('startTime')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}