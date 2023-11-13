import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_tutorial/core/contants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_provider.dart';
import 'package:reddit_tutorial/models/add_user-model.dart';
import '../../../core/type_def.dart';



final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(firestore: ref.read(firestoreProvider),
      auth: ref.read(authProvider),
      googleSignIn: ref.read(googleSignInProvider));
});

class AuthRepository{
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn
}):_firestore =firestore,
  _auth=auth,
  _googleSignIn=googleSignIn;

  CollectionReference get _users=>_firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange=>_auth.authStateChanges();

 FutureEither<UserModel> signWithGoogle()
  async{
    try{
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth=await googleUser?.authentication;
      final credential= GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
      );

      UserCredential userCredential=await _auth.signInWithCredential(credential);
      UserModel userModel;
     if(userCredential.additionalUserInfo!.isNewUser)
       {
         userModel=UserModel(name: userCredential.user!.displayName,
             age: null,
             phone: null,
             email: userCredential.user!.email,
             id: userCredential.user!.uid);

        await _users.doc(userCredential.user!.uid).set(userModel.toJson());
       }
     else
       {
         userModel=await getUserData(userCredential.user!.uid).first;
       }
     return right(userModel);
    }
   on FirebaseException catch(e)
    {
      throw e.message!;
    }
    catch (e)
    {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<UserModel> getUserData(String id)
  {
   return _users.doc(id).snapshots().map((event) => UserModel.fromJson(event.data() as Map<String,dynamic>));
  }
}