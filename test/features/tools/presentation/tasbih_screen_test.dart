import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/features/menu/application/preferences_provider.dart';
import 'package:islamfull/features/tools/presentation/tasbih_screen.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

class _FakePreferencesNotifier extends PreferencesNotifier {
  @override
  PreferencesState build() {
    return const PreferencesState(
      hapticFeedbackEnabled: false,
    );
  }
}

Widget _buildTestApp(Locale locale) {
  return ProviderScope(
    overrides: [
      preferencesProvider.overrideWith(
        _FakePreferencesNotifier.new,
      ),
    ],
    child: MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const TasbihScreen(),
    ),
  );
}

void main() {
  testWidgets(
    'displays localized English tabs and digital counter instruction',
    (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const Locale('en')),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Digital'),
        findsOneWidget,
      );

      expect(
        find.text('Physical Tasbih'),
        findsOneWidget,
      );

      expect(
        find.text('Tap to increment the counter'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'displays localized reset confirmation',
    (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const Locale('en')),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.byTooltip('Reset'),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Are you sure you want to reset the count?'),
        findsOneWidget,
      );

      expect(
        find.text('Cancel'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'displays translated Arabic tab labels',
    (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const Locale('ar')),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('السبحة الرقمية'),
        findsOneWidget,
      );

      expect(
        find.text('السبحة التقليدية'),
        findsOneWidget,
      );

      expect(
        find.text('اضغط لزيادة العدّاد'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'displays localized physical tasbih progress',
    (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const Locale('en')),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.text('Physical Tasbih'),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Start / Imamah'),
        findsOneWidget,
      );

      expect(
        find.text('Scroll down to move the beads'),
        findsOneWidget,
      );

      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, -80),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('SubhanAllah (1/33)'),
        findsOneWidget,
      );
    },
  );
}
