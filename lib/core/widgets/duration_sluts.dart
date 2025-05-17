import 'package:flutter/material.dart';

class DurationSluts extends StatelessWidget {
  final TextEditingController durationController;
  final String value;
  final String text;
  final VoidCallback onTap;
  const DurationSluts(
      {super.key,
      required this.durationController,
      required this.value,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: durationController.text == value
                ? Colors.blue.withOpacity(0.2)
                : Colors.transparent,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
