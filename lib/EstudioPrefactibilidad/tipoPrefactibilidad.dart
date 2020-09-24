import 'package:audicol_fiber/widgets/header.dart';
import 'package:flutter/material.dart';

class CrearPrefactibilidad extends StatefulWidget {
  @override
  _CrearPrefactibilidadState createState() => _CrearPrefactibilidadState();
}

class _CrearPrefactibilidadState extends State<CrearPrefactibilidad> {
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
  }

  static const menuOS = [
    'Mantenimiento Correctivo',
    'Instalacion de Servicio de Internet',
    'Adicion de Fibra Optica',
    'Retiro',
    
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
      appBar: header('Crear Prefactibilidad', context,''),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              ListTile(
                title: Column(
                  children: [
                    Text('Seleccione el tipo de prefactibilidad:',style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,color: Colors.grey[600])),
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
 

    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
            color: Theme.of(context).buttonColor,
            elevation: 15,
            child: Text('Siguiente'),
            onPressed: () {
                if (osId.contains('Adicion de Fibra Optica')) {
                Navigator.pushNamed(context, 'EstudioPrefactibilidad');
              }
            },
          ),
        
      ],
    );
  }
}
