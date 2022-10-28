import 'package:cloud_firestore/cloud_firestore.dart';

class MessageEntity {
  final String messageId;
  final String authorId;
  final Timestamp createdTime;
  final String roomId;
  final int status;
  final String text;
  final String typeMedia;
  final Timestamp updatedTime;
  final String mediaUrl;

  MessageEntity({
    this.messageId = "",
    required this.authorId,
    required this.createdTime,
    required this.roomId,
    this.status = 0,
    this.text = "",
    this.typeMedia = "",
    required this.updatedTime,
    this.mediaUrl = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'authorId': authorId,
      'createdTime': createdTime,
      'roomId': roomId,
      'status': status,
      'text': text,
      'typeMedia': typeMedia,
      'updatedTime': updatedTime,
      'mediaUrl': mediaUrl,
    };
  }

  Map<String, dynamic> toJsonWithoutMessageId() {
    return {
      'authorId': authorId,
      'createdTime': createdTime,
      'roomId': roomId,
      'status': status,
      'text': text,
      'typeMedia': typeMedia,
      'updatedTime': updatedTime,
      'mediaUrl': mediaUrl,
    };
  }

  static MessageEntity fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      authorId: json["authorId"],
      createdTime: json["createdTime"],
      roomId: json["roomId"],
      updatedTime: json["updatedTime"],
      mediaUrl: json["mediaUrl"],
      status: json["status"],
      text: json["text"],
      typeMedia: json["typeMedia"],
    );
  }

  MessageEntity copyWith({
    String? messageId,
    String? authorId,
    Timestamp? createdTime,
    String? roomId,
    int? status,
    String? text,
    String? typeMedia,
    Timestamp? updatedTime,
    String? mediaUrl,
  }) {
    return MessageEntity(
      authorId: authorId ?? this.authorId,
      createdTime: createdTime ?? this.createdTime,
      roomId: roomId ?? this.roomId,
      updatedTime: updatedTime ?? this.updatedTime,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      status: status ?? this.status,
      text: text ?? this.text,
      typeMedia: typeMedia ?? this.typeMedia,
    );
  }
}
