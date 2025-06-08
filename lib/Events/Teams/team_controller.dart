// Updated team_controller.dart
import 'package:college_connectd/Events/Teams/team_repository.dart';
import 'package:college_connectd/model/team_model.dart';
import 'package:college_connectd/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teamControllerProvider =
    StateNotifierProvider.family<TeamController, bool, String>((ref, eventId) {
  return TeamController(
      teamRepository: ref.read(TeamRepositoryProvider(eventId)), ref: ref);
});


final userTeamStreamProvider = StreamProvider.family<Team?, String>((ref, key) {
  final parts = key.split('|');
  final eventId = parts[0];
  final userId = parts[1];
  return ref.read(TeamRepositoryProvider(eventId)).userTeamStream(userId);
});


class TeamController extends StateNotifier<bool> {
  final TeamRepository _teamRepository;
  final Ref _ref;

  TeamController({
    required TeamRepository teamRepository,
    required Ref ref,
  })  : _teamRepository = teamRepository,
        _ref = ref,
        super(false);

        Future<List<int>> getMinMax() async{
         return await  _teamRepository.getMinMax();
        }

  Future<bool> createTeam(Team team,String userId) async {
    try {
      state = true;
      await _teamRepository.createTeam(team,userId);
      state = false;
      return true;
    } catch (e) {
      state = false;
      return false;
    }
  }

  Future<bool> joinTeam(String joinPin, String userId) async {
    try {
      state = true;
      final result = await _teamRepository.joinTeam(joinPin, userId);
      state = false;
      return result;
    } catch (e) {
      state = false;
      return false;
    }
  }

  Future<bool> leaveTeam(Team team, String userId) async {
    try {
      state = true;
      final result = await _teamRepository.leaveTeam(team, userId);
      state = false;
      return result;
    } catch (e) {
      state = false;
      return false;
    }
  }

  Future<bool> removeMember(Team team, String memberId) async {
    try {
      state = true;
      final result = await _teamRepository.removeMember(team, memberId);
      state = false;
      return result;
    } catch (e) {
      state = false;
      return false;
    }
  }

  Future<bool> submitTeam(Team team) async {
    try {
      state = true;
      final result = await _teamRepository.submitTeam(team);
      state = false;
      return result;
    } catch (e) {
      state = false;
      return false;
    }
  }

  Future<bool> sameTeamName(String name) async {
    try {
      state = true;
      final result = await _teamRepository.sameTeamName(name);
      state = false;
      return result;
    } catch (e) {
      state = false;
      return false;
    }
  }

  Future<List<UserModel>> getTeamMembers(List<String> memberIds) async {
    try {
      return await _teamRepository.getTeamMembers(memberIds);
    } catch (e) {
      return [];
    }
  }

  Stream<bool> isInTeamStream(String userId) {
    return _teamRepository.isInTeamStream(userId);
  }

  // Stream<Team?> userTeamStream(String userId) {
  //   return _teamRepository.userTeamStream(userId);
  // }

}