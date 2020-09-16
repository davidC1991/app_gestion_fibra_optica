import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'package:audicol_fiber/bloc/peticiones_firebase.dart';


class FirebaseBloc{
 
  DatosRedFibra datosRedFibra= DatosRedFibra();

  
  final _ordenesServicioController = new BehaviorSubject<List<DocumentSnapshot>>();
  final itemsSeleccionadosController = new BehaviorSubject<DocumentSnapshot>();
  final posteSeleccionadoController = new BehaviorSubject<DocumentSnapshot>();
  final listaPostesOSController = new BehaviorSubject<List<DocumentSnapshot>>();
  
    
    //---sink---
     final anchoPantallaController = new BehaviorSubject<double>();
     final altoPantallaController = new BehaviorSubject<double>();
     final checkBoxAereaController = new BehaviorSubject<bool>();
     final checkBoxCanalizadaController = new BehaviorSubject<bool>();
     final fotoCajaEmpalmeController = new BehaviorSubject<File>();
     final fotoPosteController = new BehaviorSubject<File>();
     final lineaTransmisionPosteIdController = new BehaviorSubject<String>();
     final opcionesIDController = new BehaviorSubject<String>();
     final alturaPostesIDController = new BehaviorSubject<String>();
     final resistenciaPostesIDController = new BehaviorSubject<String>();
     final tipoPosteIDController = new BehaviorSubject<String>();
     final materialPosteIDController = new BehaviorSubject<String>();
     final estadoPostesIDController = new BehaviorSubject<String>();
     final estadoOrdenServicioController = new BehaviorSubject<String>();
     final latitudController = new BehaviorSubject<String>();
     final itemController = new BehaviorSubject<String>();
     final idPosteController = new BehaviorSubject<String>();
     final rutaFibraController = new BehaviorSubject<List<LatLng>>();
     final listaPostesIdController = new BehaviorSubject<List<String>>();
     final listaHilosAgregadosController = new BehaviorSubject<List<String>>();
     final agregadarHiloController = new BehaviorSubject<bool>();
     final idUsuarioController = new BehaviorSubject<String>();
     final datosUsuarioController = new BehaviorSubject<Map<String,dynamic>>();
    
    
    Stream<List<DocumentSnapshot>> get ordenServicioStream => _ordenesServicioController;
    Stream<List<DocumentSnapshot>> get listaPostesOSControllerStream => listaPostesOSController;
    Stream<List<String>> get listaHilosAgregadosStream => listaHilosAgregadosController;
    Stream<DocumentSnapshot> get itemsSeleccionadosStream => itemsSeleccionadosController;
    Stream<DocumentSnapshot> get posteSeleccionadoStream => posteSeleccionadoController;
    Stream<String> get itemStream => itemController;
    Stream<String> get latitudStream => latitudController;
    Stream<String> get estadoOrdenServicioControllerStream => estadoOrdenServicioController;
    Stream<double> get altoPantallaStream => altoPantallaController;
    Stream<double> get anchoPantallaStream => anchoPantallaController;
    Stream<bool> get checkBoxAereaStream => checkBoxAereaController;
    Stream<bool> get checkBoxCanalizadaStream => checkBoxCanalizadaController;
    Stream<String> get lineaTransmisionPosteIDStream => lineaTransmisionPosteIdController;
    Stream<String> get opcionesIDStream => opcionesIDController;
    Stream<String> get alturaPostesIDStream => alturaPostesIDController;
    Stream<String> get resistenciaPostesIDStream => resistenciaPostesIDController;
    Stream<String> get tipoPosteIDStream => tipoPosteIDController;
    Stream<String> get materialPosteIDStream => materialPosteIDController;
    Stream<String> get estadoPostesStream => estadoPostesIDController;
    Stream<String> get idPosteStream => idPosteController;
    Stream<File> get fotoCajaEmpalmeStream => fotoCajaEmpalmeController;
    Stream<File> get fotoPosteEmpalmeStream => fotoPosteController;
    Stream<List<LatLng>> get rutaFibraStream => rutaFibraController;
    Stream<List<String>> get listaPostesIdStream => listaPostesIdController;
    Stream<bool> get agregadarHiloIdStream => agregadarHiloController;
    Stream<String> get idUsuarioControllerStream => idUsuarioController;
    Stream<Map<String,dynamic>> get datosUsuarioControllerStream => datosUsuarioController;
  
     
  
    getOservicios()async {
       // await getDatosUsuario();
        Map<String, dynamic> mapUsuario= new Map();
       // datosUsuarioControllerStream.listen((event) { 
          print('esots son los datos del usuario');
          mapUsuario=datosUsuarioController.value;
          print(mapUsuario);
       // });
       if(mapUsuario!=null){ 
       final oSs= await datosRedFibra.getOrdenesServicio(mapUsuario);
       _ordenesServicioController.sink.add(oSs);
       }
      
    }

    Future<Map<String,dynamic>>getDatosUsuario()async{
      print('entro a getDatosUsuarios................');
     
      final usuario= await datosRedFibra.getDatosUsuario();
      datosUsuarioController.sink.add(usuario);

      return usuario;
    }
    
     getListaPostes(String iDos, bool eliminar)async {
    
       final listaPostesId= await datosRedFibra.getNumeroPoste(iDos, eliminar);
       listaPostesIdController.sink.add(listaPostesId['listaPostes']);
  
      
    }
     getDetallePosteInstalado(String numeroOs)async {
    
       final oSs = await datosRedFibra.getGestionOsPostes(numeroOs);
       listaPostesOSController.sink.add(oSs);
   
     
    }
  
    getItemsSeleccionados(DocumentSnapshot datositem) async {
      print('entro a getItemSeleccionado--$datositem');
       itemsSeleccionadosController.sink.add(datositem);
     //final items = datosRedFibra.getListaProductos();
      // itemsSeleccionadosController.sink.add(items);
    }
      
     dispose(){
      _ordenesServicioController?.close();
      itemsSeleccionadosController?.close();
      itemController?.close();
      anchoPantallaController?.close();
      altoPantallaController?.close();
      checkBoxAereaController?.close();
      lineaTransmisionPosteIdController?.close();
      opcionesIDController?.close();
      alturaPostesIDController?.close();
      resistenciaPostesIDController?.close();
      tipoPosteIDController?.close();
      materialPosteIDController?.close();
      estadoPostesIDController?.close();
      checkBoxCanalizadaController?.close();
      fotoCajaEmpalmeController?.close();
      fotoPosteController?.close();
      listaPostesOSController?.close();
      estadoOrdenServicioController?.close();
      latitudController?.close();
      rutaFibraController?.close();
      posteSeleccionadoController?.close();
      idPosteController?.close();
      listaPostesIdController?.close();
      listaHilosAgregadosController?.close();
      agregadarHiloController?.close();
      idUsuarioController?.close();
      datosUsuarioController?.close();
    }
  
  
  }
  
  class DocumentSnapshop {
}
