import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/contants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_tutorial/features/home/drawer/community_list_drawer.dart';
import 'package:reddit_tutorial/features/home/drawer/profile_drawer.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/theme/pallet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}
  class _HomeScreenState extends ConsumerState<HomeScreen>{

int _page=0;
  void displayDrawer(BuildContext context)
  {
    Scaffold.of(context).openDrawer();
  }
  void displayEndDrawer(BuildContext context)
  {
    Scaffold.of(context).openEndDrawer();
  }

void onPageChanged(int page)
{
  setState(() {
    _page=page;
  });
}
  @override
  Widget build(BuildContext context) {
    final user=ref.watch(userProvider)!;
    final isGuest=!user.isAuthenticated;
    final currentheme=ref.watch(themeNotifierProvider);
    return Scaffold(
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
          IconButton(onPressed:() {
            Routemaster.of(context).push('/add_post');
          },
              icon: Icon(Icons.add)),
          Builder(
            builder: (context) {
              return IconButton(onPressed: () {
                displayEndDrawer(context);
              }, icon: CircleAvatar(
                backgroundImage: NetworkImage(user!.profilePic),
              ));
            }
          )
        ],
      ),
      body: Constants.tabWidgets[_page],
      drawer: const CommunityListDrawer(),
      endDrawer: isGuest ? null:const ProfileDrawer() ,
      bottomNavigationBar:isGuest || kIsWeb ? null: CupertinoTabBar(
        activeColor: currentheme.iconTheme.color,
        backgroundColor: currentheme.backgroundColor,
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.add)),
        ],
        onTap: onPageChanged,
        currentIndex: _page,
      ),
    );
  }


}



