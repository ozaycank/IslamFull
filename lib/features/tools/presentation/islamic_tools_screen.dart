import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class IslamicToolsScreen extends StatelessWidget {
  const IslamicToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.toolsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.touch_app_outlined,
                      color: context.colorScheme.primary,),
                  title: Text(l10n.tasbihTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.tasbih),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.calculate_outlined,
                      color: context.colorScheme.primary,),
                  title: Text(l10n.menuZakatCalc),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.zakat),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
