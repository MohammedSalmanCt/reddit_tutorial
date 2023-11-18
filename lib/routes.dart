import 'package:reddit_tutorial/features/community/screens/create_community_screen.dart';
import 'package:reddit_tutorial/features/home/screen/home_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';
import 'features/auth/screen/login_screen.dart';

//////LogedOutRoute

final logedOutRout=RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen())
});


///// LogedInRoutes
final logedInRout=RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community':(_)=> const MaterialPage(child: CreateCommunityScreen())
});
