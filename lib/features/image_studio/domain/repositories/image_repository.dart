import '../entities/generated_image.dart';
import '../../../../core/errors/failures.dart';

abstract class ImageStudioRepository {
  Future<Result<GeneratedImage>> generate({
    required String prompt,
    required String apiKey,
    required String provider,
    Map<String, dynamic> params,
  });

  Future<Result<List<GeneratedImage>>> loadCache();
  Future<Result<void>> saveToCache(GeneratedImage image);
}
