import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class RegistrarVertice extends StatefulWidget {
  @override
  _RegistrarVerticeState createState() => _RegistrarVerticeState();
}

class _RegistrarVerticeState extends State<RegistrarVertice> {
  TextEditingController longNodoCentralController = TextEditingController();

  TextEditingController longVerticesController = TextEditingController();

  TextEditingController latitudController = TextEditingController();

  TextEditingController longitudController = TextEditingController();

  //TextEditingController idRutaController = TextEditingController();

  TextEditingController idVerticeController = TextEditingController();

  static const menuRutas = [
    'ruta1',
    'ruta2',
    'ruta3',
    'ruta4',
    'ruta5',
    'ruta6',
    'ruta7',
    'ruta8',
    'ruta9',
    'ruta10',
    'ruta11',
    'ruta12',
    'ruta13',
    'ruta14',
    'ruta15',
    'ruta16',
    'ruta17',
    'ruta18',
    'ruta19',
    'ruta20',
    'ruta21',
    'ruta22',
    'ruta23'
  ];

  final List<DropdownMenuItem<String>> dropDownMenuItems = menuRutas
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String rutaId = 'ruta1';
  @override
  Widget build(BuildContext context) {
    /* final showSnack = () => Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('El vertice fue agregado con exito!'),
            duration: Duration(milliseconds: 500),
          ),
        ); */
    return Scaffold(
      //appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            ListTile(
              title: Text('Seleccione la ruta:'),
              trailing: DropdownButton(
                value: rutaId,
                onChanged: (String newValue) {
                  setState(() {
                    rutaId = newValue;
                  });
                },
                items: this.dropDownMenuItems,
              ),
            ),
            SizedBox(
              height: 20,
              child: Text('_______________________________________________'),
            ),
            SizedBox(height: 20),
            Text('Ingrese los datos del vertice'),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Tenga en cuenta el protocolo estandar',
                  labelText: 'ID del vertice'),
              controller: idVerticeController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'vertices longitud',
                  labelText: 'Longitud hacia el nodo central'),
              controller: longNodoCentralController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'dslmkldls',
                  labelText: 'Longitud hacia el vertice izquierdo'),
              controller: longVerticesController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'dslmkldls',
                  labelText: 'Latitud del punto'),
              controller: latitudController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'dslmkldls',
                  labelText: 'Longitud del punto'),
              controller: longitudController,
            ),
            SizedBox(height: 20),
            botonCalcular()
          ],
        ),
      ),
    );
  }

  Widget botonCalcular() {
    print('----------------------');

    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          color: Colors.blueAccent.withOpacity(0.5),
          elevation: 15,
          child: Text('Agregar'),
          onPressed: () {
            //print('----------------------');

            sendBaseDatos();
          },
        )
      ],
    );
  }

  void sendBaseDatos() {
    //String idRuta = idRutaController.text;
    String idVertice = idVerticeController.text;
    String longNodoCentral = longNodoCentralController.text;
    String longVertices = longVerticesController.text;
    final latitud = latitudController.text;
    final longitud = longitudController.text;
    print('idRuta: $rutaId');
    print('idVertice: $idVertice');
    print('longNodoCentral: $longNodoCentral');
    print('longVertices: $longVertices');
    print('latitud: $latitud');
    print('longitud: $longitud');

    if (idVertice.isNotEmpty ||
        longNodoCentral.isNotEmpty ||
        longVertices.isNotEmpty ||
        latitud.isNotEmpty ||
        longitud.isNotEmpty) {
      rutas
          .document(rutaId)
          .collection('muflas')
          .document(idVertice.toUpperCase())
          .setData({
        //idVertice.toUpperCase(): {
        'longNodoCentral': double.parse(longNodoCentral),
        'longVertices': double.parse(longVertices),
        'latitud': double.parse(latitud),
        'longitud': double.parse(longitud)
        // }
      });
      rutas.document(rutaId).setData({'a': 'a'});
      Fluttertoast.showToast(
          msg: 'El vertice fue guardado con exito!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 10,
          backgroundColor: Colors.grey);

      idVerticeController.clear();
      longNodoCentralController.clear();
      longVerticesController.clear();
      latitudController.clear();
      longitudController.clear();
    } else {
      Fluttertoast.showToast(
          msg: 'LLene todos los campos!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 10,
          backgroundColor: Colors.grey);
    }
  }
}
