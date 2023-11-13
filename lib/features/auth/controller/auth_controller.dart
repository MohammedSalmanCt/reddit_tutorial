import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/auth/repository/auth_repository.dart';
import '../../../core/utils.dart';
import '../../../models/add_user-model.dart';

final userProvider = StateProvider<UserModel?>((ref) {
  return null;
});

final authControlleProvider = StateNotifierProvider<AuthController,bool>((ref) {
  return AuthController(authRepository: ref.watch(authRepositoryProvider),
      ref: ref);
});

final authStateChangeProvider=StreamProvider((ref) {
  final authController = ref.watch(authControlleProvider.notifier);
 return authController.authStateChange;
});

class AuthController extends StateNotifier<bool>
{
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,required Ref ref
}):_authRepository=authRepository,
  _ref=ref,
  super(false); ///// loadong part

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Future<void> signWithGoogle(BuildContext context)
  async {
    state =true;
    final user=await _authRepository.signWithGoogle();
    state =false;
    user.fold((l) => showSnackBar(context,l.message), (UserModel) => _ref.read(userProvider.notifier).update((state) => UserModel ));
  }
}