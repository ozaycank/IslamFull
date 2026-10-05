import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/features/activity/application/activity_provider.dart';
import 'package:noor_life/features/activity/domain/activity_models.dart';
import 'package:noor_life/features/activity/domain/activity_prayer_type.dart';
import 'package:noor_life/features/activity/presentation/screens/activity_screen.dart';
import 'package:noor_life/features/activity/utils/activity_date_utils.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';

class FakeActivityScreenRepository implements ActivityRepository {
  @override
  Future<Result<DailyActivity, ActivityFailure>> getDailyActivity(
    String date,
  ) async {
    return Success(
      DailyActivity(
        date: date,
        completedPrayers: const {
          ActivityPrayerType.fajr: true,
          ActivityPrayerType.dhuhr: false,
          ActivityPrayerType.asr: false,
          ActivityPrayerType.maghrib: false,
          ActivityPrayerType.isha: false,
        },
      ),
    );
  }

  @override
  Future<Result<List<DailyActivity>, ActivityFailure>>
      getAllActivities() async {
    return Success(
      [
        DailyActivity(
          date: ActivityDateUtils.today(),
        ),
      ],
    );
  }

  @override
  Future<Result<void, ActivityFailure>> saveDailyActivity(
    DailyActivity activity,
  ) async {
    return const Success(null);
  }
}

void main() {
  Widget buildTestableWidget({
    double textScale = 1,
  }) {
    final repository = FakeActivityScreenRepository();

    return ProviderScope(
      overrides: [
        activityNotifierProvider.overrideWith(
          (ref) => ActivityNotifier(
            repository,
          ),
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
          child: const ActivityScreen(),
        ),
      ),
    );
  }

  testWidgets(
    'Activity screen exposes worship controls through semantics',
    (tester) async {
      final semanticsHandle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel(
          'Fajr',
        ),
        findsOneWidget,
      );

      expect(
        find.bySemanticsLabel(
          'Dhuhr',
        ),
        findsOneWidget,
      );

      semanticsHandle.dispose();
    },
  );

  testWidgets(
    'Activity screen remains responsive with large text',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          textScale: 2,
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
      );

      expect(
        find.text(
          'Activity',
        ),
        findsOneWidget,
      );
    },
  );
}
