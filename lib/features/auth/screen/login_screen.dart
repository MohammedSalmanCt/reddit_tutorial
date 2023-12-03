import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/common/sign_in_button.dart';
import 'package:reddit_tutorial/core/contants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import '../../../main.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signAsGuest(WidgetRef ref,BuildContext context)
  {
    ref.read(authControlleProvider.notifier).signAsGuest(context);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
   final isLoading= ref.watch(authControlleProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(Constants.logoPath,
        height: h*(0.06)),
        actions: [
          TextButton(
              onPressed:() {
                signAsGuest(ref,context);
              },
              child: const Text("Skip",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),)
          )
        ],
      ),
      body: isLoading
          ?const Loader()
          : Column(
          children: [
          const SizedBox(
            height:30,
          ),
          const Text("Dive into anythings",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing:0.5
          ),
          ),
          const SizedBox(
            height:30,
          ),
          Image.asset(Constants.logoEmotePath,
          height: 450,
          ),
          const SizedBox(
            height:20,
          ),
          const SignInButton(),
        ],
      ),
    );
  }
}
