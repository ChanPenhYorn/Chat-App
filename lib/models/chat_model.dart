import 'package:chatapp/utils/enum/message_type_enum.dart';

class ChatMessage {
  final String content;
  final MessageTypeEnum type;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.type,
    required this.timestamp,
  });
}
