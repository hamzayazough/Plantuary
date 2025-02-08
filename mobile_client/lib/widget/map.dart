import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController controller = MapController();
  LatLng latLng = const LatLng(48.8584, 2.2945);

  @override
  Widget build(BuildContext context) {
    String mapboxToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';

    return FlutterMap(
      mapController: controller,
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
