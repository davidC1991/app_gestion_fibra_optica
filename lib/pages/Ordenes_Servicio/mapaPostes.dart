

import 'dart:math';

import 'package:audicol_fiber/bloc/provider.dart';
import 'package:audicol_fiber/provider/direcctionsProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geo/geo.dart' as geo;

// ignore: must_be_immutable
class MapaPostes extends StatefulWidget {
  //geo.LatLng coordenadaFalla;
  List<DocumentSnapshot> listaPostes;

  MapaPostes({@required this.listaPostes});

  final LatLng fromPoint = LatLng(11.226963, -74.202977);
  final LatLng audicol = LatLng(11.244266, -74.211976); 
  @override
  _MapaPostesState createState() => _MapaPostesState();
}

class _MapaPostesState extends State<MapaPostes> {
  GoogleMapController mapController;
  List<LatLng> rutaFibra2 = List();
  double latitudFalla;
  double longitudFalla;
  LatLng puntoFalla;
  BitmapDescriptor myIcon;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /* latitudFalla = widget.coordenadaFalla.lat.toDouble();
    longitudFalla = widget.coordenadaFalla.lng.toDouble();
    puntoFalla = LatLng(latitudFalla, longitudFalla);
 */
    /* BitmapDescriptor.fromAssetImage(
            , 'assets/audicol.PNG')
        .then((onValue) {
      myIcon = onValue;
    }); */
    createRuta();
    icono();
  }

  icono() async {
    myIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/alfiler.png');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final firebaseBloc  = Provider.firebaseBloc(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Probando API Google Maps'),
      ),
      body: GoogleMap(
            initialCameraPosition: CameraPosition(target: widget.fromPoint, zoom: 16),
            markers: createMarkers(),
            //polylines: api.currentRoute,
            polylines: createRuta(),
            onMapCreated: onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
       
      /* floatingActionButton: FloatingActionButton(
        child: Icon(Icons.zoom_out_map),
        onPressed: centerView,
      ), */
    );
  }

  Set<Polyline> createRuta() {
    var ruta = Set<Polyline>();
    List<LatLng> rutaFibra = List();
    double lat;
    double lng;
    LatLng coordenada;
    
    for (var i = 0; i < widget.listaPostes.length; i++) {
      if(widget.listaPostes[i].data['georeferenciacion']['latitud']!=''||widget.listaPostes[i].data['georeferenciacion']['longitud']!=''){
           lat=double.parse(widget.listaPostes[i].data['georeferenciacion']['latitud']);
           lng=double.parse(widget.listaPostes[i].data['georeferenciacion']['longitud']);
           coordenada = LatLng(lat, lng);
           rutaFibra.add(coordenada); 
      }
    }
      
    rutaFibra2=rutaFibra;
     
     ruta.add(Polyline(
        polylineId: PolylineId('ruta1'),
        points: rutaFibra,
        color: Colors.blue,
        width: 2));
 
    return ruta;
  }

  Set<Marker> createMarkers() {
    var tmp = Set<Marker>();
    double lat;
    double lng;
    LatLng coordenada;

    for (var i = 0; i < widget.listaPostes.length; i++) {
       lat=double.parse(widget.listaPostes[i].data['georeferenciacion']['latitud']);
       lng=double.parse(widget.listaPostes[i].data['georeferenciacion']['longitud']);
       coordenada = LatLng(lat, lng);
      if(widget.listaPostes[i].data['georeferenciacion']['latitud']!=''||widget.listaPostes[i].data['georeferenciacion']['longitud']!=''){
       
        tmp.add(Marker(
        icon: myIcon, 
        markerId: MarkerId(widget.listaPostes[i].data['posteID']),
        position: coordenada,
        infoWindow: InfoWindow(
        title: "${widget.listaPostes[i].data['posteID']}, Fibra: ${widget.listaPostes[i].data['fibra']['hilosCantidad']} hilos, Hilos utilizados: ${widget.listaPostes[i].data['cajaEmpalme']['hilosIntervalo']}")));
      }
    }



    return tmp;
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    centerView();

    
    // api.findDirections(widget.fromPoint, widget.toPoint);
  }

  void centerView() async {
    await mapController.getVisibleRegion();
     var left = min(rutaFibra2[0].latitude, rutaFibra2[rutaFibra2.length-1].latitude);
    var right = max(rutaFibra2[0].latitude, rutaFibra2[rutaFibra2.length-1].latitude);
    var top = max(rutaFibra2[0].longitude, rutaFibra2[rutaFibra2.length-1].longitude);
    var bottom = min(rutaFibra2[0].longitude, rutaFibra2[rutaFibra2.length-1].longitude); 

      var bounds = LatLngBounds(
      southwest: LatLng(left, bottom),
      northeast: LatLng(right, top),
    ); 

    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
     
    //var cameraUpdate = CameraUpdate.newLatLngZoom(widget.fromPoint, 16);
    mapController.animateCamera(cameraUpdate);
  }
}
