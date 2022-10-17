import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String uId;
  final String lastName;
  final String firstName;
  final String avatarUrl;
  final int status;
  final String phoneNumber;
  final Timestamp createdTime;
  final Timestamp lastTime;
  final String phoneCode;

  UserEntity({
    required this.phoneCode,
    required this.uId,
    required this.lastName,
    required this.firstName,
    required this.avatarUrl,
    this.status = 0,
    required this.phoneNumber,
    required this.createdTime,
    required this.lastTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'lastName': lastName,
      'firstName': firstName,
      'avatarUrl': avatarUrl,
      'status': status,
      'phoneNumber': phoneNumber,
      'createdTime': createdTime,
      'lastTime': lastTime,
      "phoneCode": phoneCode,
    };
  }

  Map<String, dynamic> toJsonWithoutUid() {
    return {
      'lastName': lastName,
      'firstName': firstName,
      'avatarUrl': avatarUrl,
      'status': status,
      'phoneNumber': phoneNumber,
      'createdTime': createdTime,
      'lastTime': lastTime,
      "phoneCode": phoneCode,
    };
  }
}
