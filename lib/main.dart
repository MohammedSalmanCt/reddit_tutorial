import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/theme/pallet.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/auth/screen/login_screen.dart';
import 'package:reddit_tutorial/models/add_user-model.dart';
import 'package:reddit_tutorial/routes.dart';
import 'package:routemaster/routemaster.dart';
var size,h,w;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBsR9M2KxR42qc8OlTk933QEt6piB7BjEY",
            authDomain: "famous-archway-397605.firebaseapp.com",
            projectId: "famous-archway-397605",
            storageBucket: "famous-archway-397605.appspot.com",
            messagingSenderId: "36796006740",
            appId: "1:36796006740:web:3ba6fa90ca5e391ff0c8c1",
            measurementId: "G-CW0WWWQ0PB"
        )
    );
  }
  else {
    await Firebase.initializeApp();
  }
  runApp( ProviderScope(child: MyApp()));
}
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  Future<void> getData(WidgetRef ref,User data)
  async {
userModel=await ref.watch(authControlleProvider.notifier).getUserData(data.uid).first;
ref.read(userProvider.notifier).update((state) => userModel);
setState(() {

});
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    h= size.height;
    w = size.width;
    return ref.watch(authStateChangeProvider).when(data: (data) {
      return MaterialApp.router(
        theme: Pallete.darkModeAppTheme,
        routerDelegate: RoutemasterDelegate(routesBuilder: (context)
        {
          if(data!=null)
          {
           getData(ref, data);
           if(userModel!=null)
             {
               return logedInRout;
             }
          }
          return logedOutRout;
        }),
        routeInformationParser:const RoutemasterParser(),
        debugShowCheckedModeBanner: false,
      );
    }, error: (error, stackTrace) {
      return ErrorText(error: error.toString());
    }, loading: () {
      return Loader();
    },);

  }
}
