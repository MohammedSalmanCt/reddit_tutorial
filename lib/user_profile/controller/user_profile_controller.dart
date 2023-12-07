import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/providers/storage_repositiry_provider.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/models/add_user-model.dart';
import 'package:reddit_tutorial/user_profile/repository/user_profile_repository.dart';
import 'package:routemaster/routemaster.dart';

import '../../core/utils.dart';
import '../../models/post_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
      userProfileRepoitory: ref.watch(userProfileRepositoryProvider),
      ref: ref,
      storageRepository: ref.watch(storageRepositoryProvider));
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getPost(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepoitory _profileRepoitory;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController(
      {required UserProfileRepoitory userProfileRepoitory,
      required Ref ref,
      required StorageRepository storageRepository})
      : _profileRepoitory = userProfileRepoitory,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  Future<void> editProfile(
      {required BuildContext context,
      required File? profileFile,
      required File? bannerFile,
        required Uint8List? profileWebFile,
      required Uint8List? bannerWebFile,
      required String name}) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileFile != null || profileWebFile!=null) {
      final res = await _storageRepository.storeFile(
          path: "users/profile", id: user.uid, file: profileFile,webFile: profileWebFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => user = user.copyWith(profilePic: r));
    }

    if (bannerFile != null || bannerWebFile !=null) {
      final res = await _storageRepository.storeFile(
          path: "users/banner", id: user.uid, file: bannerFile,webFile: bannerWebFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => user = user.copyWith(banner: r));
    }
    user = user.copyWith(name: name);
    final res = await _profileRepoitory.editProfile(user);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
    state = false;
  }

  Stream<List<Post>> getPost(String uid) {
    return _profileRepoitory.getPost(uid);
  }

  Future<void> updateUserKarma(
      UserKarma userKarma, BuildContext context) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma:user.karma + userKarma.karma );
    print(user.name);
    print("user.nameaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    final res = await _profileRepoitory.updateUserKarma(user);
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaapcontroller");
    print(userKarma.karma);
    print(user.karma);
    res.fold((l) => showSnackBar(context, l.message),
        (r) => _ref.read(userProvider.notifier).update((state) => user)
    );
    print(user.karma);
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaQQQQQQQQQQQQQQQQQQQQQQ");
  }
}
