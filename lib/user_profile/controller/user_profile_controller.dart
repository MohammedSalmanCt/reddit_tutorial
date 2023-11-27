import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/providers/storage_repositiry_provider.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/models/add_user-model.dart';
import 'package:reddit_tutorial/user_profile/repository/user_profile_repository.dart';
import 'package:routemaster/routemaster.dart';

import '../../core/utils.dart';

final userProfileControllerProvider =
StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
      userProfileRepoitory: ref.watch(userProfileRepositoryProvider),
      ref: ref,
      storageRepository: ref.watch(storageRepositoryProvider));
});

class UserProfileController extends StateNotifier<bool>{
  final UserProfileRepoitory _profileRepoitory;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController({required UserProfileRepoitory userProfileRepoitory,required Ref ref,required StorageRepository storageRepository}):_profileRepoitory=userProfileRepoitory,
  _ref=ref,
  _storageRepository=storageRepository,
  super(false);

  Future<void> editProfile(
      {required BuildContext context,
        required File? profileFile,
        required File? bannerFile,
      required String name}) async {
    state = true;
    UserModel user=_ref.read(userProvider)!;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
          path: "users/profile", id: user.uid, file: profileFile);
      res.fold((l) => showSnackBar(context, l.message),
              (r) => user = user.copyWith(profilePic: r));
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          path: "users/banner", id: user.uid, file: bannerFile);
      res.fold((l) => showSnackBar(context, l.message),
              (r) => user = user.copyWith(banner: r));
    }
    user=user.copyWith(name: name);
    final res = await _profileRepoitory.editProfile(user);
    res.fold((l) => showSnackBar(context, l.message),
            (r) {
      _ref.read(userProvider.notifier).update((state) => user);
              Routemaster.of(context).pop();
            });
    state = false;
  }
}