import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/weather_details_page.dart';
import 'pages/favorites_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/details': (context) => WeatherDetailsPage(),
        '/favorites': (context) => FavoritesPage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
