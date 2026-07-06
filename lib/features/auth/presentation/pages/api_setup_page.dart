import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/topological_background.dart';
import '../../../../core/widgets/salvia_watermark.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/haptics.dart';
import '../../domain/entities/api_config.dart';
import '../providers/auth_provider.dart';
import '../../../../core/errors/failures.dart';

class ApiSetupPage extends ConsumerStatefulWidget {
  const ApiSetupPage({super.key});

  @override
  ConsumerState<ApiSetupPage> createState() => _ApiSetupPageState();
}

class _ApiSetupPageState extends ConsumerState<ApiSetupPage> {
  final _chatControllers = <ChatProvider, TextEditingController>{};
  final _imageControllers = <ImageGenProvider, TextEditingController>{};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    for (final p in ChatProvider.values) {
      _chatControllers[p] = TextEditingController();
    }
    for (final p in ImageGenProvider.values) {
      _imageControllers[p] = TextEditingController();
    }
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    final repo = ref.read(authRepositoryProvider);
    for (final p in ChatProvider.values) {
      final r = await repo.getChatApiKey(p);
      if (r is Success<String?> && r.value != null) {
        _chatControllers[p]!.text = r.value!;
      }
    }
    for (final p in ImageGenProvider.values) {
      final r = await repo.getImageApiKey(p);
      if (r is Success<String?> && r.value != null) {
        _imageControllers[p]!.text = r.value!;
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final repo = ref.read(authRepositoryProvider);
    for (final p in ChatProvider.values) {
      final key = _chatControllers[p]!.text.trim();
      if (key.isNotEmpty) await repo.saveChatApiKey(p, key);
    }
    for (final p in ImageGenProvider.values) {
      final key = _imageControllers[p]!.text.trim();
      if (key.isNotEmpty) await repo.saveImageApiKey(p, key);
    }
    await HapticUtils.success();
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API keys saved!')),
      );
    }
  }

  @override
  void dispose() {
    for (final c in _chatControllers.values) c.dispose();
    for (final c in _imageControllers.values) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TopologicalBackground(
        child: Stack(
          children: [
            const SalviaWatermark(),
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    title: Text('API Keys'),
                    floating: true,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _section('Chat Providers', ChatProvider.values
                            .map((p) => _keyField(p.displayName, _chatControllers[p]!))
                            .toList()),
                        const SizedBox(height: 16),
                        _section('Image Providers', ImageGenProvider.values
                            .map((p) => _keyField(p.displayName, _imageControllers[p]!))
                            .toList()),
                        const SizedBox(height: 24),
                        GlassContainer(
                          padding: EdgeInsets.zero,
                          child: ElevatedButton(
                            onPressed: _saving ? null : _save,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                            ),
                            child: _saving
                                ? const CircularProgressIndicator()
                                : const Text('Save Keys'),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _keyField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
