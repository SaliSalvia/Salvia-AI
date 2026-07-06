import 'dart:math';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/api/image_api_service.dart';
import '../../domain/entities/generated_image.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/image_datasource.dart';

class ImageRepositoryImpl implements ImageStudioRepository {
  final ImageLocalDatasource _local;
  ImageRepositoryImpl(this._local);

  @override
  Future<Result<GeneratedImage>> generate({
    required String prompt,
    required String apiKey,
    required String provider,
    Map<String, dynamic> params = const {},
  }) async {
    try {
      final service = ImageApiServiceFactory.create(provider);
      final url = await service.generateImage(
        prompt: prompt,
        apiKey: apiKey,
        params: params,
      );
      final image = GeneratedImage(
        id: Random().nextInt(999999999).toString(),
        prompt: prompt,
        url: url,
        provider: provider,
        createdAt: DateTime.now(),
      );
      await _local.saveImage(image);
      return Success(image);
    } catch (e) {
      return Err(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<GeneratedImage>>> loadCache() async {
    try {
      final images = await _local.loadCache();
      return Success(images);
    } catch (e) {
      return Err(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> saveToCache(GeneratedImage image) async {
    try {
      await _local.saveImage(image);
      return const Success(null);
    } catch (e) {
      return Err(CacheFailure(e.toString()));
    }
  }
}
