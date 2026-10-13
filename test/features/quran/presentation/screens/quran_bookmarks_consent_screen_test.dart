import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/privacy/religious_progress_consent_provider.dart';
import 'package:noor_life/features/quran/application/providers/quran_bookmark_provider.dart';
import 'package:noor_life/features/quran/application/providers/quran_provider.dart';
import 'package:noor_life/features/quran/application/states/quran_bookmark_state.dart';
import 'package:noor_life/features/quran/application/states/quran_state.dart';
import 'package:noor_life/features/quran/presentation/screens/quran_bookmarks_screen.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';

class _FakeConsentNotifier extends ReligiousProgressConsentNotifier {
  _FakeConsentNotifier(this.initiallyGranted);

  final bool initiallyGranted;

  @override
  ReligiousProgressConsentState build() =>
      ReligiousProgressConsentState(granted: initiallyGranted);
}

class _FakeQuranNotifier extends QuranNotifier {
  @override
  QuranState build() => const QuranState(
        isLoading: false,
        surahs: [],
        searchQuery: '',
      );
}

class _FakeBookmarksNotifier extends QuranBookmarkNotifier {
  @override
  QuranBookmarkState build() => const QuranBookmarkState(isLoading: false);
}

void main() {
  Widget makeApp({required bool consentGranted}) {
    return ProviderScope(
      overrides: [
        religiousProgressConsentProvider.overrideWith(
          () => _FakeConsentNotifier(consentGranted),
        ),
        quranNotifierProvider.overrideWith(_FakeQuranNotifier.new),
        quranBookmarkNotifierProvider.overrideWith(_FakeBookmarksNotifier.new),
      ],
      child: const MaterialApp(
        locale: Locale('en'),
        supportedLocales: [Locale('en')],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: QuranBookmarksScreen(),
      ),
    );
  }

  testWidgets('without consent bookmarks show optional saving guidance',
      (tester) async {
    await tester.pumpWidget(makeApp(consentGranted: false));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('remember your last-read Quran verse'),
      findsOneWidget,
    );
    expect(find.text('Allow Local Progress Saving'), findsOneWidget);
    expect(find.text('No bookmarks yet.'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('consented empty bookmarks keep existing empty state',
      (tester) async {
    await tester.pumpWidget(makeApp(consentGranted: true));
    await tester.pumpAndSettle();

    expect(find.text('No bookmarks yet.'), findsOneWidget);
    expect(find.text('Allow Local Progress Saving'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
