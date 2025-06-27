import 'dart:io';
import 'dart:typed_data';
import 'package:college_connectd/auth/controller/auth_controller.dart';
import 'package:college_connectd/model/peer_model.dart';
import 'package:college_connectd/peers/peer_card.dart';
import 'package:college_connectd/peers/peer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// Image picker and storage functions
// Future<Uint8List> pickImage() async {
//   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//   final finalBytes = await File(pickedFile!.path).readAsBytes();
//   return finalBytes;
// }

// class StorageMethods {
//   Future<String> getUploadedImage(Uint8List file) async {
//     final String bucketName = 'peers';
//     final String fileName = 'peers${DateTime.now().millisecondsSinceEpoch}.jpg';

//     try {
//       final response = await Supabase.instance.client.storage.from(bucketName).uploadBinary(
//         fileName,
//         file,
//       );

//       if (response.isEmpty) {
//         print("Upload failed: Empty response");
//         return 'null';
//       }

//       final String publicUrl = 'Supabase.instance.client.storage.from(bucketName).getPublicUrl(fileName)';
//       print("Uploaded Image URL: $publicUrl");

//       return publicUrl;
//     } catch (e) {
//       print("Error uploading image: $e");
//       return 'null';
//     }
//   }
// }

class PeerProfile extends ConsumerStatefulWidget {
  PeerProfile({super.key});

  @override
  ConsumerState<PeerProfile> createState() => _PeerProfileState();
}

class _PeerProfileState extends ConsumerState<PeerProfile> {
  @override
  Widget build(BuildContext context) {
    final _peerCard = ref.watch(PeerControllerProvider.notifier);
    final _userId = ref.watch(userProvider)!.registrationId;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
               
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
                  
                  SizedBox(width: 44), // Balance the back button
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: FutureBuilder(
                future: _peerCard.getMyPeerCard(_userId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading your profile...'),
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
                    final data = snapshot.data;
                    return _buildExistingProfile(data!, _userId!);
                  } else {
                    return _buildCreateProfile(_userId!);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExistingProfile(PeerModel peerModel, String userId) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My PeerCard',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Share your skills/Intrests and connect with peers',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                FloatingActionButton(
                  mini: true,
                  onPressed: () => _showPeerCardForm(context, peerModel: peerModel, userId: userId),
                  backgroundColor: Colors.black,
                  child: Icon(Icons.edit, color: Colors.white),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Peer Card Display
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 2),
            ),
            child: PeerCard(peerModel: peerModel)
          ),
        ],
      ),
    );
  }

  Widget _buildCreateProfile(String userId) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Icon(
                  //   Icons.person_add_alt_1,
                  //   size: 80,
                  //   color: Colors.blue[600],
                  // ),
                  // SizedBox(height: 24),
                  Text(
                    'Create Your PeerCard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Share your skills, projects, and connect\nwith like-minded peers in your college',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showPeerCardForm(context, userId: userId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPeerCardForm(BuildContext context, {PeerModel? peerModel, required String userId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PeerCardFormBottomSheet(
        peerModel: peerModel,
        userId: userId,
        onSave: () {
          Navigator.pop(context);
          setState(() {}); // Refresh the page
        },
      ),
    );
  }
}

class PeerCardFormBottomSheet extends ConsumerStatefulWidget {
  final PeerModel? peerModel;
  final String userId;
  final VoidCallback onSave;

  PeerCardFormBottomSheet({
    Key? key,
    this.peerModel,
    required this.userId,
    required this.onSave,
  }) : super(key: key);

  @override
  ConsumerState<PeerCardFormBottomSheet> createState() => _PeerCardFormBottomSheetState();
}

class _PeerCardFormBottomSheetState extends ConsumerState<PeerCardFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _profileLinkController = TextEditingController();
  final _gitHubController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _skillController = TextEditingController();
  final _traitController = TextEditingController();

  List<String> _skills = [];
  List<String> _traits = [];
  bool _isPublic = true;
  bool _isLoading = false;
  Uint8List? _profileImage;

  @override
  void initState() {
    super.initState();
    if (widget.peerModel != null) {
      _prefillForm();
    }
  }

  void _prefillForm() {
    final peer = widget.peerModel!;
    _nameController.text = peer.name;
    _bioController.text = peer.bio;
    //_profileLinkController.text = peer.profileLink;
    _gitHubController.text = peer.gitHubLink ?? '';
    _linkedinController.text = peer.linkedinLink;
    _skills = List.from(peer.skills);
    _traits = List.from(peer.traits);
    _isPublic = peer.isPublic;
  } 

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
                Expanded(
                  child: Text(
                    widget.peerModel != null ? 'Edit PeerCard' : 'Create PeerCard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
          ),

          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // // Profile Image Section
                    // Center(
                    //   child: GestureDetector(
                    //     onTap: _pickProfileImage,
                    //     child: Container(
                    //       height: 100,
                    //       width: 100,
                    //       decoration: BoxDecoration(
                    //         color: Colors.grey[200],
                    //         shape: BoxShape.circle,
                    //         border: Border.all(color: Colors.blue[600]!, width: 2),
                    //       ),
                    //       child: _profileImage != null
                    //           ? ClipOval(
                    //               child: Image.memory(
                    //                 _profileImage!,
                    //                 fit: BoxFit.cover,
                    //               ),
                    //             )
                    //           : Icon(
                    //               Icons.add_a_photo,
                    //               size: 40,
                    //               color: Colors.blue[600],
                    //             ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 8),
                    // Center(
                    //   child: Text(
                    //     'Tap to add profile photo',
                    //     style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    //   ),
                    // ),

                    // SizedBox(height: 24),

                    // Name Field
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
                    ),

                    // Bio Field
                    _buildTextField(
                      controller: _bioController,
                      label: 'Bio',
                      hint: 'Tell others about yourself...',
                      maxLines: 3,
                      validator: (value) => value?.isEmpty == true ? 'Bio is required' : null,
                    ),

                    // Profile Link Field
                    // _buildTextField(
                    //   controller: _profileLinkController,
                    //   label: 'Profile Link',
                    //   hint: 'https://yourprofile.com',
                    //   validator: (value) => value?.isEmpty == true ? 'Profile link is required' : null,
                    // ),

                    // GitHub Link Field
                    _buildTextField(
                      controller: _gitHubController,
                      label: 'GitHub Link (Optional)',
                      hint: 'https://github.com/username',
                    ),

                    // LinkedIn Link Field
                    _buildTextField(
                      controller: _linkedinController,
                      label: 'LinkedIn Link',
                      hint: 'https://linkedin.com/in/username',
                    ),

                    // Skills Section
                    _buildChipSection(
                      title: 'Skills',
                      items: _skills,
                      controller: _skillController,
                      onAdd: () => _addChip(_skillController, _skills),
                      onRemove: (skill) => setState(() => _skills.remove(skill)),
                      hint: 'Add a skill (e.g., Flutter, Python)',
                    ),

                    // Traits Section
                    _buildChipSection(
                      title: 'Traits/Interests',
                      items: _traits,
                      controller: _traitController,
                      onAdd: () => _addChip(_traitController, _traits),
                      onRemove: (trait) => setState(() => _traits.remove(trait)),
                      hint: 'Add a trait (e.g., Projects, Leadership)',
                    ),

                    // Public Profile Toggle
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Public Profile',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Allow others to discover your profile',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isPublic,
                            onChanged: (value) => setState(() => _isPublic = value),
                            activeColor: Colors.blue[600],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _savePeerCard,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                widget.peerModel != null ? 'Update PeerCard' : 'Create PeerCard',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipSection({
    required String title,
    required List<String> items,
    required TextEditingController controller,
    required VoidCallback onAdd,
    required Function(String) onRemove,
    required String hint,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
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
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: hint,
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onSubmitted: (_) => onAdd(),
                      ),
                    ),
                    IconButton(
                      onPressed: onAdd,
                      icon: Icon(Icons.add, color: Colors.black),
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                if (items.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: items.map((item) => Chip(
                      label: Text(item),
                      onDeleted: () => onRemove(item),
                      backgroundColor: Colors.blue[50],
                      deleteIconColor: Colors.black,
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addChip(TextEditingController controller, List<String> list) {
    final text = controller.text.trim();
    if (text.isNotEmpty && !list.contains(text)) {
      setState(() {
        list.add(text);
        controller.clear();
      });
    }
  }

  // Future<void> _pickProfileImage() async {
  //   try {
  //     final imageBytes = await pickImage();
  //     setState(() {
  //       _profileImage = imageBytes;
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to pick image: $e')),
  //     );
  //   }
  // }

  Future<void> _savePeerCard() async {
    if (!_formKey.currentState!.validate()) return;
    if (_skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one skill')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? profileImageUrl;
      if (_profileImage != null) {
        // final storageMethod = StorageMethods();
        // profileImageUrl = await storageMethod.getUploadedImage(_profileImage!);
        if (profileImageUrl == 'null') {
          profileImageUrl = null;
        }
      }

      final peerModel = PeerModel(
        userId: widget.userId,
        name: _nameController.text.trim(),
        profileLink: _profileLinkController.text.trim().isEmpty ? null : _profileLinkController.text.trim(),
        skills: _skills,
        gitHubLink: _gitHubController.text.trim().isEmpty ? null : _gitHubController.text.trim(),
        linkedinLink: _linkedinController.text.trim(),
        traits: _traits,
        bio: _bioController.text.trim(),
        isPublic: _isPublic,
        lastActive: DateTime.now(),
      );

      final peerController = ref.read(PeerControllerProvider.notifier);
      
      if (widget.peerModel != null) {
        // Update existing peer card
        await peerController.createPeerCard(peerModel, widget.userId);
      } else {
        // Create new peer card
        await peerController.createPeerCard(peerModel, widget.userId);
      }

      widget.onSave();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.peerModel != null ? 'PeerCard updated successfully!' : 'PeerCard created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _profileLinkController.dispose();
    _gitHubController.dispose();
    _linkedinController.dispose();
    _skillController.dispose();
    _traitController.dispose();
    super.dispose();
  }
}