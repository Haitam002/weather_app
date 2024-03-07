import 'package:flutter/material.dart';

class WeatherForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String value;
  const WeatherForecast(
      {super.key, required this.icon, required this.time, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          child: Card(
            elevation: 6,
            child: Container(
              width: 100,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Icon(
                    icon,
                    size: 32,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    value,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
