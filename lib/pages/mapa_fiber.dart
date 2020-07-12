import 'dart:math';

import 'package:audicol_fiber/provider/direcctionsProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapaRutas extends StatefulWidget {
  final LatLng fromPoint = LatLng(11.226963, -74.202977);
  final LatLng toPoint = LatLng(11.226301, -74.202010);
  @override
  _MapaRutasState createState() => _MapaRutasState();
}

class _MapaRutasState extends State<MapaRutas> {
  GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Probando API Google Maps'),
      ),
      body: Consumer<DirectionProvider>(
        builder: (BuildContext context, DirectionProvider api, Widget child) {
          return GoogleMap(
            initialCameraPosition:
                CameraPosition(target: widget.fromPoint, zoom: 16),
            markers: createMarkers(),
            polylines: api.currentRoute,
            onMapCreated: onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.zoom_out_map),
        onPressed: centerView,
      ),
    );
  }

  Set<Marker> createMarkers() {
    var tmp = Set<Marker>();

    tmp.add(Marker(
        markerId: MarkerId("fromPoint"),
        position: widget.fromPoint,
        infoWindow: InfoWindow(title: "punto A")));
    tmp.add(Marker(
        markerId: MarkerId("toPoint"),
        position: widget.toPoint,
        infoWindow: InfoWindow(title: "punto B")));

    return tmp;
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    centerView();

    var api = Provider.of<DirectionProvider>(context, listen: false);
    api.findDirections(widget.fromPoint, widget.toPoint);
  }

  void centerView() async {
    await mapController.getVisibleRegion();
    var left = min(widget.fromPoint.latitude, widget.toPoint.latitude);
    var right = max(widget.fromPoint.latitude, widget.toPoint.latitude);
    var top = max(widget.fromPoint.longitude, widget.toPoint.longitude);
    var bottom = min(widget.fromPoint.longitude, widget.toPoint.longitude);

    var bounds = LatLngBounds(
      southwest: LatLng(left, bottom),
      northeast: LatLng(right, top),
    );

    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
    mapController.animateCamera(cameraUpdate);
  }
}
