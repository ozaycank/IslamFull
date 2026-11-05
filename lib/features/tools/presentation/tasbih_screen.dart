import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../menu/application/preferences_provider.dart';

class TasbihScreen extends ConsumerStatefulWidget {
  const TasbihScreen({super.key});

  @override
  ConsumerState<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends ConsumerState<TasbihScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _digitalCount = 0;
  final int _goal = 33;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _incrementDigital() {
    setState(() {
      _digitalCount++;
    });

    final useHaptic = ref.read(hapticFeedbackProvider);

    if (useHaptic) {
      if (_digitalCount % _goal == 0) {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    }
  }

  void _resetDigital() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.tasbihReset),
        content: Text(context.l10n.tasbihResetConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              MaterialLocalizations.of(context).cancelButtonLabel,
            ),
          ),
          FilledButton(
            onPressed: () {
              setState(() => _digitalCount = 0);
              Navigator.of(dialogContext).pop();
            },
            child: Text(context.l10n.tasbihReset),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tasbihTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _tabController.index == 0 ? _resetDigital : null,
            tooltip: l10n.tasbihReset,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          tabs: [
            Tab(text: l10n.tasbihDigitalTab),
            Tab(text: l10n.tasbihPhysicalTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildDigitalTasbih(context, l10n, colorScheme),
          const _PhysicalTasbihView(),
        ],
      ),
    );
  }

  Widget _buildDigitalTasbih(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.tasbihGoal(_goal),
            style: context.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: _incrementDigital,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    width: 8,
                  ),
                ),
                child: Center(
                  child: Text(
                    _digitalCount.toString(),
                    style: context.textTheme.displayLarge?.copyWith(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Text(
            l10n.tasbihTapToCount,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Physical tasbih visualization.
class _PhysicalTasbihView extends ConsumerStatefulWidget {
  const _PhysicalTasbihView();

  @override
  ConsumerState<_PhysicalTasbihView> createState() =>
      _PhysicalTasbihViewState();
}

class _PhysicalTasbihViewState extends ConsumerState<_PhysicalTasbihView> {
  late FixedExtentScrollController _scrollController;

  int _scrollIndex = 0;

  // 1 imamah + 33 beads + 1 separator + 33 beads +
  // 1 separator + 33 beads = 102 items.
  final int _totalListItems = 102;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: 0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onSelectedItemChanged(int index) {
    setState(() {
      _scrollIndex = index;
    });

    final useHaptic = ref.read(hapticFeedbackProvider);

    if (!useHaptic) return;

    final normalizedIndex = index % _totalListItems;

    // Give stronger feedback at the imamah and separators.
    if (normalizedIndex == 0 ||
        normalizedIndex == 34 ||
        normalizedIndex == 68) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final l10n = context.l10n;

    final normalizedIndex = _scrollIndex % _totalListItems;

    String statusText;
    String subText;

    if (normalizedIndex == 0) {
      statusText = l10n.tasbihPhysicalStart;
      subText = l10n.tasbihPhysicalStartHint;
    } else if (normalizedIndex == 34 || normalizedIndex == 68) {
      statusText = l10n.tasbihPhysicalSeparator;
      subText = l10n.tasbihPhysicalContinue;
    } else {
      int totalCount;
      int segmentCount;
      String dhikrName;

      if (normalizedIndex <= 33) {
        totalCount = normalizedIndex;
        segmentCount = normalizedIndex;
        dhikrName = l10n.tasbihDhikrSubhanallah;
      } else if (normalizedIndex <= 67) {
        totalCount = normalizedIndex - 1;
        segmentCount = normalizedIndex - 34;
        dhikrName = l10n.tasbihDhikrAlhamdulillah;
      } else {
        totalCount = normalizedIndex - 2;
        segmentCount = normalizedIndex - 68;
        dhikrName = l10n.tasbihDhikrAllahuAkbar;
      }

      statusText = l10n.tasbihTotalProgress(totalCount, 99);
      subText = l10n.tasbihSegmentProgress(
        dhikrName,
        segmentCount,
      );
    }

    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Text(
          statusText,
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subText,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(200, double.infinity),
                painter: _CurvedStringPainter(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              ListWheelScrollView.useDelegate(
                controller: _scrollController,
                itemExtent: 80,
                diameterRatio: 2.0,
                offAxisFraction: 0.2,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: _onSelectedItemChanged,
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    final itemPosition = index % _totalListItems;

                    if (itemPosition == 0) {
                      return _buildImamah(colorScheme);
                    } else if (itemPosition == 34 || itemPosition == 68) {
                      return _buildSeparator(colorScheme);
                    } else {
                      return _buildBead(colorScheme, itemPosition);
                    }
                  },
                ),
              ),
              IgnorePointer(
                child: Container(
                  height: 80,
                  width: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBead(ColorScheme colorScheme, int number) {
    return Center(
      child: Container(
        width: 60,
        height: 70,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: RadialGradient(
            colors: [
              colorScheme.primary.withValues(alpha: 0.3),
              colorScheme.primaryContainer,
            ],
            center: const Alignment(-0.3, -0.3),
            radius: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator(ColorScheme colorScheme) {
    return Center(
      child: Container(
        width: 70,
        height: 20,
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.3),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImamah(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 60,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 10,
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(5)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws the curved tasbih string.
class _CurvedStringPainter extends CustomPainter {
  final Color color;

  _CurvedStringPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(size.width / 2 + 15, 0);

    path.quadraticBezierTo(
      size.width / 2 + 25,
      size.height / 2,
      size.width / 2 - 25,
      size.height,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvedStringPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
