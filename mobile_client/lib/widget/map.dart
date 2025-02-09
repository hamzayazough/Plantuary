import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_client/models/environment.dart';

class MapScreen extends StatefulWidget {
  final MapController controller;

  const MapScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng latLng = const LatLng(48.8584, 2.2945);

  void updateMarker(LatLng newLatLng) {
    setState(() {
      latLng = newLatLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    String mapboxToken = Environment.mapboxAccessToken;

    return FlutterMap(
      mapController: widget.controller,
      options: MapOptions(
        initialCenter: latLng,
        initialZoom: 18,
      ),
      children: [
        TileLayer(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=$mapboxToken"),
        MarkerLayer(
          markers: [
            Marker(
              point: latLng,
              width: 60,
              height: 60,
              alignment: Alignment.topCenter,
              child: Icon(
                Icons.location_pin,
                color: Colors.red.shade700,
                size: 60,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
