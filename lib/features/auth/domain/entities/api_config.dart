class ApiConfig {
  final String provider;
  final String apiKey;
  final bool isValid;

  const ApiConfig({
    required this.provider,
    required this.apiKey,
    this.isValid = false,
  });

  ApiConfig copyWith({String? provider, String? apiKey, bool? isValid}) {
    return ApiConfig(
      provider: provider ?? this.provider,
      apiKey: apiKey ?? this.apiKey,
      isValid: isValid ?? this.isValid,
    );
  }
}

enum ChatProvider {
  gemini('Google Gemini'),
  deepseek('DeepSeek'),
  zai('z.ai'),
  openrouter('OpenRouter'),
  anthropic('Anthropic Claude');

  final String displayName;
  const ChatProvider(this.displayName);
}

/// Renamed from ImageProvider to avoid conflict with Flutter's built-in ImageProvider
enum ImageGenProvider {
  stability('Stability AI'),
  dalle('OpenAI DALL-E'),
  replicate('Replicate'),
  leonardo('Leonardo.ai'),
  ideogram('Ideogram');

  final String displayName;
  const ImageGenProvider(this.displayName);
}
