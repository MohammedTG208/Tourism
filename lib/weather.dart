import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_albaha/API/weatherData.dart';
import 'package:url_launcher/url_launcher.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  late Future<WeatherData> _weatherDataFuture;

  @override
  void initState() {
    super.initState();
    _weatherDataFuture = _fetchWeatherData();
  }

  Future<WeatherData> _fetchWeatherData() async {
    WeatherData weatherData = WeatherData();
    await weatherData.fetchData();
    return weatherData;
  }

  final Uri _url =
      Uri.parse('https://ncm.gov.sa/Ar/Weather/RegionWeather/Pages/Bahah.aspx');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('حدث خطاء $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
          ),
        ),
        body: Center(
          child: FutureBuilder<WeatherData>(
            future: _weatherDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final weatherData = snapshot.data!;
                return Container(
                  height: 450,
                  width: 400,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weatherData.cityName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'درجة الحرارة: ${weatherData.temperature.toString().substring(0, 2)}°C',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        weatherData.description,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 100,
                        width: 150,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://openweathermap.org/img/w/${weatherData.icon}.png"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'التفاصيل:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'الرياح: ${weatherData.windSpeed} كم/س',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
                        ),
                      ),
                      Text(
                        'الرطوبة: ${weatherData.humidity}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 35,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your onPressed functionality here
                            _launchUrl();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 54, 175, 255),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'المزيد',
                            style: TextStyle(
                              fontFamily: 'Noto Sans TC',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
