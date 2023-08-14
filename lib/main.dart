import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teste_mapa/marcadores/centros.dart';
import 'package:teste_mapa/marcadores/cordenacoes.dart';
import 'marcadores/predios.dart';
import 'dart:io' as io;


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
    init();
    super.initState();
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
    mapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _initialLocation,
          zoom: 16,
        )
    ));
  }
  _loadMarkers() async{
    Set<Marker> set = {};
    late List<Map<String, dynamic>> builds;
    if(widget.markerOption == 0) {
     setState(() {
       builds = centros;
     });
    }else if(widget.markerOption == 1){
      setState(() {
        builds = predios;
      });
    }else if(widget.markerOption == 2){
      setState(() {
        builds = coordenacoes;
      });
    }
    for(Map<String, dynamic> p in builds){
      //BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/images/${p['id']}.png");
      set.add(Marker(
        markerId: MarkerId(p['id']),
        position: LatLng(p['lat'], p['lng']),
        //icon: icon,
        infoWindow: InfoWindow(
          title: p['title'],
          snippet: p['snippet'] ?? '',
          onTap: (widget.markerOption == 0)? (){
            setState(() {
              widget.markerOption = 1;
              mapController.moveCamera(CameraUpdate.zoomTo(18));
            });
            _loadMarkers();
          }: (){}
        )
      ));
    }
    _markers = set;
  }


  Set<Marker> _markers = {};

  /*Set<TileOverlay> _tileOverlays = {
    TileOverlay(
      tileOverlayId: TileOverlayId("MapaUFSM"),
      tileProvider: myTile(),
    )
  };
  */


  @override
  Widget build(BuildContext context) {
    _loadMarkers();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa UFMS"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory),
            label: "Centros"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.apartment),
              label: "Prédios"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "Coordenações"
          )
        ],
        currentIndex: widget.markerOption,
        onTap: (index){
          setState(() {
            widget.markerOption = index!;
          });
        },
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: 16,
        ),
        layoutDirection: TextDirection.ltr,
        //tileOverlays: _tileOverlays,
        minMaxZoomPreference: MinMaxZoomPreference(16,20),
      ),
    );
  }
}

void main(){
  runApp(MaterialApp(
    home: MapScreen(markerOption: 0),
  ));
}


class myTile implements TileProvider{

  final data =  io.File("assets/tile/mapa.png").readAsBytesSync();

  @override
  Future<Tile> getTile(int x, int y, int? zoom) {
    return Future(() => Tile(100, 100, data));
  }
}