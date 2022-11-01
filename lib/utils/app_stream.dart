import 'dart:async';

import 'package:chat_app/common/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppStream {
  StreamController messagesController = StreamController<dynamic>.broadcast();

  void startStream() {
    FirebaseFirestore.instance
        .collection(AppConstants.messagesKey)
        .snapshots()
        .listen((querySnapshot) async {
      messagesController.sink.add(querySnapshot);
    });
  }
}

