import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/controller/comminity_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  const AddModsScreen({super.key, required this.name});
  final String name;
  @override
  ConsumerState createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids={};
  @override
  Widget build(BuildContext context) {
    final cname = Uri.decodeComponent(widget.name);
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.done))],
      ),
      body:ref.watch(getCommunityByNameProvider(cname)).when(
        data: (community)=>ListView.builder(
        itemCount: community.members.length,
        itemBuilder: (BuildContext context,int  index) {
          final member=community.members[index];
          return ref.watch(getUserDataProvider(member))
              .when(data: (user) {
                if(community.mods.contains(member))
                  {
                    uids.add(member);
                  }
            return CheckboxListTile(
              value: true,
              onChanged: (value) {},
              title: Text(user.name),
            );
          }, error: (error, stackTrace) {
            return Text(error.toString());
          }, loading: () {
            return Loader();
          },);
        },
      ), error: (Object error, StackTrace stackTrace) {       return Text(error.toString());
      }, loading: () {       return Loader();
      }
      )
    );
  }
}
