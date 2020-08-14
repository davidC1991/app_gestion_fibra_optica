import 'package:flutter/material.dart';
import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';
import 'package:fluttertoast/fluttertoast.dart';


class RegistrarSangria extends StatefulWidget {
  @override
  _RegistrarSangriaState createState() => _RegistrarSangriaState();
}

class _RegistrarSangriaState extends State<RegistrarSangria> {
  DatosRedFibra datosRedFibra = DatosRedFibra();
  TextEditingController longNodoCentralController = TextEditingController();
  TextEditingController longVerticeDController = TextEditingController();
  TextEditingController latitudController = TextEditingController();
  TextEditingController longitudController = TextEditingController();
  //TextEditingController idRutaController = TextEditingController();
  TextEditingController idVerticeController = TextEditingController();
  List<String> clientes_aux = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCientes();
  }

  getCientes() async {
    List<String> cliente_db = await datosRedFibra.getCliente();
    //print(cliente_db[0].documentID);
    for (var i = 0; i < cliente_db.length; i++) {
      clientes_aux.add(cliente_db[i]);
    }
    print(clientes_aux);
  }

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

  static const menuSangria = [
    'sangria1',
    'sangria2',
    'sangria3',
    'sangria4',
    'sangria5',
    'sangria6',
    'sangria7',
    'sangria8',
    'sangria9',
    'sangria10',
    'sangria11',
    'sangria12',
    'sangria13',
    'sangria14',
    'sangria15',
    'sangria16',
    'sangria17',
    'sangria18',
    'sangria19',
    'sangria20',
    'sangria21',
    'sangria22',
    'sangria23'
  ];

  final List<DropdownMenuItem<String>> dropDownMenuRutas = menuRutas
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String rutaId = 'ruta1';

  final List<DropdownMenuItem<String>> dropDownMenuSangria = menuSangria
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String sangriaId = 'sangria1';

  String clienteId;

  @override
  Widget build(BuildContext context) {
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
                items: this.dropDownMenuRutas,
              ),
            ),
            SizedBox(height: 5),
            ListTile(
              title: Text('Seleccione la sangria:'),
              trailing: DropdownButton(
                value: sangriaId,
                onChanged: (String newValue) {
                  setState(() {
                    sangriaId = newValue;
                  });
                },
                items: this.dropDownMenuSangria,
              ),
            ),
            SizedBox(height: 5),
            ListTile(
              title: Text('Seleccione el cliente:'),
              trailing: DropdownButton(
                hint: Text('Nombre'),
                value: clienteId,
                onChanged: (String neValue) {
                  setState(() {
                    clienteId = neValue;
                  });
                },
                items: clientes_aux.map((String a) {
                  return new DropdownMenuItem<String>(
                      value: a, child: new Text(a));
                }).toList(),
              ),
            ),
            SizedBox(
              height: 20,
              child: Text('_______________________________________________'),
            ),
            SizedBox(height: 20),
            Text('Ingrese los datos de la Sangria'),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Tenga en cuenta el protocolo estandar',
                  labelText: 'ID del Vertice Drop'),
              controller: idVerticeController,
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
                  labelText: 'Longitud hacia el vertice izquierdo'),
              controller: longVerticeDController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Ingresar parametro en metros',
                  labelText: 'Latitud del vertice'),
              controller: latitudController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Ingresar parametro en metros',
                  labelText: 'Longitud del vertice'),
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
    String longVertice = longVerticeDController.text;
    final latitud = latitudController.text;
    final longitud = longitudController.text;
    print('idRuta: $rutaId');
    print('idVerticeDrop: $idVertice');
    print('longNodoCentral: $longNodoCentral');
    print('longVertice: $longVertice');
    print('latitud: $latitud');
    print('longitud: $longitud');
    print('clienteId: $clienteId');

    if (idVertice.isNotEmpty &&
        longNodoCentral.isNotEmpty &&
        longVertice.isNotEmpty &&
        latitud.isNotEmpty &&
        longitud.isNotEmpty &&
        clienteId != null) {
      rutas
          .document(rutaId)
          .collection('sangrias')
          .document(sangriaId)
          .collection(clienteId)
          .document(idVertice.toUpperCase())
          .setData({
        //idVertice.toUpperCase(): {
        'longNodoCentral': double.parse(longNodoCentral),
        'longVertices': double.parse(longVertice),
        'latitud': double.parse(latitud),
        'longitud': double.parse(longitud)
        //},
      });
      //GUARDAMOS LA SANGRIA AL CLIENTE QUE SELECCIONÓ EL USUARIO
      clientes.document(clienteId).updateData({'sangria': sangriaId});
      rutas
          .document(rutaId)
          .collection('sangrias')
          .document(sangriaId)
          .setData({'a': 'a'});
      Fluttertoast.showToast(
          msg: 'La sangria fue guardada con exito!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 10,
          backgroundColor: Colors.grey);

      idVerticeController.clear();
      longNodoCentralController.clear();
      longVerticeDController.clear();
      latitudController.clear();
      longitudController.clear();
    } else {
      if (clienteId == null) {
        Fluttertoast.showToast(
            msg: 'Seleccione un cliente!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 10,
            backgroundColor: Colors.grey);
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
}
