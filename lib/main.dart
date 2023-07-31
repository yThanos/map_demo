import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teste_mapa/marcadores/centros.dart';
import 'package:teste_mapa/marcadores/cordenacoes.dart';

import 'marcadores/predios.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _initialLocation = const LatLng(-29.718214958928517, -53.71514061433697);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  init() async{
    if(await Geolocator.checkPermission() == LocationPermission.denied){
      Geolocator.requestPermission();
    }
  }

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
      setState(() {
        _markers = centros;
      });
    }else if(_markerOption == 1){
      setState(() {
        _markers = predios;
      });
    }else if(_markerOption == 2){
      setState(() {
        _markers = coordenacoes;
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