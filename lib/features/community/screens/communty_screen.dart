import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/controller/comminity_controller.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String communityName = Uri.decodeComponent(name);
    final user=ref.watch(userProvider);
    return SafeArea(
      child: Scaffold(
          body: ref.read(getCommunityByNameProvider(communityName)).when(
                data: (data) => NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 150,
                        floating: true,
                        snap: true,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(
                              child:
                                  Image.network(data.banner, fit: BoxFit.cover),
                            )
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.all(16),
                        sliver: SliverList(
                            delegate: SliverChildListDelegate([
                          Align(
                            alignment: Alignment.topLeft,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(data.avatar),
                              radius: 35,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.name,
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              data.mods.contains(user!.uid)?
                              OutlinedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25)),
                                child: const Text("Mod Tools"),
                              )
                                  : OutlinedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25)),
                                child: const Text("Join"),
                              )
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text("${data.members.length} members")),
                        ])),
                      )
                    ];
                  },
                  body: const Text("Displayimg posts"),
                ),
                error: (Object error, StackTrace stackTrace) {
                  return Text(error.toString());
                },
                loading: () {
                  return Loader();
                },
              )),
    );
  }
}
