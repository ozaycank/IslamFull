import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class InfoCenterScreen extends StatelessWidget {
  const InfoCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.infoCenterTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.clean_hands_outlined,
                    color: context.colorScheme.primary,
                  ),
                  title: Text(l10n.wuduGuideTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.wuduGuide),
                ),
                // İleride Gusül, Namaz Rehberi vb. buraya eklenebilir.
              ],
            ),
          ),
        ],
      ),
    );
  }
}
