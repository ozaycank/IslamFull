import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/core/privacy/religious_progress_consent_provider.dart';
import 'package:noor_life/core/storage/secure_storage_service.dart';
import 'package:noor_life/features/guidance/application/journey_progress_provider.dart';
import 'package:noor_life/features/guidance/domain/journey_step_id.dart';

class _ConsentNotifier extends ReligiousProgressConsentNotifier {
  @override
  ReligiousProgressConsentState build() =>
      const ReligiousProgressConsentState();

  void update(bool granted) {
    state = ReligiousProgressConsentState(granted: granted);
  }
}

class _JourneyStorage extends SecureStorageService {
  int reads = 0;

  @override
  Future<String?> getJourneyReviewedSteps() async {
    reads++;
    return '["foundations"]';
  }

  @override
  Future<String?> getJourneyLastVisitedStep() async => 'wudu';
}

void main() {
  late ProviderContainer container;
  late _JourneyStorage storage;

  setUp(() async {
    await getIt.reset();
    storage = _JourneyStorage();
    getIt.registerSingleton<SecureStorageService>(storage);
    container = ProviderContainer(
      overrides: [
        religiousProgressConsentProvider.overrideWith(_ConsentNotifier.new),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await getIt.reset();
  });

  test('Journey notifier rebuilds safely as consent changes', () async {
    container.read(journeyProgressProvider);
    await pumpEventQueue();
    expect(storage.reads, 0);

    final consent = container.read(religiousProgressConsentProvider.notifier)
        as _ConsentNotifier;
    consent.update(true);
    // Trigger the watched provider's lazy rebuild before awaiting its load.
    container.read(journeyProgressProvider);
    await pumpEventQueue();

    final grantedState = container.read(journeyProgressProvider);
    expect(grantedState.isReviewed(JourneyStepId.foundations), isTrue);
    expect(grantedState.lastVisitedStep, JourneyStepId.wudu);

    consent.update(false);
    await pumpEventQueue();
    final withdrawnState = container.read(journeyProgressProvider);
    expect(withdrawnState.reviewedSteps, isEmpty);
    expect(withdrawnState.lastVisitedStep, isNull);
  });
}
