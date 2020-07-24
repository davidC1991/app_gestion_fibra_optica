import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrarReserva extends StatefulWidget {
  @override
  _RegistrarReservaState createState() => _RegistrarReservaState();
}

class _RegistrarReservaState extends State<RegistrarReserva> {
  TextEditingController longNodoCentralController = TextEditingController();

  TextEditingController longReservaController = TextEditingController();

  TextEditingController latitudController = TextEditingController();

  TextEditingController longitudController = TextEditingController();

  //TextEditingController idRutaController = TextEditingController();

  TextEditingController idReservaController = TextEditingController();

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
            Text('Ingrese los datos de la Reserva'),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Tenga en cuenta el protocolo estandar',
                  labelText: 'ID de la Reserva'),
              controller: idReservaController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Ingresar parametro en metros',
                  labelText: 'Longitud hacia el nodo central'),
              controller: longNodoCentralController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Ingresar parametro en metros',
                  labelText: 'Cantidad de reserva'),
              controller: longReservaController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Ingresar parametro en metros',
                  labelText: 'Latitud de la reserva'),
              controller: latitudController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Ingresar parametro en metros',
                  labelText: 'Longitud de la reserva'),
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
    String idReserva = idReservaController.text;
    String longNodoCentral = longNodoCentralController.text;
    String longReserva = longReservaController.text;
    final latitud = latitudController.text;
    final longitud = longitudController.text;
    print('idRuta: $rutaId');
    print('idVertice: $idReserva');
    print('longNodoCentral: $longNodoCentral');
    print('longVertices: $longReserva');
    print('latitud: $latitud');
    print('longitud: $longitud');

    if (idReserva.isNotEmpty ||
        longNodoCentral.isNotEmpty ||
        longReserva.isNotEmpty ||
        latitud.isNotEmpty ||
        longitud.isNotEmpty) {
      rutas
          .document(rutaId)
          .collection('reservas')
          .document(idReserva.toUpperCase())
          .setData({
        //idReserva.toUpperCase(): {
        'longNodoCentral': double.parse(longNodoCentral),
        'longReserva': double.parse(longReserva),
        'latitud': double.parse(latitud),
        'longitud': double.parse(longitud)
        //},
      });

      Fluttertoast.showToast(
          msg: 'El reserva fue guardada con exito!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 10,
          backgroundColor: Colors.grey);

      idReservaController.clear();
      longNodoCentralController.clear();
      longReservaController.clear();
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
