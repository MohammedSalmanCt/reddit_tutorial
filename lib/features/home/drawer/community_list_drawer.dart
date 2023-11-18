import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawe extends ConsumerWidget {
  const CommunityListDrawe({super.key});

  void navigateToCreateCommunity(BuildContext context)
  {
   Routemaster.of(context).push('/create-community');
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
            )
          ],
        ),
      ),
    );
  }
}