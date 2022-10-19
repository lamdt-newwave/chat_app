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
    this.uId = "",
    required this.lastName,
    required this.firstName,
    required this.avatarUrl,
    required this.status,
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

  static UserEntity fromJsonWithoutUid(Map<String, dynamic> json) {
    return UserEntity(
      phoneCode: json["phoneCode"],
      lastName: json["lastName"],
      firstName: json["firstName"],
      avatarUrl: json["avatarUrl"],
      phoneNumber: json["phoneNumber"],
      createdTime: json["createdTime"],
      status: json["status"],
      lastTime: json["lastTime"],
    );
  }

  UserEntity copyWith({
    String? uId,
    String? lastName,
    String? firstName,
    String? avatarUrl,
    int? status,
    String? phoneNumber,
    Timestamp? createdTime,
    Timestamp? lastTime,
    String? phoneCode,
  }) {
    return UserEntity(
      uId: uId ?? this.uId,
      status: status ?? this.status,
      phoneCode: phoneCode ?? this.phoneCode,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdTime: createdTime ?? this.createdTime,
      lastTime: lastTime ?? this.lastTime,
    );
  }

  @override
  String toString() {
    return 'UserEntity{uId: $uId, lastName: $lastName, firstName: $firstName, avatarUrl: $avatarUrl, status: $status, phoneNumber: $phoneNumber, createdTime: $createdTime, lastTime: $lastTime, phoneCode: $phoneCode}';
  }
}
