import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
export 'package:audicol_fiber/bloc/peticiones_firebase.dart';


class FirebaseBloc{
 
  DatosRedFibra datosRedFibra= DatosRedFibra();

  final _ordenesServicioController = new BehaviorSubject<List<DocumentSnapshot>>();
  
  Stream<List<DocumentSnapshot>> get ordenServicioStream => _ordenesServicioController;
   

  getOservicios()async {
  
     final oSs= await datosRedFibra.getOrdenesServicio();
     _ordenesServicioController.sink.add(oSs);

    // print(oSs.length);
  }
    
    
     
  
  


 dispose(){
    _ordenesServicioController?.close();
  }


}