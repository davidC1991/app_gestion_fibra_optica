import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ResgistrarRuta extends StatelessWidget {
  List opciones = [
    'Agregar Vertice',
    'Agregar Reservas',
    'Agregar Sangria',
    'Agregar Descripcion'
  ];
  int contPantalla = 0;
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
        bottomNavigationBar: _bottomNavigationBar(context));
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: Color.fromRGBO(55, 57, 84, 1.0),
          primaryColor: Colors.pinkAccent,
          textTheme: Theme.of(context).textTheme.copyWith(
              caption: TextStyle(color: Color.fromRGBO(116, 117, 152, 1.0)))),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.toll, size: 30.0), title: Container()),
          BottomNavigationBarItem(
              icon: Icon(Icons.pan_tool, size: 30.0), title: Container()),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle, size: 30.0),
              title: Container())
        ],
      ),
    );
  }

  Widget _tablaOpciones(BuildContext context) {
    int cont_pantalla = 0;
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
              'Protocolo de Rutas', context),
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
        if (texto.contains('Descripción')) {
          print('Descripción');
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
          // Navigator.pushNamed(context, 'registroReservas');
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
