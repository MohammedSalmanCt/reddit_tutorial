import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/community/controller/comminity_controller.dart';
import 'package:reddit_tutorial/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context)
  {
   Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text("Create a community"),
              leading: Icon(Icons.add),
              onTap: ()=>navigateToCreateCommunity(context),
            ),
            ref.watch(userCommunitiesProvider).when(data: (data) {
              return Expanded(
                child: ListView.builder(itemCount:data.length,
                itemBuilder: (context, index) {
                  final community=data[index];
                  return  ListTile(
                    title: Text(community.name),
                    leading:  CircleAvatar(
                      backgroundImage: NetworkImage(community.avatar),
                    ),
                    onTap: () {
                      navigateToCommunity(context, community);
                    },
                  );
                },),
              );
            }, error: (error, stackTrace) {
              return Text(error.toString());
            }, loading: () {
              return const Loader();
            },)
          ],
        ),
      ),
    );
  }
}