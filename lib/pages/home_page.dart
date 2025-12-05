import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/weather_model.dart';
import '../pages/weather_details_page.dart';
import 'favorites_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _ctrl = TextEditingController();
  bool _loading = false;
  Weather? _weather;
  String _error = '';
  String units = 'metric'; // default, can be overridden via settings saved in shared_prefs

  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _search(String city) async {
    setState(() { _loading = true; _error=''; _weather = null; });
    try {
      final w = await _api.fetchWeatherByCity(city, units: units);
      setState(() { _weather = w; });
      // نفتح صفحة التفاصيل
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => WeatherDetailsPage(weather: w)));
    } catch (e) {
      setState(() { _error = e.toString(); });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather - Search'),
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage())), icon: const Icon(Icons.favorite)),
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())), icon: const Icon(Icons.settings)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _ctrl,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Enter city name (eg: Cairo)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final city = _ctrl.text.trim();
                    if (city.isNotEmpty) _search(city);
                  },
                ),
              ),
              onSubmitted: (v) {
                final city = v.trim();
                if (city.isNotEmpty) _search(city);
              },
            ),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (_error.isNotEmpty) Padding(
              padding: const EdgeInsets.only(top:12.0),
              child: Text(_error, style: const TextStyle(color: Colors.red)),
            ),
            if (_weather != null && !_loading)
              Card(
                child: ListTile(
                  leading: Image.network(ApiService.iconUrl(_weather!.icon)),
                  title: Text(_weather!.cityName),
                  subtitle: Text('${_weather!.description} • ${_weather!.temp.toStringAsFixed(1)}°'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WeatherDetailsPage(weather: _weather!))),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
