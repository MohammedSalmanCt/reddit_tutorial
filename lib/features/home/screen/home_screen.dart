import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user=ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {

          },
          icon: Icon(Icons.menu),
        ),
        actions: [
          IconButton(onPressed: () {

          }, icon: Icon(Icons.search)),
          IconButton(onPressed: () {

          }, icon: CircleAvatar(
            backgroundImage: NetworkImage(user!.profilePic),
          ))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(user?.name??"asdadada"),
            Text(user?.name??"asdadada"),
          ],
        ),
      ),
    );
  }
}

