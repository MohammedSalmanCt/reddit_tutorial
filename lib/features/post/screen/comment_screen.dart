import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/common/post_card.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';

class CommentScreen extends ConsumerStatefulWidget {
   CommentScreen({super.key,required this.postId});
  String postId;

  @override
  ConsumerState createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController=TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostBiIdProvider(widget.postId)).when(data: (data) {
        return Column(
          children: [
            PostCard(post: data),
        const SizedBox(height: 10,),
        TextField(
          controller: commentController,
          decoration: const InputDecoration(hintText: "What are your thougths",
          filled: true,
            border: InputBorder.none
          ),
        ),
          ],
        );
      }, error: (error, stackTrace) {
        return Text(error.toString());
      }, loading: () {
        return const Loader();
      },),
    );
  }
}
