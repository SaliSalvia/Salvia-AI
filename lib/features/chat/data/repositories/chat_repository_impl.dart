import '../../../../core/errors/failures.dart';
import '../../../../core/services/api/chat_api_service.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDatasource _local;
  ChatRepositoryImpl(this._local);

  @override
  Stream<String> streamMessage({
    required String message,
    required List<ChatMessage> history,
    required String apiKey,
    required String provider,
  }) {
    final service = ChatApiServiceFactory.create(provider);
    return service.sendMessage(
      message: message,
      history: history.map((m) => m.toApiMap()).toList(),
      apiKey: apiKey,
    );
  }

  @override
  Future<Result<List<ChatMessage>>> loadHistory(String sessionId) async {
    try {
      final msgs = await _local.loadHistory(sessionId);
      return Success(msgs);
    } catch (e) {
      return Err(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> saveMessage(String sessionId, ChatMessage message) async {
    try {
      await _local.saveMessage(sessionId, message);
      return const Success(null);
    } catch (e) {
      return Err(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> clearHistory(String sessionId) async {
    try {
      await _local.clearHistory(sessionId);
      return const Success(null);
    } catch (e) {
      return Err(CacheFailure(e.toString()));
    }
  }
}
