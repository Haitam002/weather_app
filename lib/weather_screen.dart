import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/secrets.dart';
import 'package:weather_app/weather_forecast.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      final res = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey"),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }
      return data;

      //data["list"][0]["main"]["temp"];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          /*
           iconButtom = Inkwell =  GestureDetector but Inkwell  give me a splatsh effect on the icons and has less properties than GestureDetector
          
         */
          IconButton(
              //for refreshing the page
              onPressed: () {
                setState(() {
                  weather = getCurrentWeather();
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          //variables to make data changes
          //to see if the var data has data or not

          final data = snapshot.data!;

          final currentWeatherData = data["list"][0];

          final currentTemp = currentWeatherData["main"]["temp"];

          final currentSky = currentWeatherData["weather"][0]["main"];

          final currentPressure = currentWeatherData["main"]["pressure"];
          final currentWindSpeed = currentWeatherData["wind"]["speed"];
          final currentHumidity = currentWeatherData["main"]["humidity"];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                //main Card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(children: [
                            Text(
                              '$currentTemp k',
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Icon(
                              currentSky == 'Clouds' || currentSky == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 64,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              currentSky,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hourly Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //weather forecast cards
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 39; i++)
                //         WeatherForecast(
                //           icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Clouds' ||
                //                   data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Rain'
                //             /  ? Icons.cloud
                //               : Icons.sunny,
                //           time: data['list'][i + 1]['dt'].toString(),
                //           value: data['list'][i + 1]['main']['temp'].toString(),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlySky =
                          data['list'][index + 1]['weather'][0]['main'];

                      final time = DateTime.parse(hourlyForecast['dt_txt']);

                      return WeatherForecast(
                          icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          time: DateFormat.j().format(time),
                          value: hourlyForecast['main']['temp'].toString());
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //additional info
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //1
                    AdditionalInfo(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    //2
                    AdditionalInfo(
                      icon: Icons.air,
                      value: currentWindSpeed.toString(),
                      label: 'Wind Speed',
                    ),
                    //3
                    AdditionalInfo(
                        icon: Icons.beach_access,
                        value: currentPressure.toString(),
                        label: 'Pressure'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
