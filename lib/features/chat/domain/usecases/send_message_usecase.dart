import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository _repository;
  SendMessageUseCase(this._repository);

  Stream<String> execute({
    required String message,
    required List<ChatMessage> history,
    required String apiKey,
    required String provider,
  }) {
    return _repository.streamMessage(
      message: message,
      history: history,
      apiKey: apiKey,
      provider: provider,
    );
  }
}
