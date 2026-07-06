import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/storage/secure_storage_service.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/api_config.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.read(secureStorageServiceProvider);
  final datasource = AuthLocalDatasource(storage);
  return AuthRepositoryImpl(datasource);
});

final selectedChatProviderProvider =
    StateNotifierProvider<SelectedChatProviderNotifier, ChatProvider>(
  (ref) => SelectedChatProviderNotifier(ref.read(authRepositoryProvider)),
);

class SelectedChatProviderNotifier extends StateNotifier<ChatProvider> {
  final AuthRepository _repo;
  SelectedChatProviderNotifier(this._repo) : super(ChatProvider.gemini) {
    _load();
  }

  Future<void> _load() async {
    final result = await _repo.getSelectedChatProvider();
    if (result is Success<ChatProvider>) state = result.value;
  }

  Future<void> select(ChatProvider provider) async {
    state = provider;
    await _repo.setSelectedChatProvider(provider);
  }
}

final selectedImageProviderProvider =
    StateNotifierProvider<SelectedImageProviderNotifier, ImageGenProvider>(
  (ref) => SelectedImageProviderNotifier(ref.read(authRepositoryProvider)),
);

class SelectedImageProviderNotifier extends StateNotifier<ImageGenProvider> {
  final AuthRepository _repo;
  SelectedImageProviderNotifier(this._repo) : super(ImageGenProvider.stability) {
    _load();
  }

  Future<void> _load() async {
    final result = await _repo.getSelectedImageProvider();
    if (result is Success<ImageGenProvider>) state = result.value;
  }

  Future<void> select(ImageGenProvider provider) async {
    state = provider;
    await _repo.setSelectedImageProvider(provider);
  }
}
