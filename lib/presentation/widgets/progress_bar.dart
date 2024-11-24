import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.total,
    required this.free,
  });
  final int total;
  final int free;
  @override
  Widget build(BuildContext context) {
    final percent = (free / total);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: Colors.grey[300],
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$free/$total',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
