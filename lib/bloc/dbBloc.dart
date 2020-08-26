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
  
  Stream<List<DocumentSnapshot>> get ordenServicioStream => _ordenesServicioController;
  Stream<DocumentSnapshot> get itemsSeleccionadosStream => itemsSeleccionadosController;
  Stream<String> get itemStream => itemController;
  Stream<double> get altoPantallaStream => altoPantallaController;
  Stream<double> get anchoPantallaStream => anchoPantallaController;
   

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
  }


}