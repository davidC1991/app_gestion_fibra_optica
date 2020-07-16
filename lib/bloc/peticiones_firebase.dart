import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';

class DatosRedFibra {
  getCliente() async {
    DocumentSnapshot snapshot = await clientes.document('celustar').get();

    // print(snapshot.data['ruta']);
  }

  getRutas() async {
    // QuerySnapshot snapshot = await rutas.getDocuments();
    DocumentSnapshot snapshot = await rutas.document('ruta1').get();

    print(snapshot.data);
  }
}
