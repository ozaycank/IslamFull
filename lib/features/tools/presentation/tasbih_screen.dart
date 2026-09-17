import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../menu/presentation/screens/preferences_screen.dart';

class TasbihScreen extends ConsumerStatefulWidget {
  const TasbihScreen({super.key});

  @override
  ConsumerState<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends ConsumerState<TasbihScreen> {
  int _count = 0;
  final int _goal = 33;

  void _increment() {
    setState(() {
      _count++;
    });

    // Preferences'tan titreşim ayarını oku
    final useHaptic = ref.read(hapticFeedbackProvider);
    if (useHaptic) {
      if (_count % _goal == 0) {
        HapticFeedback.heavyImpact(); // Hedefe ulaştığında sert titreşim
      } else {
        HapticFeedback.lightImpact(); // Normal basışta hafif titreşim
      }
    }
  }

  void _reset() {
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
              setState(() => _count = 0);
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
            onPressed: _reset,
            tooltip: l10n.tasbihReset,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              // FIX: type 'int' is expected, so we pass the int directly instead of .toString()
              l10n.tasbihGoal(_goal),
              style: context.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _increment,
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
                      _count.toString(),
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
      ),
    );
  }
}
