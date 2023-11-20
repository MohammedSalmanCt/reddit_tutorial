import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/contants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_provider.dart';
import 'package:reddit_tutorial/core/type_def.dart';
import 'package:reddit_tutorial/models/community_model.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});
class CommunityRepository{
  final FirebaseFirestore _firestore;
  CommunityRepository({
    required FirebaseFirestore firestore
}):_firestore=firestore;


  CollectionReference get _communities=> _firestore.collection(FirebaseConstants.communitiesCollection);
  FutureVoid createCommunity(Community community)
  async{
    try{
      var communityDoc=await _communities.doc(community.name).get();
      if(communityDoc.exists)
        {
          throw "Community with the same name already exists!";
        }

   return right(await _communities.doc(community.name).set(community.toMap()));
    }
    on FirebaseException catch(e)
    {
throw e.message!;
    }
    catch(error)
    {
      return left(Failure(message: error.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid)
  {
    return _communities.where("members",arrayContains: uid).snapshots().map((event) {
     List<Community> communities=[];
     for(var i in event.docs)
       {
         communities.add(Community.fromMap(i.data() as Map<String,dynamic>));
       }
     return communities;
    });
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map(
            (event) => Community.fromMap(event.data() as Map<String, dynamic>));
  }


}