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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    // final isInTeamStream = ref
    //     .watch(teamControllerProvider(widget.eventId).notifier)
    //     .isInTeamStream(user?.registrationId ?? '');
    final teamAsync = ref.watch(userTeamStreamProvider(
        '${widget.eventId}|${user?.registrationId ?? ""}'));
    return Scaffold(
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
                        Icons.arrow_back_ios_new,
                        size: 20,
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
              SizedBox(
                height: 20,
              ),
              Text(
                'Create/Join Teams and make the fun gooo!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              user == null
                  ? CircularProgressIndicator()
                  : teamAsync.when(
                      data: (team) {
                        if (team == null) {
                          return Expanded(
                            child: Column(
                              children: [
                                ToggleButtons(
                                  fillColor: Colors.black,
                                  isSelected: [
                                    _currentPage == 0,
                                    _currentPage == 1
                                  ],
                                  onPressed: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        "Create Team",
                                        style: TextStyle(
                                          color: (_currentPage == 0)
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        "Join Team",
                                        style: TextStyle(
                                          color: (_currentPage == 1)
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: IndexedStack(
                                    index: _currentPage,
                                    children: [
                                      _createTeam(user),
                                      _joinTeam(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return _buildTeamDash(team);
                        }
                      },
                      loading: () => Center(child: LinearProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createTeam(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomTextField(
            controller: _nameController,
            label: 'Enter Team Name',
            icon: Icons.text_fields_rounded,
          ),
          ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isEmpty) {
                  print('h');
                  const snackBar = SnackBar(
                    /// need to set following properties for best effect of awesome_snackbar_content
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'On Snap!',
                      message: 'Please Enter Name',

                      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
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
                    /// need to set following properties for best effect of awesome_snackbar_content
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    forceActionsBelow: true,
                    content: AwesomeSnackbarContent(
                      title: 'Oh Hey!!',
                      message: 'Same Team Name',

                      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                      contentType: ContentType.warning,
                      // to configure for material banner
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
                      ).copyWith(id: user.ukid.toString()));
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: Size(double.infinity, 44)),
              child: Text('Start Building Team'))
        ],
      ),
    );
  }

  Widget _joinTeam() {
    return Text('joinn');
  }

  Widget _buildTeamDash(Team team) {
    return Column(
      children: [
        Text('JOIN CODE ${team.joinPin}'),
        Text(team.memberIds.toString()),
      ],
    );
  }
}
