import 'dart:io';
import 'package:chatapp/controllers/chat/audio_record_controller.dart';
import 'package:chatapp/controllers/chat/chat_controller.dart';
import 'package:chatapp/utils/app_font.dart';
import 'package:chatapp/utils/enum/message_type_enum.dart';
import 'package:chatapp/widget/app_cached_netword_image_widget.dart';

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
  final ChatController chatController = Get.find();

  final AudioRecorderController audioCtrl = Get.find();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      chatController.sendText(text);
      _controller.clear();
    }

    chatController.isRecordingAudio(true);
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

  bool shouldShowProfile(int index) {
    if (index == 0) {
      // First message (bottom of list in reversed order) should show profile
      return true;
    }

    final currentMessage = chatController.messages[index];
    final previousMessage = chatController.messages[index - 1];

    final isDifferentSender =
        currentMessage.senderId != previousMessage.senderId;

    return isDifferentSender;
  }

  // bool shouldShowProfile(int index) {
  //   if (index == chatController.messages.length - 1) {
  //     return true;
  //   }

  //   final currentMessage = chatController.messages[index];
  //   final nextMessage = chatController.messages[index + 1];

  //   final isDifferentSender = currentMessage.senderId != nextMessage.senderId;

  //   return isDifferentSender;
  // }

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
            Obx(() {
              if (audioCtrl.isRecording.value) {
                return SizedBox.shrink();
              }
              return IconButton(
                onPressed: _filePicker,
                icon: const Icon(Icons.image_outlined),
              );
            }),
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
                    final isCurrentUser = message.senderId == 'currentUser';
                    final senderProfile = message.profile;
                    final showProfile = shouldShowProfile(index);

                    switch (message.type) {
                      case MessageTypeEnum.text:
                        return buildTextMessage(message.content, isCurrentUser,
                            senderProfile, showProfile);
                      case MessageTypeEnum.image:
                        return buildImageMessage(message.content, isCurrentUser,
                            senderProfile, showProfile);
                      case MessageTypeEnum.file:
                        return buildFileMessage(message.content, context,
                            isCurrentUser, senderProfile, showProfile);
                      case MessageTypeEnum.audio:
                        return buildAudioMessage(context, message.content,
                            isCurrentUser, senderProfile, showProfile);
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

Widget buildAudioMessage(BuildContext context, String audioPath,
    bool isCurrentUser, String? senderProfile, bool showProfile) {
  return Align(
    alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end, // Align items at the bottom
        children: [
          if (!isCurrentUser && showProfile)
            buildChatProfile(senderProfile ?? "")
          else
            SizedBox(
              width: 40,
            ),
          if (!isCurrentUser && showProfile) const SizedBox(width: 8),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AudioWaveformPlayer(audioPath: audioPath),
          ),
        ],
      ),
    ),
  );
}

Widget buildFileMessage(String filePath, BuildContext context,
    bool isCurrentUser, String? senderProfile, bool showProfile) {
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
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.end, // Align items at the bottom
          children: [
            if (!isCurrentUser && showProfile)
              buildChatProfile(senderProfile ?? "")
            else
              SizedBox(
                width: 40,
              ),
            if (!isCurrentUser && showProfile) const SizedBox(width: 8),
            Container(
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
          ],
        ),
      ),
    ),
  );
}

Widget buildImageMessage(String imagePath, bool isCurrentUser,
    String? senderProfile, bool showProfile) {
  // Helper method to determine if it's a network URL
  bool isNetworkImage(String path) {
    final trimmed = path.trim();
    return trimmed.startsWith('http://') || trimmed.startsWith('https://');
  }

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
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.end, // Align items at the bottom
          children: [
            if (!isCurrentUser && showProfile)
              buildChatProfile(senderProfile ?? "")
            else
              SizedBox(
                width: 40,
              ),
            if (!isCurrentUser && showProfile) const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isNetworkImage(imagePath)
                    ? AppCachedNetwordImageWidget(
                        width: 250,
                        height: 250,
                        imageUrl: imagePath,
                      )
                    : Image.file(
                        File(imagePath),
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Widget buildTextMessage(
//     String text, bool isCurrentUser, String? senderProfile, bool showProfile) {
//   return Align(
//     alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
//     child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment:
//             isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.end, // Align items at the bottom
//         children: [
//           // if (!isCurrentUser) buildChatProfile(senderProfile ?? ""),
//           if (!isCurrentUser && showProfile)
//             buildChatProfile(senderProfile ?? ""),
//           if (!isCurrentUser && showProfile) const SizedBox(width: 8),

//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: BoxDecoration(
//               color: Colors.blueAccent,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               text,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget buildTextMessage(
//     String text, bool isCurrentUser, String? senderProfile, bool showProfile) {
//   return Align(
//     alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
//     child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment:
//             isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           if (!isCurrentUser && showProfile)
//             buildChatProfile(senderProfile ?? ""),
//           if (!isCurrentUser && showProfile) const SizedBox(width: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: BoxDecoration(
//               color: isCurrentUser ? Colors.blueAccent : Colors.grey[300],
//               borderRadius: BorderRadius.only(
//                 topLeft: const Radius.circular(12),
//                 topRight: const Radius.circular(12),
//                 bottomLeft: Radius.circular(isCurrentUser ? 12 : 0),
//                 bottomRight: Radius.circular(isCurrentUser ? 0 : 12),
//               ),
//             ),
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: isCurrentUser ? Colors.white : Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

Widget buildTextMessage(
    String text, bool isCurrentUser, String? senderProfile, bool showProfile) {
  return Align(
    alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser && showProfile)
            buildChatProfile(senderProfile ?? "")
          else
            SizedBox(
              width: 40,
            ),
          if (!isCurrentUser && showProfile) const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(Get.context!).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blueAccent : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Widget buildChatProfile(String? imageUrl) {
//   if (imageUrl == null || imageUrl.isEmpty) {
//     return CircleAvatar(
//       radius: 16,
//       backgroundColor: Colors.grey[300],
//       child: const Icon(Icons.person, color: Colors.white),
//     );
//   }
//   return CircleAvatar(
//     backgroundColor: Colors.grey[300],
//     radius: 16,
//     backgroundImage: NetworkImage(imageUrl),
//   );
// }

Widget buildChatProfile(String profileUrl, {bool isNotShowProfile = false}) {
  if (isNotShowProfile) {
    return SizedBox(
      width: 32,
      height: 32,
    );
  }
  return ClipOval(
    child: AppCachedNetwordImageWidget(
      width: 32,
      height: 32,
      imageUrl: profileUrl,
    ),
  );
}
