import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
/*Future<Set<Marker>> loadPredios() async{
  Set<Marker> set = {};
  set.add(Marker(
    markerId: MarkerId("72C"),
    position: LatLng(-29.722279977714823, -53.71779118905314),
    infoWindow: InfoWindow(
        title: "72 C"
    ),
    icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40,40)), "assets/images/72C.png")
  ));
  set.add( Marker(
    markerId: MarkerId("72D"),
    position: LatLng(-29.722518789025543, -53.71772452491716),
    infoWindow: InfoWindow(
        title: "72D"
    ),
  ));
  set.add( Marker(
    markerId: MarkerId("72E"),
    position: LatLng(-29.722739508064972, -53.717666193798166),
    infoWindow: InfoWindow(
        title: "72 E"
    )
  ));
  set.add( Marker(
    markerId: MarkerId("72F"),
    position: LatLng(-29.72304591233729, -53.71774163582372),
    infoWindow: InfoWindow(
        title: "72 F"
    )
  ));
  set.add( Marker(
    markerId: MarkerId("72G"),
    position: LatLng(-29.723250183135367, -53.7176487101325),
    infoWindow: InfoWindow(
        title: "72 G"
    )
  ));
  return set;
}*/

List<Map<String, dynamic>> predios = [
  {"id": "72C", "lat": -29.722279977714823, "lng": -53.71779118905314, "title": "72 C - Politécnico", "snippet": ""},
  {"id": "72D", "lat": -29.722518789025543, "lng": -53.71772452491716, "title": "72 D - Politécnico", "snippet": ""},
  {"id": "72E", "lat": -29.722739508064972, "lng": -53.717666193798166, "title": "72 E - Politécnico", "snippet": ""},
  {"id": "72F", "lat": -29.72304591233729, "lng": -53.71774163582372, "title": "72 F - Politécnico", "snippet": ""},
  {"id": "72G", "lat": -29.723250183135367, "lng": -53.7176487101325, "title": "72 G - Politécnico", "snippet": ""}
];

