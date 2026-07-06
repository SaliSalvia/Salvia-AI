import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

abstract class ChatApiService {
  Stream<String> sendMessage({
    required String message,
    required List<Map<String, String>> history,
    required String apiKey,
  });
}

// ─── Gemini Implementation ────────────────────────────────────
class GeminiChatService implements ChatApiService {
  final Dio _dio;
  GeminiChatService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://generativelanguage.googleapis.com/v1beta/',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  @override
  Stream<String> sendMessage({
    required String message,
    required List<Map<String, String>> history,
    required String apiKey,
  }) async* {
    final contents = [
      ...history.map((h) => {'role': h['role'], 'parts': [{'text': h['content']}]}),
      {'role': 'user', 'parts': [{'text': message}]},
    ];

    final response = await _dio.post(
      'models/gemini-1.5-flash:generateContent?key=$apiKey',
      data: {'contents': contents},
    );

    final text = response.data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String? ?? '';
    yield text;
  }
}

// ─── DeepSeek / OpenRouter / OpenAI-compatible Implementation ─
class OpenAICompatibleChatService implements ChatApiService {
  final String baseUrl;
  final String model;
  final Dio _dio;

  OpenAICompatibleChatService({
    required this.baseUrl,
    this.model = 'gpt-3.5-turbo',
    Dio? dio,
  }) : _dio = dio ?? Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
        ));

  @override
  Stream<String> sendMessage({
    required String message,
    required List<Map<String, String>> history,
    required String apiKey,
  }) async* {
    final messages = [
      ...history.map((h) => {'role': h['role'], 'content': h['content']}),
      {'role': 'user', 'content': message},
    ];

    final response = await _dio.post(
      '/chat/completions',
      options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      data: {
        'model': model,
        'messages': messages,
        'stream': false,
      },
    );

    final text = response.data['choices']?[0]?['message']?['content'] as String? ?? '';
    yield text;
  }
}

// ─── Anthropic (Claude) Implementation ─────────────────────────
class AnthropicChatService implements ChatApiService {
  final Dio _dio;
  AnthropicChatService({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
          baseUrl: 'https://api.anthropic.com/v1/',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
        ));

  @override
  Stream<String> sendMessage({
    required String message,
    required List<Map<String, String>> history,
    required String apiKey,
  }) async* {
    final messages = [
      ...history.map((h) => {'role': h['role'], 'content': h['content']}),
      {'role': 'user', 'content': message},
    ];

    final response = await _dio.post(
      'messages',
      options: Options(headers: {
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      }),
      data: {
        'model': 'claude-3-5-haiku-20241022',
        'max_tokens': 2048,
        'messages': messages,
      },
    );

    final text = response.data['content']?[0]?['text'] as String? ?? '';
    yield text;
  }
}

// ─── Factory ──────────────────────────────────────────────────
class ChatApiServiceFactory {
  static ChatApiService create(String provider) {
    switch (provider) {
      case 'gemini':
        return GeminiChatService();
      case 'deepseek':
        return OpenAICompatibleChatService(
          baseUrl: 'https://api.deepseek.com/v1',
          model: 'deepseek-chat',
        );
      case 'zai':
        return OpenAICompatibleChatService(
          baseUrl: 'https://api.z.ai/v1',
          model: 'z1',
        );
      case 'openrouter':
        return OpenAICompatibleChatService(
          baseUrl: 'https://openrouter.ai/api/v1',
          model: 'openai/gpt-4o-mini',
        );
      case 'anthropic':
        return AnthropicChatService();
      default:
        return GeminiChatService();
    }
  }
}
