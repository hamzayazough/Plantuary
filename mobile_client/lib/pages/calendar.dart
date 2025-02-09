import 'package:flutter/material.dart';
import 'package:mobile_client/models/analyse_request.dart';
import 'package:mobile_client/services/plant_data_service.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int currentWeek = 0;
  final PlantDataService plantDataService = PlantDataService.instance;
  List<Weather> weekWeatherData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    setState(() {
      isLoading = true;
    });

    try {
      weekWeatherData = await plantDataService.getWeatherByAddressAndInterval();
    } catch (e) {
      print("Error fetching weather data: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime startOfWeek =
        today.subtract(Duration(days: today.weekday - 1 + (7 * currentWeek)));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    List<Weather> filteredWeather = weekWeatherData.where((weather) {
      DateTime weatherDate = DateTime.parse(weather.date);
      return weatherDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
          weatherDate.isBefore(endOfWeek.add(Duration(days: 1)));
    }).toList();

    PlantReport? report = plantDataService.currentPlantStat?.report;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Calendar"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Week Navigation
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          setState(() {
                            currentWeek--;
                          });
                        },
                      ),
                      Text(
                        'Week of ${DateFormat.yMMMd().format(startOfWeek)} - ${DateFormat.yMMMd().format(endOfWeek)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          setState(() {
                            currentWeek++;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Weather List
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredWeather.length,
                    itemBuilder: (context, index) {
                      Weather weather = filteredWeather[index];
                      DateTime weatherDate = DateTime.parse(weather.date);
                      bool isToday = weatherDate.day == today.day &&
                          weatherDate.month == today.month &&
                          weatherDate.year == today.year;

                      double tempDiff = (weather.temperatureC -
                              (report?.perfectTemperature ??
                                  weather.temperatureC))
                          .abs();
                      double humidityDiff = (weather.relativeHumidity -
                              (report?.perfectHumidity ??
                                  weather.relativeHumidity))
                          .abs();

                      String insight = generateInsight(tempDiff, humidityDiff);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: isToday ? Colors.blue[50] : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date
                              Text(
                                DateFormat.EEEE().format(weatherDate),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              // Weather Information
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.thermostat, color: Colors.red),
                                  Text(
                                    "Temp: ${weather.temperatureC}°C",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Icon(Icons.water_drop, color: Colors.blue),
                                  Text(
                                    "Humidity: ${weather.relativeHumidity}%",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              // Differences
                              Row(
                                children: [
                                  Text(
                                    "Temp Diff: ${tempDiff.toStringAsFixed(1)}°C",
                                    style: TextStyle(
                                        color: tempDiff > 5
                                            ? Colors.red
                                            : Colors.blue),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    "Humidity Diff: ${humidityDiff.toStringAsFixed(1)}%",
                                    style: TextStyle(
                                        color: humidityDiff > 10
                                            ? Colors.red
                                            : Colors.blue),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              // Insights
                              if (insight.isNotEmpty)
                                Text(
                                  "🌿 $insight",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  String generateInsight(double tempDiff, double humidityDiff) {
    if (tempDiff > 5 && humidityDiff > 10) {
      return "Consider moving plants indoors or using a humidifier.";
    } else if (tempDiff > 5) {
      return "Temperature is too different from ideal, consider shade or heating.";
    } else if (humidityDiff > 10) {
      return "Humidity difference is high, consider adjusting watering schedule.";
    }
    return "";
  }
}
