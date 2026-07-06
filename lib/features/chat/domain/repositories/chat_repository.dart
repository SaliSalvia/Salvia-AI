import '../entities/chat_message.dart';
import '../../../../core/errors/failures.dart';

abstract class ChatRepository {
  Stream<String> streamMessage({
    required String message,
    required List<ChatMessage> history,
    required String apiKey,
    required String provider,
  });

  Future<Result<List<ChatMessage>>> loadHistory(String sessionId);
  Future<Result<void>> saveMessage(String sessionId, ChatMessage message);
  Future<Result<void>> clearHistory(String sessionId);
}
