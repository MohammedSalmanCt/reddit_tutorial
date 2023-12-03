import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/contants/firebase_constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/providers/firebase_provider.dart';
import 'package:reddit_tutorial/models/add_user-model.dart';

import '../../core/failure.dart';
import '../../core/type_def.dart';
import '../../models/community_model.dart';
import '../../models/post_model.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepoitory(firestore: ref.watch(firestoreProvider));
});

class UserProfileRepoitory {
  final FirebaseFirestore _firestore;
  UserProfileRepoitory({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _user =>
      _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _post =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid editProfile(
    UserModel user,
  ) async {
    try {
      return right(_user.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<List<Post>> getPost(String uid) {
    return _post
        .where("uid", isEqualTo: uid)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  FutureVoid updateUserKarma(UserModel user) async {
    try {
      return right(_user.doc(user.uid).update({
        'karma': user.karma,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }


}
