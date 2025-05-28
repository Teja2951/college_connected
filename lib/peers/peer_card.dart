import 'package:college_connectd/model/peer_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PeerCard extends StatelessWidget {
  final PeerModel peerModel;

  const PeerCard({
    Key? key,
    required this.peerModel,
  }) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.cyan.shade400.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with terminal-style design
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade800,
                  Colors.grey.shade900,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Terminal header
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade600,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green.shade400,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const Spacer(),
                    Text(
                        '${peerModel.name.toLowerCase().replaceFirst(' ', '_')}.json',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan.shade400,
                            Colors.blue.shade500,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8), 
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          peerModel.name.isNotEmpty 
                              ? '${peerModel.name[0].toUpperCase()} ;)'
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'monospace',
                                color: Colors.grey.shade300,
                              ),
                              children: [
                                TextSpan(
                                  text: 'const ',
                                  style: TextStyle(color: Colors.purple.shade300),
                                ),
                                TextSpan(
                                  text: '_dev ',
                                  style: TextStyle(color: Colors.cyan.shade300),
                                ),
                                const TextSpan(text: '= {\n  '),
                                TextSpan(
                                  text: 'name',
                                  style: TextStyle(color: Colors.orange.shade300),
                                ),
                                const TextSpan(text: ': "'),
                                TextSpan(
                                  text: peerModel.name,
                                  style: TextStyle(color: Colors.green.shade300),
                                ),
                                const TextSpan(text: '",'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (!peerModel.isPublic) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade900.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.orange.shade400,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'PRIVATE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange.shade300,
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Main content area
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bio section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '// ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade400,
                              fontFamily: 'monospace',
                            ),
                          ),
                          Text(
                            'Bio',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade400,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        peerModel.bio,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade300,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Skills array
                if (peerModel.skills.isNotEmpty) ...[
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                        color: Colors.grey.shade300,
                      ),
                      children: [
                        TextSpan(
                          text: 'skills',
                          style: TextStyle(color: Colors.orange.shade300),
                        ),
                        const TextSpan(text: ': ['),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: peerModel.skills.take(5).map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.cyan.shade400.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '"$skill"',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade300,
                            fontFamily: 'monospace',
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '];',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Traits if available
                if (peerModel.traits.isNotEmpty) ...[
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                        color: Colors.grey.shade300,
                      ),
                      children: [
                        TextSpan(
                          text: 'Intrested in',
                          style: TextStyle(color: Colors.orange.shade300),
                        ),
                        const TextSpan(text: ': ['),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: peerModel.traits.take(3).map((trait) {
                      return Text(
                        '"$trait"',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple.shade300,
                          fontFamily: 'monospace',
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '];',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Action buttons
                Row(
                  children: [
                    if (peerModel.linkedinLink != null)
                      Expanded(
                        child: _buildTechButton(
                          icon: Icons.work_outline,
                          label: 'LinkedIn',
                          color: Colors.blue.shade600,
                          onTap: () => _launchUrl(peerModel.linkedinLink!),
                        ),
                      ),
                    if (peerModel.linkedinLink != null && peerModel.gitHubLink != null)
                      const SizedBox(width: 12),
                    if (peerModel.gitHubLink != null)
                      Expanded(
                        child: _buildTechButton(
                          icon: Icons.code,
                          label: 'GitHub',
                          color: Colors.grey.shade300,
                          onTap: () => _launchUrl(peerModel.gitHubLink!),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}