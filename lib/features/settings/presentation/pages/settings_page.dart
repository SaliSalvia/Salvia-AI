import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/salvia_watermark.dart';
import '../../../../core/widgets/topological_background.dart';
import '../../../auth/presentation/pages/api_setup_page.dart';
import '../../../auth/domain/entities/api_config.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localProvider);

    return Scaffold(
      body: TopologicalBackground(
        child: Stack(
          children: [
            const SalviaWatermark(),
            SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const AppBar(title: Text('Settings')),
                  const SizedBox(height: 16),
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Language',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _LangButton(
                              label: 'English',
                              selected: locale.languageCode == 'en',
                              onTap: () async {
                                await HapticUtils.light();
                                ref.read(localProvider.notifier).setEnglish();
                              },
                            ),
                            const SizedBox(width: 8),
                            _LangButton(
                              label: 'Persian (فارسی)',
                              selected: locale.languageCode == 'fa',
                              onTap: () async {
                                await HapticUtils.light();
                                ref.read(localProvider.notifier).setPersian();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Chat Provider',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButton<ChatProvider>(
                          value: ref.watch(selectedChatProviderProvider),
                          isExpanded: true,
                          dropdownColor: AppColors.surface,
                          items: ChatProvider.values
                              .map((p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(p.displayName,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ))
                              .toList(),
                          onChanged: (p) async {
                            if (p == null) return;
                            await HapticUtils.light();
                            ref
                                .read(selectedChatProviderProvider.notifier)
                                .select(p);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Image Provider',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButton<ImageGenProvider>(
                          value: ref.watch(selectedImageProviderProvider),
                          isExpanded: true,
                          dropdownColor: AppColors.surface,
                          items: ImageGenProvider.values
                              .map((p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(p.displayName,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ))
                              .toList(),
                          onChanged: (p) async {
                            if (p == null) return;
                            await HapticUtils.light();
                            ref
                                .read(selectedImageProviderProvider.notifier)
                                .select(p);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.vpn_key_outlined),
                    label: const Text('Manage API Keys'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ApiSetupPage()),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'Salvia AI v4.0 — SalarSalvia',
                      style: TextStyle(
                          color: AppColors.white30, fontSize: 12),
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
}

class _LangButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LangButton(
      {required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.glassFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: selected
                    ? AppColors.primary
                    : AppColors.glassBorder),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.white70,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
