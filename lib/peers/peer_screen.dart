import 'package:college_connectd/model/peer_model.dart';
import 'package:college_connectd/peers/peer_card.dart';
import 'package:college_connectd/peers/peer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class PeerScreen extends ConsumerStatefulWidget {
  const PeerScreen({super.key});

  @override
  ConsumerState<PeerScreen> createState() => _PeerScreenState();
}

class _PeerScreenState extends ConsumerState<PeerScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<String> _selectedSkills = [];
  List<String> _selectedTraits = [];
  String _sortBy = 'latest'; // latest, name, skills
  String _searchQuery = '';
  bool _showFilters = false;
  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;

  @override
  void initState() {
    super.initState();
    _filterAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOut,
    );
    
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildAppBar(),
            
            // Search Bar
            _buildSearchBar(),
            
            // Results Header
            _buildResultsHeader(),
            
            // Peer Feed
            Expanded(
              child: _buildPeerFeed(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () => Routemaster.of(context).push('/peerProfile'),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  spacing: 10,
                  children: [
                    Text('My PeerCard',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    Icon(Icons.launch,color: Colors.white,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[600]),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              // FIXED: Call the method properly
              _showBottomSheet();
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _hasActiveFilters() ? Colors.blue[600] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _hasActiveFilters() ? Colors.blue[600]! : Colors.grey[300]!,
                ),
              ),
              child: Icon(
                Icons.tune,
                color: _hasActiveFilters() ? Colors.white : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // FIXED: Added this for better control
      backgroundColor: Colors.transparent, // FIXED: For rounded corners
      builder: (context) => StatefulBuilder( // FIXED: Added StatefulBuilder for state updates
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75, // FIXED: Set proper height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // FIXED: Added drag handle
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // FIXED: Added header with title and close button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters & Sort',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              Divider(),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sort Options
                      Text(
                        'Sort By',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          _buildSortChip('Latest', 'latest', setModalState),
                          SizedBox(width: 8),
                          _buildSortChip('Skills', 'skills', setModalState),
                        ],
                      ),
                      SizedBox(height: 16),
                      
                      // Skills Filter
                      FutureBuilder<List<String>>(
                        future: _getAvailableSkills(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return _buildFilterChips(
                              'Skills',
                              snapshot.data!,
                              _selectedSkills,
                              (skill) => _toggleSkillFilter(skill, setModalState),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      
                      // Traits Filter
                      FutureBuilder<List<String>>(
                        future: _getAvailableTraits(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return _buildFilterChips(
                              'Traits',
                              snapshot.data!,
                              _selectedTraits,
                              (trait) => _toggleTraitFilter(trait, setModalState),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // FIXED: Added Apply and Clear buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _clearAllFilters();
                                setModalState(() {});
                              },
                              child: Text('Clear All'),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {}); // Update main screen
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Apply'),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 32), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // FIXED: Added setModalState parameter to update bottom sheet UI
  Widget _buildSortChip(String label, String value, StateSetter setModalState) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () {
        setState(() => _sortBy = value);
        setModalState(() => _sortBy = value); // FIXED: Update bottom sheet UI
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[600] : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(
    String title,
    List<String> options,
    List<String> selected,
    Function(String) onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return GestureDetector(
              onTap: () => onTap(option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.blue[600] : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildResultsHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          if (_hasActiveFilters())
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Filtered',
                style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPeerFeed() {
    return FutureBuilder<List<PeerModel>>(
      future: _getFilteredPeers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading peers...'),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Something went wrong!'),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          final peers = snapshot.data!;
          if (peers.isEmpty) {
            return _buildEmptyState();
          }
          return _buildPeerList(peers);
        } else {
          return _buildEmptyState();
        }
      },
    );
  }

  Widget _buildPeerList(List<PeerModel> peers) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(8),
      itemCount: peers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: PeerCard(peerModel: peers[index]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            _hasActiveFilters() ? 'No peers match your filters' : 'No peers found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            _hasActiveFilters() 
                ? 'Try adjusting your search criteria'
                : 'Be the first to create a peer card!',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          if (_hasActiveFilters()) ...[
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _clearAllFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
              child: Text('Clear Filters'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    if (!_hasActiveFilters()) return SizedBox.shrink();
    
    return FloatingActionButton.extended(
      onPressed: _clearAllFilters,
      backgroundColor: Colors.red[400],
      foregroundColor: Colors.white,
      icon: Icon(Icons.clear),
      label: Text('Clear Filters'),
    );
  }

  // FIXED: Updated toggle methods to work with StatefulBuilder
  void _toggleSkillFilter(String skill, StateSetter setModalState) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
    setModalState(() {}); // Update bottom sheet UI
  }

  void _toggleTraitFilter(String trait, StateSetter setModalState) {
    setState(() {
      if (_selectedTraits.contains(trait)) {
        _selectedTraits.remove(trait);
      } else {
        _selectedTraits.add(trait);
      }
    });
    setModalState(() {}); // Update bottom sheet UI
  }

  bool _hasActiveFilters() {
    return _selectedSkills.isNotEmpty || 
           _selectedTraits.isNotEmpty || 
           _searchQuery.isNotEmpty ||
           _sortBy != 'latest';
  }

  void _clearAllFilters() {
    setState(() {
      _selectedSkills.clear();
      _selectedTraits.clear();
      _searchQuery = '';
      _sortBy = 'latest';
      _searchController.clear();
      _showFilters = false;
    });
    _filterAnimationController.reverse();
  }

  // Data Fetching Methods
  Future<List<String>> _getAvailableSkills() async {
    try {
      final peerController = ref.read(PeerControllerProvider.notifier);
      final allPeers = await peerController.getAllPublicPeers();
      
      final skillsSet = <String>{};
      for (final peer in allPeers) {
        skillsSet.addAll(peer.skills);
      }
      
      final skills = skillsSet.toList();
      skills.sort();
      return skills;
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> _getAvailableTraits() async {
    try {
      final peerController = ref.read(PeerControllerProvider.notifier);
      final allPeers = await peerController.getAllPublicPeers();
      
      final traitsSet = <String>{};
      for (final peer in allPeers) {
        traitsSet.addAll(peer.traits);
      }
      
      final traits = traitsSet.toList();
      traits.sort();
      return traits;
    } catch (e) {
      return [];
    }
  }

  Future<List<PeerModel>> _getFilteredPeers() async {
    try {
      final peerController = ref.read(PeerControllerProvider.notifier);
      var peers = await peerController.getAllPublicPeers();
      
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        peers = peers.where((peer) =>
          peer.name.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();
      }
      
      // Apply skills filter
      if (_selectedSkills.isNotEmpty) {
        peers = peers.where((peer) =>
          _selectedSkills.any((skill) => peer.skills.contains(skill))
        ).toList();
      }
      
      // Apply traits filter
      if (_selectedTraits.isNotEmpty) {
        peers = peers.where((peer) =>
          _selectedTraits.any((trait) => peer.traits.contains(trait))
        ).toList();
      }
      
      // Apply sorting
      switch (_sortBy) {
        case 'latest':
          peers.sort((a, b) => b.lastActive.compareTo(a.lastActive));
          break;
        case 'name':
          peers.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'skills':
          peers.sort((a, b) => b.skills.length.compareTo(a.skills.length));
          break;
      }
      
      return peers;
    } catch (e) {
      throw Exception('Failed to load peers: $e');
    }
  }
}