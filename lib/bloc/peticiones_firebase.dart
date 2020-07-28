import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';
import 'package:geo/geo.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

    List<DocumentSnapshot> listVertices = new List();
    // ignore: missing_return
    //QuerySnapshot snapshot = await rutas.getDocuments();

    for (var i = 0; i < rutasCliente.length; i++) {
      // print('uno');
      snapshot = await rutas
          .document(rutasCliente[i])
          .collection('muflas')
          .getDocuments();
      for (var i = 0; i < snapshot.documents.length; i++) {
        listVertices.add(snapshot.documents[i]);
      }
    }

    //print('longitud de la cantidad de rutas: ${listVertices.length}');
    // print(listVertices[0].data);
    //print(snapshot.documents[0].data[snapshot.documents[0].documentID]['latitud']);
    //print(snapshot.documents);
    return listVertices;
  }

  getReservas(List<dynamic> rutasCliente) async {
    QuerySnapshot snapshot;
    print('------CREANDO EL VECTOR DE RESERVAS-------');
    List<DocumentSnapshot> listReservas = new List();

    for (var i = 0; i < rutasCliente.length; i++) {
      print('n');
      snapshot = await rutas
          .document(rutasCliente[i])
          .collection('reservas')
          .getDocuments()
          .catchError((onError) {
        print('error en reserva, no existe para la ruta ${rutasCliente[i]}');
      });
      //print('snapshot $i : ${snapshot.documents}');
      for (var i = 0; i < snapshot.documents.length; i++) {
        listReservas.add(snapshot.documents[i]);
      }
    }

    if (listReservas == null) {
      return [];
    }
    //print('longitud de la cantidad de rutas: ${listVertices.length}');

    //print(snapshot.documents[0].data[snapshot.documents[0].documentID]['latitud']);
    return listReservas;
  }

  getSangria(String cliente, List<dynamic> rutasCliente, String sangria) async {
    QuerySnapshot snapshot;
    print('');
    print('');
    print(
        '------CREANDO LA LISTA DE VERTICES DE LA SANGRIA DEL CLIENTE: $cliente -------');
    List<DocumentSnapshot> listVerticesSangria = new List();

    snapshot = await rutas
        .document(rutasCliente[rutasCliente.length - 1])
        .collection('sangrias')
        .document(sangria)
        .collection(cliente)
        .getDocuments()
        .catchError((onError) {
      print('error en la la sangria: $onError');
    });

    if (snapshot == null) {
      return [];
    }

    for (var i = 0; i < snapshot.documents.length; i++) {
      listVerticesSangria.add(snapshot.documents[i]);
    }

    //print(listVerticesSangria);

    return listVerticesSangria;
  }

  // ignore: missing_return
  Future<List<String>> codificarRutas() async {
    QuerySnapshot _rutas = await rutas.getDocuments();
    List<QuerySnapshot> listVertices = new List();
    print(_rutas.documents);
    List<geo.LatLng> listLatLng = List();
    geo.LatLng coordenada;
    double lat;
    double lng;
    String encode;

    for (var i = 0; i < _rutas.documents.length; i++) {
      QuerySnapshot vertices = await rutas
          .document(_rutas.documents[i].documentID)
          .collection('muflas')
          .getDocuments();
      print('ruta : ${_rutas.documents[i].documentID} ---------');
      listLatLng.clear();
      for (var j = 0; j < vertices.documents.length; j++) {
        lat = vertices.documents[j].data['latitud'];
        lng = vertices.documents[j].data['longitud'];
        coordenada = geo.LatLng(lat, lng);
        listLatLng.add(coordenada);
      }

      encode = const geo.PolylineCodec().encode(listLatLng);

      rutas
          .document(_rutas.documents[i].documentID)
          .setData({'polyline': encode});
      print(encode);
    }

    //---------------------------------------------

    /*  listLatLng.clear();
      for (var j = 0; j < verticesC.documents.length; j++) {
        lat = verticesC.documents[j].data['latitud'];
        lng = verticesC.documents[j].data['longitud'];
        coordenada = geo.LatLng(lat, lng);
        listLatLng.add(coordenada);
      }

      encode = const geo.PolylineCodec().encode(listLatLng);

      rutas
          .document(_rutas.documents[i].documentID)
          .setData({'polyline': encode});
      print(encode); */
  }
}
