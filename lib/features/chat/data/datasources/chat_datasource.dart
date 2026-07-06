import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/chat_message.dart';

class ChatLocalDatasource {
  static const _boxName = 'chat_history';

  Future<Box> _openBox(String sessionId) async {
    return Hive.openBox('${_boxName}_$sessionId');
  }

  Future<List<ChatMessage>> loadHistory(String sessionId) async {
    final box = await _openBox(sessionId);
    return box.values.map((raw) {
      final m = raw as Map;
      return ChatMessage(
        id: m['id'] as String,
        content: m['content'] as String,
        role: MessageRole.values.firstWhere(
          (r) => r.name == m['role'],
          orElse: () => MessageRole.user,
        ),
        timestamp: DateTime.parse(m['timestamp'] as String),
      );
    }).toList();
  }

  Future<void> saveMessage(String sessionId, ChatMessage message) async {
    final box = await _openBox(sessionId);
    await box.put(message.id, {
      'id': message.id,
      'content': message.content,
      'role': message.role.name,
      'timestamp': message.timestamp.toIso8601String(),
    });
  }

  Future<void> clearHistory(String sessionId) async {
    final box = await _openBox(sessionId);
    await box.clear();
  }
}
