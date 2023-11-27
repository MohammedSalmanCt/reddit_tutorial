import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/controller/comminity_controller.dart';
import 'package:reddit_tutorial/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({super.key, required this.uid});
  final String uid;
  @override
  void navigateTOEditUser(BuildContext context)
  {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  Widget build(BuildContext context, WidgetRef ref) {
    final user=ref.watch(userProvider);

    return SafeArea(
      child: Scaffold(
          body: ref.read(getUserDataProvider(uid)).when(
            data: (data) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 250,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child:
                          Image.network(data.profilePic, fit: BoxFit.cover),
                        ),
                Container(
                  alignment:  Alignment.bottomLeft,
                  padding: const EdgeInsets.all(20).copyWith(bottom: 70),
                  child: CircleAvatar(
                  backgroundImage: NetworkImage(data.profilePic),
                  radius: 45,
                  ),
                ),
                Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(20).copyWith(bottom: 30),
                          child: OutlinedButton(
                            onPressed: () {
                              navigateTOEditUser(context);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25)),
                            child:  const Text("edit profile"),
                          ),
                        )
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(16),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.name,
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text("${data.karma} karma")),
                           const SizedBox(height: 10,),
                          const Divider(thickness: 2,),
                        ])),
                  )
                ];
              },
              body: const Text("Displaying posts"),
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

