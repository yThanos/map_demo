import 'package:google_maps_flutter/google_maps_flutter.dart';

Set<Marker> coordenacoes = {
  Marker(
      markerId: MarkerId("Coordenacao CSI"),
      position: LatLng(-29.722985540440572, -53.717654869991335),
      infoWindow: InfoWindow(
          snippet: "Corndenação do curso de Sistemas para Internet, sala 309 - 72 F",
          title: "Sistemas para Internet"
      )
  ),
};