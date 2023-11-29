import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';

import '../../models/post_model.dart';
import '../theme/pallet.dart';

class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == "image";
    final isTypeText = post.type == "text";
    final isTypeLink = post.type == "link";
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16)
                          .copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(

                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(post.communityProfilePic),
                                    radius: 16,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post.communityName,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            post.username,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              if (post.uid == user.uid)
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.delete,
                                      color: Pallete.redColor,
                                    )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(post.title,style: const TextStyle(
                              fontSize:19,
                              fontWeight: FontWeight.bold
                            ),),
                          ),
                          if(isTypeImage)
                            SizedBox(height: MediaQuery.of(context).size.height *(0.35),
                            width: double.infinity,
                            child: Image.network(post.link!,
                            fit: BoxFit.fill),),

                          if(isTypeLink)
                            SizedBox(height: MediaQuery.of(context).size.height *(0.35),
                            width: double.infinity,
                            child: AnyLinkPreview(displayDirection: UIDirection.uiDirectionHorizontal,
                              link: post.link!,)),
                          if(isTypeText)
                            SizedBox(height: MediaQuery.of(context).size.height *(0.35),
                            width: double.infinity,
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(post.description!,style: const TextStyle(
                                  color: Colors.grey
                                ),),
                              ),
                            ))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
