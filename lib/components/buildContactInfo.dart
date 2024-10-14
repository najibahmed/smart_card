import 'package:flutter/material.dart';

Widget buildContactInfo(BuildContext context, IconData icon, String text, String label) {
  final displayText = text.isNotEmpty ? text : 'Not Provided';

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayText, style: Theme.of(context).textTheme.bodyLarge),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    ),
  );
}