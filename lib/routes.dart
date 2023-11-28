import 'package:reddit_tutorial/features/community/screens/add_screen_mod.dart';
import 'package:reddit_tutorial/features/community/screens/create_community_screen.dart';
import 'package:reddit_tutorial/features/community/screens/edir_community_scree.dart';
import 'package:reddit_tutorial/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_tutorial/features/home/screen/home_screen.dart';
import 'package:reddit_tutorial/features/post_screen/add_post_type_screen.dart';
import 'package:reddit_tutorial/user_profile/screen/edit_profile.dart';
import 'package:reddit_tutorial/user_profile/screen/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';
import 'features/auth/screen/login_screen.dart';
import 'features/community/screens/communty_screen.dart';

//////LogedOutRoute

final logedOutRout=RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen())
});


///// LogedInRoutes
final logedInRout=RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community':(_)=> const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route) => MaterialPage(
    child: CommunityScreen(
      name: route.pathParameters['name']!,
    ),
  ),
  '/mod-tools/:name':(routData)=>  MaterialPage(child: ModToolsScreen(name: routData.pathParameters["name"]!,)),
  '/edit-community/:name':(routDa)=>  MaterialPage(child: EditCommunityScreen(name: routDa.pathParameters["name"]!,)),
  '/add_mods/:name':(routDat)=>  MaterialPage(child: AddModsScreen(name: routDat.pathParameters["name"]!,)),
  '/u/:uid':(routDat)=>  MaterialPage(child: UserProfile(uid: routDat.pathParameters["uid"]!,)),
  '/edit-profile/:uid':(routDat)=>  MaterialPage(child: EditProfileScreen(uid: routDat.pathParameters["uid"]!,)),
  '/add-post/:type':(routDat)=>  MaterialPage(child: AddPostTypeScreen(type: routDat.pathParameters["type"]!,)),
});
