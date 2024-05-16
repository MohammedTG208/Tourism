// ignore_for_file: file_names

import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class WeatherData {
  late String description;
  late String icon;
  late double temperature;
  late int humidity;
  late double windSpeed;
  late String cityName;
  late String main;

  WeatherData({
    this.description = '',
    this.icon = '',
    this.temperature = 0.0,
    this.humidity = 0,
    this.windSpeed = 0.0,
    this.cityName = '',
    this.main = "",
  });

  Future<void> fetchData() async {
    const apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=Al%20Bahah&lang=ar&appid=7b5cd80404d87176d5ff4f9587125b0f'; // replace API_URL_HERE with your API URL
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        description = decodedData['weather'][0]['description'];
        icon = decodedData['weather'][0]['icon'];
        temperature = decodedData['main']['temp'];
        humidity = decodedData['main']['humidity'];
        windSpeed = decodedData['wind']['speed'];
        cityName = decodedData['name'];
        main = decodedData['weather'][0]['main'];
      } else {
        throw Exception('لم يتم جلب البيانات الرجاء اعد المحاولة');
      }
    } catch (e) {
      throw Exception('حدث خطاء في جلب البيانات');
    }
  }
}
