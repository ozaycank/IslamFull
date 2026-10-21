import 'package:intl/intl.dart';

/// Formats zakat amounts in a readable form without changing the calculation.
/// Turkish uses magnitude labels (Bin, Milyon, etc.); other locales use the
/// locale's standard numeric currency format with the Turkish lira symbol.
class ZakatAmountFormatter {
  static const List<String> _turkishScales = <String>[
    '',
    'Bin',
    'Milyon',
    'Milyar',
    'Trilyon',
    'Katrilyon',
  ];

  const ZakatAmountFormatter._();

  static String format(
    double amount, {
    required String locale,
  }) {
    final normalizedAmount = amount.isFinite && amount > 0 ? amount : 0.0;

    if (locale.toLowerCase().startsWith('tr')) {
      return _formatTurkishLira(normalizedAmount);
    }

    return NumberFormat.currency(
      locale: locale,
      symbol: '₺',
      decimalDigits: 2,
    ).format(normalizedAmount);
  }

  static String _formatTurkishLira(double amount) {
    final totalKurus = (amount * 100).round();
    final lira = totalKurus ~/ 100;
    final kurus = totalKurus % 100;
    final liraText = _formatTurkishMagnitude(lira);

    if (kurus == 0) {
      return '$liraText TL';
    }

    return '$liraText TL $kurus Kuruş';
  }

  static String _formatTurkishMagnitude(int value) {
    if (value == 0) {
      return '0';
    }

    var remaining = value;
    var scale = 0;
    final groups = <String>[];

    while (remaining > 0) {
      final group = remaining % 1000;
      if (group > 0) {
        if (scale >= _turkishScales.length) {
          return NumberFormat.decimalPattern('tr').format(value);
        }

        final scaleLabel = _turkishScales[scale];
        groups.insert(
          0,
          scaleLabel.isEmpty ? '$group' : '$group $scaleLabel',
        );
      }

      remaining = remaining ~/ 1000;
      scale++;
    }

    return groups.join(' ');
  }
}
