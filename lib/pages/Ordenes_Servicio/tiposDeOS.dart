import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CrearOS extends StatefulWidget {
  @override
  _CrearOSState createState() => _CrearOSState();
}

class _CrearOSState extends State<CrearOS> {
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

  static const menuOS = [
    'Mantenimiento Correctivo',
    'Instalacion de Servicio de Internet',
    'Adicion de Fibra Optica',
    'Retiro',
    'Soporte Tecnico',
  ];

  final List<DropdownMenuItem<String>> dropDownmenuOS = menuOS
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String osId = 'Adicion de Fibra Optica';

  String clienteId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Center(
           child: Text(
                'Crear Orden de Servicio',
                 style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey[400]
                  )
               
        ),
         ), 
        backgroundColor: Colors.white24,
        elevation: 0.0,
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle,size: 30.0, color: Colors.blue,),
              onPressed: (){},
            )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              ListTile(
                title: Column(
                  children: [
                    Text('Seleccione el tipo de orden de servicio:',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 50),
                    DropdownButton(
                      value: osId,
                      onChanged: (String newValue) {
                        setState(() {
                          osId = newValue;
                        });
                      },
                      items: this.dropDownmenuOS,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              botonCalcular()
            ],
          ),
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
          child: Text('Siguiente'),
          onPressed: () {
            //print('----------------------');

            if (osId.contains('Adicion de Fibra Optica')) {
              Navigator.pushNamed(context, 'DetallesOSadicionFibra');
            }
          },
        )
      ],
    );
  }
}
