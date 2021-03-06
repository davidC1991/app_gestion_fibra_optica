import 'dart:math';

import 'package:audicol_fiber/provider/direcctionsProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geo/geo.dart' as geo;

// ignore: must_be_immutable
class MapaRutas extends StatefulWidget {
  geo.LatLng coordenadaFalla;
  String encode;

  MapaRutas({Key key, @required this.coordenadaFalla, @required this.encode})
      : super(key: key);

  final LatLng fromPoint = LatLng(11.226963, -74.202977);
  final LatLng audicol = LatLng(11.244266, -74.211976);
  @override
  _MapaRutasState createState() => _MapaRutasState();
}

class _MapaRutasState extends State<MapaRutas> {
  GoogleMapController mapController;
  double latitudFalla;
  double longitudFalla;
  LatLng puntoFalla;
  BitmapDescriptor myIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    latitudFalla = widget.coordenadaFalla.lat.toDouble();
    longitudFalla = widget.coordenadaFalla.lng.toDouble();
    puntoFalla = LatLng(latitudFalla, longitudFalla);

    /* BitmapDescriptor.fromAssetImage(
            , 'assets/audicol.PNG')
        .then((onValue) {
      myIcon = onValue;
    }); */

    icono();
  }

  icono() async {
    myIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/audicol.PNG');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Probando API Google Maps'),
      ),
      body: Consumer<DirectionProvider>(
        builder: (BuildContext context, DirectionProvider api, Widget child) {
          return GoogleMap(
            initialCameraPosition: CameraPosition(target: puntoFalla, zoom: 16),
            markers: createMarkers(),
            //polylines: api.currentRoute,
            polylines: createRuta(),
            onMapCreated: onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          );
        },
      ),
      /* floatingActionButton: FloatingActionButton(
        child: Icon(Icons.zoom_out_map),
        onPressed: centerView,
      ), */
    );
  }

  Set<Polyline> createRuta() {
    var ruta = Set<Polyline>();
    List<geo.LatLng> listLatLng = List();
    List<LatLng> rutaFibra = List();
    double lat;
    double lng;
    LatLng coordenada;
    /*  rutaFibra.add(LatLng(11.244266, -74.211976));
    rutaFibra.add(LatLng(11.244339, -74.211866));
    rutaFibra.add(LatLng(11.243607, -74.207394));
    rutaFibra.add(LatLng(11.243833, -74.207372)); */

    /* print(const geo.PolylineCodec().encode(const [
      geo.LatLng(11.244266, -74.211976),
      geo.LatLng(11.244339, -74.211866),
      geo.LatLng(11.243607, -74.207394),
      geo.LatLng(11.243833, -74.207372),
    ])); */
    print(widget.encode);
    //print('1111111111111111111111111111111111111111');
    listLatLng = const geo.PolylineCodec().decode(widget.encode);
    print(listLatLng);
    for (var i = 0; i < listLatLng.length; i++) {
      lat = listLatLng[i].lat;
      lng = listLatLng[i].lng;
      coordenada = LatLng(lat, lng);
      rutaFibra.add(coordenada);
    }
    ruta.add(Polyline(
        polylineId: PolylineId('ruta1'),
        points: rutaFibra,
        color: Colors.blue,
        width: 2));

    return ruta;
  }

  Set<Marker> createMarkers() {
    var tmp = Set<Marker>();

    tmp.add(Marker(
        markerId: MarkerId("Punto de falla"),
        position: puntoFalla,
        infoWindow: InfoWindow(
            title: "Punto de falla:$latitudFalla - $longitudFalla")));

    tmp.add(Marker(
        icon: myIcon,
        markerId: MarkerId("Audicol"),
        position: widget.audicol,
        infoWindow: InfoWindow(title: "Audicol")));
    /* tmp.add(Marker(
        markerId: MarkerId("toPoint"),
        position: widget.toPoint,
        infoWindow: InfoWindow(title: "punto B"))); */

    return tmp;
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    centerView();

    var api = Provider.of<DirectionProvider>(context, listen: false);
    // api.findDirections(widget.fromPoint, widget.toPoint);
  }

  void centerView() async {
    await mapController.getVisibleRegion();
    /* var left = min(widget.fromPoint.latitude, widget.toPoint.latitude);
    var right = max(widget.fromPoint.latitude, widget.toPoint.latitude);
    var top = max(widget.fromPoint.longitude, widget.toPoint.longitude);
    var bottom = min(widget.fromPoint.longitude, widget.toPoint.longitude); */

    /*  var bounds = LatLngBounds(
      southwest: LatLng(left, bottom),
      northeast: LatLng(right, top),
    ); */

    //var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
    var cameraUpdate = CameraUpdate.newLatLngZoom(puntoFalla, 16);
    mapController.animateCamera(cameraUpdate);
  }
}
