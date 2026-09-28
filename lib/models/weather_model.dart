class WeatherModel {
  final String city;
  final String region;
  final String country;
  final String localTime;
  final double tempC;
  final double feelsLikeC;
  final String condition;
  final String iconUrl;
  final int humidity;
  final double windKph;
  final String lastUpdated;

  WeatherModel({
    required this.city,
    required this.region,
    required this.country,
    required this.localTime,
    required this.tempC,
    required this.feelsLikeC,
    required this.condition,
    required this.iconUrl,
    required this.humidity,
    required this.windKph,
    required this.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] ?? {};
    final current = json['current'] ?? {};
    final cond = current['condition'] ?? {};

    return WeatherModel(
      city: location['name'] ?? 'Unknown',
      region: location['region'] ?? '',
      country: location['country'] ?? '',
      localTime: location['localtime'] ?? '',
      tempC: (current['temp_c'] as num? ?? 0).toDouble(),
      feelsLikeC: (current['feelslike_c'] as num? ?? 0).toDouble(),
      condition: cond['text'] ?? '',
      iconUrl: cond['icon'] != null ? 'https:${cond['icon']}' : '',
      humidity: (current['humidity'] as num? ?? 0).toInt(),
      windKph: (current['wind_kph'] as num? ?? 0).toDouble(),
      lastUpdated: current['last_updated'] ?? '',
    );
  }
}
