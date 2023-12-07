import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/models/comment_model.dart';
import 'package:reddit_tutorial/responsive/responsive.dart';

class CommentCard extends ConsumerWidget {
  const CommentCard({super.key,required this.comment});
  final CommentModel comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Responsive(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 10),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(comment.profilePic,),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment.username,style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                        Text(comment.text),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(onPressed: () {

                }, icon: const Icon(Icons.reply)),
                const Text("reply")
              ],
            )
          ],
        ),
      ),
    );
  }
}
