import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';

class SelectionItem {
  final String id;
  final String label;
  final String? description;

  const SelectionItem(
    this.id,
    this.label, [
    this.description,
  ]);
}

class SelectionBottomSheet extends StatelessWidget {
  final String title;
  final List<SelectionItem> items;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final maxListHeight = MediaQuery.sizeOf(context).height * 0.65;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(
              AppSpacing.lg,
            ),
            child: Semantics(
              header: true,
              child: Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxListHeight,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (
                context,
                index,
              ) {
                final item = items[index];

                final isSelected = item.id == selectedId;

                return Semantics(
                  selected: isSelected,
                  button: true,
                  child: ListTile(
                    selected: isSelected,
                    title: Text(
                      item.label,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: item.description != null
                        ? Text(
                            item.description!,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          )
                        : null,
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      Navigator.of(context).pop();

                      if (!isSelected) {
                        onSelected(
                          item.id,
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
