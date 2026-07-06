import 'package:flutter_test/flutter_test.dart';
import 'package:salvia_ai/features/chat/domain/entities/chat_message.dart';

void main() {
  group('ChatMessage', () {
    final message = ChatMessage(
      id: '1',
      content: 'Hello',
      role: MessageRole.user,
      timestamp: DateTime(2024, 1, 1),
    );

    test('copyWith preserves unchanged fields', () {
      final updated = message.copyWith(content: 'Updated');
      expect(updated.content, 'Updated');
      expect(updated.id, '1');
      expect(updated.role, MessageRole.user);
    });

    test('toApiMap returns correct keys', () {
      final map = message.toApiMap();
      expect(map['role'], 'user');
      expect(map['content'], 'Hello');
    });

    test('isStreaming defaults to false', () {
      expect(message.isStreaming, isFalse);
    });
  });
}
