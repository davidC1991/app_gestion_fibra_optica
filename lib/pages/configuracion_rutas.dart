import 'dart:ui';

import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ResgistrarRuta extends StatelessWidget {
  List opciones = [
    'Agregar Vertice',
    'Agregar Reservas',
    'Agregar Sangria',
    'Agregar Descripcion'
  ];
  int contPantalla = 0;

  DatosRedFibra datosRedFibra = DatosRedFibra();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        // title: Center(child: Text('Crear Ruta')),
        backgroundColor: Colors.lightBlue,
      ), */
      body: Center(
        child: Container(
          alignment: Alignment.center,
          // color: Colors.blue.withOpacity(0.2),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: FractionalOffset(0.0, 0.6),
                  end: FractionalOffset(0.0, 1.0),
                  colors: [
                Color.fromRGBO(52, 54, 101, 1.0),
                Color.fromRGBO(35, 37, 57, 1.0)
              ])),
          child: _tablaOpciones(context),
        ),
      ),
    );
  }

  Widget _tablaOpciones(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          _crearBotonRedondeado(
              Colors.blue, Icons.border_all, 'Registrar Vertice', context),
          _crearBotonRedondeado(Colors.purpleAccent, Icons.directions_bus,
              'Registrar Reserva', context),
        ]),
        TableRow(children: [
          _crearBotonRedondeado(
              Colors.green, Icons.directions_car, 'Registrar Sangria', context),
          _crearBotonRedondeado(Colors.brown, Icons.directions_railway,
              'Registrar Cliente', context),
        ]),
        TableRow(children: [
          _crearBotonRedondeado(Colors.blueGrey, Icons.directions_car,
              'Codificar coordenadas', context),
          _crearBotonRedondeado(
              Colors.pink, Icons.directions_car, 'Opciones', context),
        ]),
      ],
    );
  }

  Widget _crearBotonRedondeado(
      Color color, IconData icono, String texto, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (texto.contains('Registrar Vertice')) {
          print('Se presionó vertice');
          Navigator.pushNamed(context, 'registroVertices');
        }
        if (texto.contains('Registrar Reserva')) {
          print('Se presionó Reserva');
          Navigator.pushNamed(context, 'registroReservas');
        }
        if (texto.contains('Registrar Sangria')) {
          print('Se presionó Sangria');
          Navigator.pushNamed(context, 'registroSangrias');
        }
        if (texto.contains('Registrar Cliente')) {
          print('Registrar Cliente');
          Navigator.pushNamed(context, 'RegistroClientes');
        }
        if (texto.contains('Codificar coordenadas')) {
          codificarCoordenadasRutas();
        }
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
        child: Container(
          height: 150.0,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Color.fromRGBO(62, 66, 107, 0.7).withOpacity(0.7),
              borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: color,
                radius: 35.0,
                child: Icon(icono, color: Colors.white, size: 30.0),
              ),
              Text(texto, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  void codificarCoordenadasRutas() async {
    print('Codificar coordenadas');
    await datosRedFibra.codificarRutas();
  }

  /* Widget _crearBotonRedondeado(String opciones, int i, BuildContext context) {
    print(i);
    return GestureDetector(
      onTap: () {
        if (i == 0) {
          print('agregar vertice');
          //
        }
        if (contPantalla == 1) {
          print('agregar reserva');
          // 
          pushNamed(context, 'registroReservas');
        }
        if (contPantalla == 2) {
          print('agregar sangria');
        }
        if (contPantalla == 3) {
          print('agregar descripcion');
        }
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.0),
        child: Container(
          height: 150.0,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              //color: Color.fromRGBO(62,66,107,0.7).withOpacity(0.2),
              color: Colors.blue[500],
              borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(opciones,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  } */
}
