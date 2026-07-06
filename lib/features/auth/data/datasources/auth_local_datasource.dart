import '../../../../core/services/storage/secure_storage_service.dart';

class AuthLocalDatasource {
  final SecureStorageService _storage;
  AuthLocalDatasource(this._storage);

  Future<void> saveChatKey(String provider, String key) =>
      _storage.saveChatApiKey(provider, key);

  Future<String?> getChatKey(String provider) =>
      _storage.getChatApiKey(provider);

  Future<void> saveImageKey(String provider, String key) =>
      _storage.saveImageApiKey(provider, key);

  Future<String?> getImageKey(String provider) =>
      _storage.getImageApiKey(provider);

  Future<void> setSelectedChat(String provider) =>
      _storage.setSelectedChatProvider(provider);

  Future<String?> getSelectedChat() =>
      _storage.getSelectedChatProvider();

  Future<void> setSelectedImage(String provider) =>
      _storage.setSelectedImageProvider(provider);

  Future<String?> getSelectedImage() =>
      _storage.getSelectedImageProvider();
}
