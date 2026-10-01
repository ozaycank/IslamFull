import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/primary_button.dart';

class ManualLocationSheet extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final Future<bool> Function(
    double latitude,
    double longitude,
  ) onSave;

  const ManualLocationSheet({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    required this.onSave,
  });

  @override
  State<ManualLocationSheet> createState() => _ManualLocationSheetState();
}

class _ManualLocationSheetState extends State<ManualLocationSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _latitudeController;

  late final TextEditingController _longitudeController;

  bool _isSaving = false;
  bool _saveFailed = false;

  @override
  void initState() {
    super.initState();

    _latitudeController = TextEditingController(
      text: widget.initialLatitude?.toStringAsFixed(6),
    );

    _longitudeController = TextEditingController(
      text: widget.initialLongitude?.toStringAsFixed(6),
    );
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();

    super.dispose();
  }

  double? _parseCoordinate(
    String value,
  ) {
    return double.tryParse(
      value.trim().replaceAll(',', '.'),
    );
  }

  String? _validateLatitude(
    String? value,
  ) {
    final l10n = context.l10n;
    final parsed = _parseCoordinate(value ?? '');

    if (parsed == null) {
      return l10n.manualCoordinateRequired;
    }

    if (parsed < -90 || parsed > 90) {
      return l10n.manualLatitudeRange;
    }

    return null;
  }

  String? _validateLongitude(
    String? value,
  ) {
    final l10n = context.l10n;
    final parsed = _parseCoordinate(value ?? '');

    if (parsed == null) {
      return l10n.manualCoordinateRequired;
    }

    if (parsed < -180 || parsed > 180) {
      return l10n.manualLongitudeRange;
    }

    return null;
  }

  Future<void> _submit() async {
    setState(() {
      _saveFailed = false;
    });

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final latitude = _parseCoordinate(
      _latitudeController.text,
    );

    final longitude = _parseCoordinate(
      _longitudeController.text,
    );

    if (latitude == null || longitude == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final success = await widget.onSave(
      latitude,
      longitude,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      await Navigator.of(context).maybePop();
      return;
    }

    setState(() {
      _isSaving = false;
      _saveFailed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.manualLocationTitle,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: AppSpacing.sm,
              ),
              Text(
                l10n.manualLocationDescription,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              TextFormField(
                key: const ValueKey(
                  'manualLatitudeField',
                ),
                controller: _latitudeController,
                validator: _validateLatitude,
                enabled: !_isSaving,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.manualLatitudeLabel,
                ),
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
              TextFormField(
                key: const ValueKey(
                  'manualLongitudeField',
                ),
                controller: _longitudeController,
                validator: _validateLongitude,
                enabled: !_isSaving,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: l10n.manualLongitudeLabel,
                ),
              ),
              if (_saveFailed) ...[
                const SizedBox(
                  height: AppSpacing.md,
                ),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    l10n.manualLocationSaveFailed,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ],
              const SizedBox(
                height: AppSpacing.lg,
              ),
                            SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  key: const ValueKey(
                    'manualLocationSaveButton',
                  ),
                  text: l10n.manualLocationSave,
                  icon: Icons.location_on_outlined,
                  isLoading: _isSaving,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
