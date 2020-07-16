import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';

// ignore: must_be_immutable
class RegistrarRuta extends StatelessWidget {
  TextEditingController longNodoCentralController = TextEditingController();
  TextEditingController longVerticesController = TextEditingController();
  TextEditingController latitudController = TextEditingController();
  TextEditingController longitudController = TextEditingController();
  TextEditingController idRutaController = TextEditingController();
  TextEditingController idVerticeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Registrar nueva ruta')),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Tenga en cuenta el protocolo estandar',
                  labelText: 'ID de la ruta'),
              controller: idRutaController,
            ),
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
          color: Colors.blueAccent,
          child: Text('Guardar'),
          onPressed: () {
            //print('----------------------');
            //sendBaseDatos();
            String idRuta = idRutaController.text;
            String idVertice = idVerticeController.text;
            String longNodoCentral = longNodoCentralController.text;
            String longVertices = longVerticesController.text;
            final latitud = latitudController.text;
            final longitud = longitudController.text;
            print('idRuta: $idRuta');
            print('idVertice: $idVertice');
            print('longNodoCentral: $longNodoCentral');
            print('longVertices: $longVertices');
            print('latitud: $latitud');
            print('longitud: $longitud');
          },
        )
      ],
    );
  }

  void sendBaseDatos() {
    String idRuta = idRutaController.toString();
    rutas.document(idRuta).collection('muflas').document('').setData({
      /*   'postId': postId,
      'nombreDoc': userName,
      'materia': materiaSelected,
      'curso': cursoSelected,
      'tituloTema': tituloTema,
      'mediaUrl': mediaUrl,
      'descripcion': description,
      'calificacion': false,
      'revisado': true,
      'fechaLimite': fecha,
      'timestamp': DateTime.now(),
      'likes': {}, */
    });
  }
}
