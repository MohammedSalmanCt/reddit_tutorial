import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/theme/pallet.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref)
  {
    ref.read(authControlleProvider.notifier).logOut();
  }
  void navigateTOUserProfile(BuildContext context, String uid)
  {
  Routemaster.of(context).push("/u/$uid");
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user=ref.watch(userProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user!.profilePic),
              radius: 70,
            ),
            const SizedBox(
              height: 10,
            ),
            Text("${user.name}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),),
            SizedBox(
              height: 10,
            ),
            Divider(),
            ListTile(
              title: Text("My profile"),
               leading: Icon((Icons.person),),
              onTap: () {
                navigateTOUserProfile(context,user.uid);
              },
            ),ListTile(
              title: Text("Log out"),
               leading: Icon((Icons.logout),
                   color: Pallete.redColor,),
              onTap: () {
                logOut(ref);
              },
            ),
            Switch.adaptive(value: true,
              onChanged: (value) {

            },)
          ],
        ),
      ),
    );
  }
}
