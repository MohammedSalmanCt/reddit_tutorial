import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_tutorial/features/home/drawer/community_list_drawer.dart';
import 'package:reddit_tutorial/features/home/drawer/profile_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context)
  {
    Scaffold.of(context).openDrawer();
  }
  void displayEndDrawer(BuildContext context)
  {
    Scaffold.of(context).openEndDrawer();
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user=ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () =>displayDrawer(context),
              icon: Icon(Icons.menu),
            );
          }
        ),
        actions: [
          IconButton(onPressed: () {
            showSearch(context: context, delegate: SearchCommunityDelegate(ref: ref));
          }, icon: Icon(Icons.search)),
          IconButton(onPressed: () {

          }, icon: CircleAvatar(
            backgroundImage: NetworkImage(user!.profilePic),
          ))
        ],
      ),
      drawer: CommunityListDrawer(),
      endDrawer:const ProfileDrawer() ,
    );
  }
}

