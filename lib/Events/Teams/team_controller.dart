import 'package:college_connectd/Events/Teams/team_repository.dart';
import 'package:college_connectd/model/team_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teamControllerProvider = StateNotifierProvider.family<TeamController, bool, String>((ref,eventId) {
  return TeamController(teamRepository: ref.read(TeamRepositoryProvider(eventId)), ref: ref);
});

class TeamController extends StateNotifier<bool> {
  final TeamRepository _teamRepository;
  final Ref _ref;

  TeamController({
    required TeamRepository teamRepository,
    required Ref ref,
  }) : _teamRepository = teamRepository , _ref = ref, super(false);


  Future<bool> createTeam(Team team) async{
    try{
       state = true;
       await _teamRepository.createTeam(team);
       state = false;
       return true;
    }catch(e){
      state = false;
      return false;
    }
  }

   Future<bool> sameTeamName(String name) async{
    try{
       state = true;
       final result = await _teamRepository.sameTeamName(name);
       state = false;
       return result;
    }catch(e){
      state = false;
      return false;
    }
  }

  Stream<bool> isInTeamStream(String userId){
    try{
      return _teamRepository.isInTeamStream(userId);
    }catch(e){
      throw e;
    }
  }


Stream<Team?> userTeamStream(String userId){
    try{
      return _teamRepository.userTeamStream(userId);
    }catch(e){
      throw e;
    }
  }

  




}