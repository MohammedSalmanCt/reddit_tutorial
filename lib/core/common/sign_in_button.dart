import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/contants/constants.dart';
import 'package:reddit_tutorial/core/theme/pallet.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  void signWithGoogle(BuildContext context,WidgetRef ref)
  {
    ref.read(authControlleProvider.notifier).signWithGoogle(context);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton.icon(
          onPressed: () {
            signWithGoogle(context,ref);
          },
       icon: Image.asset(Constants.logoGooglePath,
       width: 40,),
        label: const Text("Continue with Google",
        style: TextStyle(
          fontSize: 20
        )
        ),
        style: ElevatedButton.styleFrom(
      backgroundColor:Pallete.greyColor,
          minimumSize: const Size(double.infinity,50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          )
        ),
      ),
    );
  }
}
