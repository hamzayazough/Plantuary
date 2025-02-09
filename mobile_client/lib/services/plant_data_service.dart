import 'package:mobile_client/models/analyse_request.dart';

class PlantDataService {
  static final PlantDataService _instance = PlantDataService._internal();
  factory PlantDataService() => _instance;
  PlantDataService._internal();

  static PlantDataService get instance => _instance;

  List<PlantStat> plantStats = [];

  void setPlantStats(List<PlantStat> stats) {
    plantStats = stats;
  }
}
