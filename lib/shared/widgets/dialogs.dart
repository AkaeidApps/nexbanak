import 'package:flutter/material.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.danger = false,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final bool danger;

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(title, style: AppTextStyles.headlineSmall),
        content: Text(message, style: AppTextStyles.bodyMedium),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: danger ? AppColors.error : AppColors.primaryNavy,
            ),
            child: Text(confirmLabel),
          ),
        ],
      );
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.reference,
    this.buttonLabel = 'Done',
  });

  final String title;
  final String message;
  final String? reference;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE7F6F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, size: 36, color: AppColors.success),
            ),
            const SizedBox(height: 18),
            Text(title, style: AppTextStyles.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            if (reference != null) ...<Widget>[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Reference: $reference', style: AppTextStyles.labelSmall),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(backgroundColor: AppColors.success),
              child: Text(buttonLabel),
            ),
          ],
        ),
      );
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, color: AppColors.error),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: AppTextStyles.headlineSmall)),
          ],
        ),
        content: Text(message, style: AppTextStyles.bodyMedium),
        actions: <Widget>[
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Close'),
          ),
        ],
      );
}

class ReasonDialog extends StatefulWidget {
  const ReasonDialog({super.key, required this.title});

  final String title;

  @override
  State<ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<ReasonDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(widget.title, style: AppTextStyles.headlineSmall),
        content: TextField(
          controller: _controller,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Reason',
            hintText: 'Explain your decision…',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (_controller.text.trim().isEmpty) return;
              Navigator.of(context).pop(_controller.text.trim());
            },
            child: const Text('Submit'),
          ),
        ],
      );
}
