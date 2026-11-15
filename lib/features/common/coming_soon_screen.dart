import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// যে ফিচার এখনও তৈরি হয়নি, সেখানে সৎভাবে সেটা জানানো হয়।
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title, this.phaseNote});

  final String title;
  final String? phaseNote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction, size: 64, color: AppColors.teal),
              const SizedBox(height: 16),
              const Text(
                'এই ফিচারটি এখনও তৈরি হচ্ছে',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (phaseNote != null) ...[
                const SizedBox(height: 8),
                Text(
                  phaseNote!,
                  style: const TextStyle(color: AppColors.textMuted),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
