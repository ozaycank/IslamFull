import 'package:equatable/equatable.dart';

class AsrConvention extends Equatable {
  static const String singleShadowId = 'single_shadow';
  static const String doubleShadowId = 'double_shadow';

  static const AsrConvention singleShadow = AsrConvention(
    id: singleShadowId,
    shadowFactor: 1.0,
  );

  static const AsrConvention doubleShadow = AsrConvention(
    id: doubleShadowId,
    shadowFactor: 2.0,
  );

  static const List<AsrConvention> values = [
    singleShadow,
    doubleShadow,
  ];

  final String id;
  final double shadowFactor;

  const AsrConvention({
    required this.id,
    required this.shadowFactor,
  }) : assert(
          shadowFactor > 0,
          'Shadow factor must be positive.',
        );

  static AsrConvention? fromId(
    String? id,
  ) {
    switch (id) {
      case singleShadowId:
        return singleShadow;

      case doubleShadowId:
        return doubleShadow;

      default:
        return null;
    }
  }

  @override
  List<Object?> get props => [
        id,
        shadowFactor,
      ];
}
