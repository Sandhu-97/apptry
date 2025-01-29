import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  const Button({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(onPressed: onPressed, child: Text(label));
  }
}
