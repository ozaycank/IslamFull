import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/section_header.dart';

/// ARCHITECTURE: Zakat Calculator Module
/// Strictly adheres to Diyanet 80.18g Nisab logic.
/// Stateless business logic embedded in State since it requires no persistence (local calculation).
class ZakatCalculatorScreen extends StatefulWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  State<ZakatCalculatorScreen> createState() => _ZakatCalculatorScreenState();
}

class _ZakatCalculatorScreenState extends State<ZakatCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _goldPriceController = TextEditingController();
  final _cashController = TextEditingController();
  final _goldGramsController = TextEditingController();
  final _tradeGoodsController = TextEditingController();
  final _receivablesController = TextEditingController();
  final _debtsController = TextEditingController();

  // Calculation Results
  bool _hasCalculated = false;
  double _totalNetWealth = 0;
  double _nisabThreshold = 0;
  double _zakatAmount = 0;

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

  void _calculateZakat() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final goldPrice =
        double.tryParse(_goldPriceController.text.replaceAll(',', '.')) ?? 0.0;
    final cash =
        double.tryParse(_cashController.text.replaceAll(',', '.')) ?? 0.0;
    final goldGrams =
        double.tryParse(_goldGramsController.text.replaceAll(',', '.')) ?? 0.0;
    final tradeGoods =
        double.tryParse(_tradeGoodsController.text.replaceAll(',', '.')) ?? 0.0;
    final receivables =
        double.tryParse(_receivablesController.text.replaceAll(',', '.')) ??
            0.0;
    final debts =
        double.tryParse(_debtsController.text.replaceAll(',', '.')) ?? 0.0;

    // BUSINESS LOGIC: Diyanet Rules
    // 1. Total Wealth = Cash + (Gold Grams * Gold Price) + Trade Goods + Receivables
    final totalGrossWealth =
        cash + (goldGrams * goldPrice) + tradeGoods + receivables;

    // 2. Net Wealth = Total Wealth - Debts
    _totalNetWealth = totalGrossWealth - debts;

    // 3. Nisab Threshold = 80.18 grams * Current Gold Price
    _nisabThreshold = 80.18 * goldPrice;

    // 4. Zakat condition (Net Wealth >= Nisab) -> 1/40 (2.5%)
    if (_totalNetWealth >= _nisabThreshold && _totalNetWealth > 0) {
      _zakatAmount = _totalNetWealth / 40.0;
    } else {
      _zakatAmount = 0.0;
    }

    setState(() {
      _hasCalculated = true;
    });
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d*')),
        ],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: context.colorScheme.surface,
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return '*';
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
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // Diyanet Info Box
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: colorScheme.secondary.withValues(alpha: 0.2),),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: colorScheme.secondary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.zakatDiyanetNote,
                      style: textTheme.bodySmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // GOLD PRICE INPUT (Required for calculation)
            _buildInputField(
              label: '${l10n.zakatGoldPriceLabel} *',
              controller: _goldPriceController,
              isRequired: true,
            ),
            const SizedBox(height: AppSpacing.md),

            // ASSETS
            SectionHeader(title: l10n.zakatAssetsGroup),
            AppCard(
              child: Column(
                children: [
                  _buildInputField(
                      label: l10n.zakatCashLabel, controller: _cashController,),
                  _buildInputField(
                      label: l10n.zakatGoldGramsLabel,
                      controller: _goldGramsController,),
                  _buildInputField(
                      label: l10n.zakatTradeGoodsLabel,
                      controller: _tradeGoodsController,),
                  _buildInputField(
                      label: l10n.zakatReceivablesLabel,
                      controller: _receivablesController,),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // DEBTS
            SectionHeader(title: l10n.zakatDebtsGroup),
            AppCard(
              child: _buildInputField(
                  label: l10n.zakatDebtsLabel, controller: _debtsController,),
            ),
            const SizedBox(height: AppSpacing.xl),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: l10n.zakatCalculateButton,
                icon: Icons.calculate,
                onPressed: _calculateZakat,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // RESULTS CARD
            if (_hasCalculated) ...[
              SectionHeader(title: l10n.zakatResultTitle),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ResultRow(
                        label: l10n.zakatTotalWealth,
                        value: '₺${_totalNetWealth.toStringAsFixed(2)}',),
                    const Divider(),
                    _ResultRow(
                        label: l10n.zakatNisabAmount,
                        value: '₺${_nisabThreshold.toStringAsFixed(2)}',),
                    const Divider(thickness: 2),
                    if (_zakatAmount > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.zakatRequiredAmount,
                              style: textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₺${_zakatAmount.toStringAsFixed(2)}',
                              style: textTheme.headlineMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          l10n.zakatNotRequired,
                          style: textTheme.bodyLarge?.copyWith(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: context.textTheme.bodyMedium
                  ?.copyWith(color: context.colorScheme.onSurfaceVariant),),
          Text(value,
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
