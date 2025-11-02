import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  final IconData infoIcon;
  final String property;
  final int quantity;
  const AdditionalInformation({
    super.key,
    required this.infoIcon,
    required this.property,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(infoIcon, size: 50),
        const SizedBox(height: 5),
        Text(property, style: TextStyle(fontSize: 15)),
        Text(
          quantity.toStringAsFixed(0),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
