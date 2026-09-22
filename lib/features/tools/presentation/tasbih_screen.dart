import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      builder: (context) => AlertDialog(
        title: Text(context.l10n.tasbihReset),
        content: const Text('Zikri sıfırlamak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              setState(() => _digitalCount = 0);
              Navigator.pop(context);
            },
            child: const Text('Sıfırla'),
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
          tabs: const [
            Tab(text: 'Dijital'),
            Tab(text: 'Gerçek Tesbih'),
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
    dynamic l10n,
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
            'Dokunarak sayacı artırın',
            style: context.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------
/// FİZİKSEL TESBİH ANİMASYONU
/// ---------------------------------------------------------
class _PhysicalTasbihView extends ConsumerStatefulWidget {
  const _PhysicalTasbihView();

  @override
  ConsumerState<_PhysicalTasbihView> createState() =>
      _PhysicalTasbihViewState();
}

class _PhysicalTasbihViewState extends ConsumerState<_PhysicalTasbihView> {
  late FixedExtentScrollController _scrollController;

  int _scrollIndex = 0;

  // FİZİKSEL DİZİLİM: Toplam 102 eleman. (1 İmame + 33 Boncuk + 1 Ayraç + 33 Boncuk + 1 Ayraç + 33 Boncuk = 102)
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

    // İmame (0) veya Ayraçlarda (34, 68) ağır titreşim ver. Boncuklarda normal titreşim.
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

    final normalizedIndex = _scrollIndex % _totalListItems;

    // GERÇEK NAMAZ TESBİHİ MANTIĞI:
    String statusText = '';
    String subText = '';

    if (normalizedIndex == 0) {
      statusText = 'Başlangıç / İmame';
      subText = 'Aşağı doğru kaydırarak çekin';
    } else if (normalizedIndex == 34 || normalizedIndex == 68) {
      statusText = 'Ayraç (Nişane)';
      subText = 'Devam edin';
    } else {
      int totalCount;
      int segmentCount;
      String zikirName;

      if (normalizedIndex <= 33) {
        totalCount = normalizedIndex;
        segmentCount = normalizedIndex;
        zikirName = 'Sübhanallah';
      } else if (normalizedIndex <= 67) {
        totalCount = normalizedIndex - 1;
        segmentCount = normalizedIndex - 34; // 35. eleman -> 1. Elhamdülillah
        zikirName = 'Elhamdülillah';
      } else {
        totalCount = normalizedIndex - 2;
        segmentCount = normalizedIndex - 68; // 69. eleman -> 1. Allahu Ekber
        zikirName = 'Allahu Ekber';
      }

      statusText = '$totalCount / 99';
      subText = '$zikirName ($segmentCount/33)';
    }

    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        // Ana Sayaç
        Text(
          statusText,
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        // Zikir İsmi ve 33'lük Sayaç
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
              // ÖZEL KAVİSLİ İP (0.2 offAxisFraction EĞİMİNE KUSURSUZ UYUMLU)
              CustomPaint(
                size: const Size(200, double.infinity),
                painter: _CurvedStringPainter(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),

              // 3D SİLİNDİR
              ListWheelScrollView.useDelegate(
                controller: _scrollController,
                itemExtent: 80,
                diameterRatio: 2.0,
                offAxisFraction: 0.2, // Eğimi sağlayan ayar
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

              // SEÇİLİ ALAN VURGUSU
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

/// ---------------------------------------------------------
/// TESBİH İPİ ÇİZİMİ (0.2 offAxisFraction İçin Tam Ortalı Eğik İp)
/// ---------------------------------------------------------
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

    // Matematiksel Uyum: offAxisFraction = 0.2 olduğunda,
    // boncuklar ortada sola doğru kavis yapar, üstte ve altta sağa kayarlar.

    // Üst Başlangıç Noktası (Biraz sağdan başlar)
    path.moveTo(size.width / 2 + 15, 0);

    // Quadratic Bezier Eğrisi
    path.quadraticBezierTo(
      size.width / 2 + 25, // Kontrol Noktası
      size.height / 2, // Kontrol Noktası Y (Tam orta)
      size.width / 2 - 25, // Alt Bitiş Noktası (Tekrar sağda biter)
      size.height,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
