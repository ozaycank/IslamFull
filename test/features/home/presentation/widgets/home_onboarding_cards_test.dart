import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/features/home/presentation/widgets/home_onboarding_cards.dart';
import 'package:islamfull/features/prayer/location/application/providers/location_notifier.dart';
import 'package:islamfull/features/prayer/location/application/states/location_state.dart';
import 'package:islamfull/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:islamfull/features/prayer/location/domain/interfaces/location_service.dart';
import 'package:islamfull/features/prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import 'package:islamfull/features/prayer/prayer_times/application/states/prayer_times_state.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/entities/prayer_day.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/entities/prayer_schedule.dart';
import 'package:islamfull/features/settings/application/providers/notification_settings_provider.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

const _location = PrayerLocation(
  latitude: 41.0082,
  longitude: 28.9784,
  cityName: 'Istanbul',
  countryName: 'Türkiye',
  timezoneIdentifier: 'Europe/Istanbul',
);

class _FakeLocationNotifier extends LocationNotifier {
  final LocationState initialState;

  _FakeLocationNotifier(this.initialState);

  @override
  LocationState build() => initialState;
}

class _FakePrayerTimesNotifier extends PrayerTimesNotifier {
  final PrayerTimesState initialState;

  _FakePrayerTimesNotifier(this.initialState);

  @override
  PrayerTimesState build() => initialState;
}

class _FakeNotificationSettingsNotifier extends NotificationSettingsNotifier {
  final NotificationSettingsState initialState;

  _FakeNotificationSettingsNotifier(this.initialState);

  @override
  NotificationSettingsState build() => initialState;
}

Widget _testApp({
  required Widget child,
  required List<Override> overrides,
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      locale: const Locale('en'),
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: SingleChildScrollView(
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'location setup card is shown when no location is configured',
    (tester) async {
      await tester.pumpWidget(
        _testApp(
          child: const HomeLocationSetupCard(),
          overrides: [
            locationNotifierProvider.overrideWith(
              () => _FakeLocationNotifier(
                const LocationState(
                  status: LocationStatus.failure,
                  failure: LocationFailure(
                    'No location selected',
                    code: 'locationNotConfigured',
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Set your location'),
        findsOneWidget,
      );

      expect(
        find.text('Use my current location'),
        findsOneWidget,
      );

      expect(
        find.text('Enter coordinates manually'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'location setup card is hidden when a saved location exists',
    (tester) async {
      await tester.pumpWidget(
        _testApp(
          child: const HomeLocationSetupCard(),
          overrides: [
            locationNotifierProvider.overrideWith(
              () => _FakeLocationNotifier(
                const LocationState(
                  status: LocationStatus.success,
                  location: _location,
                ),
              ),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Set your location'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'notification card is hidden until prayer schedule is loaded',
    (tester) async {
      await tester.pumpWidget(
        _testApp(
          child: const HomeNotificationSetupCard(),
          overrides: [
            prayerTimesNotifierProvider.overrideWith(
              () => _FakePrayerTimesNotifier(
                const PrayerTimesState(
                  location: _location,
                ),
              ),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Stay informed about prayer times'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'notification card is shown after prayer schedule is loaded',
    (tester) async {
      final day = PrayerDay(
        targetDate: DateTime(2026, 10, 30),
        prayerTimes: const [],
      );

      final schedule = PrayerSchedule(
        yesterday: day,
        today: day,
        tomorrow: day,
      );

      await tester.pumpWidget(
        _testApp(
          child: const HomeNotificationSetupCard(),
          overrides: [
            prayerTimesNotifierProvider.overrideWith(
              () => _FakePrayerTimesNotifier(
                PrayerTimesState(
                  isLoading: false,
                  location: _location,
                  schedule: schedule,
                ),
              ),
            ),
            notificationSettingsProvider.overrideWith(
              () => _FakeNotificationSettingsNotifier(
                const NotificationSettingsState(
                  isLoaded: true,
                  platformSupported: true,
                  masterEnabled: false,
                  notificationPromptDismissed: false,
                ),
              ),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Stay informed about prayer times'),
        findsOneWidget,
      );

      expect(
        find.text('Enable notifications'),
        findsOneWidget,
      );

      expect(
        find.text('Not now'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'notification card remains hidden after user dismissed it',
    (tester) async {
      final day = PrayerDay(
        targetDate: DateTime(2026, 10, 30),
        prayerTimes: const [],
      );

      final schedule = PrayerSchedule(
        yesterday: day,
        today: day,
        tomorrow: day,
      );

      await tester.pumpWidget(
        _testApp(
          child: const HomeNotificationSetupCard(),
          overrides: [
            prayerTimesNotifierProvider.overrideWith(
              () => _FakePrayerTimesNotifier(
                PrayerTimesState(
                  location: _location,
                  schedule: schedule,
                ),
              ),
            ),
            notificationSettingsProvider.overrideWith(
              () => _FakeNotificationSettingsNotifier(
                const NotificationSettingsState(
                  isLoaded: true,
                  platformSupported: true,
                  notificationPromptDismissed: true,
                ),
              ),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Stay informed about prayer times'),
        findsNothing,
      );
    },
  );
}
