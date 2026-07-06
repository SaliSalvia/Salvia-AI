import '../../../../core/errors/failures.dart';
import '../../../../core/services/storage/secure_storage_service.dart';
import '../../domain/entities/api_config.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource _datasource;
  AuthRepositoryImpl(this._datasource);

  @override
  Future<Result<void>> saveChatApiKey(ChatProvider provider, String key) async {
    try {
      await _datasource.saveChatKey(provider.name, key);
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Result<String?>> getChatApiKey(ChatProvider provider) async {
    try {
      final key = await _datasource.getChatKey(provider.name);
      return Success(key);
    } catch (e) {
      return Err(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> saveImageApiKey(ImageGenProvider provider, String key) async {
    try {
      await _datasource.saveImageKey(provider.name, key);
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Result<String?>> getImageApiKey(ImageGenProvider provider) async {
    try {
      final key = await _datasource.getImageKey(provider.name);
      return Success(key);
    } catch (e) {
      return Err(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> setSelectedChatProvider(ChatProvider provider) async {
    try {
      await _datasource.setSelectedChat(provider.name);
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Result<ChatProvider>> getSelectedChatProvider() async {
    try {
      final name = await _datasource.getSelectedChat();
      final provider = ChatProvider.values.firstWhere(
        (p) => p.name == name,
        orElse: () => ChatProvider.gemini,
      );
      return Success(provider);
    } catch (e) {
      return const Success(ChatProvider.gemini);
    }
  }

  @override
  Future<Result<void>> setSelectedImageProvider(ImageGenProvider provider) async {
    try {
      await _datasource.setSelectedImage(provider.name);
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Result<ImageGenProvider>> getSelectedImageProvider() async {
    try {
      final name = await _datasource.getSelectedImage();
      final provider = ImageGenProvider.values.firstWhere(
        (p) => p.name == name,
        orElse: () => ImageGenProvider.stability,
      );
      return Success(provider);
    } catch (e) {
      return const Success(ImageGenProvider.stability);
    }
  }
}
