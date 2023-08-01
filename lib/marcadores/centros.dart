import 'package:google_maps_flutter/google_maps_flutter.dart';

Set<Marker> centros = {
  const Marker(
    markerId: MarkerId("Politécnico"),
    position: LatLng(-29.72303402194787, -53.717745596549456),
    infoWindow: InfoWindow(
      snippet: "Unidade de Educação Básica, Técnica e Tecnológica",
      title: "Politécnico"
    )
  )
};