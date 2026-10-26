import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QuranSourcesScreen extends StatelessWidget {
  const QuranSourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final copy = _QuranSourceCopy.forLanguage(languageCode);

    return Scaffold(
      appBar: AppBar(title: Text(copy.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              copy.introduction,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            _SourceCard(
              title: copy.arabicTextTitle,
              description: copy.arabicTextDescription,
              license: copy.arabicTextLicense,
              linkLabel: copy.tanzilLinkLabel,
              url: 'https://tanzil.net',
              secondaryLinkLabel: copy.licenseLinkLabel,
              secondaryUrl: 'https://tanzil.net/docs/Text_License',
            ),
            const SizedBox(height: 12),
            _SourceCard(
              title: copy.turkishTranslationTitle,
              description: copy.turkishTranslationDescription,
              license: copy.turkishTranslationLicense,
              linkLabel: copy.acikKuranLinkLabel,
              url: 'https://api.acikkuran.com/',
              secondaryLinkLabel: copy.acikKuranRepositoryLinkLabel,
              secondaryUrl: 'https://github.com/acik-kuran/acikkuran-api',
            ),
            const SizedBox(height: 12),
            _SourceCard(
              title: copy.englishTranslationTitle,
              description: copy.englishTranslationDescription,
              license: copy.englishTranslationLicense,
              linkLabel: copy.pickthallLinkLabel,
              url:
                  'https://en.wikisource.org/wiki/The_Meaning_of_the_Glorious_Koran_(1930)',
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.title,
    required this.description,
    this.license,
    this.linkLabel,
    this.url,
    this.secondaryLinkLabel,
    this.secondaryUrl,
  });

  final String title;
  final String description;
  final String? license;
  final String? linkLabel;
  final String? url;
  final String? secondaryLinkLabel;
  final String? secondaryUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(description),
            if (license != null) ...[
              const SizedBox(height: 8),
              Text(license!, style: textTheme.bodyMedium),
            ],
            if (url != null && linkLabel != null)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () => _openUrl(url!),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(linkLabel!),
                ),
              ),
            if (secondaryUrl != null && secondaryLinkLabel != null)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () => _openUrl(secondaryUrl!),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(secondaryLinkLabel!),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String value) async {
    await launchUrl(
      Uri.parse(value),
      mode: LaunchMode.externalApplication,
    );
  }
}

class _QuranSourceCopy {
  const _QuranSourceCopy({
    required this.title,
    required this.introduction,
    required this.arabicTextTitle,
    required this.arabicTextDescription,
    required this.arabicTextLicense,
    required this.tanzilLinkLabel,
    required this.licenseLinkLabel,
    required this.turkishTranslationTitle,
    required this.turkishTranslationDescription,
    required this.turkishTranslationLicense,
    required this.acikKuranLinkLabel,
    required this.acikKuranRepositoryLinkLabel,
    required this.englishTranslationTitle,
    required this.englishTranslationDescription,
    required this.englishTranslationLicense,
    required this.pickthallLinkLabel,
  });

  final String title;
  final String introduction;
  final String arabicTextTitle;
  final String arabicTextDescription;
  final String arabicTextLicense;
  final String tanzilLinkLabel;
  final String licenseLinkLabel;
  final String turkishTranslationTitle;
  final String turkishTranslationDescription;
  final String turkishTranslationLicense;
  final String acikKuranLinkLabel;
  final String acikKuranRepositoryLinkLabel;
  final String englishTranslationTitle;
  final String englishTranslationDescription;
  final String englishTranslationLicense;
  final String pickthallLinkLabel;

  static _QuranSourceCopy forLanguage(String languageCode) {
    if (languageCode == 'tr') {
      return const _QuranSourceCopy(
        title: 'Kur’an kaynakları ve atıflar',
        introduction:
            'Kur’an metni ve çeviriler için kaynak ve atıf bilgileri aşağıdadır.',
        arabicTextTitle: 'Arapça Kur’an metni',
        arabicTextDescription:
            'Kaynak: Tanzil Projesi. Arapça metin değiştirilmeden sunulmalı ve kaynak atfı korunmalıdır.',
        arabicTextLicense:
            'Lisans: Creative Commons Attribution 3.0 (CC BY 3.0).',
        tanzilLinkLabel: 'Tanzil web sitesini aç',
        licenseLinkLabel: 'Tanzil lisans koşullarını aç',
        turkishTranslationTitle: 'Türkçe meal',
        turkishTranslationDescription:
            'Çevirmen: Erhan Aktaş (Kerim Kur’an). Uygulamanın kaynak kaydı, Türkçe meali AçıkKuran API üzerinden alınmış olarak belirtir.',
        turkishTranslationLicense:
            'AçıkKuran API deposu CC BY-NC-SA 4.0 lisansını listeler. Bu lisansın paketlenen meal metnini ve uygulamanın dağıtım biçimini kapsadığı yayın öncesinde doğrulanmalıdır.',
        acikKuranLinkLabel: 'AçıkKuran API kaynağını aç',
        acikKuranRepositoryLinkLabel: 'AçıkKuran API deposunu aç',
        englishTranslationTitle: 'İngilizce meal',
        englishTranslationDescription:
            'Depodaki kaynak kaydı metni Marmaduke Pickthall’ın The Meaning of the Glorious Koran (1930) eserine atfediyor.',
        englishTranslationLicense:
            'Depodaki kaynak kaydı Public Domain olarak belirtmektedir. Paketlenen veri kümesinin hak ve dağıtım durumu yayın öncesinde ayrıca doğrulanmalıdır.',
        pickthallLinkLabel: 'Kaynak eseri görüntüle',
      );
    }

    if (languageCode == 'ar') {
      return const _QuranSourceCopy(
        title: 'مصادر القرآن والإسناد',
        introduction:
            'فيما يلي معلومات المصدر والإسناد للنص القرآني والترجمات المرفقة بالتطبيق.',
        arabicTextTitle: 'النص العربي للقرآن',
        arabicTextDescription:
            'المصدر: مشروع تنزيل. يجب عرض النص العربي دون تعديل مع الحفاظ على الإسناد إلى المصدر.',
        arabicTextLicense:
            'الترخيص: Creative Commons Attribution 3.0 (CC BY 3.0).',
        tanzilLinkLabel: 'فتح موقع تنزيل',
        licenseLinkLabel: 'عرض شروط ترخيص تنزيل',
        turkishTranslationTitle: 'الترجمة التركية',
        turkishTranslationDescription:
            'المترجم: Erhan Aktaş، واسم العمل Kerim Kur’an. تشير معلومات المصدر في التطبيق إلى أن الترجمة التركية مأخوذة عبر واجهة AçıkKuran API.',
        turkishTranslationLicense:
            'يذكر مستودع AçıkKuran API ترخيص CC BY-NC-SA 4.0. يجب التحقق قبل الإصدار من أن هذا الترخيص يغطي نص الترجمة المرفق وطريقة توزيعه داخل التطبيق.',
        acikKuranLinkLabel: 'فتح مصدر AçıkKuran API',
        acikKuranRepositoryLinkLabel: 'فتح مستودع AçıkKuran API',
        englishTranslationTitle: 'الترجمة الإنجليزية',
        englishTranslationDescription:
            'تنسب ملاحظة المصدر في المستودع النص إلى عمل The Meaning of the Glorious Koran لمارمادوك بيكثال (1930).',
        englishTranslationLicense:
            'تسجل ملاحظة المستودع الحالة على أنها Public Domain. ينبغي التحقق بصورة مستقلة من حقوق مجموعة البيانات المرفقة وشروط توزيعها.',
        pickthallLinkLabel: 'عرض العمل المرجعي',
      );
    }

    return const _QuranSourceCopy(
      title: 'Quran sources and attributions',
      introduction:
          'Source and attribution details for the Quran text and bundled translations are provided below.',
      arabicTextTitle: 'Arabic Quran text',
      arabicTextDescription:
          'Source: Tanzil Project. The Arabic text must remain unmodified, and its source attribution must be retained.',
      arabicTextLicense:
          'License: Creative Commons Attribution 3.0 (CC BY 3.0).',
      tanzilLinkLabel: 'Open Tanzil website',
      licenseLinkLabel: 'View Tanzil license terms',
      turkishTranslationTitle: 'Turkish translation',
      turkishTranslationDescription:
          'Translator: Erhan Aktaş (Kerim Kur’an). The application source record identifies AçıkKuran API as the source of the Turkish translation.',
      turkishTranslationLicense:
          'The AçıkKuran API repository lists CC BY-NC-SA 4.0. Before release, verify that this license covers the bundled translation text and its distribution in this application.',
      acikKuranLinkLabel: 'Open AçıkKuran API',
      acikKuranRepositoryLinkLabel: 'Open AçıkKuran API repository',
      englishTranslationTitle: 'English translation',
      englishTranslationDescription:
          'The repository source record attributes this text to Marmaduke Pickthall’s The Meaning of the Glorious Koran (1930).',
      englishTranslationLicense:
          'The repository metadata lists this work as Public Domain. Verify the rights and status of the complete bundled dataset before distribution.',
      pickthallLinkLabel: 'View reference work',
    );
  }
}
