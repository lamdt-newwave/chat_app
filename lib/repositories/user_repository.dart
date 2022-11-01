import 'package:chat_app/common/constants.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserRepository {
  Future<void> addUser({required UserEntity userEntity});

  Future<bool> isExistedUser({required String uId});

  Future<void> updateUser(
    UserEntity userEntity, {
    String? uId,
    String? lastName,
    String? firstName,
    String? avatarUrl,
    int? status,
    String? phoneNumber,
    Timestamp? createdTime,
    Timestamp? lastTime,
    String? phoneCode,
  });

  Future<List<UserEntity>> fetchUsersWithoutUid(String uId);

  Future<UserEntity> getUserById(String uId);
}

class UserRepositoryImpl extends UserRepository {
  final CollectionReference users =
      FirebaseFirestore.instance.collection(AppConstants.usersKey);

  @override
  Future<void> addUser({required UserEntity userEntity}) {
    return users.doc(userEntity.uId).set(userEntity.toJsonWithoutUid());
  }

  @override
  Future<bool> isExistedUser({required String uId}) async {
    final user = await users.doc(uId).get();
    return user.exists;
  }

  @override
  Future<List<UserEntity>> fetchUsersWithoutUid(String uId) async {
    final usersCollection = await FirebaseFirestore.instance
        .collection(AppConstants.usersKey)
        .get();
    return usersCollection.docs
        .map((e) {
          final data = e.data();
          UserEntity userEntity = UserEntity.fromJsonWithoutUid(data);
          return userEntity.copyWith(uId: e.id);
        })
        .where((element) => element.uId != uId)
        .cast<UserEntity>()
        .toList();
  }

  @override
  Future<UserEntity> getUserById(String uId) async {
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance
            .collection(AppConstants.usersKey)
            .doc(uId)
            .get();
    var user = UserEntity.fromJsonWithoutUid(userDoc.data()!);
    user = user.copyWith(uId: uId);
    return user;
  }

  @override
  Future<void> updateUser(UserEntity userEntity,
      {String? uId,
      String? lastName,
      String? firstName,
      String? avatarUrl,
      int? status,
      String? phoneNumber,
      Timestamp? createdTime,
      Timestamp? lastTime,
      String? phoneCode}) {
    final newUser = userEntity.copyWith(
      uId: uId ?? userEntity.uId,
      status: status ?? userEntity.status,
      phoneCode: phoneCode ?? userEntity.phoneCode,
      lastName: lastName ?? userEntity.lastName,
      firstName: firstName ?? userEntity.firstName,
      avatarUrl: avatarUrl ?? userEntity.avatarUrl,
      phoneNumber: phoneNumber ?? userEntity.phoneNumber,
      createdTime: createdTime ?? userEntity.createdTime,
      lastTime: lastTime ?? userEntity.lastTime,
    );
    return users.doc(userEntity.uId).set(
          newUser.toJsonWithoutUid(),
        );
  }
}
