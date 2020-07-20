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
    String cliente;
    String snapshot = await clientes.document(query).get().then((value) {
      // value.data['nombre'];
      //print('----');
      print(value.data['nombre']);
      cliente = value.data['nombre'].toString();
      return cliente;
    }).catchError((error) {});
  }

  getRutas() async {
    // QuerySnapshot snapshot = await rutas.getDocuments();
    DocumentSnapshot snapshot = await rutas.document('ruta1').get();

    print(snapshot.data);
  }
}
