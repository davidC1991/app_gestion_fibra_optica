import 'package:flutter/material.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';
import 'package:fluttertoast/fluttertoast.dart';


// ignore: must_be_immutable
class DetallesOSadicionFibra extends StatefulWidget {
  
 

  @override
  _DetallesOSadicionFibraState createState() => _DetallesOSadicionFibraState();
}

class _DetallesOSadicionFibraState extends State<DetallesOSadicionFibra> {
 
 TextEditingController idOSController = TextEditingController();
 TextEditingController idDiasController = TextEditingController();
 TextEditingController objetivoController = TextEditingController();

 

 static const contratistas = [
    'Orlando xxxxxx',
    'Macias xxxxxx',
    'Gerson xxxxxx',
  ];

  static const proyectos = [
    'Audicol',
    'Conectividad Wifi',
  ];  

  final List<DropdownMenuItem<String>> dropDownProyectos = proyectos
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  String proyectosID = 'Conectividad Wifi';

  final List<DropdownMenuItem<String>> dropDownMenuItems = contratistas
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  String contratistasID = 'Gerson xxxxxx';



  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      //appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Nombre del Proyecto',
                   style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600]
                )
                ),
                SizedBox(width: 30),
                DropdownButton(
                value: proyectosID,
                onChanged: (String newValue) {
                  setState(() {
                    proyectosID = newValue;
                  });
                },
                items: this.dropDownProyectos,
              ),  
              ],
            ),
            
            
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: '',
                  labelText: 'Numero de Orden de Servicio'),
              controller: idOSController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Ingresar parametro en dias',
                  labelText: 'Tiempo estimado de ejecución'),
              controller: idDiasController,
            ),
            SizedBox(height: 20),
             ListTile(
               contentPadding: EdgeInsets.symmetric(horizontal: 0),
              title: Text(
                'Contratista a asignar O.S.',
                style: TextStyle(
                        fontSize: 16.0,
                        //fontWeight: FontWeight.bold,
                        color: Colors.grey[600]
                )
              ),
              
              trailing: DropdownButton(
                value: contratistasID,
                onChanged: (String newValue) {
                  setState(() {
                    contratistasID = newValue;
                  });
                },
                items: this.dropDownMenuItems,
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              maxLines: 5,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: false,
                  hintText: 'Descripcion de la O.S.',
                  labelText: 'Objetivo de Orden de Servicio'),
              controller: objetivoController,
            ),
            SizedBox(height: 20),
            
            botonCrear()
           
         
          ],
        ),
      ),
    );
  }

  Widget botonCrear() {
    print('----------------------');

    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          color: Colors.blueAccent.withOpacity(0.5),
          elevation: 15,
          child: Text('Crear'),
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
    //String idReserva = proyectosID;
    String idOS = idOSController.text;
    String tiempoEstimado = idDiasController.text;
    String objetivo = objetivoController.text;
  

   
    if (tiempoEstimado.isNotEmpty || idOS.isNotEmpty || objetivo.isNotEmpty) {

      ordenesServicio
          .document(idOS)
          .setData({
        
        'proyecto':proyectosID,
        'NumeroOS': double.parse(idOS),
        'tiempoEstimado': double.parse(tiempoEstimado),
        'contratista': contratistasID,
        'objetivo' : objetivo
        
      });

      Fluttertoast.showToast(
          msg: 'La Orden de serivio fue guardada con exito!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 10,
          backgroundColor: Colors.grey);

      //idNombreProyecto.clear();
      idOSController.clear();
      idDiasController.clear();
      objetivoController.clear();
     // longitudController.clear();
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