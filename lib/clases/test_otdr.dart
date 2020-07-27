import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geo/geo.dart';

class TestOtdr {
  int distancia = 0;
  //List<QuerySnapshot> listVertices = new List();
  DatosRedFibra datosRedFibra = DatosRedFibra();
  //ENCONTRAMOS LAS RUTAS POR LA QUE PASA EL CLIENTE
  getVerticesElegidos(String cliente, List<dynamic> rutas, String sangria,
      double distancia) async {
    print('');
    print('');
    print('las rutas del $cliente son $rutas');
    List<DocumentSnapshot> listVerticesSangria = new List();

    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    //CREAMOS LA LISTA DE SANGRIAS DE LAS RUTAS DEL CLIENTE
    List<DocumentSnapshot> listReservas =
        await datosRedFibra.getReservas(rutas);
    print('');
    print('');
    print(
        '-------LISTA DE RESERVAS DE LAS RUTAS-----------------------------------');
    if (listReservas.isEmpty) {
      print('lista de reservas esta vacia');
    } else {
      print(listReservas);
      //OBTENIENDO LA LONGITUD DE LA RESERVA HACIA NODO CENTRAL A TRAVES DE LA LISTA DE MAPAS
      print(listReservas[0].data['longNodoCentral']);
    }
    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    //CREAMOS LA LISTA DE LOS VERTICES DE LA SANGRIA A LA QUE PERTENECE EL CLIENTE

    listVerticesSangria =
        await datosRedFibra.getSangria(cliente, rutas, sangria);
    if (listVerticesSangria.isEmpty) {
      print('lista de vertices de sangria esta vacia');
    } else {
      for (var i = 0; i < listVerticesSangria.length; i++) {
        print(listVerticesSangria[i].documentID);
      }
    }

    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    //CREAMOS LA LISTA DE VERTICES DE LAS RUTAS DEL CLIENTE
    //NO ES CONVENIENTE INDEPENDIZAR LAS LONGITUDES DE NODO CENTRAL
    //DE LA LISTA DE MAPAS GENERAL DE LAS RUTAS, POR QUE AL REALIZAR LAS RESTAS NO SE VA PODER UBICAR EL VERTICE
    List<DocumentSnapshot> listVertices =
        await datosRedFibra.getVertices(rutas);
    //OBTENIENDO LA LONGITUD DEL VERTICE HACIA NODO CENTRAL A TRAVES DE LA LISTA DE MAPAS
    //print(listVertices[0].data["longVertices"]);
    print('');
    print('');
    for (var i = 0; i < listVertices.length; i++) {
      print(listVertices[i].documentID);
    }
    print(
        '-------LISTA DE VERTICES DE LAS RUTAS-----------------------------------');
    List<DocumentSnapshot> _listVertices = List();
    for (var i = 0; i < listVertices.length; i++) {
      if (listVertices[i].data['longNodoCentral'] <=
          listVerticesSangria[0].data['longNodoCentral']) {
        _listVertices.add(listVertices[i]);
      }
    }
    for (var i = 0; i < _listVertices.length; i++) {
      print(_listVertices[i].documentID);
    }
    print('');
    print('');
    print(
        '-------ITERANDO LA DISTANCIA DEL OTDR CON LAS LISTAS DE VECTORES RESERVAS, VERTICES RUTAS Y VERTICES SANGRIAS-----------------------------------');
    print('');
    print('');
    //RESTAR EL RECORRIDO DE LAS RESERVAS DE LAS RUTAS A LA DISTANCIA ENTREGADA POR EL OTDR
    /*  var lonReserva;
    var lonNodoCentral;
    if (listReservas.isNotEmpty) {
      for (var i = 0; i < listReservas.length; i++) {
        lonReserva = listReservas[i].data['longReserva'];
        lonNodoCentral = listReservas[i].data['longNodoCentral'];
        //print(lonReserva);
        //print(lonNodoCentral);
        //VALIDACION DE LA DISTANCIA CON LA RESERVA, SI ES MAYOR A LA DISTANCIA DE LA RESERVA
        //Y MAYOR A LA DISTANCIA DE LA RESERVA MAS LA LONGITUD DE LA RESERVA ENTONCES RESTE
        if (distancia > lonNodoCentral &&
            distancia > (lonNodoCentral + lonReserva)) {
          print('');
          print('');
          print(
              'se restó a la distancia la reserva ${listReservas[i].documentID}');
          distancia = distancia - listReservas[i].data['longReserva'];
          print('');
          print('');
          break;
        }
        //SI NO SE CUMPLE LA CONDICION ANTERIOR ENTONCES SE PREGUNTA SI LA DISTANCIA ESTA ENTRE EL INTERVALO DE LA RESERVA
        //EN ESE CASO SE REGISTRA LA DISTANCIA COMO LA MISMA LONGITUD HACIA EL NODO CENTRAL
        if (distancia > lonNodoCentral &&
            distancia <= (lonNodoCentral + lonReserva)) {
          distancia = lonNodoCentral;
          break;
        }
      }
    } else {
      print('');
      print('');
      print('--------------NO HAY RESERVAS EN LA RUTA----------------------');
      print('');
      print('');
    } */
/*
    print('DISTANCIA INGRESADA: $distancia');
    print('');
    print('');
    List<DocumentSnapshot> listVerticesSangriasRutas = List();
    //CONCATENANDO LA LISTA DE VERTICES DE RUTAS CON LA LISTA DE VERTICES DE SANGRIAS
    for (var i = 0; i < _listVertices.length; i++) {
      listVerticesSangriasRutas.add(_listVertices[i]);
    }
    for (var i = 0; i < listVerticesSangria.length; i++) {
      listVerticesSangriasRutas.add(listVerticesSangria[i]);
    }
    print('');
    print('');
    print(
        '--------------LISTA DE VERTICES DE LA RUTAS MAS LOS VERTICES DE LA SANGRIA----------------------');
    for (var i = 0; i < listVerticesSangriasRutas.length; i++) {
      print(listVerticesSangriasRutas[i].documentID);
    }
    print('');
    print('');
    //ITERAR LA DISTANCIA CON EL LA LISTA DE VERTICES DE RUTAS, PREGUNTANDO POR EL VERTICE CUYA LONGITUD
    // HACIA EL NODO CENTRAL SEA MENOR A ESTA DISTANCIA
       Map<String, dynamic> verticeA = Map();
    Map<String, dynamic> verticeB = Map();
    print('ITERANDO LA DISTANCIA CON LOS VERTICES DE LAS RUTAS DEL CLIENTE');
    for (var i = 0; i < listVerticesSangriasRutas.length; i++) {
      print(listVerticesSangriasRutas[i].data["longNodoCentral"]);
      if (distancia <= listVerticesSangriasRutas[i].data["longNodoCentral"]) {
        verticeA = listVerticesSangriasRutas[i - 1].data;
        verticeB = listVerticesSangriasRutas[i].data;
        break;
      }
    }
/* 
    //ITERAR LA DISTANCIA CON LA LISTA DE VERTICE DE LA SANGRIA DEL CLIENTE, PREGUNTANDO POR EL VERTICE CUYA
    // LONGITUD HACIA EL NODO CENTRAL SEA MENOR A ESTA DISTANCIA
    if (verticeA.isEmpty && verticeB.isEmpty) {
      print('ITERANDO LA DISTANCIA CON LOS VERTICES DE LA SANGRIA DEL CLIENTE');
      for (var i = 0; i < listVerticesSangria.length; i++) {
        print(listVerticesSangria[i].data["longNodoCentral"]);
        if (distancia <= listVerticesSangria[i].data["longNodoCentral"]) {
          verticeA = listVerticesSangria[i - 1].data;
          verticeB = listVerticesSangria[i].data;
          break;
        }
      }
    } */
    print('');
    print('');
    print('verticeA: $verticeA');
    print('verticeB: $verticeB');
    print('');
    print('');
    //SI INNGRESAN UNA DISTANCIA MAYOR A LA SUMATORIA DE LAS RUTAS Y LA SANGRIA DEL CLIENTE
    //ENTONCES RETORNA VACIO
    if (distancia >
        listVerticesSangria[listVerticesSangria.length - 1]
            .data['longNodoCentral']) {
      print(
          'Ditancia del OTDR es mayor a la distancia de la ruta y la sangira del cliente');
      return {};
    }
    double distanciaEnVertice = verticeB['longNodoCentral'] - distancia;
    distanciaEnVertice = verticeB['longVertices'] - distanciaEnVertice;
    print('distanciaReal: $distanciaEnVertice');
    //print('latitud escogida:${verticeA['latitud']}');
    return {
      'latitudA': verticeA['latitud'],
      'longitudA': verticeA['longitud'],
      'longNodoCentralA': verticeA['longNodoCentral'],
      'longVerticesA': verticeA['longVertices'],
      'latitudB': verticeB['latitud'],
      'longitudB': verticeB['longitud'],
      'longNodoCentralB': verticeB['longNodoCentral'],
      'longVerticesB': verticeB['longVertices'],
      'distancia': distanciaEnVertice
    }; */
  }
}
