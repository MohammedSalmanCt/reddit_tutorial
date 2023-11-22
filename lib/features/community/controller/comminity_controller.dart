import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/contants/constants.dart';
import 'package:reddit_tutorial/core/providers/storage_repositiry_provider.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/repository/community_reository.dart';
import 'package:reddit_tutorial/models/community_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/utils.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
      communityRepository: ref.watch(communityRepositoryProvider),
      ref: ref,
      storageRepository: ref.watch(storageRepositoryProvider));
});

/// user community stream
final userCommunitiesProvider = StreamProvider((ref) {
  return ref.watch(communityControllerProvider.notifier).getUserCommunities();
});

///
final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref,String query)  {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _strorageRepository;
  CommunityController(
      {required CommunityRepository communityRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _communityRepository = communityRepository,
        _ref = ref,
        _strorageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.name ?? "";
    Community community = Community(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [uid],
        mods: [uid]);
    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.name;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  Future<void> editCommunity(
      {required BuildContext context,
      required Community community,
      required File? profileFile,
      required File? bannerFile}) async {
    state=true;
    if (profileFile != null) {
      final res = await _strorageRepository.storeFile(
          path: "community/profile", id: community.name, file: profileFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(avatar: r));
    }

    if (bannerFile != null) {
      final res = await _strorageRepository.storeFile(
          path: "community/banner", id: community.name, file: bannerFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(banner: r));
    }
    final res = await _communityRepository.editCommunity(community);
    res.fold((l) => showSnackBar(context, l.message),
        (r) => Routemaster.of(context).pop());
    state=false;
  }
  Stream<List<Community>> searchCommunity(String query)
  {
    return _communityRepository.searchCommunity(query);
  }

}
