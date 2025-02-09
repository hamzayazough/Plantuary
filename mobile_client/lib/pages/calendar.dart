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

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    List<Weather> weekWeatherData =
        plantDataService.weatherData.where((weather) {
      DateTime weatherDate = DateTime.parse(weather.date);
      return weatherDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
          weatherDate.isBefore(endOfWeek.add(Duration(days: 1)));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    currentWeek--;
                  });
                },
              ),
              Text(
                'Week of ${DateFormat.yMMMd().format(startOfWeek)} - ${DateFormat.yMMMd().format(endOfWeek)}',
                style: TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    currentWeek++;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: weekWeatherData.length,
              itemBuilder: (context, index) {
                Weather weather = weekWeatherData[index];
                DateTime weatherDate = DateTime.parse(weather.date);
                bool isToday = weatherDate.day == today.day &&
                    weatherDate.month == today.month &&
                    weatherDate.year == today.year;

                PlantReport report = plantDataService
                    .plantStats[0].report; // Assuming one plant for simplicity

                return Card(
                  color: isToday ? Colors.yellow[100] : Colors.white,
                  child: ListTile(
                    title: Text(DateFormat.EEEE().format(weatherDate)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Temperature: ${weather.temperatureC}°C'),
                        Text('Precipitation: ${weather.precipitationMM} mm'),
                        Text('Humidity: ${weather.relativeHumidity}%'),
                        Text(
                          'Temperature Difference: ${weather.temperatureC - report.perfectTemperature}°C',
                          style: TextStyle(
                            color: (weather.temperatureC -
                                            report.perfectTemperature)
                                        .abs() >
                                    5
                                ? Colors.red
                                : Colors.blue,
                          ),
                        ),
                        Text(
                          'Humidity Difference: ${weather.relativeHumidity - report.perfectHumidity}%',
                          style: TextStyle(
                            color: (weather.relativeHumidity -
                                            report.perfectHumidity)
                                        .abs() >
                                    10
                                ? Colors.red
                                : Colors.blue,
                          ),
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
}
