import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geo/geo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

final clientes = Firestore.instance.collection('clientes');

class CalculoCoordenada extends StatefulWidget {
  @override
  _CalculoCoordenadaState createState() => _CalculoCoordenadaState();
}

class _CalculoCoordenadaState extends State<CalculoCoordenada> {
  TextEditingController distanciaController = TextEditingController();
  String distanciaString = "";
  int distancia;
  String clienteId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculo de punto de falla'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 30),
          titulo(),
          SizedBox(height: 30),
          entradaDistancia(),
          SizedBox(height: 20),
          botonCalcular()
        ],
      ),
    );
  }

  Widget titulo() {
    return Text('Distancia OTDR');
  }

  Widget entradaDistancia() {
    return Container(
      width: 300,
      child: TextField(
        controller: distanciaController,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
            icon: Icon(Icons.account_circle),
            labelText: 'Kilometros',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        onChanged: (val) {
          //print('val:$val');
          distanciaString = val;
        },
      ),
    );
  }

  Widget botonCalcular() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          color: Colors.blueAccent,
          child: Text('Calcular'),
          onPressed: () {
            print('----------------------');
            print(distanciaString);

            distancia = int.tryParse(distanciaString);
            const p1 = LatLng(11.226940, -74.198010);
            const p2 = LatLng(11.225604, -74.196796);
            final angulo = computeHeading(p1, p2);
            print('angulo: $angulo grados');
            print(
                'distancia entre los dos puntos: ${computeDistanceBetween(p1, p2)} metros');

            print(
                'coordenadas del punto de falla: ${computeOffset(p1, 20, angulo)}');

            distanciaController.clear();
            distanciaString = "";

            clientes.document(clienteId).setData({
              'id': clienteId,
              'username': 'Laura Vicuña',
              'photoUrl': '',
              'email': 'lauraVicuña@hotmail.com',
              'ruta': 'R1-R2-R3',
              'hilo': '34',
              'celular': '3459589655',
              'activo': true,
              'tipoCliente': 'publico',
            });
            //print(v);
            //distanciaController.clear();
          },
        )
      ],
    );
  }
}
