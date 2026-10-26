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
            ),
            const SizedBox(height: 12),
            _SourceCard(
              title: copy.englishTranslationTitle,
              description: copy.englishTranslationDescription,
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
                  icon: const Icon(Icons.policy_outlined),
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
    required this.englishTranslationTitle,
    required this.englishTranslationDescription,
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
  final String englishTranslationTitle;
  final String englishTranslationDescription;
  final String pickthallLinkLabel;

  static _QuranSourceCopy forLanguage(String languageCode) {
    if (languageCode == 'tr') {
      return const _QuranSourceCopy(
        title: 'Kur’an kaynakları ve atıflar',
        introduction:
            'Kur’an metni ve çeviriler için mevcut kaynak bilgileri ve lisans durumu aşağıda açıklanmıştır.',
        arabicTextTitle: 'Arapça Kur’an metni',
        arabicTextDescription:
            'Kaynak: Tanzil Projesi. Arapça metin değiştirilmeden sunulur; kaynak atfı korunmalıdır.',
        arabicTextLicense:
            'Lisans: Creative Commons Attribution 3.0 (CC BY 3.0).',
        tanzilLinkLabel: 'Tanzil web sitesini aç',
        licenseLinkLabel: 'Tanzil lisans koşullarını aç',
        turkishTranslationTitle: 'Türkçe meal',
        turkishTranslationDescription:
            'Uygulamayla birlikte gelen Türkçe meal veri kümesinin çevirmeni, kesin kaynağı ve yeniden dağıtım izni tam veri kümesi için henüz doğrulanmamıştır. Depodaki eski AçıkKuran/lisans notu mevcut veri kümesinin kökenini veya yayın iznini tek başına doğrulamıyor. Bu nedenle doğrulanmış bir lisans iddiası sunulmuyor. Yayın öncesinde lisansı doğrulayın veya başka bir meal kullanın.',
        englishTranslationTitle: 'İngilizce meal',
        englishTranslationDescription:
            'Depodaki kaynak kaydı metni Marmaduke Pickthall’ın The Meaning of the Glorious Koran (1930) eserine atfediyor. Paketlenmiş veri kümesinin eksiksiz kökeni ve yeniden dağıtım koşulları ayrıca doğrulanmalıdır.',
        pickthallLinkLabel: 'Kaynak eseri görüntüle',
      );
    }

    if (languageCode == 'ar') {
      return const _QuranSourceCopy(
        title: 'مصادر القرآن والإسناد',
        introduction:
            'فيما يلي معلومات المصادر وحالة الترخيص الحالية للنص القرآني والترجمات المرفقة بالتطبيق.',
        arabicTextTitle: 'النص العربي للقرآن',
        arabicTextDescription:
            'المصدر: مشروع تنزيل. يُعرض النص العربي دون تعديل، ويجب الحفاظ على الإسناد إلى المصدر.',
        arabicTextLicense:
            'الترخيص: Creative Commons Attribution 3.0 (CC BY 3.0).',
        tanzilLinkLabel: 'فتح موقع تنزيل',
        licenseLinkLabel: 'عرض شروط ترخيص تنزيل',
        turkishTranslationTitle: 'الترجمة التركية',
        turkishTranslationDescription:
            'لم يتم بعد التحقق من المترجم والمصدر الدقيق وإذن إعادة توزيع مجموعة الترجمة التركية المرفقة كاملةً. والملاحظة السابقة التي تذكر AçıkKuran وترخيصًا معينًا لا تثبت وحدها مصدر البيانات الحالية أو الإذن بنشرها. يجب التحقق من الحقوق قبل الإصدار العام أو استبدال المجموعة بترجمة ذات ترخيص مناسب.',
        englishTranslationTitle: 'الترجمة الإنجليزية',
        englishTranslationDescription:
            'تنسب ملاحظة المصدر في المستودع النص إلى عمل Marmaduke Pickthall الصادر عام 1930. يجب التحقق بصورة مستقلة من مصدر مجموعة البيانات المرفقة وشروط إعادة توزيعها.',
        pickthallLinkLabel: 'عرض العمل المرجعي',
      );
    }

    return const _QuranSourceCopy(
      title: 'Quran sources and attributions',
      introduction:
          'The current source information and license status for the Quran text and bundled translations are described below.',
      arabicTextTitle: 'Arabic Quran text',
      arabicTextDescription:
          'Source: Tanzil Project. The Arabic text is presented without modification; source attribution must be retained.',
      arabicTextLicense:
          'License: Creative Commons Attribution 3.0 (CC BY 3.0).',
      tanzilLinkLabel: 'Open Tanzil website',
      licenseLinkLabel: 'View Tanzil license terms',
      turkishTranslationTitle: 'Turkish translation',
      turkishTranslationDescription:
          'The translator, exact source and redistribution permission for the complete bundled Turkish translation dataset have not yet been verified. The previous AçıkKuran/license note in the repository does not by itself establish the provenance or publication permission for the current dataset. No verified license claim is made here. Verify the rights before public distribution or replace the dataset with a suitably licensed translation.',
      englishTranslationTitle: 'English translation',
      englishTranslationDescription:
          'The repository source record attributes this text to Marmaduke Pickthall’s The Meaning of the Glorious Koran (1930). The provenance and redistribution terms of the complete bundled dataset must be verified separately.',
      pickthallLinkLabel: 'View reference work',
    );
  }
}
