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
    final now = DateTime.now();

    messages.addAll([
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg",
        senderId: 'user123',
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        content:
            "https://assets.mixkit.co/active_storage/sfx/466/466-preview.mp3",
        type: MessageTypeEnum.audio,
      ),
      // PDF
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg",
        senderId: 'user123',
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        content:
            "https://assets.mixkit.co/active_storage/sfx/59/59-preview.mp3",
        type: MessageTypeEnum.audio,
      ),
      // PDF File Message
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg",
        senderId: 'user123',
        timestamp: DateTime.now().subtract(Duration(minutes: 4)),
        content:
            "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
        type: MessageTypeEnum.file,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg",
        senderId: 'user123',
        timestamp: now.subtract(const Duration(minutes: 6)),
        content: "Hey! How's everything going?",
        type: MessageTypeEnum.text,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg",
        senderId: 'user123',
        timestamp: now.subtract(const Duration(minutes: 5)),
        content: "How have you been lately?",
        type: MessageTypeEnum.text,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg",
        senderId: 'user123',
        timestamp: now.subtract(const Duration(minutes: 4)),
        content: "Hello! Hope you're having a great day!",
        type: MessageTypeEnum.text,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg",
        senderId: 'currentUser',
        timestamp: now.subtract(const Duration(minutes: 3)),
        content: "It's great to hear from you!",
        type: MessageTypeEnum.text,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg",
        senderId: 'user123',
        timestamp: now.subtract(const Duration(minutes: 2)),
        content: "Let’s catch up soon, maybe this weekend?",
        type: MessageTypeEnum.text,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=600",
        senderId: 'user1234',
        timestamp: now.subtract(const Duration(minutes: 1)),
        content: "Did you finish the presentation for tomorrow?",
        type: MessageTypeEnum.text,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg",
        senderId: 'currentUser',
        timestamp: now.subtract(const Duration(seconds: 45)),
        content: "Yes, I wrapped it up earlier today.",
        type: MessageTypeEnum.text,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg",
        senderId: 'user123',
        timestamp: now.subtract(const Duration(seconds: 30)),
        content: "Awesome! Can't wait to see it.",
        type: MessageTypeEnum.text,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=600",
        senderId: 'user1234',
        timestamp: now.subtract(const Duration(seconds: 20)),
        content: "Check out this image I found!",
        type: MessageTypeEnum.text,
      ),
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=600",
        senderId: 'user1234',
        timestamp: now.subtract(const Duration(seconds: 10)),
        content: "https://images.unsplash.com/photo-1607746882042-944635dfe10e",
        type: MessageTypeEnum.image,
      ),
      // Text message
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg",
        senderId: 'user123',
        timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
        content: "Hey! How's the progress on the project?",
        type: MessageTypeEnum.text,
      ),

      // Short voice message (assumed under 60 seconds)
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=600",
        senderId: 'user1234',
        timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
        content:
            "https://commondatastorage.googleapis.com/codeskulptor-assets/Evillaugh.ogg", // Assume < 60s
        type: MessageTypeEnum.audio,
      ),

      // PDF file message
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://images.unsplash.com/photo-1695927621677-ec96e048dce2?fm=jpg&q=60&w=3000",
        senderId: 'currentUser',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        content:
            "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
        type: MessageTypeEnum.file,
      ),

      // Text message
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg",
        senderId: 'user123',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        content:
            "I sent a voice note under a minute and the PDF. Let me know if you got them.",
        type: MessageTypeEnum.text,
      ),

      // Image message
      MessageModel(
        id: UniqueKey().toString(),
        profile:
            "https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg",
        senderId: 'user123',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        content: "https://images.unsplash.com/photo-1607746882042-944635dfe10e",
        type: MessageTypeEnum.image,
      ),
    ]);
  }
}
