import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/theme/pallet.dart';
import 'package:reddit_tutorial/features/auth/screen/login_screen.dart';
import 'package:reddit_tutorial/routes.dart';
import 'package:routemaster/routemaster.dart';
var size,h,w;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    h= size.height;
    w = size.width;
    return MaterialApp.router(
      theme: Pallete.darkModeAppTheme,
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) => logedOutRout),
      routeInformationParser:const RoutemasterParser(),
      debugShowCheckedModeBanner: false,
    );
  }
}