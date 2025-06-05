import 'package:college_connectd/model/oppurtunities_model.dart';
import 'package:college_connectd/opputunities/oppurtunities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

final selectedFiltersProvider = StateProvider<OpportunityType>((ref) {
  return OpportunityType.internship;
});

// StreamProvider for opportunities based on selected filters
final opportunitiesStreamProvider = StreamProvider<List<OpportunityModel>>((ref) {
  final selectedFilter = ref.watch(selectedFiltersProvider);
  final repository = ref.watch(opportunityRepositoryProvider);
  
  return repository.getOpportunitiesByType(selectedFilter);
});


// final allOpportunitiesStreamProvider = StreamProvider<List<OpportunityModel>>((ref) {
//   final repository = ref.watch(opportunityRepositoryProvider);
  
  
//   return repository.getAllOpportunities();
// });

// Provider for filtered opportunities (for search functionality)
final filteredOpportunitiesProvider = Provider<AsyncValue<List<OpportunityModel>>>((ref) {
  final opportunities = ref.watch(opportunitiesStreamProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  
  return opportunities.when(
    data: (data) {
      if (searchQuery.isEmpty) {
        return AsyncValue.data(data);
      }
      final filtered = data.where((opportunity) {
        final query = searchQuery.toLowerCase();
        return opportunity.title.toLowerCase().contains(query) ||
               opportunity.company.toLowerCase().contains(query) ||
               opportunity.description.toLowerCase().contains(query) ||
               opportunity.skills.any((skill) => skill.toLowerCase().contains(query));
      }).toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Controller class for opportunity-related operations
class OpportunityController extends StateNotifier<AsyncValue<void>> {
  final OpportunityRepository _repository;
  final Ref _ref;

  OpportunityController(this._repository, this._ref) : super(const AsyncValue.data(null));

  // // Toggle filter selection
  // void toggleFilter(OpportunityType type) {
  //   final currentFilters = _ref.read(selectedFiltersProvider);
  //   final updatedFilters = List<OpportunityType>.from(currentFilters);
    
  //   if (updatedFilters.contains(type)) {
  //     updatedFilters.remove(type);
  //   } else {
  //     updatedFilters.add(type);
  //   }
    
  //   _ref.read(selectedFiltersProvider.notifier).state = updatedFilters;
  // }

  // // Set filters
  // void setFilters(List<OpportunityType> filters) {
  //   _ref.read(selectedFiltersProvider.notifier).state = filters;
  // }

  // // Clear all filters
  // void clearFilters() {
  //   _ref.read(selectedFiltersProvider.notifier).state = [];
  // }

  // Set search query
  void setSearchQuery(String query) {
    _ref.read(searchQueryProvider.notifier).state = query;
  }

  // Clear search
  void clearSearch() {
    _ref.read(searchQueryProvider.notifier).state = '';
  }

  // Get opportunity by ID
  Future<OpportunityModel?> getOpportunityById(String id) async {
    try {
      return await _repository.getOpportunityById(id);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  // Add new opportunity
  Future<bool> addOpportunity(OpportunityModel opportunity) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addOpportunity(opportunity);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  // Update opportunity
  Future<bool> updateOpportunity(OpportunityModel opportunity) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateOpportunity(opportunity);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  // Delete opportunity
  Future<bool> deleteOpportunity(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteOpportunity(id);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  // Launch URL (for application links)
  Future<void> launchApplicationUrl(String url) async {
    try {
       await launchUrl(Uri.parse(url));
    } catch (e) {
      state = AsyncValue.error('Could not launch $url', StackTrace.current);
    }
  }
}

// Provider for the opportunity controller
final opportunityControllerProvider = StateNotifierProvider<OpportunityController, AsyncValue<void>>((ref) {
  final repository = ref.watch(opportunityRepositoryProvider);
  return OpportunityController(repository, ref);
});

// Utility providers for UI state
final isLoadingProvider = Provider<bool>((ref) {
  final opportunities = ref.watch(opportunitiesStreamProvider);
  final controller = ref.watch(opportunityControllerProvider);
  
  return opportunities.isLoading || controller.isLoading;
});

final hasErrorProvider = Provider<bool>((ref) {
  final opportunities = ref.watch(opportunitiesStreamProvider);
  final controller = ref.watch(opportunityControllerProvider);
  
  return opportunities.hasError || controller.hasError;
});

final errorMessageProvider = Provider<String?>((ref) {
  final opportunities = ref.watch(opportunitiesStreamProvider);
  final controller = ref.watch(opportunityControllerProvider);
  
  if (opportunities.hasError) {
    return opportunities.error.toString();
  }
  if (controller.hasError) {
    return controller.error.toString();
  }
  return null;
});