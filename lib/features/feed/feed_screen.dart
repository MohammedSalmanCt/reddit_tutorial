import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/common/post_card.dart';
import 'package:reddit_tutorial/features/community/controller/comminity_controller.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';

import '../auth/controller/auth_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user=ref.watch(userProvider)!;
    final isGuest=!user.isAuthenticated;
    if(!isGuest) {
      return ref.watch(userCommunitiesProvider).when(
        data: (communities) {
          return ref.watch(userPostProvider(communities)).when(
            data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final post = data[index];
                  return PostCard(post: post);
                },
              );
            },
            error: (error, stackTrace) {
              return Text(error.toString());
            },
            loading: () {
              return Loader();
            },
          );
        },
        error: (error, stackTrace) {
          return Text(error.toString());
        },
        loading: () {
          return Loader();
        },
      );
    }
      return ref.watch(guestPostsProvider).when(data: (data) {
        return ListView.builder(
          itemCount:data.length ,
          itemBuilder: (context, index) {
            final post=data[index];
            return PostCard(post: post);
          },);
      }, error: (error, stackTrace) {
        return Text(error.toString());
      }, loading: () {
        return Loader();
      },);
  }
}
