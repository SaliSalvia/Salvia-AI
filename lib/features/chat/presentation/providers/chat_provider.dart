import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/storage/secure_storage_service.dart';
import '../../../../core/utils/haptics.dart';
import '../../../auth/domain/entities/api_config.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/chat_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'dart:math';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ChatLocalDatasource());
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  return SendMessageUseCase(ref.read(chatRepositoryProvider));
});

class ChatState {
  final List<ChatMessage> messages;
  final bool isSending;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isSending = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isSending,
    String? error,
  }) =>
      ChatState(
        messages: messages ?? this.messages,
        isSending: isSending ?? this.isSending,
        error: error,
      );
}

final chatProvider =
    StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(
    ref.read(sendMessageUseCaseProvider),
    ref.read(chatRepositoryProvider),
    ref.read(authRepositoryProvider),
    ref.read(selectedChatProviderProvider),
  );
});

class ChatNotifier extends StateNotifier<ChatState> {
  final SendMessageUseCase _useCase;
  final ChatRepository _repository;
  final AuthRepository _authRepo;
  ChatProvider _chatProvider;
  static const _sessionId = 'default';

  ChatNotifier(
    this._useCase,
    this._repository,
    this._authRepo,
    this._chatProvider,
  ) : super(const ChatState()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final result = await _repository.loadHistory(_sessionId);
    if (result is Success<List<ChatMessage>>) {
      state = state.copyWith(messages: result.value);
    }
  }

  Future<void> send(String text) async {
    if (text.trim().isEmpty || state.isSending) return;

    final apiKeyResult = await _authRepo.getChatApiKey(_chatProvider);
    final apiKey = apiKeyResult is Success<String?> ? apiKeyResult.value ?? '' : '';

    // Capture history BEFORE mutating state to avoid polluted context
    final historySnapshot = List<ChatMessage>.from(state.messages)
        .where((m) => !m.isStreaming)
        .take(20)
        .toList();

    final userMsg = ChatMessage(
      id: _uid(),
      content: text.trim(),
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    final assistantMsg = ChatMessage(
      id: _uid(),
      content: '',
      role: MessageRole.assistant,
      timestamp: DateTime.now(),
      isStreaming: true,
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg, assistantMsg],
      isSending: true,
      error: null,
    );

    await _repository.saveMessage(_sessionId, userMsg);

    try {
      String accumulated = '';
      await for (final chunk in _useCase.execute(
        message: text.trim(),
        history: historySnapshot,
        apiKey: apiKey,
        provider: _chatProvider.name,
      )) {
        accumulated += chunk;
        final updatedMsgs = state.messages.map((m) {
          if (m.id == assistantMsg.id) {
            return m.copyWith(content: accumulated, isStreaming: true);
          }
          return m;
        }).toList();
        state = state.copyWith(messages: updatedMsgs);
      }

      final finalMsgs = state.messages.map((m) {
        if (m.id == assistantMsg.id) {
          return m.copyWith(isStreaming: false);
        }
        return m;
      }).toList();

      state = state.copyWith(messages: finalMsgs, isSending: false);

      final finalAssistant = finalMsgs.firstWhere((m) => m.id == assistantMsg.id);
      await _repository.saveMessage(_sessionId, finalAssistant);
      await HapticUtils.success();
    } catch (e) {
      final errorMsgs = state.messages.where((m) => m.id != assistantMsg.id).toList();
      state = state.copyWith(
        messages: errorMsgs,
        isSending: false,
        error: e.toString(),
      );
      await HapticUtils.error();
    }
  }

  void updateProvider(ChatProvider provider) {
    _chatProvider = provider;
  }

  Future<void> clearHistory() async {
    await _repository.clearHistory(_sessionId);
    state = const ChatState();
  }

  String _uid() => Random().nextInt(999999999).toString();
}
