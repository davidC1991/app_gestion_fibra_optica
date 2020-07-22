import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geo/geo.dart';

class TestOtdr {
  int distancia = 0;
  //List<QuerySnapshot> listVertices = new List();
  DatosRedFibra datosRedFibra = DatosRedFibra();
  //ENCONTRAMOS LAS RUTAS POR LA QUE PASA EL CLIENTE
  buscarRutas(String cliente, List<dynamic> rutas) async {
    print('las rutas del $cliente son $rutas');
    List<Map<String, dynamic>> vectorVertices = new List();
    List<double> vectorNodoCentral = List();
    //CREAMOS EL VECTOR DE VERTICES DE LAS RUTAS
    final listVertices = await datosRedFibra.getVertices(rutas);
    vectorVertices.clear();
    print('------------------------------------------');
    print(listVertices);

    for (var i = 0; i < listVertices.length; i++) {
      for (var j = 0; j < listVertices[i].documents.length; j++) {
        vectorVertices.add(listVertices[i].documents[j].data);
      }
    }
    vectorNodoCentral.clear();
    //CREAMOS EL VECTOR DE LONGITUD NODO CENTRAL----> NO ES CONVENIENTE INDEPENDIZAR LAS LONGITUDES DE NODO CENTRAL
    //DE LA LISTA DE MAPAS GENERAL DE LAS RUTAS, POR QUE AL REALIZAR LAS RESTAS NO SE VA PODER UBICAR EL VERTICE
    for (var i = 0; i < vectorVertices.length; i++) {
      vectorNodoCentral.add(vectorVertices[i]['longNodoCentral']);
    }

    print(vectorNodoCentral);
    print('------------------------------------------');
    print('vectorVetices: ${vectorVertices}');
    //OBTENIENDO LA LONGITUD DE NODO CENTRAL A TRAVES DE LA LISTA DE MAPAS
    print('------------------------------------------');
    print('vectorVetices: ${vectorVertices[4]["longNodoCentral"]}');

    //print(vectorVertices[0].keys);
    //print(vectorVertices[0].values);
  }
}

//vector_vertices=[]
//vector_Reservas=[]
//vector
//vector
