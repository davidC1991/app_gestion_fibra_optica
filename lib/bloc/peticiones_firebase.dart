import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';

class DatosRedFibra {
  getCliente() async {
    QuerySnapshot snapshot = await clientes.getDocuments();

    print(snapshot.documents[0].documentID);
    return snapshot.documents;
  }

  getRutas() async {
    // QuerySnapshot snapshot = await rutas.getDocuments();
    DocumentSnapshot snapshot = await rutas.document('ruta1').get();

    print(snapshot.data);
  }
}
