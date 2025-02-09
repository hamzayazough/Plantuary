import 'package:mobile_client/models/analyse_request.dart';
import 'package:mobile_client/services/api_service.dart';

class PlantDataService {
  static final PlantDataService _instance = PlantDataService._internal();
  factory PlantDataService() => _instance;
  PlantDataService._internal();

  static PlantDataService get instance => _instance;

  List<PlantStat> plantStats = [];
  List<Weather> weatherData = [];
  int interval = 0;
  Address? address;

  void setPlantStats(List<PlantStat> stats) {
    plantStats = stats;
  }

  void setInterval(int interval, Address address) {
    interval = interval;
    address = address;
  }

  Future<List<Weather>> getWeatherbyAddressAndInterval() async {
    try {
      ApiService apiService = ApiService();
      if (this.address == null) {
        throw Exception("Address is not set");
      }
      TestConnectionDto request =
          TestConnectionDto(address: this.address!, interval: this.interval);
      List<Weather> weatherData = await apiService.getDates(request);
      this.weatherData = weatherData;
      return weatherData;
    } catch (e) {
      print("Error fetching weather data: $e");
      return [];
    }
  }
}
