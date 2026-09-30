import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../application/providers/quran_progress_provider.dart';
import '../../application/providers/quran_provider.dart';
import '../../application/states/quran_state.dart';
import '../widgets/continue_reading_card.dart';
import '../widgets/surah_list_tile.dart';

class QuranHomeScreen extends ConsumerWidget {
  const QuranHomeScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    final state = ref.watch(
      quranNotifierProvider,
    );

    final notifier = ref.read(
      quranNotifierProvider.notifier,
    );

    final progressState = ref.watch(
      quranProgressNotifierProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.quranTitle,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bookmarks,
            ),
            tooltip: l10n.quranBookmarks,
            onPressed: () => context.push(
              '${AppRoutes.quran}/bookmarks',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: Column(
              children: [
                if (progressState.lastRead != null && state.surahs.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      0,
                    ),
                    child: ContinueReadingCard(
                      progress: progressState.lastRead!,
                      surahs: state.surahs,
                      onTap: () {
                        context.push(
                          '${AppRoutes.quran}/surah/'
                          '${progressState.lastRead!.surahNumber}',
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(
                    AppSpacing.lg,
                  ),
                  child: TextField(
                    onChanged: notifier.searchSurahs,
                    autocorrect: false,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: l10n.quranSearchHint,
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildBody(
                    context,
                    ref,
                    state,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    QuranState state,
  ) {
    final l10n = context.l10n;

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.failure != null) {
      return ErrorStateWidget(
        title: l10n.errorStateDefaultTitle,
        message: state.failure!.message,
        retryText: l10n.retryButton,
        onRetry: () {
          ref.invalidate(
            quranNotifierProvider,
          );
        },
      );
    }

    if (state.surahs.isEmpty) {
      return Center(
        child: Text(
          l10n.quranNoSurahFound,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      itemCount: state.surahs.length,
      separatorBuilder: (_, __) => const SizedBox(
        height: AppSpacing.sm,
      ),
      itemBuilder: (context, index) {
        return SurahListTile(
          surah: state.surahs[index],
        );
      },
    );
  }
}
