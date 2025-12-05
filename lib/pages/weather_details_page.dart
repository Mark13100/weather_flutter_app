import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../utils/helpers.dart';
import '../widgets/weather_info_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherDetailsPage extends StatefulWidget {
  final Weather? weather;
  const WeatherDetailsPage({super.key, this.weather});

  @override
  State<WeatherDetailsPage> createState() => _WeatherDetailsPageState();
}

class _WeatherDetailsPageState extends State<WeatherDetailsPage> {
  late Weather? w;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    w = widget.weather;
    _checkSaved();
  }

  Future<void> _checkSaved() async {
    if (w == null) return;
    final sp = await SharedPreferences.getInstance();
    final favs = sp.getStringList('favorites') ?? [];
    setState(() { _saved = favs.contains(w!.cityName); });
  }

  Future<void> _toggleFavorite() async {
    if (w == null) return;
    final sp = await SharedPreferences.getInstance();
    final favs = sp.getStringList('favorites') ?? [];
    if (_saved) {
      favs.remove(w!.cityName);
    } else {
      favs.add(w!.cityName);
    }
    await sp.setStringList('favorites', favs);
    setState(() { _saved = !_saved; });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_saved ? 'Added to favorites' : 'Removed from favorites')));
  }

  @override
  Widget build(BuildContext context) {
    if (w == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: const Center(child: Text('No weather data provided')),
      );
    }

    final localSunrise = dateTimeFromUnixWithOffset(w!.sunrise, w!.timezone);
    final localSunset = dateTimeFromUnixWithOffset(w!.sunset, w!.timezone);
    final localNow = DateTime.now().toUtc().add(Duration(seconds: w!.timezone));

    return Scaffold(
      appBar: AppBar(
        title: Text(w!.cityName),
        actions: [
          IconButton(
            icon: Icon(_saved ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(ApiService.iconUrl(w!.icon)),
            const SizedBox(height: 8),
            Text('${w!.temp.toStringAsFixed(1)}°', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Text(w!.description, style: const TextStyle(fontSize: 18)),
            const Divider(),
            Card(
              child: Column(
                children: [
                  WeatherInfoTile(label: 'Feels like', value: '${w!.feelsLike.toStringAsFixed(1)}°'),
                  WeatherInfoTile(label: 'Humidity', value: '${w!.humidity}%'),
                  WeatherInfoTile(label: 'Wind speed', value: '${w!.windSpeed} m/s'),
                  WeatherInfoTile(label: 'Sunrise', value: formatTimeHM(localSunrise)),
                  WeatherInfoTile(label: 'Sunset', value: formatTimeHM(localSunset)),
                  WeatherInfoTile(label: 'Local time', value: formatTimeHM(localNow)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
