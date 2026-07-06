import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/salvia_watermark.dart';
import '../../../../core/widgets/topological_background.dart';
import '../../../auth/domain/entities/api_config.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/image_studio_provider.dart';

class ImageStudioPage extends ConsumerStatefulWidget {
  const ImageStudioPage({super.key});

  @override
  ConsumerState<ImageStudioPage> createState() => _ImageStudioPageState();
}

class _ImageStudioPageState extends ConsumerState<ImageStudioPage> {
  final _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _generate() async {
    await HapticUtils.medium();
    ref
        .read(imageStudioProvider.notifier)
        .generate(_promptController.text);
  }

  @override
  Widget build(BuildContext context) {
    final studioState = ref.watch(imageStudioProvider);
    final selectedProvider = ref.watch(selectedImageProviderProvider);

    return Scaffold(
      body: TopologicalBackground(
        child: Stack(
          children: [
            const SalviaWatermark(),
            Column(
              children: [
                AppBar(
                  title: const Text('Image Studio'),
                  actions: [
                    PopupMenuButton<ImageGenProvider>(
                      icon: const Icon(Icons.palette_outlined),
                      initialValue: selectedProvider,
                      onSelected: (p) async {
                        await HapticUtils.light();
                        ref
                            .read(selectedImageProviderProvider.notifier)
                            .select(p);
                        ref
                            .read(imageStudioProvider.notifier)
                            .updateProvider(p);
                      },
                      itemBuilder: (_) => ImageGenProvider.values
                          .map((p) => PopupMenuItem(
                                value: p,
                                child: Text(p.displayName),
                              ))
                          .toList(),
                    ),
                  ],
                ),
                GlassContainer(
                  borderRadius: 0,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _promptController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your image prompt...',
                          ),
                          minLines: 1,
                          maxLines: 3,
                          onSubmitted: (_) => _generate(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed:
                            studioState.isGenerating ? null : _generate,
                        child: studioState.isGenerating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.auto_awesome),
                      ),
                    ],
                  ),
                ),
                if (studioState.isGenerating) _ShimmerPlaceholder(),
                if (studioState.error != null)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(studioState.error!,
                        style: const TextStyle(color: AppColors.error)),
                  ),
                Expanded(
                  child: studioState.images.isEmpty
                      ? const Center(
                          child: Text('No images yet',
                              style: TextStyle(color: AppColors.white30)))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: studioState.images.length,
                          itemBuilder: (_, i) {
                            final img = studioState.images[i];
                            return GestureDetector(
                              onTap: () async {
                                await HapticUtils.light();
                                showDialog(
                                  context: context,
                                  builder: (_) => _ImageDialog(image: img),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: img.url.startsWith('data:')
                                    ? Image.memory(
                                        Uri.parse(img.url)
                                            .data!
                                            .contentAsBytes(),
                                        fit: BoxFit.cover)
                                    : CachedNetworkImage(
                                        imageUrl: img.url,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) =>
                                            _ShimmerPlaceholder(),
                                        errorWidget: (_, __, ___) =>
                                            const Icon(Icons.broken_image,
                                                color: AppColors.error),
                                      ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.glassFill,
      child: Container(
        height: 180,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _ImageDialog extends StatelessWidget {
  final dynamic image;
  const _ImageDialog({required this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image.url.startsWith('data:')
                  ? Image.memory(Uri.parse(image.url).data!.contentAsBytes())
                  : CachedNetworkImage(imageUrl: image.url as String),
            ),
            const SizedBox(height: 8),
            Text(
              image.prompt as String,
              style: const TextStyle(
                  color: AppColors.white70, fontSize: 12),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Provider: ${image.provider}',
              style: const TextStyle(
                  color: AppColors.secondary, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
