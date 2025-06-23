import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_connectd/auth/controller/auth_controller.dart';
import 'package:college_connectd/auth/repository/auth_repository.dart';
import 'package:college_connectd/core/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(user),
            _buildQuickActionsSection(),
            const Divider(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(user) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset('assets/icons/profile_bg.png'),
        _buildBackButton(),
        _buildProfileInfo(user),
      ],
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 0,
      left: 0,
      child: GestureDetector(
                    onTap: () => Routemaster.of(context).pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
    );
  }

  Widget _buildProfileInfo(user) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.0),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.name ?? 'Unknown User',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                user?.email ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Text(
                (user?.year != null) ? 'B.Tech(${user!.year})' : '',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildQuickActionsSection() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTilesGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTilesGrid() {
    return Column(
      children: [
        _buildNoticeBoardTile(),
        const SizedBox(height: 8),
        Divider(color: Colors.blue,indent: 65,endIndent: 65,thickness: 2,),
        Row(
          children: [
            Expanded(
                  child: _buildActionTile(
                    title: 'Follow Us!',
                    subtitle: 'Show some love on Instagram',
                    icon: Icons.share,
                    color: Colors.purple,
                    onTap: _openInstagram,
                  ),
                ),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                title: 'Report Issues/bugs',
                subtitle: 'Connect via Email or +91-8688153143',
                icon: Icons.bug_report,
                color: Colors.orange,
                onTap: _openGmail,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                title: 'Legal',
                subtitle: 'Privacy Policy and T&C',
                icon: Icons.policy,
                color: Colors.green,
                onTap: _showLegalOptions,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoticeBoardTile() {
    return GestureDetector(
      onTap: _showNoticeBoard,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            _buildBackgroundPattern(),
            _buildNoticeBoardContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Stack(
      children: [
        Positioned(
          right: -20,
          top: -20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: -30,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoticeBoardContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.campaign, color: Colors.white, size: 24),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.8),
                size: 16,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📢 Notice Board',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Latest college updates and announcements',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
            child: ElevatedButton(
              onPressed: () => _showLogoutDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC143C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                minimumSize: const Size(double.infinity, 0),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Text(
            'Made with 😍 by Team Aavishkaar',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // Action methods
  void _openInstagram() async {
    const url = 'https://www.instagram.com/unisyncofficial/';
    await launchUrl(Uri.parse(url));
    
  }

  void _openGmail() async {
    const url = 'mailto:varshithteja86@gmail.com?subject=UniSync bug report';
    await launchUrl(Uri.parse(url));
  }

  void _showNoticeBoard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const NoticeBoardModal(),
    );
  }

  void _showLegalOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LegalOptionsModal(),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Are you sure?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Do you really want to log out? You\'ll need to log in again to access your profile.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                await SecureStorageService().clearLoginStatus();
                //Navigator.pop(context);
                ref.read(authStateProvider.notifier).state = false;
                Routemaster.of(context).replace('/');
              },
              child: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

Future<List<Map<String,dynamic>>> getNoticesData() async{
  final snapshot = await FirebaseFirestore.instance.collection('notice').get();
  return snapshot.docs.map((eachd) => eachd.data()).toList();
}

// Separate modal widgets for better organization
class NoticeBoardModal extends StatefulWidget {
  const NoticeBoardModal({super.key});

  @override
  State<NoticeBoardModal> createState() => _NoticeBoardModalState();
}

class _NoticeBoardModalState extends State<NoticeBoardModal> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHandle(),
            const SizedBox(height: 20),
            const Text(
              '📢 College Notice Board',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: getNoticesData(),
                builder: (context,snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // loading
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data found")); // empty
          } else {
            final d = snapshot.data!;
            return ListView.builder(
              itemCount: d.length,
              itemBuilder: (context,index){
                final l = d[index];
                return _buildNoticeItem(
                  l['heading'],
                  l['description'],
                  l['date'],
                  );
              }
            );
          }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildNoticeItem(String heading, String description, Timestamp date) {
    String formattedDate = DateFormat('dd MMM yyyy').format(date.toDate());
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  heading,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class LegalOptionsModal extends StatefulWidget {
  const LegalOptionsModal({super.key});

  @override
  State<LegalOptionsModal> createState() => _LegalOptionsModalState();
}

Future<String> fetchPolicyText() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('texts')
      .doc('policy')
      .get();

  if (snapshot.exists) {
    return snapshot.data()!['text'];
  } else {
    throw Exception('Updating Soon');
  }
}

Future<String> fetchTermsText() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('texts')
      .doc('t_c')
      .get();

  if (snapshot.exists) {
    return snapshot.data()!['text'];
  } else {
    throw Exception('Updating soon');
  }
}


class _LegalOptionsModalState extends State<LegalOptionsModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Legal Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          FutureBuilder(
            future: fetchPolicyText(),
            builder: (context,snapshot){

              if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // loading
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data found")); // empty
          } else {

            final data = snapshot.data!;
              
            return ListTile(
              leading: const Icon(Icons.description, color: Colors.green),
              title: const Text('Terms & Conditions'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pop(context);
                _showTermsAndConditions(context,data);
              },
            );
            }
            }
          ),
          FutureBuilder(
            future: fetchTermsText(),
            builder: (context,snapshot){

              if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // loading
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data found")); // empty
          } else {
            final data = snapshot.data!;
            return ListTile(
              leading: const Icon(Icons.privacy_tip, color: Colors.blue),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pop(context);
                _showPrivacyPolicy(context,data);
              },
            );
          }
            }
          ),
        ],
      ),
    );
  }

  void _showTermsAndConditions(BuildContext, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>  LegalDocumentModal(
        title: 'Terms & Conditions',
        content: content
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>  LegalDocumentModal(
        title: 'Privacy Policy',
        content: content
      ),
    );
  }
}

class LegalDocumentModal extends StatelessWidget {
  final String title;
  final String content;

  const LegalDocumentModal({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}