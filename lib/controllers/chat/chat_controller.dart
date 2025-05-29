import 'package:chatapp/models/message_model.dart';

import 'package:chatapp/utils/enum/message_type_enum.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final RxList<MessageModel> messages = <MessageModel>[].obs;

  RxBool isRecording = true.obs;

  void sendText(String text) {
    if (text.trim().isNotEmpty) {
      messages.insert(
        0,
        MessageModel(
          id: UniqueKey().toString(),
          senderId: 'currentUser', // Replace with actual sender id
          timestamp: DateTime.now(),
          content: text.trim(),
          type: MessageTypeEnum.text,
        ),
      );
    }
  }

  void sendImage(String imagePath) {
    messages.insert(
      0,
      MessageModel(
        id: UniqueKey().toString(),
        senderId: 'currentUser', // Replace with actual sender id
        timestamp: DateTime.now(),
        content: imagePath,
        type: MessageTypeEnum.image,
      ),
    );
  }

  void sendFile(String filePath) {
    messages.insert(
      0,
      MessageModel(
        id: UniqueKey().toString(),
        senderId: 'currentUser', // Replace with actual sender id
        timestamp: DateTime.now(),
        content: filePath,
        type: MessageTypeEnum.file,
      ),
    );
  }

  void sendAudio(String audioPath) {
    messages.insert(
      0,
      MessageModel(
        id: UniqueKey().toString(),
        senderId: 'currentUser', // Replace with actual sender id
        timestamp: DateTime.now(),
        content: audioPath,
        type: MessageTypeEnum.audio,
      ),
    );
  }

  void isRecordingAudio(bool value) {
    isRecording.value = value;
  }
}
