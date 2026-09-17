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

// FIX: Profil ekranı yerine yeni MenuScreen import edildi
import 'package:noor_life/features/menu/presentation/screens/menu_screen.dart';

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
  Future<Result<void, ActivityFailure>> saveDailyActivity(
      DailyActivity activity,) async {
    return const Success(null);
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
        locale: Locale('en'), // İngilizce test ediyoruz
        // FIX: ProfileScreen() yerine MenuScreen() çağrıldı
        home: Scaffold(body: MenuScreen()),
      ),
    );
  }

  testWidgets('Menu screen renders safely with new architecture',
      (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // FIX: Test senaryosu artık yeni Menu ekranındaki metinleri (İngilizce olarak) arıyor
    expect(find.text('Menu'), findsWidgets); // Appbar title
    expect(find.text('App Settings'), findsOneWidget); // Section header
    expect(find.text('Tools & Information'), findsOneWidget); // Section header
  });
}
