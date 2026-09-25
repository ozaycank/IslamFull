import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/section_header.dart';

/// Provides a general zakat calculation estimate based on the user's inputs.
///
/// The calculator uses the 80.18 g gold nisab reference and the general
/// guidance published by the Presidency of Religious Affairs. It does not
/// replace an individual religious ruling.
class ZakatCalculatorScreen extends StatefulWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  State<ZakatCalculatorScreen> createState() => _ZakatCalculatorScreenState();
}

class _ZakatCalculatorScreenState extends State<ZakatCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _goldPriceController = TextEditingController();
  final _cashController = TextEditingController();
  final _goldGramsController = TextEditingController();
  final _tradeGoodsController = TextEditingController();
  final _receivablesController = TextEditingController();
  final _debtsController = TextEditingController();

  bool _hasCalculated = false;
  bool _lunarYearConfirmed = false;

  double _totalNetWealth = 0;
  double _nisabThreshold = 0;
  double _zakatAmount = 0;

  bool get _meetsNisab =>
      _totalNetWealth >= _nisabThreshold && _totalNetWealth > 0;

  @override
  void dispose() {
    _goldPriceController.dispose();
    _cashController.dispose();
    _goldGramsController.dispose();
    _tradeGoodsController.dispose();
    _receivablesController.dispose();
    _debtsController.dispose();
    super.dispose();
  }

  double _parseAmount(TextEditingController controller) {
    return double.tryParse(
          controller.text.trim().replaceAll(',', '.'),
        ) ??
        0.0;
  }

  void _calculateZakat() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final goldPrice = _parseAmount(_goldPriceController);
    final cash = _parseAmount(_cashController);
    final goldGrams = _parseAmount(_goldGramsController);
    final tradeGoods = _parseAmount(_tradeGoodsController);
    final receivables = _parseAmount(_receivablesController);
    final deductions = _parseAmount(_debtsController);

    // Current zakatable assets entered by the user.
    final totalGrossWealth =
        cash + (goldGrams * goldPrice) + tradeGoods + receivables;

    final calculatedNetWealth = totalGrossWealth - deductions;

    // A negative zakatable balance does not produce negative wealth.
    _totalNetWealth = calculatedNetWealth > 0 ? calculatedNetWealth : 0;

    // Gold nisab reference used by the Presidency of Religious Affairs.
    _nisabThreshold = 80.18 * goldPrice;

    // An estimated payable amount is shown only when both the current nisab
    // comparison and the lunar-year condition are confirmed.
    if (_meetsNisab && _lunarYearConfirmed) {
      _zakatAmount = _totalNetWealth / 40.0;
    } else {
      _zakatAmount = 0;
    }

    setState(() {
      _hasCalculated = true;
    });
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? helperText,
    bool requiresPositiveValue = false,
  }) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.md,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'^\d+[\.,]?\d*'),
          ),
        ],
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          helperMaxLines: 3,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: context.colorScheme.surface,
        ),
        validator: (value) {
          if (!requiresPositiveValue) {
            return null;
          }

          if (value == null || value.trim().isEmpty) {
            return l10n.zakatGoldPriceRequired;
          }

          final parsed = double.tryParse(
            value.trim().replaceAll(',', '.'),
          );

          if (parsed == null || parsed <= 0) {
            return l10n.zakatGoldPricePositive;
          }

          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.zakatTitle),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(
                      width: AppSpacing.md,
                    ),
                    Expanded(
                      child: Text(
                        l10n.zakatDiyanetNote,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSpacing.xl,
              ),
              SectionHeader(
                title: l10n.zakatLunarYearTitle,
              ),
              const SizedBox(
                height: AppSpacing.sm,
              ),
              AppCard(
                padding: EdgeInsets.zero,
                child: CheckboxListTile(
                  value: _lunarYearConfirmed,
                  onChanged: (value) {
                    setState(() {
                      _lunarYearConfirmed = value ?? false;

                      if (_hasCalculated) {
                        _hasCalculated = false;
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    l10n.zakatLunarYearConfirmed,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.xs,
                    ),
                    child: Text(
                      l10n.zakatLunarYearDesc,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: AppSpacing.xl,
              ),
              _buildInputField(
                label: '${l10n.zakatGoldPriceLabel} *',
                controller: _goldPriceController,
                requiresPositiveValue: true,
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
              SectionHeader(
                title: l10n.zakatAssetsGroup,
              ),
              AppCard(
                child: Column(
                  children: [
                    _buildInputField(
                      label: l10n.zakatCashLabel,
                      controller: _cashController,
                    ),
                    _buildInputField(
                      label: l10n.zakatGoldGramsLabel,
                      controller: _goldGramsController,
                    ),
                    _buildInputField(
                      label: l10n.zakatTradeGoodsLabel,
                      controller: _tradeGoodsController,
                    ),
                    _buildInputField(
                      label: l10n.zakatReceivablesLabel,
                      controller: _receivablesController,
                      helperText: l10n.zakatReceivablesHelp,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              SectionHeader(
                title: l10n.zakatDebtsGroup,
              ),
              AppCard(
                child: _buildInputField(
                  label: l10n.zakatDebtsLabel,
                  controller: _debtsController,
                  helperText: l10n.zakatDebtsHelp,
                ),
              ),
              const SizedBox(
                height: AppSpacing.xl,
              ),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: l10n.zakatCalculateButton,
                  icon: Icons.calculate_outlined,
                  onPressed: _calculateZakat,
                ),
              ),
              const SizedBox(
                height: AppSpacing.xl,
              ),
              if (_hasCalculated) ...[
                SectionHeader(
                  title: l10n.zakatResultTitle,
                ),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ResultRow(
                        label: l10n.zakatTotalWealth,
                        value: '₺${_totalNetWealth.toStringAsFixed(2)}',
                      ),
                      const Divider(),
                      _ResultRow(
                        label: l10n.zakatNisabAmount,
                        value: '₺${_nisabThreshold.toStringAsFixed(2)}',
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      if (_meetsNisab && _lunarYearConfirmed)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.zakatRequiredAmount,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: AppSpacing.xs,
                              ),
                              Text(
                                '₺${_zakatAmount.toStringAsFixed(2)}',
                                style: textTheme.headlineMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (_meetsNisab)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(
                                width: AppSpacing.sm,
                              ),
                              Expanded(
                                child: Text(
                                  l10n.zakatLunarYearNotConfirmed,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                          ),
                          child: Text(
                            l10n.zakatNotRequired,
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.45,
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: AppSpacing.md,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: AppSpacing.sm,
                      ),
                      Text(
                        l10n.zakatEstimateNote,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.xxl,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(
            width: AppSpacing.md,
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
