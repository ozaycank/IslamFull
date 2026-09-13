// ignore_for_file: avoid_relative_lib_imports
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:noor_life/core/base/result.dart';
// FIX: GetIt doğrudan projenin kendi container'ından çekiliyor
import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/features/activity/domain/activity_models.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';
import 'package:noor_life/features/profile/presentation/screens/profile_screen.dart';

class FakeActivityRepository implements ActivityRepository {
  @override
  Future<Result<DailyActivity, ActivityFailure>> getDailyActivity(
    String date,
  ) async {
    return Success(DailyActivity(date: date));
  }

  @override
  Future<Result<List<DailyActivity>, ActivityFailure>>
      getAllActivities() async {
    return const Success([]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() {
    // FIX: Projenin kendi GetIt servisi üzerinden güvenli kayıt
    if (!getIt.isRegistered<ActivityRepository>()) {
      getIt.registerSingleton<ActivityRepository>(FakeActivityRepository());
    } else {
      getIt.unregister<ActivityRepository>();
      getIt.registerSingleton<ActivityRepository>(FakeActivityRepository());
    }
  });

  tearDown(() {
    getIt.reset();
  });

  Widget buildTestableWidget() {
    return const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        locale: Locale('en'),
        home: Scaffold(body: ProfileScreen()),
      ),
    );
  }

  testWidgets('Profile screen renders safely with basic local data',
      (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    expect(find.text('Your Progress'), findsOneWidget);
    expect(find.text('IslamFull'), findsOneWidget);
  });
}
