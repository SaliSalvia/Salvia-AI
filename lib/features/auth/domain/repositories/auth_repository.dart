import '../entities/api_config.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Result<void>> saveChatApiKey(ChatProvider provider, String key);
  Future<Result<String?>> getChatApiKey(ChatProvider provider);
  Future<Result<void>> saveImageApiKey(ImageGenProvider provider, String key);
  Future<Result<String?>> getImageApiKey(ImageGenProvider provider);
  Future<Result<void>> setSelectedChatProvider(ChatProvider provider);
  Future<Result<ChatProvider>> getSelectedChatProvider();
  Future<Result<void>> setSelectedImageProvider(ImageGenProvider provider);
  Future<Result<ImageGenProvider>> getSelectedImageProvider();
}
