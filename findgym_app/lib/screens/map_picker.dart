import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng selectedLocation =
      LatLng(-2.9761, 104.7754); // Palembang

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Lokasi Gym"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: selectedLocation,
                initialZoom: 13,
                onTap: (tapPosition, point) {
                  setState(() {
                    selectedLocation = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.example.aplikasi_gym_palembang',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Latitude : ${selectedLocation.latitude}",
                ),
                const SizedBox(height: 8),
                Text(
                  "Longitude : ${selectedLocation.longitude}",
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        selectedLocation,
                      );
                    },
                    child: const Text(
                      "Gunakan Lokasi Ini",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}