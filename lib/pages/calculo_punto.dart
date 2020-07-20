import 'dart:ui';

import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:audicol_fiber/search/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:geo/geo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

final clientes = Firestore.instance.collection('clientes');
final rutas = Firestore.instance.collection('rutas');

// ignore: must_be_immutable
class CalculoCoordenada extends StatefulWidget {
  String cliente = 'a';
  CalculoCoordenada({Key key, @required this.cliente}) : super(key: key);
  @override
  _CalculoCoordenadaState createState() => _CalculoCoordenadaState();
}

class _CalculoCoordenadaState extends State<CalculoCoordenada> {
  TextEditingController distanciaController = TextEditingController();
  DatosRedFibra datosRedFibra = DatosRedFibra();
  String clienteAux = '';
  String distanciaString = "";
  int distancia;
  String clienteId = Uuid().v4();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.cliente == null) {
      clienteAux = '';
    } else {
      print(widget.cliente);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Buscar nombre del cliente',
            style: TextStyle(fontSize: 20.0, color: Colors.grey)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            widget.cliente == null ? Container() : descripcionCliente(),
            SizedBox(height: 30),
            titulo(),
            SizedBox(height: 30),
            entradaDistancia(),
            SizedBox(height: 90),
            botonCalcular()
          ],
        ),
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
          color: Colors.blueAccent.withOpacity(0.5),
          elevation: 15,
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
            datosRedFibra.getCliente();
            datosRedFibra.getRutas();
            /*  clientes.document('celustar').setData({
              'id': clienteId,
              'username': 'celustar',
              'photoUrl': '',
              'email': 'celustar@hotmail.com',
              'ruta': 'R1',
              'hilo': '37',
              'celular': '3459589655',
              'activo': true,
              'tipoCliente': 'privado',
            }); */
          },
        )
      ],
    );
  }

  Widget descripcionCliente() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage(
              image: NetworkImage(
                  'https://www.opinioncaribe.com/wp-content/uploads/2018/01/WhatsApp-Image-2018-01-12-at-6.13.09-PM.jpeg'),
              placeholder: AssetImage('assets/img/no.image.jpg'),
              width: 350.0,
              fit: BoxFit.contain,
            ),
          ),
          Text(widget.cliente),
        ],
      ),
    );
  }
}
