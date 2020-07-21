import 'package:flutter/material.dart';

import 'package:audicol_fiber/pages/calculo_punto.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrarCliente extends StatefulWidget {
  @override
  _RegistrarClienteState createState() => _RegistrarClienteState();
}

class _RegistrarClienteState extends State<RegistrarCliente> {
  TextEditingController nombreClienteController = TextEditingController();

  TextEditingController celularController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController hiloController = TextEditingController();

  TextEditingController rutaController = TextEditingController();

  TextEditingController fotoController = TextEditingController();

  TextEditingController tipoClienteController = TextEditingController();

  TextEditingController estadoController = TextEditingController();

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
    return Scaffold(
      //appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Text('Ingrese los datos del cliente'),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: '',
                  labelText: 'Nombre del cliente'),
              controller: nombreClienteController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: '',
                  labelText: 'Celular'),
              controller: celularController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: '',
                  labelText: 'Email'),
              controller: emailController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Verificar los registros de hilos',
                  labelText: 'Numero de hilo utilizado'),
              controller: hiloController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Copiar y pegar desde google',
                  labelText: 'Url de la foto del colegio'),
              controller: fotoController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Verificar los registros',
                  labelText: 'Ingrese las rutas del cliente'),
              controller: rutaController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Verificar los registros',
                  labelText: 'Tipo de cliente'),
              controller: tipoClienteController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Verificar los registros',
                  labelText: 'Estado del cliente'),
              controller: estadoController,
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
    String nombre = nombreClienteController.text;
    String celular = celularController.text;
    String email = emailController.text;
    String hilo = hiloController.text;
    String rutas = rutaController.text;
    String foto = fotoController.text;
    String tipoCliente = tipoClienteController.text;
    String estado = estadoController.text;
    print(rutas.split(','));

    if (nombre.isNotEmpty &&
        celular.isNotEmpty &&
        email.isNotEmpty &&
        hilo.isNotEmpty &&
        foto.isNotEmpty &&
        tipoCliente.isNotEmpty &&
        estado.isNotEmpty &&
        rutas.isNotEmpty) {
      clientes.document(nombre).setData({
        'activo': estado,
        'celular': celular,
        'email': email,
        'hilo': hilo,
        'rutas': rutas.split(','),
        'photoUrl': foto,
        'tipoCliente': tipoCliente,
        'nombre': nombre
      });
      Fluttertoast.showToast(
          msg: 'El cliente fue guardado con exito',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 10,
          backgroundColor: Colors.grey);

      nombreClienteController.clear();
      celularController.clear();
      emailController.clear();
      hiloController.clear();
      rutaController.clear();
      fotoController.clear();
      tipoClienteController.clear();
      estadoController.clear();
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
