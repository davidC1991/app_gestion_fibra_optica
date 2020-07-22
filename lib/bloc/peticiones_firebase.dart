import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';

class DatosRedFibra {
  Future<List<String>> getCliente() async {
    QuerySnapshot snapshot = await clientes.getDocuments();
    List<String> clientesList = new List();

    for (var i = 0; i < snapshot.documents.length; i++) {
      clientesList.add(snapshot.documents[i].documentID);
    }

    //print(snapshot.documents[0].documentID);
    //return snapshot.documents;
    return clientesList;
  }

  // ignore: missing_return
  getClienteAux(String query) async {
    Map<String, Object> datosClientes = new Map();
    QuerySnapshot snapshot = await clientes.document(query).get().then((value) {
      // value.data['nombre'];
      // print('----');
      value.data.forEach((key, value) {
        datosClientes[key] = value;
      });
      //print(datosClientes);
      if (value.exists) {
        /*  for (var i = 0; i < value.data.length; i++) {
          materiasYcursos[b.data['cursoInd'][i]] = b.data['curso'][b.data['cursoInd'][i]];
        } */
      }
    }).catchError((error) {});
    return datosClientes;
  }

  getVertices(List<dynamic> rutasCliente) async {
    // QuerySnapshot snapshot = await rutas.getDocuments();
    QuerySnapshot snapshot;
    print('-------|--------');
    List<QuerySnapshot> listVertices = new List();
    // ignore: missing_return
    //QuerySnapshot snapshot = await rutas.getDocuments();

    for (var i = 0; i < rutasCliente.length; i++) {
      snapshot = await rutas
          .document(rutasCliente[i])
          .collection('muflas')
          .getDocuments();
      listVertices.add(snapshot);
    }
    print('longitud de la cantidad de rutas: ${listVertices.length}');
    //print(listVertices[0].documents);
    return listVertices;
  }
}
