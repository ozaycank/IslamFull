import 'package:flutter/material.dart';
import '../../../../../core/extensions/context_extensions.dart';

class PresentationLocalizer {
  PresentationLocalizer._();

  static String localizePrayerNameRaw(BuildContext context, String rawName) {
    final nameLower = rawName.toLowerCase();
    switch (nameLower) {
      case 'fajr':
        return context.l10n.prayerFajr;
      case 'sunrise':
        return context.l10n.prayerSunrise;
      case 'dhuhr':
        return context.l10n.prayerDhuhr;
      case 'asr':
        return context.l10n.prayerAsr;
      case 'maghrib':
        return context.l10n.prayerMaghrib;
      case 'isha':
        return context.l10n.prayerIsha;
      default:
        return rawName;
    }
  }

  static String localizePrayerName(BuildContext context, dynamic name) {
    return localizePrayerNameRaw(context, name.toString().split('.').last);
  }

  static String localizeHijriMonth(BuildContext context, int monthIndex) {
    final l10n = context.l10n;
    switch (monthIndex) {
      case 1:
        return l10n.hijriMuharram;
      case 2:
        return l10n.hijriSafar;
      case 3:
        return l10n.hijriRabiAlAwwal;
      case 4:
        return l10n.hijriRabiAlThani;
      case 5:
        return l10n.hijriJumadaAlAwwal;
      case 6:
        return l10n.hijriJumadaAlThani;
      case 7:
        return l10n.hijriRajab;
      case 8:
        return l10n.hijriShaaban;
      case 9:
        return l10n.hijriRamadan;
      case 10:
        return l10n.hijriShawwal;
      case 11:
        return l10n.hijriDhuAlQiDah;
      case 12:
        return l10n.hijriDhuAlHijjah;
      default:
        return '-';
    }
  }

  static String formatSmartHijri(BuildContext context, String? rawHijri) {
    if (rawHijri == null || rawHijri.isEmpty) return '-';

    if (rawHijri.contains('-')) {
      final parts = rawHijri.split('-');
      if (parts.length >= 3) {
        final year = parts[0];
        final monthIdx = int.tryParse(parts[1]);
        final day = parts[2];
        if (monthIdx != null) {
          final localizedMonth = localizeHijriMonth(context, monthIdx);
          return '$day $localizedMonth $year';
        }
      }
    } else {
      final parts = rawHijri.split(' ');
      if (parts.length >= 3) {
        final day = parts[0];
        final year = parts.last;
        final rawMonthStr =
            parts.sublist(1, parts.length - 1).join(' ').toLowerCase();

        int monthIdx = 0;
        if (rawMonthStr.contains('muharram')) {
          monthIdx = 1;
        } else if (rawMonthStr.contains('safar')) {
          monthIdx = 2;
        } else if (rawMonthStr.contains('rabi') &&
            rawMonthStr.contains('awwal')) {
          monthIdx = 3;
        } else if (rawMonthStr.contains('rabi') &&
            rawMonthStr.contains('thani')) {
          monthIdx = 4;
        } else if (rawMonthStr.contains('jumada') &&
            rawMonthStr.contains('awwal')) {
          monthIdx = 5;
        } else if (rawMonthStr.contains('jumada') &&
            rawMonthStr.contains('thani')) {
          monthIdx = 6;
        } else if (rawMonthStr.contains('rajab')) {
          monthIdx = 7;
        } else if (rawMonthStr.contains('sha')) {
          monthIdx = 8;
        } else if (rawMonthStr.contains('ramadan')) {
          monthIdx = 9;
        } else if (rawMonthStr.contains('shawwal')) {
          monthIdx = 10;
        } else if (rawMonthStr.contains('dhu') && rawMonthStr.contains('qi')) {
          monthIdx = 11;
        } else if (rawMonthStr.contains('dhu') &&
            rawMonthStr.contains('hijjah')) {
          monthIdx = 12;
        }

        if (monthIdx > 0) {
          final localizedMonth = localizeHijriMonth(context, monthIdx);
          return '$day $localizedMonth $year';
        }
      }
    }
    return rawHijri;
  }

  static String formatLocation({
    required BuildContext context,
    String? cityName,
    String? subAdminArea,
    String? countryName,
    double? lat,
    double? lon,
  }) {
    final parts = <String>[];

    // Older releases persisted the literal English placeholder as a city.
    // Do not present it as though it were a geocoded district.
    final city = cityName?.trim() ?? '';
    final cityIsKnown = city.isNotEmpty &&
        city.toLowerCase() != 'current location' &&
        city.toLowerCase() != 'mevcut konum' &&
        city.toLowerCase() != 'unknown';

    if (cityIsKnown) {
      parts.add(city);
    }
    final district = subAdminArea?.trim() ?? '';
    if (district.isNotEmpty && district != city) {
      parts.add(district);
    }
    final country = countryName?.trim() ?? '';
    if (country.isNotEmpty &&
        country.toLowerCase() != 'unknown' &&
        country != city &&
        country != district) {
      parts.add(country);
    }

    if (!cityIsKnown && lat != null && lon != null) {
      final coordinates =
          '${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}';
      return parts.isEmpty ? coordinates : '${parts.join(', ')} ($coordinates)';
    }

    if (parts.isEmpty) {
      return context.l10n.locationUnavailable;
    }

    return parts.join(', ');
  }

  static String localizeCalculationMethod(BuildContext context, String id) {
    final l10n = context.l10n;
    switch (id) {
      case 'diyar_turk':
        return l10n.methodTurkey;
      case 'mwl':
        return l10n.methodMWL;
      case 'isna':
        return l10n.methodISNA;
      case 'egypt':
        return l10n.methodEgypt;
      case 'makkah':
        return l10n.methodMakkah;
      case 'karachi':
        return l10n.methodKarachi;
      default:
        return id;
    }
  }

  static String localizeCalculationDescription(
    BuildContext context,
    String descriptionId,
  ) {
    final l10n = context.l10n;
    switch (descriptionId) {
      case 'desc_diyar_turk':
        return l10n.descDiyarTurk;
      case 'desc_mwl':
        return l10n.descMwl;
      case 'desc_isna':
        return l10n.descIsna;
      case 'desc_egypt':
        return l10n.descEgypt;
      case 'desc_makkah':
        return l10n.descMakkah;
      default:
        return descriptionId;
    }
  }

  static String localizeAsrConvention(
    BuildContext context,
    String id,
  ) {
    final l10n = context.l10n;

    switch (id) {
      case 'single_shadow':
        return l10n.asrSingleShadowLabel;

      case 'double_shadow':
        return l10n.asrDoubleShadowLabel;

      default:
        return id;
    }
  }
}
