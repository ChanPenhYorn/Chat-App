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

  @override
  void onInit() {
    super.onInit();
    _loadDemoMessages();
  }

  void _loadDemoMessages() {
    messages.addAll([
      MessageModel(
        id: UniqueKey().toString(),
        senderId: 'user123',
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        content: "Hey! How's it going?",
        type: MessageTypeEnum.text,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        senderId: 'user123',
        timestamp: DateTime.now().subtract(Duration(minutes: 4)),
        content: "https://images.unsplash.com/photo-1607746882042-944635dfe10e",
        type: MessageTypeEnum.image,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        senderId: 'currentUser',
        timestamp: DateTime.now().subtract(Duration(minutes: 3)),
        content: "https://sample-videos.com/audio/mp3/crowd-cheering.mp3",
        type: MessageTypeEnum.audio,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        senderId: 'user123',
        timestamp: DateTime.now().subtract(Duration(minutes: 2)),
        content:
            "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
        type: MessageTypeEnum.file,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        senderId: 'currentUser',
        timestamp: DateTime.now().subtract(Duration(minutes: 1)),
        content: "Great! Let's catch up later.",
        type: MessageTypeEnum.text,
      ),
    ]);
  }
}
