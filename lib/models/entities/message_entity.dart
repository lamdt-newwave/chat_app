import 'package:cloud_firestore/cloud_firestore.dart';

class MessageEntity {
  final String messageId;
  final String authorId;
  final String repliedMessageId;
  final Timestamp createdTime;
  final String roomId;
  final int status;
  final String text;
  final String type;
  final Timestamp updatedTime;
  final String mediaUrl;
  final String thumbnailUrl;

  MessageEntity({
    this.thumbnailUrl = "",
    this.repliedMessageId = "",
    this.messageId = "",
    required this.authorId,
    required this.createdTime,
    required this.roomId,
    this.status = 0,
    this.text = "",
    this.type = "",
    required this.updatedTime,
    this.mediaUrl = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'thumbnailUrl': thumbnailUrl,
      'repliedMessageId': repliedMessageId,
      'messageId': messageId,
      'authorId': authorId,
      'createdTime': createdTime,
      'roomId': roomId,
      'status': status,
      'text': text,
      'type': type,
      'updatedTime': updatedTime,
      'mediaUrl': mediaUrl,
    };
  }

  Map<String, dynamic> toJsonWithoutMessageId() {
    return {
      'thumbnailUrl': thumbnailUrl,
      'repliedMessageId': repliedMessageId,
      'authorId': authorId,
      'createdTime': createdTime,
      'roomId': roomId,
      'status': status,
      'text': text,
      'type': type,
      'updatedTime': updatedTime,
      'mediaUrl': mediaUrl,
    };
  }

  static MessageEntity fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      thumbnailUrl: json['thumbnailUrl'],
      repliedMessageId: json['repliedMessageId'],
      authorId: json["authorId"],
      createdTime: json["createdTime"],
      roomId: json["roomId"],
      updatedTime: json["updatedTime"],
      mediaUrl: json["mediaUrl"],
      status: json["status"],
      text: json["text"],
      type: json["type"],
    );
  }

  MessageEntity copyWith({
    String? messageId,
    String? authorId,
    Timestamp? createdTime,
    String? roomId,
    int? status,
    String? text,
    String? type,
    Timestamp? updatedTime,
    String? mediaUrl,
    String? repliedMessageId,
    String? thumbnailUrl,
  }) {
    return MessageEntity(
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      messageId: messageId ?? this.messageId,
      repliedMessageId: repliedMessageId ?? this.repliedMessageId,
      authorId: authorId ?? this.authorId,
      createdTime: createdTime ?? this.createdTime,
      roomId: roomId ?? this.roomId,
      updatedTime: updatedTime ?? this.updatedTime,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      status: status ?? this.status,
      text: text ?? this.text,
      type: type ?? this.type,
    );
  }
}
