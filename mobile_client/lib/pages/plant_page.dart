import 'package:flutter/material.dart';
import 'package:mobile_client/services/plant_data_service.dart';

class PlantPage extends StatelessWidget {
  const PlantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plantStats = PlantDataService.instance.plantStats;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Analysis"),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/home");
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: plantStats.length,
        itemBuilder: (context, index) {
          final stat = plantStats[index];
          final suggestion = stat.report.suggestions.isNotEmpty
              ? stat.report.suggestions[0]
              : "No suggestion available";

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ),
                  child: Image.network(
                    stat.plant.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stat.plant.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Feasibility: ${stat.report.feasibility.toStringAsFixed(1)}%",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Perfect Temperature: ${stat.report.perfectTemperature.toStringAsFixed(1)}°",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Suggestion: ${suggestion.length > 50 ? suggestion.substring(0, 50) + "..." : suggestion}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
