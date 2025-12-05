import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../pages/weather_details_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> favorites = [];
  bool loading = false;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    _loadFavs();
  }

  Future<void> _loadFavs() async {
    final sp = await SharedPreferences.getInstance();
    setState(() { favorites = sp.getStringList('favorites') ?? []; });
  }

  Future<void> _remove(String city) async {
    final sp = await SharedPreferences.getInstance();
    final favs = sp.getStringList('favorites') ?? [];
    favs.remove(city);
    await sp.setStringList('favorites', favs);
    _loadFavs();
  }

  Future<void> _openCity(String city) async {
    setState(() { loading = true; });
    try {
      final w = await _api.fetchWeatherByCity(city);
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => WeatherDetailsPage(weather: w)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      if (mounted) setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, i) {
          final city = favorites[i];
          return ListTile(
            title: Text(city),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _remove(city),
            ),
            onTap: () => _openCity(city),
          );
        },
      ),
    );
  }
}
