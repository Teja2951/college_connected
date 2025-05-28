import 'package:college_connectd/model/peer_model.dart';
import 'package:college_connectd/peers/peer_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final PeerControllerProvider = StateNotifierProvider<PeerController,bool>((ref) {
  return PeerController(PeerRepository: ref.read(PeerRepositoryProvider), ref: ref);
});

class PeerController extends StateNotifier<bool>{
  final PeerRepository _peerRepository;
  final Ref _ref;

  PeerController({
    required PeerRepository PeerRepository,
    required Ref ref,
  }) : _peerRepository = PeerRepository , _ref = ref, super(false);

  Future<PeerModel?> getMyPeerCard(String userId) async{
    try {
  final m = await _peerRepository.getPeerCard(userId);
  return m;
}catch (e) {
  return null;
}
  }

  Future<void> createPeerCard(PeerModel peer,String userId) async{
    await _peerRepository.createPeerCard(peer,userId);
  }

  Future<void> getAllAvailableTraits() async{
    await _peerRepository.getAllPublicPeers();
  }

   Future<List<PeerModel>> getAllPublicPeers() async{
    return await _peerRepository.getAllPublicPeers();
  }

  //  Future<void> getFilteredPeers() async{
  //   await _peerRepository.ge();
  // }



}