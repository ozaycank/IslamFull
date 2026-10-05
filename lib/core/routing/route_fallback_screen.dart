import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../extensions/context_extensions.dart';
import '../../shared/design_system/tokens/app_spacing.dart';
import '../../shared/widgets/primary_button.dart';
import 'app_routes.dart';

class RouteFallbackScreen extends StatelessWidget {
  final VoidCallback? onReturnHome;

  const RouteFallbackScreen({
    super.key,
    this.onReturnHome,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(
              AppSpacing.xl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      Icons.link_off_outlined,
                      size: 64,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.xl,
                  ),
                  Semantics(
                    header: true,
                    child: Text(
                      l10n.errorStateDefaultTitle,
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.xl,
                  ),
                  PrimaryButton(
                    text: l10n.navHome,
                    icon: Icons.home_outlined,
                    onPressed: onReturnHome ??
                        () {
                          context.go(
                            AppRoutes.home,
                          );
                        },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
