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
    print('las rutas del $cliente son $rutas');
    List<DocumentSnapshot> listVerticesSangria = new List();

    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    //CREAMOS LA LISTA DE VERTICES DE LAS RUTAS DEL CLIENTE
    //NO ES CONVENIENTE INDEPENDIZAR LAS LONGITUDES DE NODO CENTRAL
    //DE LA LISTA DE MAPAS GENERAL DE LAS RUTAS, POR QUE AL REALIZAR LAS RESTAS NO SE VA PODER UBICAR EL VERTICE
    List<DocumentSnapshot> listVertices =
        await datosRedFibra.getVertices(rutas);
    print(
        '-------LISTA DE VERTICES DE LAS RUTAS-----------------------------------');
    print(listVertices);
    //OBTENIENDO LA LONGITUD DEL VERTICE HACIA NODO CENTRAL A TRAVES DE LA LISTA DE MAPAS
    print(listVertices[0].data["longVertices"]);
    print('------------------------------------------');

    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    //CREAMOS LA LISTA DE SANGRIAS DE LAS RUTAS DEL CLIENTE
    List<DocumentSnapshot> listReservas =
        await datosRedFibra.getReservas(rutas);
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
      print(listVerticesSangria);
      //OBTENIENDO LA LONGITUD DE LA RESERVA HACIA NODO CENTRAL A TRAVES DE LA LISTA DE MAPAS
      print(listVerticesSangria[0].data['longNodoCentral']);
    }
    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    print(
        '-------ITERANDO LA DISTANCIA DEL OTDR CON LAS LISTAS DE VECTORES RESERVAS, VERTICES RUTAS Y VERTICES SANGRIAS-----------------------------------');
    //RESTAR EL RECORRIDO DE LAS RESERVAS DE LAS RUTAS A LA DISTANCIA ENTREGADA POR EL OTDR
    var lonReserva;
    var lonNodoCentral;
    if (listReservas.isNotEmpty) {
      for (var i = 0; i < listReservas.length; i++) {
        lonReserva = listReservas[i].data['longReserva'];
        lonNodoCentral = listReservas[i].data['longNodoCentral'];
        print(lonReserva);
        print(lonNodoCentral);
        //VALIDACION DE LA DISTANCIA CON LA RESERVA, SI ES MAYOR A LA DISTANCIA DE LA RESERVA
        //Y MAYOR A LA DISTANCIA DE LA RESERVA MAS LA LONGITUD DE LA RESERVA ENTONCES RESTE
        if (distancia > lonNodoCentral &&
            distancia > (lonNodoCentral + lonReserva)) {
          print(
              'se restó a la distancia la reserva ${listReservas[i].documentID}');
          distancia = distancia - listReservas[i].data['longReserva'];
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
      print('No hay reservas en estas rutas');
    }
    print('Distancia: $distancia');
    //ITERAR LA DISTANCIA CON EL LA LISTA DE VERTICES DE RUTAS, PREGUNTANDO POR EL VERTICE CUYA LONGITUD
    // HACIA EL NODO CENTRAL SEA MENOR A ESTA DISTANCIA
    Map<String, dynamic> verticeA = Map();
    Map<String, dynamic> verticeB = Map();
    print('ITERANDO LA DISTANCIA CON LOS VERTICES DE LAS RUTAS DEL CLIENTE');
    for (var i = 0; i < listVertices.length; i++) {
      print(listVertices[i].data["longNodoCentral"]);
      if (distancia <= listVertices[i].data["longNodoCentral"]) {
        verticeA = listVertices[i - 1].data;
        verticeB = listVertices[i].data;
        break;
      }
    }

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
    }
    print('verticeA: $verticeA');
    print('verticeB: $verticeB');
    //SI INNGRESAN UNA DISTANCIA MAYOR A LA SUMATORIA DE LAS RUTAS Y LA SANGRIA DEL CLIENTE
    //ENTONCES RETORNA VACIO
    if (distancia >
        listVerticesSangria[listVerticesSangria.length - 1]
            .data['longNodoCentral']) {
      print(
          'Ditancia del OTDR es mayor a la distancia de la ruta y la sangira del cliente');
      return {};
    }
    print('latitud escogida:${verticeA['latitud']}');
    return {
      'latitudA': verticeA['latitud'],
      'longitudA': verticeA['longitud'],
      'longNodoCentralA': verticeA['longNodoCentral'],
      'longVerticesA': verticeA['longVertices'],
      'latitudB': verticeB['latitud'],
      'longitudB': verticeB['longitud'],
      'longNodoCentralB': verticeB['longNodoCentral'],
      'longVerticesB': verticeB['longVertices'],
      'distancia': distancia
    };
  }
}
