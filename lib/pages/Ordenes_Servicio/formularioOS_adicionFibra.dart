import 'package:flutter/cupertino.dart';
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

  static const prioridad = [
    'Alta',
    'Media',
    'Baja',
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

   final List<DropdownMenuItem<String>> dropDownPrioridad = prioridad
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  String prioridadID = 'Media';


  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
         iconTheme: CupertinoIconThemeData(color: Colors.grey),
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
                  
                  hint: Text(proyectosID),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  filled: false,
                  hintText: '',
                  labelText: 'Numero de Orden de Servicio'),
              controller: idOSController,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
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
                hint: Text(contratistasID),
                
                onChanged: (String newValue) {
                  setState(() {
                    contratistasID = newValue;
                  });
                },
                items: this.dropDownMenuItems,
              ),
            ),
             ListTile(
               contentPadding: EdgeInsets.symmetric(horizontal: 0),
              title: Text(
                'Prioridad',
                style: TextStyle(
                        fontSize: 16.0,
                        //fontWeight: FontWeight.bold,
                        color: Colors.grey[600]
                )
              ),
              
              trailing: DropdownButton(
                hint: Text(prioridadID),
                
                onChanged: (String newValue) {
                  setState(() {
                    prioridadID = newValue;
                  });
                },
                items: this.dropDownPrioridad,
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              maxLines: 5,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
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
        'objetivo' : objetivo,
        'tipo': 'Adición de fibra óptica',
        'Estado': 'No iniciada',
        'Prioridad': prioridadID
        
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