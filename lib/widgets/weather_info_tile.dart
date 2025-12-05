import 'package:flutter/material.dart';

class WeatherInfoTile extends StatelessWidget {
  final String label;
  final String value;
  const WeatherInfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Text(value),
    );
  }
}
