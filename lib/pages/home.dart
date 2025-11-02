import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:weather_app/pages/config.dart';
import 'package:weather_app/pages/widgets/additional_information_item.dart';
import 'package:weather_app/pages/widgets/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherHome extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeData theme;
  const WeatherHome({
    super.key,
    required this.toggleTheme,
    required this.theme,
  });

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late Future futureWeather;
  double temp = 0;
  bool isLoading = false;

  IconData _iconGiver(String icon, int time) {
    bool isDaytime = (time <= 6 || time >= 18) ? false : true;
    debugPrint(time.toString());

    switch (icon.toLowerCase()) {
      case 'clear':
        return isDaytime ? WeatherIcons.day_sunny : WeatherIcons.night_clear;

      case 'clouds':
        return isDaytime
            ? WeatherIcons.day_cloudy
            : WeatherIcons.night_alt_cloudy;

      case 'rain':
        return isDaytime ? WeatherIcons.day_rain : WeatherIcons.night_alt_rain;

      case 'drizzle':
        return isDaytime
            ? WeatherIcons.day_sprinkle
            : WeatherIcons.night_alt_sprinkle;

      case 'thunderstorm':
        return isDaytime
            ? WeatherIcons.day_thunderstorm
            : WeatherIcons.night_alt_thunderstorm;

      case 'snow':
        return isDaytime ? WeatherIcons.day_snow : WeatherIcons.night_alt_snow;

      case 'mist':
      case 'fog':
      case 'haze':
        return isDaytime ? WeatherIcons.day_fog : WeatherIcons.night_fog;

      case 'smoke':
        return WeatherIcons.smoke;

      case 'dust':
      case 'sand':
        return WeatherIcons.dust;

      case 'tornado':
        return WeatherIcons.tornado;

      case 'squall':
        return WeatherIcons.strong_wind;

      default:
        return isDaytime
            ? WeatherIcons.day_sunny_overcast
            : WeatherIcons.night_alt_partly_cloudy;
    }
  }

  List _getCurrentWeather(data) {
    debugPrint(data['dt_txt']);
    return [
      ((data['main']['temp']) - 273.15),
      data['weather'][0]['main'],
      data['main']['feels_like'],
      data['main']['humidity'],
      data['main']['pressure'],
    ];
  }

  List _getForecastedWeather(data) {
    final forecastList = [];
    for (final current in data) {
      String time;

      time = DateFormat.j().format(DateTime.parse(current['dt_txt']));
      final weather = current['weather'][0]['main'];
      final icon = _iconGiver(
        weather,
        int.parse(DateFormat('HH').format(DateTime.parse(current['dt_txt']))),
      );
      final temp = (current['main']['temp'] - 273.15).toInt();
      forecastList.add([time, icon, temp]);
    }

    return forecastList;
  }

  void _refresh() {
    setState(() {
      futureWeather = getWeatherInfo();
    });
  }

  //extracting the weather info
  Future<List<dynamic>> getWeatherInfo() async {
    try {
      const location = "Comilla";
      final url = Uri.parse(
        "http://api.openweathermap.org/data/2.5/forecast?q=$location&APPID=$API_KEY",
      );

      final response = await http.get(url);
      final data = jsonDecode(response.body);

      //only for checking purpose
      // final temporaryString = await DefaultAssetBundle.of(
      //   context,
      // ).loadString('lib/assets/data.json');
      // final data = jsonDecode(temporaryString);
      //only for checking purpose

      if (data["cod"] != '200') {
        throw "An unexpected error occurred";
      }

      // return ((data['list'][0]['main']['temp']) - 273.15);

      final currentWeather = _getCurrentWeather(data['list'][0]);
      final forecastedWeather = _getForecastedWeather(
        data['list'].sublist(2, 10),
      );

      return [currentWeather, forecastedWeather];
    } catch (e) {
      throw e.toString();
    }
  }

  //initialization
  @override
  void initState() {
    super.initState();
    futureWeather = getWeatherInfo();
  }

  //other code starts here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.toggleTheme,
          icon: (widget.theme == ThemeData.dark())
              ? const Icon(Icons.nightlight_outlined)
              : const Icon(Icons.wb_sunny_outlined),
        ),
        title: const Text(
          "Weather in Cumilla",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
        ],
      ),

      body: FutureBuilder(
        future: futureWeather,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator.adaptive());
          }
          if (asyncSnapshot.hasError) {
            return Center(child: Text(asyncSnapshot.error.toString()));
          }

          //assign the data for the weather
          final data = asyncSnapshot.data![0];

          final currentTemp = data[0];
          final currentSky = data[1];
          final feelsLike = (data[2] - 273.15).toInt();
          final humidity = data[3];
          final pressure = data[4];

          //forecasts
          final List forecastData = asyncSnapshot.data![1];

          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,

                  child: Card(
                    elevation: 10,
                    // shadowColor: Colors.black,
                    // color: const Color.fromARGB(255, 53, 48, 58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(18),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(18),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              Text(
                                "${currentTemp.toStringAsFixed(0)}°C ",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Icon(
                                _iconGiver(currentSky, DateTime.now().hour),
                                size: 50,
                              ),

                              const SizedBox(height: 15),

                              Text(currentSky, style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    "Weather Forecast",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 13),

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (final item in forecastData)
                //         HourlyForecastItem(
                //           day: item[0],
                //           time: item[1],
                //           icon: Icons.sunny,
                //           temp: item[3],
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      final item = forecastData[index];
                      return HourlyForecastItem(
                        time: item[0],
                        icon: item[1],
                        temp: item[2],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    "Additional Information",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformation(
                      infoIcon: WeatherIcons.thermometer_exterior,
                      property: "Feels Like",
                      quantity: feelsLike,
                    ),
                    AdditionalInformation(
                      infoIcon: WeatherIcons.raindrops,
                      property: "Humidity",
                      quantity: humidity,
                    ),
                    AdditionalInformation(
                      infoIcon: WeatherIcons.barometer,
                      property: "Pressure",
                      quantity: pressure,
                    ),
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
