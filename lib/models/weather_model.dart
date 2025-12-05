class Weather {
  final String cityName;
  final double temp;
  final String description;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int sunrise; // unix (seconds)
  final int sunset;  // unix (seconds)
  final int timezone; // offset in seconds
  final String icon;

  Weather({
    required this.cityName,
    required this.temp,
    required this.description,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.timezone,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: (json['name'] ?? '') as String,
      temp: ((json['main']?['temp'] ?? 0) as num).toDouble(),
      description: (json['weather'][0]['description'] ?? '') as String,
      feelsLike: ((json['main']?['feels_like'] ?? 0) as num).toDouble(),
      humidity: ((json['main']?['humidity'] ?? 0) as num).toInt(),
      windSpeed: ((json['wind']?['speed'] ?? 0) as num).toDouble(),
      sunrise: ((json['sys']?['sunrise'] ?? 0) as num).toInt(),
      sunset: ((json['sys']?['sunset'] ?? 0) as num).toInt(),
      timezone: ((json['timezone'] ?? 0) as num).toInt(),
      icon: (json['weather'][0]['icon'] ?? '01d') as String,
    );
  }
}
