import 'dart:ffi';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:reddit_tutorial/core/type_def.dart';

class StorageRepository{
  final FirebaseStoragea _firebaseStoragea;
  StorageRepository({required FirebaseStorage firebaseStorage}):_firebaseStoragea=firebaseStorage;

FutureEither<String?> storeFile(requirede String path,required String Id)
async{
  _firebaseStoragea.ref().chi;
}

}