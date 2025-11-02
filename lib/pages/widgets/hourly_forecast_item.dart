import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final int temp;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 15, 18, 5),

          child: Column(
            children: [
              Text(
                time,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Icon(icon, size: 25),

              const SizedBox(height: 15),

              Text("$temp°C", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
