import 'package:flutter/material.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';

class FilterOption<T> {
  const FilterOption(this.value, this.label);

  final T value;
  final String label;
}

/// Bottom sheet used across list screens for status/type filters.
class FilterBottomSheet<T> extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.initial,
  });

  final String title;
  final List<FilterOption<T>> options;
  final T initial;

  @override
  State<FilterBottomSheet<T>> createState() => _FilterBottomSheetState<T>();
}

class _FilterBottomSheetState<T> extends State<FilterBottomSheet<T>> {
  late T _selected = widget.initial;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.title, style: AppTextStyles.headlineSmall),
              const SizedBox(height: 14),
              RadioGroup<T>(
                groupValue: _selected,
                onChanged: (T? value) {
                  if (value != null) setState(() => _selected = value);
                },
                child: Column(
                  children: widget.options
                      .map(
                        (option) => RadioListTile<T>(
                          value: option.value,
                          title: Text(option.label),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(widget.initial),
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(_selected),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class DateRangePickerField extends StatelessWidget {
  const DateRangePickerField({
    super.key,
    required this.label,
    required this.range,
    required this.onChanged,
  });

  final String label;
  final DateTimeRange? range;
  final ValueChanged<DateTimeRange?> onChanged;

  @override
  Widget build(BuildContext context) {
    final String text = range == null
        ? 'Select date range'
        : '${range!.start.day}/${range!.start.month} – ${range!.end.day}/${range!.end.month}';
    return OutlinedButton.icon(
      onPressed: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now(),
          initialDateRange: range,
        );
        if (picked != null) onChanged(picked);
      },
      icon: const Icon(Icons.date_range_rounded, size: 18),
      label: Text('$label: $text'),
    );
  }
}
