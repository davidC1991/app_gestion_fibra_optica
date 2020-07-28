import 'dart:ui';

import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:audicol_fiber/clases/test_otdr.dart';
import 'package:audicol_fiber/pages/mapa_fiber.dart';
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
  TestOtdr testOtdr = TestOtdr();
  DatosRedFibra datosRedFibra = DatosRedFibra();
  String clienteAux = '';
  String distanciaString = "";
  double distancia;
  String clienteId = Uuid().v4();
  Map<String, Object> datosClientes = new Map();
  Map<String, dynamic> verticesElegidos = Map();
  String clienteName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.cliente == null) {
      clienteAux = '';
    } else {
      print('widget.cliente-->${widget.cliente}');

      getDatosCliente(widget.cliente);
    }
  }

  getDatosCliente(String cliente) async {
    datosClientes = await datosRedFibra.getClienteAux(widget.cliente);
    print('clienteName_1:$clienteName');
    print('Calculo punto.....');

    clienteName = datosClientes['nombre'];
    print('clienteName_2:$clienteName');
    setState(() {});
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
            clienteName == null ? Container() : descripcionCliente(),
            SizedBox(height: 30),
            titulo(),
            SizedBox(height: 30),
            entradaDistancia(),
            SizedBox(height: 30),
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
            distancia = double.tryParse(distanciaString);
            print('----------------------');
            getVerticesOTDR();
            /*  print(distanciaString);

           
            const p1 = LatLng(11.226940, -74.198010);
            const p2 = LatLng(11.225604, -74.196796);
            final angulo = computeHeading(p1, p2);
            print('angulo: $angulo grados');
            print(
                'distancia entre los dos puntos: ${computeDistanceBetween(p1, p2)} metros');

            print(
                'coordenadas del punto de falla: ${computeOffset(p1, 20, angulo)}');

            distanciaController.clear();
            distanciaString = ""; */
            //datosRedFibra.getCliente();
            // datosRedFibra.getRutas();
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

  void getVerticesOTDR() async {
    verticesElegidos = await testOtdr.getVerticesElegidos(
        datosClientes['nombre'],
        datosClientes['rutas'],
        datosClientes['sangria'],
        distancia);

    print('Vertices elegidos: $verticesElegidos');
    calcularCoordenada(
        verticesElegidos['latitudA'],
        verticesElegidos['longitudA'],
        verticesElegidos['latitudB'],
        verticesElegidos['longitudB'],
        verticesElegidos['distancia'],
        verticesElegidos['encode']);
  }

  void calcularCoordenada(double latitudA, double longitudA, double latitudB,
      double longitudB, double distancia, String encode) {
    var p1 = LatLng(latitudA, longitudA);
    var p2 = LatLng(latitudB, longitudB);
    LatLng coordenadaFalla;
    //var p1 = LatLng(11.243911, -74.211836);
    //var p2 = LatLng(11.24318, -74.207468);
    //si angulo negativo  sumar 360
    var angulo = computeHeading(p1, p2);
    if (angulo < 0.0) {
      angulo = angulo + 360.0;
    }
    print('angulo: $angulo grados');
    print(
        'distancia entre los dos puntos: ${computeDistanceBetween(p1, p2)} metros');
    coordenadaFalla = computeOffset(p1, distancia, angulo);

    print('coordenadas del punto de falla: $coordenadaFalla');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MapaRutas(coordenadaFalla: coordenadaFalla, encode: encode)));
  }

  Widget descripcionCliente() {
    print('entro a descripcion del cliente');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage(
              image: NetworkImage(datosClientes['photoUrl']),
              placeholder: AssetImage('assets/cargando.gif'),
              width: 350.0,
              fit: BoxFit.contain,
              // fadeInDuration: ,
            ),
          ),
          Container(
            //alignment: Alignment.topLeft,
            height: 20,
            //color: Colors.grey,
            child: ListTile(
                // contentPadding: EdgeInsets.symmetric(vertical: 0),
                dense: true,
                leading: Text('Nombre:'),
                //title: ,
                trailing: Text(widget.cliente)),
          ),
          Container(
            height: 20,
            child: ListTile(
                // contentPadding: EdgeInsets.symmetric(vertical: 0),
                dense: true,
                leading: Text('Celular:'),
                //title: ,
                trailing: Text(datosClientes['celular'])),
          ),
          Container(
            height: 20,
            child: ListTile(
                // contentPadding: EdgeInsets.symmetric(vertical: 0),
                dense: true,
                leading: Text('Email:'),
                //title: ,
                trailing: Text(datosClientes['email'])),
          ),
          Container(
            height: 20,
            child: ListTile(
                // contentPadding: EdgeInsets.symmetric(vertical: 0),
                dense: true,
                leading: Text('Hilo:'),
                //title: ,
                trailing: Text(datosClientes['hilo'])),
          ),
          Container(
            height: 20,
            child: ListTile(
                // contentPadding: EdgeInsets.symmetric(vertical: 0),
                dense: true,
                leading: Text('Rutas:'),
                //title: ,
                trailing: Text('ruta1')),
          ),
          Container(
            height: 20,
            child: ListTile(
                // contentPadding: EdgeInsets.symmetric(vertical: 0),
                dense: true,
                leading: Text('Tipo de cliente:'),
                //title: ,
                trailing: Text(datosClientes['tipoCliente'])),
          ),
          Text(''),
        ],
      ),
    );
  }
}
