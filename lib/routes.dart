import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';
import 'features/auth/screen/login_screen.dart';

//////LogedOutRoute

final logedOutRout=RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen())
});


///// LogedInRoutes
