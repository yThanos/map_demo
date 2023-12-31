import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
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
  int _markerOption = 0;
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
    if(_markerOption == 0) {
     setState(() {
       builds = centros;
     });
    }else if(_markerOption == 1){
      setState(() {
        builds = predios;
      });
    }else if(_markerOption == 2){
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
          onTap: (_markerOption == 0)? (){
            setState(() {
              _markerOption = 1;
              mapController.moveCamera(CameraUpdate.zoomTo(18));
            });
            _loadMarkers();
          }:(_markerOption == 1 || _markerOption == 2)?(){
            setState(() {
              showModalBottomSheet(context: context, builder: (context){
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: (){
                        setState(() {
                          calculaCaminho(LatLng(p['lat'], p['lng']));
                          Navigator.of(context).pop();
                        });
                      }, child: const Text("Calular rota!"))
                    ],
                  ),
                );
              });
            });
          }: (){}
        )
      ));
    }
    _markers = set;
  }

  List<Polyline> _polyLines = [];
  List<LatLng> coords = [];
  Set<Marker> _markers = {};

  final Set<TileOverlay> _tileOverlays = {
    TileOverlay(
      tileOverlayId: TileOverlayId("MapaUFSM"),
      tileProvider: myTile(),
      transparency: 0.5,
    )
  };

  GoogleMapPolyline _googleMapPolyline = GoogleMapPolyline(apiKey: "AIzaSyDEalAKzT7YOti3UKWwaCsDqbkSRcj8Hsc");
  
  calculaCaminho(LatLng destino) async{
    Position current = await Geolocator.getCurrentPosition();
    LatLng origin = LatLng(current.latitude, current.longitude);
    coords.addAll((await _googleMapPolyline.getCoordinatesWithLocation(origin: origin, destination: destino, mode: RouteMode.walking)) as Iterable<LatLng>);
    setState(() {
      _polyLines.add(
        Polyline(
          polylineId: const PolylineId("polilinha"),
          visible: true,
          points: coords,
          width: 4,
          color: Colors.blue,
          endCap: Cap.buttCap
        ));
      mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(current.latitude, current.longitude), zoom: 17)));
    });
  }

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
        currentIndex: _markerOption,
        onTap: (index){
          setState(() {
            _markerOption = index!;
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
        cameraTargetBounds: CameraTargetBounds(
          LatLngBounds(
            southwest: const LatLng(-29.7295482606084, -53.73399081626978),
            northeast: const LatLng(-29.71277556378688, -53.70736285557391)
          )
        ),
        layoutDirection: TextDirection.ltr,
        //tileOverlays: _tileOverlays,
        polylines: Set.of(_polyLines),
        minMaxZoomPreference: MinMaxZoomPreference(16,20),
      ),
    );
  }
}

void main(){
  runApp(const MaterialApp(
    home: MapScreen(),
  ));
}


class myTile implements TileProvider{

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async{
    if(x < 22988 || x > 22990 || y > 38440 || y < 38436){
      final byteData = await rootBundle.load("assets/tile/grey.png");
      final data = byteData.buffer.asUint8List();
      return Tile(100, 100, data);
    }
    print("${x} - ${y} - ${zoom}");
    final byteData = await rootBundle.load("assets/tile/mapa.png");
    final data = byteData.buffer.asUint8List();
    return Tile(100, 100, data);
  }

  Future<ByteData> getByteData(int x, int y, int? zoom) async{
    return rootBundle.load("assets/tiles/${x}-${y}-${zoom}.png");
  }
}