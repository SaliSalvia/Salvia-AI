import 'package:dio/dio.dart';

abstract class ImageApiService {
  Future<String> generateImage({
    required String prompt,
    required String apiKey,
    Map<String, dynamic> params,
  });
}

class StabilityAiService implements ImageApiService {
  final Dio _dio;
  StabilityAiService({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
          baseUrl: 'https://api.stability.ai/v1/',
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 120),
        ));

  @override
  Future<String> generateImage({
    required String prompt,
    required String apiKey,
    Map<String, dynamic> params = const {},
  }) async {
    final response = await _dio.post(
      'generation/stable-diffusion-v1-6/text-to-image',
      options: Options(headers: {
        'Authorization': 'Bearer $apiKey',
        'Accept': 'application/json',
      }),
      data: {
        'text_prompts': [{'text': prompt, 'weight': 1}],
        'width': params['width'] ?? 512,
        'height': params['height'] ?? 512,
        'samples': 1,
        'steps': params['steps'] ?? 30,
      },
    );
    final b64 = response.data['artifacts'][0]['base64'] as String;
    return 'data:image/png;base64,$b64';
  }
}

class DallEService implements ImageApiService {
  final Dio _dio;
  DallEService({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
          baseUrl: 'https://api.openai.com/v1/',
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 120),
        ));

  @override
  Future<String> generateImage({
    required String prompt,
    required String apiKey,
    Map<String, dynamic> params = const {},
  }) async {
    final response = await _dio.post(
      'images/generations',
      options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      data: {
        'model': 'dall-e-3',
        'prompt': prompt,
        'n': 1,
        'size': params['size'] ?? '1024x1024',
        'response_format': 'url',
      },
    );
    return response.data['data'][0]['url'] as String;
  }
}

class ImageApiServiceFactory {
  static ImageApiService create(String provider) {
    switch (provider) {
      case 'stability':
        return StabilityAiService();
      case 'dalle':
        return DallEService();
      default:
        return StabilityAiService();
    }
  }
}
