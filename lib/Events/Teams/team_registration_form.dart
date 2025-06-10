import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:college_connectd/Events/Teams/team_controller.dart';
import 'package:college_connectd/auth/controller/auth_controller.dart';
import 'package:college_connectd/custom_text_field.dart';
import 'package:college_connectd/model/team_model.dart';
import 'package:college_connectd/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:routemaster/routemaster.dart';

class TeamRegistrationForm extends ConsumerStatefulWidget {
  final String eventId;
  const TeamRegistrationForm({required this.eventId, super.key});

  @override
  ConsumerState<TeamRegistrationForm> createState() =>
      _TeamRegistrationFormState();
}

class _TeamRegistrationFormState extends ConsumerState<TeamRegistrationForm> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _joinPinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final teamAsync = ref.watch(userTeamStreamProvider(
        '${widget.eventId}|${user?.registrationId ?? ""}'));
    return Scaffold(
     resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Routemaster.of(context).pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'ISTE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              user == null
                  ? const CircularProgressIndicator()
                  : teamAsync.when(
                      data: (team) {
                        if (team == null) {
                          return Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'Create/Join Teams and make the fun gooo!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ToggleButtons(
                                    fillColor: const Color(0xFF1A1A1A),
                                    selectedColor: Colors.white,
                                    color: const Color(0xFF1A1A1A),
                                    borderRadius: BorderRadius.circular(12),
                                    borderColor: Colors.transparent,
                                    selectedBorderColor: Colors.transparent,
                                    isSelected: [
                                      _currentPage == 0,
                                      _currentPage == 1
                                    ],
                                    onPressed: (index) {
                                      setState(() {
                                        _currentPage = index;
                                      });
                                    },
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        child: Text(
                                          "Create Team",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        child: Text(
                                          "Join Team",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: IndexedStack(
                                    index: _currentPage,
                                    children: [
                                      _createTeam(user),
                                      _joinTeam(user),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Expanded(child: _buildTeamDash(team, user));
                        }
                      },
                      loading: () => const Center(child: LinearProgressIndicator()),
                      error: (e, _) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                            const SizedBox(height: 16),
                            Text('Error: $e', style: TextStyle(color: Colors.red.shade600)),
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

  Widget _createTeam(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.group_add_rounded,
                  color: Color(0xFF6366F1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Create Your Team',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: _nameController,
            label: 'Enter Team Name',
            icon: Icons.text_fields_rounded,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isEmpty) {
                  const snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'On Snap!',
                      message: 'Please Enter Team Name',
                      contentType: ContentType.failure,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                  return;
                }

                final same = await ref
                    .read(teamControllerProvider(widget.eventId).notifier)
                    .sameTeamName(_nameController.text.trim());
                if (same == true) {
                  const materialBanner = MaterialBanner(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    forceActionsBelow: true,
                    content: AwesomeSnackbarContent(
                      title: 'Oh Hey!!',
                      message: 'Same Team Name Already Exists',
                      contentType: ContentType.warning,
                      inMaterialBanner: true,
                    ),
                    actions: [SizedBox.shrink()],
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentMaterialBanner()
                    ..showMaterialBanner(materialBanner);
                } else {
                  final n = await ref
                      .read(teamControllerProvider(widget.eventId).notifier)
                      .getMinMax();
                  ref
                      .read(teamControllerProvider(widget.eventId).notifier)
                      .createTeam(Team(
                        teamName: _nameController.text.trim(),
                        joinPin: user.ukid.toString(),
                        memberIds: [user.registrationId!],
                        teamLeaderId: user.registrationId!,
                        isSubmitted: false,
                        min: n[0],
                        max: n[1],
                      ).copyWith(id: user.ukid.toString()),user.registrationId!);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Building Team',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _joinTeam(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.login_rounded,
                  color: Color(0xFF8B5CF6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Join Existing Team',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: _joinPinController,
            label: 'Enter Team Join Pin',
            icon: Icons.pin_rounded,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (_joinPinController.text.isEmpty) {
                  const snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'On Snap!',
                      message: 'Please Enter Join Pin',
                      contentType: ContentType.failure,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                  return;
                }

                final success = await ref
                    .read(teamControllerProvider(widget.eventId).notifier)
                    .joinTeam(_joinPinController.text.trim(), user.registrationId!);

                if (success) {
                  const snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Success!',
                      message: 'Successfully joined the team!',
                      contentType: ContentType.success,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                } else {
                  const snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Failed!',
                      message: 'Invalid pin, team full, or team already submitted',
                      contentType: ContentType.failure,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Join Team',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamDash(Team team, UserModel user) {
    final isLeader = team.teamLeaderId == user.registrationId;
    final canSubmit = team.memberIds.length >= team.min && 
                     team.memberIds.length <= team.max && 
                     !team.isSubmitted;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage/See your team status',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Team Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: team.isSubmitted 
                    ? [Colors.green.shade400, Colors.green.shade600]
                    : [Colors.orange.shade400, Colors.orange.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (team.isSubmitted ? Colors.green : Colors.orange).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      team.isSubmitted ? Icons.check_circle : Icons.pending,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      team.isSubmitted ? 'Team Submitted' : 'Pending Submission',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    team.isSubmitted ? IconButton(onPressed: () async{
                      final success = await ref
                                            .read(teamControllerProvider(widget.eventId).notifier)
                                            .deleteTeam(team,user.registrationId!);
                                        
                                        if (success) {
                                          const snackBar = SnackBar(
                                            elevation: 0,
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            content: AwesomeSnackbarContent(
                                              title: 'Success!',
                                              message: 'Team Deleted successfully!',
                                              contentType: ContentType.success,
                                            ),
                                          );

                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(snackBar);
                                        }
                                        else{
                                           const snackBar = SnackBar(
                                            elevation: 0,
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            content: AwesomeSnackbarContent(
                                              title: 'Oops!',
                                              message: 'You dont have the priviledge contact your leader',
                                              contentType: ContentType.failure,
                                            ),
                                          );

                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(snackBar);
                                        }
                    }, icon: Icon(Icons.delete,color: Colors.deepOrange,))
                    : SizedBox(),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Team Name: ${team.teamName.toUpperCase()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Join Pin: ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        team.joinPin,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Share this code with others to join your team',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Team Size Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.group, color: Colors.blue.shade600),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Team Size: ${team.memberIds.length}/${team.max}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      Text(
                        'Min required: ${team.min} members',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (canSubmit && isLeader)
                  ElevatedButton(
                    onPressed: () async {
                      final success = await ref
                          .read(teamControllerProvider(widget.eventId).notifier)
                          .submitTeam(team);
                      
                      if (success) {
                        const snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Success!',
                            message: 'Team submitted successfully!',
                            contentType: ContentType.success,
                          ),
                        );

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Submit Team'),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Team Members Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(Icons.people, color: Colors.grey.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Team Members',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const Spacer(),
                      if (isLeader && !team.isSubmitted)
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) async {
                            if (value == 'delete') {
                              _showDeleteTeamDialog(team, user);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red, size: 20),
                                  SizedBox(width: 8),
                                  Text('Delete Team', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                StreamBuilder<List<UserModel>>(
                  stream: _getTeamMembersStream(team.memberIds),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    
                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                              const SizedBox(height: 8),
                              Text(
                                'Error loading members',
                                style: TextStyle(color: Colors.red.shade600),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    final members = snapshot.data ?? [];
                    
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: members.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.grey.shade200,
                      ),
                      itemBuilder: (context, index) {
                        final member = members[index];
                        final isMemberLeader = member.registrationId == team.teamLeaderId;
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: const Color(0xFF6366F1),
                                child: Text(
                                  member.name[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      member.email,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isMemberLeader)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Leader',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  if (isLeader && !isMemberLeader && !team.isSubmitted)
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                                      onPressed: () async {
                                        final success = await ref
                                            .read(teamControllerProvider(widget.eventId).notifier)
                                            .removeMember(team, member.registrationId!);
                                        
                                        if (success) {
                                          const snackBar = SnackBar(
                                            elevation: 0,
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            content: AwesomeSnackbarContent(
                                              title: 'Success!',
                                              message: 'Member removed successfully!',
                                              contentType: ContentType.success,
                                            ),
                                          );

                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(snackBar);
                                        }
                                      },
                                    ),
                                  if (!isLeader && member.registrationId == user.registrationId && !team.isSubmitted)
                                    IconButton(
                                      icon: const Icon(Icons.exit_to_app, color: Colors.orange),
                                      onPressed: () async {
                                        final success = await ref
                                            .read(teamControllerProvider(widget.eventId).notifier)
                                            .leaveTeam(team, user.registrationId!);
                                        
                                        if (success) {
                                          const snackBar = SnackBar(
                                            elevation: 0,
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            content: AwesomeSnackbarContent(
                                              title: 'Success!',
                                              message: 'Left team successfully!',
                                              contentType: ContentType.success,
                                            ),
                                          );

                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(snackBar);
                                        }
                                      },
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _joinPinController.dispose();
    super.dispose();
  }

  // Stream for real-time team member updates
  Stream<List<UserModel>> _getTeamMembersStream(List<String> memberIds) {
    return Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
      return await ref
          .read(teamControllerProvider(widget.eventId).notifier)
          .getTeamMembers(memberIds);
    });
  }

  void _showDeleteTeamDialog(Team team, UserModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete Team'),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this team? This action cannot be undone and all team members will be removed.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                final success = await ref
                    .read(teamControllerProvider(widget.eventId).notifier)
                    .leaveTeam(team, user.registrationId!);
                
                if (success) {
                  const snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Success!',
                      message: 'Team deleted successfully!',
                      contentType: ContentType.success,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}