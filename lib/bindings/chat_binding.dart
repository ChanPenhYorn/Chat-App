import 'package:chatapp/controllers/chat/audio_record_controller.dart';
import 'package:chatapp/controllers/chat/chat_controller.dart';
import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    // Add your controller dependencies here
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<AudioRecorderController>(() => AudioRecorderController());
  }
}
