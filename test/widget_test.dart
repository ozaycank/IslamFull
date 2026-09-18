import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:noor_life/app.dart';
import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/core/logging/logger_service.dart';
import 'package:noor_life/core/providers/notification_coordinator_provider.dart';
import 'package:noor_life/features/settings/application/providers/language_settings_notifier.dart';

class MockLoggerService extends Mock implements LoggerService {}

/// Lightweight language provider used by the application bootstrap widget test.
///
/// The production notifier depends on SecureStorageService. App initialization
/// tests should not require platform persistence or plugin infrastructure.
class TestLanguageSettingsNotifier extends LanguageSettingsNotifier {
  @override
  LanguageState build() {
    return const LanguageState(Locale('en'));
  }
}

void main() {
  late MockLoggerService mockLoggerService;

  setUp(() {
    mockLoggerService = MockLoggerService();

    if (getIt.isRegistered<LoggerService>()) {
      getIt.unregister<LoggerService>();
    }

    getIt.registerSingleton<LoggerService>(
      mockLoggerService,
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets(
    'App initialization test',
    (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              // Avoid SecureStorageService dependency in this root widget test.
              languageSettingsNotifierProvider.overrideWith(
                TestLanguageSettingsNotifier.new,
              ),

              // Notification orchestration has its own focused tests and
              // requires several platform/application services. It must not
              // participate in a lightweight application bootstrap test.
              notificationCoordinatorProvider.overrideWith(
                (ref) {},
              ),
            ],
            child: const NoorLifeApp(),
          ),
        );

        await tester.pump();

        expect(
          find.byType(NoorLifeApp),
          findsOneWidget,
        );
      });
    },
  );
}
