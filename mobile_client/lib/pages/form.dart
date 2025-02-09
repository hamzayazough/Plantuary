import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:mobile_client/dict/dict.dart';
import 'package:mobile_client/models/analyse_request.dart';
import 'package:mobile_client/services/api_service.dart';
import 'package:mobile_client/widget/dropdown.dart';
import 'dart:convert';
import 'package:mobile_client/widget/map.dart';
import 'package:mobile_client/services/plant_data_service.dart';

const List<String> timeList = <String>['Jours', 'Semaines'];

class SearchMapPage extends StatefulWidget {
  final ApiService apiService = ApiService();

  SearchMapPage({Key? key}) : super(key: key);

  @override
  State<SearchMapPage> createState() => _SearchMapPageState();
}

class _SearchMapPageState extends State<SearchMapPage> {
  final MapController _mapController = MapController();
  LatLng _currentLatLng = const LatLng(48.8584, 2.2945);
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String mapboxToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
  late String selectedTimeDropdownItem = timeList.first;
  late String selectedCropDropdownItem = plantDictionary.keys.first;
  List<Map<String, String>> selectedCrops = [];

  Future<void> _searchAddress() async {
    String address = _searchController.text;
    if (address.isEmpty) return;

    final url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$address.json?access_token=$mapboxToken";

    try {
      final response = await http.get(Uri.parse(url));
      print("here");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (data['features'].isNotEmpty) {
          final location = data['features'][0]['geometry']['coordinates'];
          LatLng newLatLng = LatLng(location[1], location[0]);
          print(newLatLng);

          setState(() {
            _currentLatLng = newLatLng;
          });

          _mapController.move(newLatLng, 15);
        }
      }
    } catch (e) {
      print("Error searching location: $e");
    }
  }

  void _onTimeDropdownChanged(String value) {
    setState(() {
      selectedTimeDropdownItem = value;
    });
  }

  void _onCropDropdownChanged(String value) {
    setState(() {
      selectedCropDropdownItem = value;
    });
  }

  void _addCrop() {
    if (selectedCropDropdownItem.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      setState(() {
        selectedCrops.add({
          'crop': selectedCropDropdownItem,
          'quantity': _quantityController.text,
        });
        _quantityController.clear();
      });
    }
  }

  void _removeCrop(int index) {
    setState(() {
      selectedCrops.removeAt(index);
    });
  }

  Future<void> sendInfoToServer() async {
    late int nbJour;

    if (selectedTimeDropdownItem == 'Semaines') {
      int duration = int.parse(_durationController.text);
      nbJour = duration * 7;
    } else {
      nbJour = int.parse(_durationController.text);
    }

    Address addressObj = Address(
      longitude: _currentLatLng.longitude,
      latitude: _currentLatLng.latitude,
      addressName: _searchController.text,
    );

    List<PlantReq> plants = selectedCrops.map((crop) {
      int id = plantDictionary[crop['crop']] ?? 0;
      int quantity = int.tryParse(crop['quantity'] ?? '0') ?? 0;

      return PlantReq(
        id: id,
        quantity: quantity,
      );
    }).toList();

    AnalyzeRequest analyzeRequest = AnalyzeRequest(
      address: addressObj,
      duration: nbJour,
      plants: plants,
    );

    // Save data locally
    final storage = GetStorage();

    Map<String, dynamic> localData = {};
    for (var crop in selectedCrops) {
      localData[crop['crop'] ?? ''] = {
        'id': plantDictionary[crop['crop']] ?? 0,
        'quantity': int.tryParse(crop['quantity'] ?? '0') ?? 0,
        'longitude': _currentLatLng.longitude,
        'latitude': _currentLatLng.latitude,
        'addressName': _searchController.text,
        'duration': nbJour,
      };
    }

    await storage.write('localData', localData);

    print(localData);

    try {
      // Call your ApiService to get plant statistics.
      List<PlantStat> plantStats =
          await widget.apiService.analyzePlants(analyzeRequest);
      print("Plant analysis received:");

      // Save the plant statistics in your service.
      PlantDataService.instance.setPlantStats(plantStats);

      // Navigate to the plant page.
      Navigator.pushReplacementNamed(context, "/plant_page");
    } catch (e) {
      print("Error analyzing plants: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapScreen(controller: _mapController),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Localiser le lieu 🌱",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Entrer une addresse...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.green.shade700,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _searchAddress,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Options de culture",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Durée désirée",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _durationController,
                          decoration: const InputDecoration(
                            hintText: "Durée",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Dropdown(
                          selectedItem: selectedTimeDropdownItem,
                          listItem: timeList,
                          onChanged: _onTimeDropdownChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Cultures",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Dropdown(
                            selectedItem: selectedCropDropdownItem,
                            listItem: plantDictionary.keys.toList(),
                            onChanged: _onCropDropdownChanged,
                          )),
                          const SizedBox(width: 10),
                          Expanded(
                              child: TextField(
                            controller: _quantityController,
                            decoration: const InputDecoration(
                              hintText: "Quantité",
                              border: OutlineInputBorder(),
                            ),
                          )),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _addCrop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              textStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            child: Text('+'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: selectedCrops.map((crop) {
                              int index = selectedCrops.indexOf(crop);
                              return Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFD9D9D9),
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${crop['crop']} | ${crop['quantity']}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close,
                                          color: Colors.black),
                                      onPressed: () => _removeCrop(index),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => sendInfoToServer(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text('Plannifier'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
