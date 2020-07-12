import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/distance.dart';

class DirectionProvider extends ChangeNotifier {
  GoogleMapsDirections directionsApi =
      GoogleMapsDirections(apiKey: "AIzaSyAP28lR67ELIpaLDeR6z74Ypz3oFrEt8jc");

  Set<map.Polyline> _route = Set();
  Set<map.Polyline> get currentRoute => _route;

  findDirections(map.LatLng from, map.LatLng to) async {
    var origin = Location(from.latitude, from.longitude);
    var destination = Location(to.latitude, to.longitude);

    final result = await directionsApi.directionsWithLocation(
        origin, destination,
        travelMode: TravelMode.driving);

    print(result.routes[0].legs[0].distance.value);
    print(result.routes[0].legs[0].distance.text);
    Set<map.Polyline> newRoute = Set();
    if (result.isOkay) {
      var route = result.routes[0];
      var leg = route.legs[0];
      print("result------>${result.routes[0]}");
      print("steps------>${leg.steps.length}");
      List<map.LatLng> points = [];

      //leg.steps.forEach((step) {

      points.add(map.LatLng(
          leg.steps[0].startLocation.lat, leg.steps[0].startLocation.lng));
      points.add(map.LatLng(
          leg.steps[0].endLocation.lat, leg.steps[0].endLocation.lng));
      //});
      var line = map.Polyline(
        points: points,
        polylineId: map.PolylineId("mejor ruta"),
        color: Colors.red,
        width: 4,
      );
      newRoute.add(line);
      _route = newRoute;
      notifyListeners();
    } else {
      print("---------------------------------");
      print("error${result.status}");
    }
    print("---------------------------------");
    print(result.geocodedWaypoints);
  }
}
