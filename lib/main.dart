import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teste_mapa/marcadores/centros.dart';
import 'package:teste_mapa/marcadores/cordenacoes.dart';

import 'marcadores/predios.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key, required this.markerOption});
  int markerOption;

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
    if(await Geolocator.checkPermission() != LocationPermission.always && await Geolocator.checkPermission() != LocationPermission.whileInUse){
      Geolocator.requestPermission();
    }
  }

  late GoogleMapController mapController;

  Future<void> onMapCreated(GoogleMapController controller) async{
    mapController = controller;
    String estilo = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    mapController.setMapStyle(estilo);
    mapController.moveCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: const LatLng(-29.73535247163734, -53.735668296166274), northeast: const LatLng(-29.71021618372749, -53.702437172924526)),
        50.0
      )
    );
  }

  _markerOptions() {
    if(widget.markerOption == 0) {
      setState(() {
        _markers = centros;
      });
    }else if(widget.markerOption == 1){
      setState(() {
        _markers = predios;
      });
    }else if(widget.markerOption == 2){
      setState(() {
        _markers = coordenacoes;
      });
    }
  }

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    _markerOptions();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa UFMS"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 25),
            RadioListTile<int>(title: Text("Centros"), value: 0, groupValue: widget.markerOption, onChanged: (change){setState(() {
              _markers = {};
              widget.markerOption = change!;
              _markerOptions();
              Navigator.of(context).pop();
            });},),
            RadioListTile<int>(title: Text("Predios"), value: 1, groupValue: widget.markerOption, onChanged: (change){setState(() {
              _markers = {};
              widget.markerOption = change!;
              _markerOptions();
              Navigator.of(context).pop();
            });},),
            RadioListTile<int>(title: Text("Coordenações"), value: 2, groupValue: widget.markerOption, onChanged: (change){setState(() {
              _markers = {};
              widget.markerOption = change!;
              _markerOptions();
              Navigator.of(context).pop();
            });},),
          ],
        ),
      ),
      body: GoogleMap(
        onTap: (hit){
          print(hit);
          if(hit is InfoWindow){
            mapController.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(hit.latitude, hit.longitude), zoom: 18)
              )
            );
          }
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: 16,
        ),
        markers: _markers,
      ),
    );
  }
}

void main(){
  runApp(MaterialApp(
    home: MapScreen(markerOption: 0),
  ));
}