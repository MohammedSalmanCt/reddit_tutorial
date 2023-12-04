import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/providers/storage_repositiry_provider.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/post/repository/post_repository.dart';
import 'package:reddit_tutorial/models/comment_model.dart';
import 'package:reddit_tutorial/models/post_model.dart';
import 'package:reddit_tutorial/user_profile/controller/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils.dart';
import '../../../models/community_model.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
      postRepository: ref.watch(postRepositoryProvider),
      ref: ref,
      storageRepository: ref.watch(storageRepositoryProvider));
});

final userPostProvider =
    StreamProvider.family((ref, List<Community> communities) {
  return ref.watch(postControllerProvider.notifier).fetchUserPosts(communities);
});

final guestPostsProvider = StreamProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchGuestPosts();
});

final getPostBiIdProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getPostId(postId);
});

final getCommentsProvider = StreamProvider.family((ref,String postId)  {
  return ref.watch(postControllerProvider.notifier).getComments(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _strorageRepository;
  PostController(
      {required PostRepository postRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _postRepository = postRepository,
        _ref = ref,
        _strorageRepository = storageRepository,
        super(false);
  void shareTextPost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required String description}) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: "text",
        createdAt: DateTime.now(),
        awards: [],
        description: description);

    final res = await _postRepository.addPost(post);
if(context.mounted)
  {
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.textPost, context);
  }
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Posted Successfully");
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required String link}) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: "link",
        createdAt: DateTime.now(),
        awards: [],
        link: link);

    final res = await _postRepository.addPost(post);
if(context.mounted)
  {
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.linkPost, context);
  }
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Posted Successfully");
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required File? file}) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _strorageRepository.storeFile(
        path: "posts/${selectedCommunity.name}", id: postId, file: file);

    imageRes.fold((l) => showSnackBar(context, l.message), (imgUrl) async {
      final Post post = Post(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: "image",
          createdAt: DateTime.now(),
          awards: [],
          link: imgUrl);
      final res = await _postRepository.addPost(post);
if(context.mounted)
  {
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.imagePost, context);
  }
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, "Posted Successfully");
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchGuestPosts() {
    print("contro;;;;;;;;;;;;;;;;;;;;;;;;;;");
      return _postRepository.fetchGuestPosts();

  }

  Future<void> deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);
   if(context.mounted)
     {
       _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.deletePost, context);
     }
    res.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, "Deleted successfully"));
  }

  void upvote(Post post) async {
    final userId = _ref.read(userProvider)!.uid;
    _postRepository.upvote(post, userId);
  }

  void downvote(Post post) async {
    final userId = _ref.read(userProvider)!.uid;
    _postRepository.downvote(post, userId);
  }

  Stream<Post> getPostId(String postId) {
    return _postRepository.getPostId(postId);
  }

  addComment(
      {required BuildContext context,
      required String text,
      required Post post}) async {
    final user = _ref.watch(userProvider)!;
    String commentId = const Uuid().v1();
    CommentModel comment = CommentModel(
        id: commentId,
        text: text,
        createdAt: DateTime.now(),
        postId: post.id,
        profilePic: user.profilePic,
        username: user.name);
   final res=await _postRepository.addComment(comment);
   if(context.mounted)
     {
       _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.comment, context);
     }
   res.fold((l) => showSnackBar(context,l.message), (r) => null);
  }

  Stream<List<CommentModel>> getComments(String postId) {
    return _postRepository.getComments(postId);
  }
  void awardPost({required Post post,required String award,required BuildContext context})
  async{
    final user=_ref.read(userProvider)!;
    final res=await _postRepository.awardPost(post, award, user.uid);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.awardPost,context);
      _ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });
    Routemaster.of(context).pop();
    });
  }

}
