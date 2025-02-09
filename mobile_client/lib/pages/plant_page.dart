import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:mobile_client/services/plant_data_service.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({Key? key}) : super(key: key);

  @override
  _PlantPageState createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  final List<bool> _expandedStates = [];

  @override
  void initState() {
    super.initState();
    _expandedStates.addAll(
        List.filled(PlantDataService.instance.plantStats.length, false));
  }

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
          final feasibility = stat.report.feasibility / 100;
          final feasibilityColor =
              _getFeasibilityColor(stat.report.feasibility);
          final suggestion = stat.report.suggestions.isNotEmpty
              ? stat.report.suggestions[0]
              : "No suggestion available";

          return Card(
            elevation: 6,
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: InkWell(
              onTap: () {
                setState(() {
                  _expandedStates[index] = !_expandedStates[index];
                });
              },
              borderRadius: BorderRadius.circular(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16.0)),
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
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 60, // Ensure the gauge does not overflow
                              child: CircularPercentIndicator(
                                radius: 30, // Reduced size
                                lineWidth: 5,
                                percent: feasibility,
                                center: Text(
                                  "${stat.report.feasibility}%",
                                  style: const TextStyle(
                                    fontSize: 14, // Smaller text
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                progressColor: feasibilityColor,
                                backgroundColor: Colors.grey.shade300,
                              ),
                            ),
                            const SizedBox(width: 8), // Reduce spacing
                            Expanded(
                              // This will avoid overflow
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Perfect Temp: ${stat.report.perfectTemperature}°C",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Suggestion: ${suggestion.isNotEmpty ? (suggestion.length > 50 ? suggestion.substring(0, 50) + "..." : suggestion) : "No suggestion available"}",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_expandedStates[index]) _buildExpandedContent(stat),
                        const SizedBox(height: 10),
                        _buildTrackOnCalendarButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpandedContent(stat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text("More Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildDetailRow(
            Icons.wb_sunny, "Sunlight: ${stat.plant.sunlight.join(", ")}"),
        _buildDetailRow(Icons.water_drop,
            "Watering: ${_getWateringEmoji(stat.plant.watering)} ${stat.plant.watering}"),
        _buildDetailRow(Icons.grass,
            "Growth Rate: ${_getGrowthRateEmoji(stat.plant.growthRate)} ${stat.plant.growthRate}"),
        _buildDetailRow(Icons.eco,
            "Care Level: ${_getCareLevelEmoji(stat.plant.careLevel)} ${stat.plant.careLevel}"),
        _buildDetailRow(Icons.cyclone, "Cycle: ${stat.plant.cycle}"),
        if (stat.plant.fruitingSeason.isNotEmpty)
          _buildDetailRow(Icons.date_range,
              "Fruiting Season: ${stat.plant.fruitingSeason}"),
        _buildDetailRow(
            Icons.cloud, "Perfect Humidity: ${stat.report.perfectHumidity}%"),
        _buildDetailRow(Icons.opacity,
            "Perfect Watering Frequency: ${stat.report.perfectWateringFrequency}"),
        const SizedBox(height: 8),
        const Text("Suggestions:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...stat.report.suggestions.map((s) => _buildSuggestionRow(s)).toList(),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildSuggestionRow(String suggestion) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 20, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Expanded(
              child: Text(suggestion, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildTrackOnCalendarButton() {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        icon: const Icon(Icons.calendar_today, color: Colors.white),
        label: const Text("Track on Calendar", style: TextStyle(fontSize: 16)),
        onPressed: () {
          // Navigate to Calendar Page
        },
      ),
    );
  }

  Color _getFeasibilityColor(int feasibility) {
    if (feasibility > 70) return Colors.green;
    if (feasibility >= 50) return Colors.orange;
    return Colors.red;
  }

  String _getWateringEmoji(String watering) => watering == "Frequent"
      ? "💦"
      : watering == "Average"
          ? "🚿"
          : "🌵";
  String _getGrowthRateEmoji(String rate) => rate == "High"
      ? "📈"
      : rate == "Moderate"
          ? "📊"
          : "🐢";
  String _getCareLevelEmoji(String level) => level == "High"
      ? "🔥"
      : level == "Medium"
          ? "⚖️"
          : "🌿";
}
