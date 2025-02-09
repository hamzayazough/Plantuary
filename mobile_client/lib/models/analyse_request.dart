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
