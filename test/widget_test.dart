import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:noor_life/app.dart';
import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/core/logging/logger_service.dart';

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late MockLoggerService mockLoggerService;

  setUp(() {
    mockLoggerService = MockLoggerService();

    if (!getIt.isRegistered<LoggerService>()) {
      getIt.registerSingleton<LoggerService>(mockLoggerService);
    } else {
      getIt.unregister<LoggerService>();
      getIt.registerSingleton<LoggerService>(mockLoggerService);
    }
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('App initialization test', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        const ProviderScope(
          child: NoorLifeApp(),
        ),
      );

      // Let the first frame render without forcing animations to complete
      await tester.pump();

      expect(find.byType(NoorLifeApp), findsOneWidget);
    });
  });
}
