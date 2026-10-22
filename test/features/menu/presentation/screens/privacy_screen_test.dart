import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/core/privacy/religious_progress_consent_provider.dart';
import 'package:islamfull/features/menu/presentation/screens/privacy_screen.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

class _FakeConsentNotifier extends ReligiousProgressConsentNotifier {
  @override
  ReligiousProgressConsentState build() {
    return const ReligiousProgressConsentState();
  }
}

void main() {
  Widget buildTestableWidget({
    double textScale = 1,
  }) {
    return ProviderScope(
      overrides: [
        religiousProgressConsentProvider.overrideWith(
          _FakeConsentNotifier.new,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        locale: const Locale('en'),
        home: MediaQuery(
          data: MediaQueryData(
            textScaler: TextScaler.linear(
              textScale,
            ),
          ),
          child: const PrivacyScreen(),
        ),
      ),
    );
  }

  testWidgets(
    'privacy screen renders core disclosures and public policy access',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'Privacy & Legal',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Privacy at a glance',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Public privacy policy',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Open Privacy Policy',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Email privacy contact',
        ),
        findsOneWidget,
      );

      expect(
        find.textContaining(
          'islamfull.app@gmail.com',
        ),
        findsOneWidget,
      );

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );

  testWidgets(
    'privacy screen remains safe with large text',
    (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(
          360,
          800,
        ),
      );

      addTearDown(
        () => tester.binding.setSurfaceSize(
          null,
        ),
      );

      await tester.pumpWidget(
        buildTestableWidget(
          textScale: 2,
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'Privacy at a glance',
        ),
        findsOneWidget,
      );

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );
}
