import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String units = 'metric'; // metric = °C, imperial = °F
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    setState(() { units = sp.getString('units') ?? 'metric'; });
  }

  Future<void> _save(String u) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('units', u);
    setState(() { units = u; });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Temperature units', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Metric (°C)'),
                  selected: units == 'metric',
                  onSelected: (s) { if (s) _save('metric'); },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Imperial (°F)'),
                  selected: units == 'imperial',
                  onSelected: (s) { if (s) _save('imperial'); },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('- Units applied when searching from Home.'),
            const SizedBox(height: 8),
            const Text('- To use GPS location, you can extend the app with geolocator plugin.'),
          ],
        ),
      ),
    );
  }
}
