import 'package:flutter/material.dart';


class HourlyForecastItem extends StatelessWidget {

  final String time;
  final String temp;
  final IconData icon;
  const HourlyForecastItem({
    super.key,
    required this.temp,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        ),
        width: 100,
        child: Column(
          children: [
            Text(time,
              maxLines: 1,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8,),
            const Icon(Icons.cloud,
              size: 32,),
            const SizedBox(height: 8,),
            Text(temp,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}