import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatapp/controllers/chat/audio_record_controller.dart';
import 'package:chatapp/controllers/chat/chat_controller.dart';
import 'package:chatapp/utils/app_font.dart';
import 'package:chatapp/utils/enum/message_type_enum.dart';

import 'package:chatapp/widget/app_pdf_view_widget.dart';
import 'package:chatapp/widget/app_textformfiled_widget.dart';
import 'package:chatapp/widget/audio_play_widget.dart';
import 'package:chatapp/widget/image_view_widget.dart';
import 'package:chatapp/widget/waveforms_record_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart' as path;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatController chatController = Get.put(ChatController());
  final audioCtrl = Get.put(AudioRecorderController());

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      chatController.sendText(text);
      _controller.clear();
    }
  }

  void _filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'mp3', 'wav'],
    );

    if (result != null) {
      for (final file in result.files) {
        final extension = file.extension?.toLowerCase();
        if (extension == 'jpg' || extension == 'png') {
          chatController.sendImage(file.path!);
        } else if (extension == 'pdf' || extension == 'doc') {
          chatController.sendFile(file.path!);
        } else if (extension == 'mp3' || extension == 'wav') {
          chatController.sendAudio(file.path!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#f2f2f7"),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chat"),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(0),
        color: Colors.white,
        child: Row(
          children: [
            IconButton(
              onPressed: _filePicker,
              icon: const Icon(Icons.image_outlined),
            ),
            Obx(() {
              if (audioCtrl.isRecording.value) {
                return SizedBox.shrink();
              }

              return Expanded(
                child: AppTextformfieldWidget(
                  fillColor: HexColor("#f2f2f7"),
                  isRequried: false,
                  controller: _controller,
                  hintText: "Type a message",
                  onChanged: (p0) {
                    if (p0.isNotEmpty) {
                      chatController.isRecordingAudio(false);
                    } else {
                      chatController.isRecordingAudio(true);
                    }
                  },
                ),
              );
            }),
            Obx(() => chatController.isRecording.value
                ? WaveformRecorderWidget(
                    onSend: (audioPath) {
                      chatController.sendAudio(audioPath);
                    },
                  )
                : SizedBox.shrink()),
            Obx(() => chatController.isRecording.value == false
                ? IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                    color: Colors.blue,
                  )
                : SizedBox.shrink())
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Text("Today", style: AppFont.medium()),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  reverse: true,
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatController.messages[index];
                    switch (message.type) {
                      case MessageTypeEnum.text:
                        return buildTextMessage(message.content);
                      case MessageTypeEnum.image:
                        return buildImageMessage(message.content);
                      case MessageTypeEnum.file:
                        return buildFileMessage(message.content, context);
                      case MessageTypeEnum.audio:
                        return buildAudioMessage(context, message.content);
                    }
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildAudioMessage(BuildContext context, String audioPath) {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AudioWaveformPlayer(audioPath: audioPath),
    ),
  );
}

Widget buildFileMessage(String filePath, BuildContext context) {
  final fileName = path.basename(filePath);

  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PdfViewerScreen(filePath: filePath),
          ));
    },
    child: Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insert_drive_file, color: Colors.blue),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                fileName,
                style: const TextStyle(color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildImageMessage(String imagePath) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder: (_) => ImageViewerScreen(imagePath: imagePath),
        ),
      );
    },
    child: Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(imagePath),
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}

Widget buildTextMessage(String text) {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
