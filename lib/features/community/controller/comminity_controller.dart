import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/repository/community_reository.dart';
import 'package:reddit_tutorial/models/community_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/utils.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
      communityRepository: ref.watch(communityRepositoryProvider), ref: ref);
});
/// user community stream
final userCommunitiesProvider = StreamProvider((ref){
  return ref.watch(communityControllerProvider.notifier).getUserCommunities();
});
class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository communityRepository, required Ref ref})
      : _communityRepository = communityRepository,
        _ref = ref,super(false);

  void createCommunity(String name, BuildContext context) async {
    state=true;
    final uid = _ref.read(userProvider)?.name??"";
    Community community = Community(
        id: name,
        name: name,
        banner: "",
        avatar: "",
        members: [uid],
        mods: [uid]);
   final res=await _communityRepository.createCommunity(community);
   state=false;
   res.fold((l) => showSnackBar(context,l.message), (r){
     Routemaster.of(context).pop();
   });
  }
  Stream<List<Community>>getUserCommunities()
  {
    final uid=_ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }
}
