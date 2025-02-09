class AnalyzeRequest {
  final Address address;
  final int duration;
  final List<PlantReq> plants;

  AnalyzeRequest({
    required this.address,
    required this.duration,
    required this.plants,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address.toJson(),
      'duration': duration,
      'plants': plants.map((plant) => plant.toJson()).toList(),
    };
  }
}

class Address {
  final double longitude;
  final double latitude;
  final String addressName;

  Address({
    required this.longitude,
    required this.latitude,
    required this.addressName,
  });

  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
      'addressName': addressName,
    };
  }
}

class TestConnectionDto {
  final int interval;
  final Address address;

  TestConnectionDto({required this.interval, required this.address});

  Map<String, dynamic> toJson() {
    return {
      'interval': interval,
      'address': address.toJson(),
    };
  }
}

class PlantStat {
  final PlantReport report;
  final PlantDescription plant;

  PlantStat({required this.report, required this.plant});

  factory PlantStat.fromJson(Map<String, dynamic> json) {
    return PlantStat(
      report: PlantReport.fromJson(json["report"]),
      plant: PlantDescription.fromJson(json["plant"]),
    );
  }
}

class PlantReport {
  final int feasibility;
  final List<String> suggestions;
  final int perfectTemperature;
  final String perfectWateringFrequency;
  final int perfectHumidity;

  PlantReport({
    required this.feasibility,
    required this.suggestions,
    required this.perfectTemperature,
    required this.perfectWateringFrequency,
    required this.perfectHumidity,
  });

  factory PlantReport.fromJson(Map<String, dynamic> json) {
    return PlantReport(
      feasibility: json['feasibility'],
      suggestions: List<String>.from(json['suggestions']),
      perfectTemperature: json['perfectTemperature'],
      perfectWateringFrequency: json['perfectWateringFrequency'],
      perfectHumidity: json['perfectHumidity'],
    );
  }
}

class PlantDescription {
  final int id;
  final String name;
  final String type;
  final String cycle;
  final String watering;
  final List<String> sunlight;
  final String? fruitingSeason;
  final String maintenance;
  final String growthRate;
  final String? description; // Allow description to be nullable
  final String careLevel;
  final String image;

  PlantDescription({
    required this.id,
    required this.name,
    required this.type,
    required this.cycle,
    required this.watering,
    required this.sunlight,
    this.fruitingSeason,
    required this.maintenance,
    required this.growthRate,
    this.description, // Allow description to be nullable
    required this.careLevel,
    required this.image,
  });

  factory PlantDescription.fromJson(Map<String, dynamic> json) {
    return PlantDescription(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      cycle: json['cycle'],
      watering: json['watering'],
      sunlight: List<String>.from(json['sunlight']),
      fruitingSeason: json['fruitingSeason'],
      maintenance: json['maintenance'],
      growthRate: json['growthRate'],
      description: json['description'] ?? '', // Handle null value
      careLevel: json['careLevel'],
      image: json['image'],
    );
  }
}

class PlantReq {
  final int id;
  final int quantity;

  PlantReq({
    required this.id,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }
}

class Weather {
  final String date;
  final double temperatureC;
  final double precipitationMM;
  final double relativeHumidity;

  Weather({
    required this.date,
    required this.temperatureC,
    required this.precipitationMM,
    required this.relativeHumidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      date: json["date"],
      temperatureC: (json["temperatureC"] as num).toDouble(),
      precipitationMM: (json["precipitationMM"] as num).toDouble(),
      relativeHumidity: (json["relativeHumidity"] as num).toDouble(),
    );
  }
}
