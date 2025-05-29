import 'package:chatapp/utils/enum/message_type_enum.dart';

class MessageModel {
  final String id; // Unique identifier
  final String senderId;
  final String content;
  final MessageTypeEnum type;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
  });
}
