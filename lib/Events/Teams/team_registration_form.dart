import 'package:college_connectd/Events/Teams/team_controller.dart';
import 'package:college_connectd/Events/event_repository.dart';
import 'package:college_connectd/auth/controller/auth_controller.dart';
import 'package:college_connectd/model/team_model.dart';
import 'package:college_connectd/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamRegistrationForm extends ConsumerStatefulWidget {
  final String eventId;
  const TeamRegistrationForm({super.key, required this.eventId});

  @override
  ConsumerState<TeamRegistrationForm> createState() =>
      _TeamRegistrationFormState();
}

class _TeamRegistrationFormState extends ConsumerState<TeamRegistrationForm> {
  final TextEditingController _teamName = TextEditingController();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _teamName.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isInTeamStream =
        ref.watch(teamControllerProvider(widget.eventId).notifier).isInTeamStream(user?.registrationId ?? "");
    final userTeamStream =
        ref.watch(teamControllerProvider(widget.eventId).notifier).userTeamStream(user?.registrationId ?? "");

    return Scaffold(
      appBar: AppBar(title: Text("Team Registration")),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<bool>(
              stream: isInTeamStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final isInTeam = snapshot.data!;

                if (isInTeam) {
                  return StreamBuilder(
                    stream: userTeamStream,
                    builder: (context, snapshot1) {
                      if(snapshot1.hasError) return Text('error');
                      if (!snapshot1.hasData) return CircularProgressIndicator();
                      final team = snapshot1.data!;

                      return _teamDashboard(team);
                    }
                  );
                }

                return Column(
                  children: [
                    ToggleButtons(
                      isSelected: [_currentPage == 0, _currentPage == 1],
                      onPressed: (index) {
                        setState(() {
                          _currentPage = index;
                          _pageController.jumpToPage(index);
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Create Team"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Join Team"),
                        ),
                      ],
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        children: [
                          _buildCreateTeamForm(context, user),
                          _buildJoinTeamForm(context, user),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _teamDashboard(Team team) {
    return Text(team.joinPin);
    // if curr user is teamleader can be fetch from teamstream fields he can remove the users there other team memebrs can see the dashboard but cannot delete others just can leave the team
    // and at last only teamleader can sumbit the team if min and mx team requirements are done
    // after that if the team the users are in is sumbitted then we can show them a ticket with the team details and event details
  }

  Widget _buildCreateTeamForm(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _teamName,
            decoration: InputDecoration(
              labelText: 'Team Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            icon: Icon(Icons.group_add),
            onPressed: () async {
              final name = _teamName.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Team name cannot be empty")),
                );
                return;
              }

              final isSameName = await ref
                  .read(teamControllerProvider(widget.eventId).notifier)
                  .sameTeamName(name);

              if (isSameName) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Team name already exists")),
                );
                return;
              }

              final List<int> limits = await ref
                  .read(eventRepositoryProvider)
                  .getMinMax(widget.eventId);

              final newTeam = Team(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                teamName: name,
                joinPin: user.ukid.toString(),
                memberIds: [user.registrationId!],
                teamLeaderId: user.registrationId!,
                isSubmitted: false,
                max: limits[0],
                min: limits[1],
              );

              await ref
                  .read(teamControllerProvider(widget.eventId).notifier)
                  .createTeam(newTeam);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Team created successfully!")),
              );
            },
            label: Text('Create Team'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinTeamForm(BuildContext context, UserModel user) {
    // You can add a form with joinPin here and search teams
    return Center(
      child: Text("Join Team UI Coming Soon"),
    );
  }
}
