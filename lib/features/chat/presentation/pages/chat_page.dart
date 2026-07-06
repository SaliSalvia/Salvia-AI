import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/salvia_watermark.dart';
import '../../../../core/widgets/topological_background.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../auth/domain/entities/api_config.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    await HapticUtils.medium();
    await ref.read(chatProvider.notifier).send(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final selectedProvider = ref.watch(selectedChatProviderProvider);

    return Scaffold(
      body: TopologicalBackground(
        child: Stack(
          children: [
            const SalviaWatermark(),
            Column(
              children: [
                const OfflineBanner(),
                AppBar(
                  title: const Text('Salvia AI Chat'),
                  actions: [
                    PopupMenuButton<ChatProvider>(
                      icon: const Icon(Icons.swap_horiz),
                      tooltip: 'Switch provider',
                      initialValue: selectedProvider,
                      onSelected: (p) async {
                        await HapticUtils.light();
                        ref.read(selectedChatProviderProvider.notifier).select(p);
                        ref.read(chatProvider.notifier).updateProvider(p);
                      },
                      itemBuilder: (_) => ChatProvider.values
                          .map((p) => PopupMenuItem(
                                value: p,
                                child: Text(p.displayName),
                              ))
                          .toList(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        await HapticUtils.heavy();
                        ref.read(chatProvider.notifier).clearHistory();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: chatState.messages.isEmpty
                      ? const _EmptyState()
                      : AnimationLimiter(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: chatState.messages.length,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 350),
                                child: SlideAnimation(
                                  verticalOffset: 20,
                                  child: FadeInAnimation(
                                    child: ChatBubble(
                                      message: chatState.messages[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
                if (chatState.error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      chatState.error!,
                      style: const TextStyle(color: AppColors.error, fontSize: 12),
                    ),
                  ),
                _InputBar(
                  controller: _controller,
                  isSending: chatState.isSending,
                  onSend: _send,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chat_bubble_outline,
                size: 48, color: AppColors.primary),
            const SizedBox(height: 12),
            const Text('Start a conversation',
                style: TextStyle(color: AppColors.white70, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 0,
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isSending
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.primary))
                : IconButton(
                    key: const ValueKey('send'),
                    icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                    onPressed: onSend,
                  ),
          ),
        ],
      ),
    );
  }
}
