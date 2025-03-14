import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final String title;
  final String content;
  const DialogBox({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    Color gradientColor = Colors.green.shade50;
    Color mainColor = Colors.green.shade900;
    Icon icon = Icon(
      Icons.check_circle_outline,
      color: mainColor,
      size: 50,
    );
    if (title.toLowerCase() != 'success') {
      gradientColor = Colors.red.shade100;
      mainColor = Colors.red.shade900;
      icon = Icon(
        Icons.error_outline,
        color: mainColor,
        size: 50,
      );
    }
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, gradientColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon.icon,
              color: mainColor,
              size: 50,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                "Close",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
