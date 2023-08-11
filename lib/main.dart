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
    super.initState();
    init();
  }
  init() async{
    if(await Geolocator.checkPermission() != LocationPermission.always || await Geolocator.checkPermission() != LocationPermission.whileInUse){
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

  _markerOptions() async{
    if(widget.markerOption == 0) {
      setState(() {
        _markers = centros;
      });
    }else if(widget.markerOption == 1){
      Set<Marker> predios = await loadPredios();
      setState(() {
        _markers = predios;
      });
    }else if(widget.markerOption == 2){
      setState(() {
        _markers = coordenacoes;
      });
    }
  }



  Future<Set<Marker>> loadPredios() async {
    Set<Marker> set = {};
    for(Map<String, dynamic> p in predios){
      BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/images/${p['id']}.png");
      set.add(Marker(
        markerId: MarkerId(p['id']),
        position: LatLng(p['lat'], p['lng']),
        icon: icon,
        infoWindow: InfoWindow(
          title:p['title']
        ),
        onTap: (){
          setState(() {
            print("teste");
          });
        }
      ));
    }
    return set;
  }

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    _markerOptions();
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
          if(index == 0){
            mapController.animateCamera(CameraUpdate.zoomTo(16));
          } else{
            mapController.animateCamera(CameraUpdate.zoomTo(18));
          }
          setState(() {
            widget.markerOption = index!;
          });
        },
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