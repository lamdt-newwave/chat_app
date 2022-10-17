import 'package:chat_app/common/constants.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserRepository {
  Future<void> addUser({required UserEntity userEntity});

  Future<bool> isExistedUser({required String uId});
}

class UserRepositoryImpl extends UserRepository {
  @override
  Future<void> addUser({required UserEntity userEntity}) {
    CollectionReference users =
        FirebaseFirestore.instance.collection(AppConstants.usersKey);
    return users.doc(userEntity.uId).set(userEntity.toJsonWithoutUid());
  }

  @override
  Future<bool> isExistedUser({required String uId}) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(AppConstants.usersKey);
    final user = await users.doc(uId).get();
    return user.exists;
  }
}
