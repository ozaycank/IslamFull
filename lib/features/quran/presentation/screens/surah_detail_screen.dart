import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../application/providers/quran_bookmark_provider.dart';
import '../../application/providers/quran_progress_provider.dart';
import '../../application/providers/quran_translation_provider.dart';
import '../../domain/entities/quran_reading_progress.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../constants/quran_reader_typography.dart';
import '../widgets/quran_ayah_view.dart';
import '../widgets/quran_reader_settings_sheet.dart';
import '../widgets/quran_surah_header.dart';

class SurahDetailScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final int? jumpToAyah;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    this.jumpToAyah,
  });

  @override
  ConsumerState<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends ConsumerState<SurahDetailScreen> {
  Surah? _surah;
  String? _error;
  bool _isLoading = true;

  final ItemScrollController _itemScrollController = ItemScrollController();

  int _initialScrollIndex = 0;
  int _highestVisibleAyah = 1;

  @override
  void initState() {
    super.initState();
    _loadSurahDetail();
  }

  Future<void> _loadSurahDetail() async {
    try {
      final repository = getIt<QuranRepository>();

      final surah = await repository.getSurahDetail(
        widget.surahNumber,
      );

      if (!mounted) {
        return;
      }

      final initialScrollIndex = _resolveInitialScrollIndex(
        surah,
      );

      setState(() {
        _surah = surah;
        _initialScrollIndex = initialScrollIndex;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  int _resolveInitialScrollIndex(
    Surah surah,
  ) {
    final ayahs = surah.ayahs ?? const [];

    if (ayahs.isEmpty) {
      return 0;
    }

    int? targetAyah = widget.jumpToAyah;

    if (targetAyah == null) {
      final progressState = ref.read(
        quranProgressNotifierProvider,
      );

      final lastRead = progressState.lastRead;

      if (lastRead != null && lastRead.surahNumber == widget.surahNumber) {
        targetAyah = lastRead.ayahNumber;
      }
    }

    if (targetAyah == null || targetAyah < 1 || targetAyah > ayahs.length) {
      return 0;
    }

    final showBismillah = widget.surahNumber != 1 && widget.surahNumber != 9;

    // List structure:
    //
    // index 0 = surah header
    // index 1 = bismillah when applicable
    // remaining indexes = ayahs
    //
    // Without Bismillah:
    // ayah 1 -> index 1
    //
    // With Bismillah:
    // ayah 1 -> index 2
    return targetAyah + (showBismillah ? 1 : 0);
  }

  void _updateProgress(
    int ayahNumber,
  ) {
    if (ayahNumber <= _highestVisibleAyah) {
      return;
    }

    _highestVisibleAyah = ayahNumber;

    final progress = QuranReadingProgress(
      surahNumber: widget.surahNumber,
      ayahNumber: _highestVisibleAyah,
      updatedAt: DateTime.now(),
    );

    ref
        .read(
          quranProgressNotifierProvider.notifier,
        )
        .saveProgress(
          progress,
        );
  }

  void _showSettingsSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) => const QuranReaderSettingsSheet(),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final l10n = context.l10n;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '${l10n.quranTitle} ${widget.surahNumber}',
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null || _surah == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.errorStateDefaultTitle,
          ),
        ),
        body: Center(
          child: Text(
            _error ?? l10n.generalError,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final ayahs = _surah!.ayahs ?? [];

    final showBismillah = widget.surahNumber != 1 && widget.surahNumber != 9;

    final totalItems = 1 + (showBismillah ? 1 : 0) + ayahs.length;

    final bookmarkState = ref.watch(
      quranBookmarkNotifierProvider,
    );

    final languageCode = l10n.localeName == 'tr' ? 'tr' : 'en';

    final translationAsyncValue = ref.watch(
      quranTranslationProvider(
        (
          surahNumber: widget.surahNumber,
          languageCode: languageCode,
        ),
      ),
    );

    final translationsMap = translationAsyncValue.valueOrNull ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.localeName == 'tr'
              ? _surah!.nameTurkish
              : _surah!.nameTransliteration,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.format_size,
            ),
            tooltip: l10n.quranReaderSettings,
            onPressed: _showSettingsSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: QuranReaderTypography.maxReaderWidth,
            ),
            child: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              initialScrollIndex: _initialScrollIndex,
              itemCount: totalItems,
              itemBuilder: (
                context,
                index,
              ) {
                if (index == 0) {
                  return QuranSurahHeader(
                    surah: _surah!,
                  );
                }

                if (showBismillah && index == 1) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                    ),
                    child: Text(
                      'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                      style: textTheme.headlineMedium?.copyWith(
                        fontSize: QuranReaderTypography.bismillahFontSize,
                        color: colorScheme.primary,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final ayahIndex = index - 1 - (showBismillah ? 1 : 0);

                final ayah = ayahs[ayahIndex];

                final isBookmarked = bookmarkState.bookmarks.any(
                  (bookmark) =>
                      bookmark.surahNumber == widget.surahNumber &&
                      bookmark.ayahNumber == ayah.numberInSurah,
                );

                final ayahTranslation = translationsMap[ayah.numberInSurah];

                return VisibilityDetector(
                  key: Key(
                    'ayah-${ayah.numberInSurah}',
                  ),
                  onVisibilityChanged: (info) {
                    if (info.visibleFraction > 0.4) {
                      _updateProgress(
                        ayah.numberInSurah,
                      );
                    }
                  },
                  child: QuranAyahView(
                    ayah: ayah,
                    isBookmarked: isBookmarked,
                    translation: ayahTranslation,
                    onBookmarkToggle: () {
                      ref
                          .read(
                            quranBookmarkNotifierProvider.notifier,
                          )
                          .toggleBookmark(
                            surahNumber: widget.surahNumber,
                            ayahNumber: ayah.numberInSurah,
                          );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
