import 'package:flutter/material.dart';

class EntryFeeConfirmationDialog extends StatelessWidget {
  final int entryFee;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const EntryFeeConfirmationDialog({
    Key? key,
    required this.entryFee,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Entry Fee'),
      content: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
                text:
                    'You are about to join a private game with an entry fee of '),
            TextSpan(
              text: '\$$entryFee',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green),
            ),
            TextSpan(
                text:
                    '. Please confirm that you agree to pay this amount to participate.'),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actions: [
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[700],
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Confirm'),
        )
      ],
    );
  }
}
