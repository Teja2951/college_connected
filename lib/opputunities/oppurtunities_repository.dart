// repositories/opportunity_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_connectd/model/oppurtunities_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final opportunityRepositoryProvider = Provider<OpportunityRepository>((ref) {
  return OpportunityRepository();
});

class OpportunityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'opportunities';

  // Get all opportunities as a stream
  Stream<List<OpportunityModel>> getAllOpportunities() {
    return _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OpportunityModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get opportunities by type
  Stream<List<OpportunityModel>> getOpportunitiesByType(OpportunityType type) {
    return _firestore
        .collection(_collection)
        .where('type', isEqualTo: type.toString().split('.').last)
        .where('isActive', isEqualTo: true)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OpportunityModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get opportunities by multiple types
  Stream<List<OpportunityModel>> getOpportunitiesByTypes(List<OpportunityType> types) {
    if (types.isEmpty) {
      return Stream.value([]);
    }

    final typeStrings = types.map((t) => t.toString().split('.').last).toList();
    
    return _firestore
        .collection(_collection)
        .where('type', whereIn: typeStrings)
        .where('isActive', isEqualTo: true)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OpportunityModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get a single opportunity by ID
  Future<OpportunityModel?> getOpportunityById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return OpportunityModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get opportunity: $e');
    }
  }

  // Add a new opportunity
  Future<String> addOpportunity(OpportunityModel opportunity) async {
    try {
      final docRef = await _firestore.collection(_collection).add(opportunity.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add opportunity: $e');
    }
  }

  // Update an opportunity
  Future<void> updateOpportunity(OpportunityModel opportunity) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(opportunity.id)
          .update(opportunity.toMap());
    } catch (e) {
      throw Exception('Failed to update opportunity: $e');
    }
  }

  // Delete an opportunity (soft delete by setting isActive to false)
  Future<void> deleteOpportunity(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'isActive': false,
      });
    } catch (e) {
      throw Exception('Failed to delete opportunity: $e');
    }
  }

  // Search opportunities
  Future<List<OpportunityModel>> searchOpportunities(String query) async {
    try {
      // Firestore doesn't support full-text search, so we'll get all and filter
      final snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();

      final opportunities = snapshot.docs.map((doc) {
        return OpportunityModel.fromMap(doc.data(), doc.id);
      }).toList();

      // Filter by query
      return opportunities.where((opportunity) {
        final searchString = query.toLowerCase();
        return opportunity.title.toLowerCase().contains(searchString) ||
               opportunity.company.toLowerCase().contains(searchString) ||
               opportunity.description.toLowerCase().contains(searchString) ||
               opportunity.skills.any((skill) => skill.toLowerCase().contains(searchString));
      }).toList();
    } catch (e) {
      throw Exception('Failed to search opportunities: $e');
    }
  }

  // Get opportunities by location
  Stream<List<OpportunityModel>> getOpportunitiesByLocation(String location) {
    return _firestore
        .collection(_collection)
        .where('location', isEqualTo: location)
        .where('isActive', isEqualTo: true)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OpportunityModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get remote opportunities
  Stream<List<OpportunityModel>> getRemoteOpportunities() {
    return _firestore
        .collection(_collection)
        .where('isRemote', isEqualTo: true)
        .where('isActive', isEqualTo: true)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OpportunityModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}