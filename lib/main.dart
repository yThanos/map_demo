import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'marcadores/predios.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _initialLocation = const LatLng(-29.718214958928517, -53.71514061433697);

  late GoogleMapController _controller;

  Future<void> onMapCreated(GoogleMapController controller) async{
    _controller = controller;
    String estilo = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    _controller.setMapStyle(estilo);
    _controller.moveCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: const LatLng(-29.73535247163734, -53.735668296166274), northeast: const LatLng(-29.71021618372749, -53.702437172924526)),
        50.0
      )
    );
  }
  int _markerOption = 0;
  _markerOptions(BuildContext context) {
    if(_markerOption == 0) {
      _markers.add(Marker(
        markerId: const MarkerId("Politécnico"),
        position: const LatLng(-29.72303402194787, -53.717745596549456),
        infoWindow: InfoWindow(
          snippet: "Unidade de Educação Básica, Técnica e Tecnológica",
          title: "Politécnico",
          onTap: () {
            setState(() {
              _markerOption = 1;
              _controller.moveCamera(
                CameraUpdate.newCameraPosition(
                 const CameraPosition(target: LatLng(-29.72271806944029, -53.71787812043287), zoom: 18)
                )
              );
            });
          },
        ),
      ));
    }
    if(_markerOption == 1){
       setState(() {
         _markers = predios;
       });
    }
  }

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    _markerOptions(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa UFMS"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 25),
            RadioListTile<int>(title: Text("Centros"), value: 0, groupValue: _markerOption, onChanged: (change){setState(() {
              _markers = {};
              _markerOption = change!;
              _markerOptions(context);
            });},),
            RadioListTile<int>(title: Text("Predios"), value: 1, groupValue: _markerOption, onChanged: (change){setState(() {
              _markers = {};
              _markerOption = change!;
              _markerOptions(context);
            });},),
            RadioListTile<int>(title: Text("Coordenações"), value: 2, groupValue: _markerOption, onChanged: (change){setState(() {
              _markers = {};
              _markerOption = change!;
              _markerOptions(context);
            });},),
          ],
        ),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: 15,
        ),
        markers: _markers,
      ),
    );
  }
}

void main(){
  runApp(const MaterialApp(
    home: MapScreen(),
  ));
}