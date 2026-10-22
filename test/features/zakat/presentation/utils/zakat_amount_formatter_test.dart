import 'package:flutter_test/flutter_test.dart';
import 'package:islamfull/features/zakat/presentation/utils/zakat_amount_formatter.dart';

void main() {
  group('ZakatAmountFormatter', () {
    test('formats Turkish lira with readable thousand and kuruş groups', () {
      expect(
        ZakatAmountFormatter.format(316388.05, locale: 'tr'),
        '316 Bin 388 TL 5 Kuruş',
      );
    });

    test('formats millions using the requested magnitude labels', () {
      expect(
        ZakatAmountFormatter.format(1350268.45, locale: 'tr'),
        '1 Milyon 350 Bin 268 TL 45 Kuruş',
      );
    });

    test('does not append kuruş when the amount is a whole lira', () {
      expect(
        ZakatAmountFormatter.format(1000000, locale: 'tr'),
        '1 Milyon TL',
      );
    });

    test('uses localized numeric currency formatting outside Turkish', () {
      expect(
        ZakatAmountFormatter.format(2500, locale: 'en'),
        '₺2,500.00',
      );
    });

    test('normalizes negative or non-finite values to zero safely', () {
      expect(
        ZakatAmountFormatter.format(-15, locale: 'tr'),
        '0 TL',
      );
      expect(
        ZakatAmountFormatter.format(double.nan, locale: 'tr'),
        '0 TL',
      );
    });
  });
}
