import 'package:flutter/material.dart';

class QuoteTile extends StatelessWidget {
  final String quoteText;
  final String authorName;

  const QuoteTile({
    Key? key,
    required this.quoteText,
    required this.authorName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero, // Remove default padding
      content: QuoteTile(
        quoteText: quoteText,
        authorName: authorName,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('OK'),
        ),
      ],
      // Optional: Set the width of the dialog to be a fraction of the screen width
      contentTextStyle: const TextStyle(
        fontSize: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Optional: Rounded corners
      ),
    );
  }
}
