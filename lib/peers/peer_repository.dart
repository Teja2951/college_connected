import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_connectd/core/Firebase/firebase_providers.dart';
import 'package:college_connectd/model/peer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository Provider
final PeerRepositoryProvider = Provider((ref) {
  return PeerRepository(firebaseFirestore: ref.read(firebaseFirestoreProvider));
});

class PeerRepository {
  final FirebaseFirestore _firebaseFirestore;

  PeerRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _peer => _firebaseFirestore.collection('peer');

  // Existing methods
  Future<void> createPeerCard(PeerModel peer, String userId) async {
    try {
      await _peer.doc(userId).set(peer.copyWith(userId: userId).toJson());
    } catch (e) {
      print('Error creating peer card: $e');
      rethrow;
    }
  }

  Future<PeerModel> getPeerCard(String userId) async {
    try {
      final doc = await _peer.doc(userId).get();
      
      if (!doc.exists) {
        throw Exception('Peer card not found');
      }

      final data = doc.data() as Map<String, dynamic>;
      return PeerModel.fromJson(data);
    } catch (e) {
      print('Error getting peer card: $e');
      rethrow;
    }
  }

  // New methods for peer discovery
  Future<List<PeerModel>> getAllPublicPeers() async {
    try {
      final querySnapshot = await _peer
          .where('isPublic', isEqualTo: true)
          .orderBy('lastActive', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PeerModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting all public peers: $e');
      rethrow;
    }
  }

  Future<List<PeerModel>> getPeersBySkills(List<String> skills) async {
    try {
      final querySnapshot = await _peer
          .where('isPublic', isEqualTo: true)
          .where('skills', arrayContainsAny: skills)
          .orderBy('lastActive', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PeerModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting peers by skills: $e');
      rethrow;
    }
  }

  Future<List<PeerModel>> getPeersByTraits(List<String> traits) async {
    try {
      final querySnapshot = await _peer
          .where('isPublic', isEqualTo: true)
          .where('traits', arrayContainsAny: traits)
          .orderBy('lastActive', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PeerModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting peers by traits: $e');
      rethrow;
    }
  }

  Future<List<String>> getAllAvailableSkills() async {
    try {
      final querySnapshot = await _peer
          .where('isPublic', isEqualTo: true)
          .get();

      final skillsSet = <String>{};
      
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final skills = List<String>.from(data['skills'] ?? []);
        skillsSet.addAll(skills);
      }

      final skillsList = skillsSet.toList();
      skillsList.sort();
      return skillsList;
    } catch (e) {
      print('Error getting all available skills: $e');
      rethrow;
    }
  }

  Future<List<String>> getAllAvailableTraits() async {
    try {
      final querySnapshot = await _peer
          .where('isPublic', isEqualTo: true)
          .get();

      final traitsSet = <String>{};
      
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final traits = List<String>.from(data['traits'] ?? []);
        traitsSet.addAll(traits);
      }

      final traitsList = traitsSet.toList();
      traitsList.sort();
      return traitsList;
    } catch (e) {
      print('Error getting all available traits: $e');
      rethrow;
    }
  }

  Future<List<PeerModel>> searchPeersByName(String searchQuery) async {
    try {
      // Firestore doesn't support case-insensitive search directly
      // So we'll get all public peers and filter in memory for better user experience
      final querySnapshot = await _peer
          .where('isPublic', isEqualTo: true)
          .get();

      final allPeers = querySnapshot.docs
          .map((doc) => PeerModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // Filter by name (case-insensitive)
      final filteredPeers = allPeers
          .where((peer) => peer.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

      // Sort by last active
      filteredPeers.sort((a, b) => b.lastActive.compareTo(a.lastActive));

      return filteredPeers;
    } catch (e) {
      print('Error searching peers by name: $e');
      rethrow;
    }
  }

  Future<void> updatePeerCard(PeerModel peer, String userId) async {
    try {
      await _peer.doc(userId).update(peer.copyWith(userId: userId).toJson());
    } catch (e) {
      print('Error updating peer card: $e');
      rethrow;
    }
  }

  Future<void> deletePeerCard(String userId) async {
    try {
      await _peer.doc(userId).delete();
    } catch (e) {
      print('Error deleting peer card: $e');
      rethrow;
    }
  }

  Future<bool> peerCardExists(String userId) async {
    try {
      final doc = await _peer.doc(userId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking if peer card exists: $e');
      return false;
    }
  }

  Future<void> updateLastActive(String userId) async {
    try {
      await _peer.doc(userId).update({
        'lastActive': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating last active: $e');
      // Don't rethrow as this is not critical
    }
  }
}

// Controller Provider
final PeerControllerProvider = StateNotifierProvider<PeerController, bool>((ref) {
  return PeerController(
    peerRepository: ref.read(PeerRepositoryProvider),
  );
});

class PeerController extends StateNotifier<bool> {
  final PeerRepository _peerRepository;

  PeerController({
    required PeerRepository peerRepository,
  }) : _peerRepository = peerRepository,
       super(false);

  // Existing methods
  Future<void> createPeerCard(PeerModel peer, String userId) async {
    state = true;
    try {
      await _peerRepository.createPeerCard(peer, userId);
    } catch (e) {
      throw Exception('Failed to create peer card: $e');
    } finally {
      state = false;
    }
  }

  Future<PeerModel> getMyPeerCard(String userId) async {
    try {
      return await _peerRepository.getPeerCard(userId);
    } catch (e) {
      throw Exception('Failed to get peer card: $e');
    }
  }

  // New methods for peer discovery
  Future<List<PeerModel>> getAllPublicPeers() async {
    try {
      return await _peerRepository.getAllPublicPeers();
    } catch (e) {
      throw Exception('Failed to get public peers: $e');
    }
  }

  Future<List<PeerModel>> getPeersBySkills(List<String> skills) async {
    try {
      if (skills.isEmpty) {
        return await getAllPublicPeers();
      }
      return await _peerRepository.getPeersBySkills(skills);
    } catch (e) {
      throw Exception('Failed to get peers by skills: $e');
    }
  }

  Future<List<PeerModel>> getPeersByTraits(List<String> traits) async {
    try {
      if (traits.isEmpty) {
        return await getAllPublicPeers();
      }
      return await _peerRepository.getPeersByTraits(traits);
    } catch (e) {
      throw Exception('Failed to get peers by traits: $e');
    }
  }

  Future<List<String>> getAllAvailableSkills() async {
    try {
      return await _peerRepository.getAllAvailableSkills();
    } catch (e) {
      print('Failed to get available skills: $e');
      return []; // Return empty list instead of throwing
    }
  }

  Future<List<String>> getAllAvailableTraits() async {
    try {
      return await _peerRepository.getAllAvailableTraits();
    } catch (e) {
      print('Failed to get available traits: $e');
      return []; // Return empty list instead of throwing
    }
  }

  Future<List<PeerModel>> searchPeersByName(String searchQuery) async {
    try {
      if (searchQuery.trim().isEmpty) {
        return await getAllPublicPeers();
      }
      return await _peerRepository.searchPeersByName(searchQuery);
    } catch (e) {
      throw Exception('Failed to search peers: $e');
    }
  }

  Future<void> updatePeerCard(PeerModel peer, String userId) async {
    state = true;
    try {
      await _peerRepository.updatePeerCard(peer, userId);
    } catch (e) {
      throw Exception('Failed to update peer card: $e');
    } finally {
      state = false;
    }
  }

  Future<void> deletePeerCard(String userId) async {
    state = true;
    try {
      await _peerRepository.deletePeerCard(userId);
    } catch (e) {
      throw Exception('Failed to delete peer card: $e');
    } finally {
      state = false;
    }
  }

  Future<bool> peerCardExists(String userId) async {
    try {
      return await _peerRepository.peerCardExists(userId);
    } catch (e) {
      return false;
    }
  }

  Future<void> updateLastActive(String userId) async {
    try {
      await _peerRepository.updateLastActive(userId);
    } catch (e) {
      // Silently fail as this is not critical
      print('Failed to update last active: $e');
    }
  }

  // Advanced filtering method that combines multiple criteria
  Future<List<PeerModel>> getFilteredPeers({
    String? searchQuery,
    List<String>? skills,
    List<String>? traits,
    String sortBy = 'latest', // latest, name, skills
  }) async {
    try {
      // Start with all public peers
      var peers = await getAllPublicPeers();

      // Apply search filter
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        peers = peers.where((peer) =>
          peer.name.toLowerCase().contains(searchQuery.toLowerCase())
        ).toList();
      }

      // Apply skills filter
      if (skills != null && skills.isNotEmpty) {
        peers = peers.where((peer) =>
          skills.any((skill) => peer.skills.contains(skill))
        ).toList();
      }

      // Apply traits filter
      if (traits != null && traits.isNotEmpty) {
        peers = peers.where((peer) =>
          traits.any((trait) => peer.traits.contains(trait))
        ).toList();
      }

      // Apply sorting
      switch (sortBy) {
        case 'latest':
          peers.sort((a, b) => b.lastActive.compareTo(a.lastActive));
          break;
        case 'name':
          peers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          break;
        case 'skills':
          peers.sort((a, b) => b.skills.length.compareTo(a.skills.length));
          break;
      }

      return peers;
    } catch (e) {
      throw Exception('Failed to get filtered peers: $e');
    }
  }

  // Utility method to get peer statistics
  Future<Map<String, int>> getPeerStatistics() async {
    try {
      final peers = await getAllPublicPeers();
      final skills = await getAllAvailableSkills();
      final traits = await getAllAvailableTraits();

      return {
        'totalPeers': peers.length,
        'totalSkills': skills.length,
        'totalTraits': traits.length,
        'activePeers': peers.where((peer) => 
          peer.lastActive.isAfter(DateTime.now().subtract(Duration(days: 7)))
        ).length,
      };
    } catch (e) {
      return {
        'totalPeers': 0,
        'totalSkills': 0,
        'totalTraits': 0,
        'activePeers': 0,
      };
    }
  }
}