import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/community/controller/comminity_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({Key? key}) : super(key: key);

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Colors.red,
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text("Create a community"),
              leading: Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
            // Use ref.watch to observe the state from the provider
            ref.watch(userCommunitiesProvider).when(
              data: (data) {
                return Expanded(
                  child: Container(
                    color: Colors.green,
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        // Check if the index is within bounds
                        if (index < data.length) {
                          final community = data[index];
                          // Make sure the 'Community' model has a 'name' property
                          final communityName = community.name ?? "Unknown";

                          return ListTile(
                            title: Text(communityName),
                            leading: CircleAvatar(
                              // Use the appropriate property for the avatar
                              // backgroundImage: NetworkImage(community.avatar),
                              backgroundColor: Colors.cyan,
                            ),
                            onTap: () {
                              // Handle the tap event
                            },
                          );
                        } else {
                          // Return an empty container if the index is out of bounds
                          return Container();
                        }
                      },
                    ),
                  ),
                );
              },
              error: (error, stackTrace) {
                return Text(error.toString());
              },
              loading: () {
                return const Loader();
              },
            )
          ],
        ),
      ),
    );
  }
}
