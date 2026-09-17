import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class WuduGuideScreen extends StatelessWidget {
  const WuduGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // ARCHITECTURE: Added 'imagePath' to support local asset images.
    // If the image doesn't exist or is null, the UI gracefully falls back to text-only.
    final List<Map<String, dynamic>> steps = [
      {
        'icon': Icons.favorite_outline,
        'title': l10n.wuduStep1Title,
        'desc': l10n.wuduStep1Desc,
        'imagePath': 'images/wudu/step1.png',
      },
      {
        'icon': Icons.wash_outlined,
        'title': l10n.wuduStep2Title,
        'desc': l10n.wuduStep2Desc,
        'imagePath': 'images/wudu/step2.png',
      },
      {
        'icon': Icons.water_drop_outlined,
        'title': l10n.wuduStep3Title,
        'desc': l10n.wuduStep3Desc,
        'imagePath': 'images/wudu/step3.png',
      },
      {
        'icon': Icons.air_outlined,
        'title': l10n.wuduStep4Title,
        'desc': l10n.wuduStep4Desc,
        'imagePath': 'images/wudu/step4.png',
      },
      {
        'icon': Icons.face_outlined,
        'title': l10n.wuduStep5Title,
        'desc': l10n.wuduStep5Desc,
        'imagePath': 'images/wudu/step5.png',
      },
      {
        'icon': Icons.back_hand_outlined,
        'title': l10n.wuduStep6Title,
        'desc': l10n.wuduStep6Desc,
        'imagePath': 'images/wudu/step6.png',
      },
      {
        'icon': Icons.accessibility_new_outlined,
        'title': l10n.wuduStep7Title,
        'desc': l10n.wuduStep7Desc,
        'imagePath': 'images/wudu/step7.png',
      },
      {
        'icon': Icons.hearing_outlined,
        'title': l10n.wuduStep8Title,
        'desc': l10n.wuduStep8Desc,
        'imagePath': 'images/wudu/step8.png',
      },
      {
        'icon': Icons.directions_walk_outlined,
        'title': l10n.wuduStep9Title,
        'desc': l10n.wuduStep9Desc,
        'imagePath': 'images/wudu/step9.png',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wuduGuideTitle),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: steps.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final step = steps[index];
          final imagePath = step['imagePath'] as String?;

          return AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        step['icon'] as IconData,
                        color: context.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['title'] as String,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            step['desc'] as String,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // IMAGE PLACEHOLDER: Render only if asset is successfully loaded
                // Using Image.asset with an errorBuilder prevents crashes if the file is missing
                if (imagePath != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
