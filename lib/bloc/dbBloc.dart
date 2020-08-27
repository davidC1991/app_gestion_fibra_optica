import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
export 'package:audicol_fiber/bloc/peticiones_firebase.dart';


class FirebaseBloc{
 
  DatosRedFibra datosRedFibra= DatosRedFibra();

  
  final _ordenesServicioController = new BehaviorSubject<List<DocumentSnapshot>>();
  final itemsSeleccionadosController = new BehaviorSubject<DocumentSnapshot>();
  final itemController = new BehaviorSubject<String>();
  final anchoPantallaController = new BehaviorSubject<double>();
  final altoPantallaController = new BehaviorSubject<double>();
  final checkBoxAereaController = new BehaviorSubject<bool>();
  final checkBoxCanalizadaController = new BehaviorSubject<bool>();
  
   
   final lineaTransmisionPosteIdController = new BehaviorSubject<String>();
   final opcionesIDController = new BehaviorSubject<String>();
   final alturaPostesIDController = new BehaviorSubject<String>();
   final resistenciaPostesIDController = new BehaviorSubject<String>();
   final tipoPosteIDController = new BehaviorSubject<String>();
   final materialPosteIDController = new BehaviorSubject<String>();
   final estadoPostesIDController = new BehaviorSubject<String>();
  
  
  Stream<List<DocumentSnapshot>> get ordenServicioStream => _ordenesServicioController;
  Stream<DocumentSnapshot> get itemsSeleccionadosStream => itemsSeleccionadosController;
  Stream<String> get itemStream => itemController;
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

   

  getOservicios()async {
  
     final oSs= await datosRedFibra.getOrdenesServicio();
     _ordenesServicioController.sink.add(oSs);

    // print(oSs.length);
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
  }


}
