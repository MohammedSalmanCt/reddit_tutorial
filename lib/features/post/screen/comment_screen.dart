import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/common/post_card.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';
import 'package:reddit_tutorial/features/post/screen/widget/comment_card.dart';

import '../../../models/post_model.dart';
import '../../auth/controller/auth_controller.dart';

class CommentScreen extends ConsumerStatefulWidget {
  CommentScreen({super.key, required this.postId});
  String postId;

  @override
  ConsumerState createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  void addComment({
    required Post post,
  }) {
    ref.read(postControllerProvider.notifier).addComment(
        context: context, text: commentController.text.trim(), post: post);
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user=ref.watch(userProvider)!;
    final isGuest=!user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostBiIdProvider(widget.postId)).when(
        data: (data) {
          return Column(
            children: [
              PostCard(post: data),
              const SizedBox(
                height: 10,
              ),
              if(!isGuest)
              TextField(
                onSubmitted: (value) => addComment(post: data),
                controller: commentController,
                decoration: const InputDecoration(
                    hintText: "What are your thougths",
                    filled: true,
                    border: InputBorder.none),
              ),
              ref.watch(getCommentsProvider(widget.postId)).when(
                    data: (comment) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: comment.length,
                          itemBuilder: (context, index) {
                            return CommentCard(comment: comment[index]);
                          },
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      return Text(error.toString());
                    },
                    loading: () => Loader(),
                  )
            ],
          );
        },
        error: (error, stackTrace) {
          return Text(error.toString());
        },
        loading: () {
          return const Loader();
        },
      ),
    );
  }
}
