import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:noor_life/core/extensions/context_extensions.dart';
import 'package:noor_life/core/routing/app_routes.dart';
import 'package:noor_life/shared/design_system/tokens/app_spacing.dart';
import 'package:noor_life/shared/widgets/app_logo.dart';
import 'package:noor_life/shared/widgets/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;
  String? _appVersion;

  @override
  void initState() {
    super.initState();

    unawaited(_loadAppVersion());

    _navigationTimer = Timer(
      const Duration(
        milliseconds: 1200,
      ),
      () {
        if (mounted) {
          context.go(
            AppRoutes.home,
          );
        }
      },
    );
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      if (!mounted) {
        return;
      }

      setState(() {
        _appVersion = packageInfo.version;
      });
    } catch (_) {
      // Keep the splash screen usable if version metadata is unavailable.
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(
              size: 104,
            ),
            const SizedBox(
              height: AppSpacing.lg,
            ),
            Text(
              'IslamFull',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            if (_appVersion != null)
              Text(
                'Version: $_appVersion',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            const SizedBox(
              height: AppSpacing.xxl,
            ),
            const LoadingIndicator(),
            const SizedBox(
              height: AppSpacing.md,
            ),
            Text(
              context.l10n.splashLoading,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
