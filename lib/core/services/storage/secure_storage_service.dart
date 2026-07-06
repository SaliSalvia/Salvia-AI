import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

class SecureStorageService {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _geminiKey    = 'api_key_gemini';
  static const _deepseekKey  = 'api_key_deepseek';
  static const _openrouterKey= 'api_key_openrouter';
  static const _anthropicKey = 'api_key_anthropic';
  static const _stabilityKey = 'api_key_stability';
  static const _dalleKey     = 'api_key_dalle';
  static const _replicateKey = 'api_key_replicate';
  static const _chatProviderKey  = 'selected_chat_provider';
  static const _imageProviderKey = 'selected_image_provider';

  Future<void> saveChatApiKey(String provider, String key) =>
      _storage.write(key: 'api_key_$provider', value: key);

  Future<String?> getChatApiKey(String provider) =>
      _storage.read(key: 'api_key_$provider');

  Future<void> saveImageApiKey(String provider, String key) =>
      _storage.write(key: 'api_img_$provider', value: key);

  Future<String?> getImageApiKey(String provider) =>
      _storage.read(key: 'api_img_$provider');

  Future<void> setSelectedChatProvider(String provider) =>
      _storage.write(key: _chatProviderKey, value: provider);

  Future<String?> getSelectedChatProvider() =>
      _storage.read(key: _chatProviderKey);

  Future<void> setSelectedImageProvider(String provider) =>
      _storage.write(key: _imageProviderKey, value: provider);

  Future<String?> getSelectedImageProvider() =>
      _storage.read(key: _imageProviderKey);

  Future<void> clearAll() => _storage.deleteAll();
}
