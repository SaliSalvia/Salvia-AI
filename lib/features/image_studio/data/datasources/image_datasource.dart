import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/generated_image.dart';

class ImageLocalDatasource {
  static const _boxName = 'image_cache';

  Future<Box> get _box async => Hive.openBox(_boxName);

  Future<List<GeneratedImage>> loadCache() async {
    final box = await _box;
    return box.values.map((raw) {
      final m = raw as Map;
      return GeneratedImage(
        id: m['id'] as String,
        prompt: m['prompt'] as String,
        url: m['url'] as String,
        provider: m['provider'] as String,
        createdAt: DateTime.parse(m['createdAt'] as String),
      );
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveImage(GeneratedImage image) async {
    final box = await _box;
    await _cleanOldEntries(box);
    await box.put(image.id, {
      'id': image.id,
      'prompt': image.prompt,
      'url': image.url,
      'provider': image.provider,
      'createdAt': image.createdAt.toIso8601String(),
    });
  }

  Future<void> _cleanOldEntries(Box box) async {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    final toDelete = <dynamic>[];
    for (final key in box.keys) {
      final raw = box.get(key) as Map?;
      if (raw != null) {
        final date = DateTime.tryParse(raw['createdAt'] as String? ?? '');
        if (date != null && date.isBefore(cutoff)) toDelete.add(key);
      }
    }
    await box.deleteAll(toDelete);
  }
}
