import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/haptics.dart';
import '../../../auth/domain/entities/api_config.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/image_datasource.dart';
import '../../data/repositories/image_repository_impl.dart';
import '../../domain/entities/generated_image.dart';
import '../../domain/repositories/image_repository.dart';

final imageRepositoryProvider = Provider<ImageStudioRepository>((ref) {
  return ImageRepositoryImpl(ImageLocalDatasource());
});

class ImageStudioState {
  final List<GeneratedImage> images;
  final bool isGenerating;
  final String? error;

  const ImageStudioState({
    this.images = const [],
    this.isGenerating = false,
    this.error,
  });

  ImageStudioState copyWith({
    List<GeneratedImage>? images,
    bool? isGenerating,
    String? error,
  }) =>
      ImageStudioState(
        images: images ?? this.images,
        isGenerating: isGenerating ?? this.isGenerating,
        error: error,
      );
}

final imageStudioProvider =
    StateNotifierProvider<ImageStudioNotifier, ImageStudioState>((ref) {
  return ImageStudioNotifier(
    ref.read(imageRepositoryProvider),
    ref.read(authRepositoryProvider),
    ref.read(selectedImageProviderProvider),
  );
});

class ImageStudioNotifier extends StateNotifier<ImageStudioState> {
  final ImageStudioRepository _repo;
  final AuthRepository _authRepository;
  ImageGenProvider _imageProvider;

  ImageStudioNotifier(this._repo, this._authRepository, this._imageProvider)
      : super(const ImageStudioState()) {
    _loadCache();
  }

  Future<void> _loadCache() async {
    final result = await _repo.loadCache();
    if (result is Success<List<GeneratedImage>>) {
      state = state.copyWith(images: result.value);
    }
  }

  Future<void> generate(String prompt) async {
    if (state.isGenerating || prompt.trim().isEmpty) return;

    final apiKeyResult =
        await _authRepository.getImageApiKey(_imageProvider);
    final apiKey =
        apiKeyResult is Success<String?> ? apiKeyResult.value ?? '' : '';

    state = state.copyWith(isGenerating: true, error: null);

    final result = await _repo.generate(
      prompt: prompt.trim(),
      apiKey: apiKey,
      provider: _imageProvider.name,
    );

    if (result is Success<GeneratedImage>) {
      state = state.copyWith(
        images: [result.value, ...state.images],
        isGenerating: false,
      );
      await HapticUtils.success();
    } else if (result is Err<GeneratedImage>) {
      state = state.copyWith(
        isGenerating: false,
        error: result.failure.message,
      );
      await HapticUtils.error();
    }
  }

  void updateProvider(ImageGenProvider provider) {
    _imageProvider = provider;
  }
}
