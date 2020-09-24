
import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:audicol_fiber/pages/selector_pantalla.dart';
import 'package:audicol_fiber/widgets/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';
import 'package:fluttertoast/fluttertoast.dart';


// ignore: must_be_immutable
class EstudioPrefactibilidad extends StatefulWidget {
  
 

  @override
  _EstudioPrefactibilidadState createState() => _EstudioPrefactibilidadState();
}

class _EstudioPrefactibilidadState extends State<EstudioPrefactibilidad> {
 
 
 TextEditingController idDiasController = TextEditingController();
 TextEditingController objetivoController = TextEditingController();
 int numeroOrdenServicio;
 
 List<String> listaContratistas= List();

 /* static const contratistas = [
    'Orlando xxxxxx',
    'Macias xxxxxx',
    'Gerson xxxxxx',
  ]; */

  static const proyectos = [
    'Audicol',
    'Conectividad Wifi',
  ];

  static const prioridad = [
    'Alta',
    'Media',
    'Baja',
  ];  

   static const zonas = [
    'Zona Norte 1',
    'Zona Norte 2',
    'Zona Norte 3',
    'Zona Norte 4',
    'Zona Este 1',
    'Zona Este 2',
    'Zona Este 3',
    'Zona Este 4',
    'Zona Oeste 1',
    'Zona Oeste 2',
    'Zona Oeste 3',
    'Zona Oeste 4',
    'Zona Sur 1',
    'Zona Sur 2',
    'Zona Sur 3',
    'Zona Sur 4',
    ]; 

  static const sitios = [
    'Santa Marta',
    'Cienaga',
    
  ]; 
  final List<DropdownMenuItem<String>> dropDownSitios = sitios
      .map((String value) => DropdownMenuItem<String>(
            value: value,
             child: Text(value, style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.grey[600]
            )),
          ))
      .toList();

  String sitioID = 'Santa Marta';

  final List<DropdownMenuItem<String>> dropDownZonas = zonas
      .map((String value) => DropdownMenuItem<String>(
            value: value,
             child: Text(value, style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.grey[600]
            )),
          ))
      .toList();

  String zonaID = 'Zona Norte 1';

  final List<DropdownMenuItem<String>> dropDownProyectos = proyectos
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  String proyectosID = 'Conectividad Wifi';

  /* final List<DropdownMenuItem<String>> dropDownMenuItems = listaContratistas
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList(); */

  String contratistasID = 'gerson';

   final List<DropdownMenuItem<String>> dropDownPrioridad = prioridad
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  String prioridadID = 'Media';

   static const rolesMenu = [
    'Jefe de cuadrilla',
    'Coordinador',
    'Contratista'
   ];

  final List<DropdownMenuItem<String>> dropDownMenuRoles = rolesMenu
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.grey[600]
            )),
          ))
      .toList();

  String roleId = 'Contratista';

   static const cuadrillasMenu = [
    '1',
    '2',
    '3',
    '4',
   ];

  final List<DropdownMenuItem<String>> dropDownMenuNumeroCuadrillas = cuadrillasMenu
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.grey[600]
            )),
          ))
      .toList();
  String numeroCuadrillaId = '1';

  DatosRedFibra datosRedFibra= DatosRedFibra();

  @override
  void initState() { 
    super.initState();
    getDatosUsuarios();
  }

  getDatosUsuarios( )async{
  listaContratistas= await datosRedFibra.getDatosTodosUsuario();
    
   //--OBTENEMOS LAS ORDENES DE SERVICIOS ASIGNADAS A ESTE USUARIO
   // print('---> $datos');
    setState(() {});
    
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar:  header('Formato de Prefactibilidad', context,''),
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
                titulo('Nombre del Proyecto'),
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
             
            elegirSitio(),
           
            proyectosID=='Conectividad Wifi'&& sitioID=='Santa Marta' ?elegirZonas():Container(),   
             
                        
          
           
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
            
           role(),
           roleId=='Jefe de cuadrilla'?numeroCuadrilla():Container(),
           roleId=='Contratista'?elegirContratista():Container(),
              
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
           
            TextFormField(
              keyboardType: TextInputType.text,
              maxLines: 5,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  filled: false,
                  hintText: 'Descripcion',
                  labelText: 'Objetivo del estudio de prefactibilidad'),
              controller: objetivoController,
            ),
            SizedBox(height: 20),
            
            botonCrear()
           
         
          ],
        ),
      ),
    );
  }

  Text titulo(String titulo) {
    return Text(
                titulo,
                 style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600]
              )
              );
  }

  ListTile elegirContratista() {
    return ListTile(
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
              items:  listaContratistas.map((String a) {
                  return new DropdownMenuItem<String>(
                      value: a, child: new Text(a));
                }).toList(),
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
   Widget role() {
    return  ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
             // leading: Icon(Icons.adjust,color:Colors.deepPurple),
              title: Text('Seleccione el cargo:',style: Theme.of(context).textTheme.headline1,),
              trailing: DropdownButton(
                value: roleId,
                onChanged: (String newValue) {
                  setState(() {
                    roleId = newValue;
                  });
                },
                items: this.dropDownMenuRoles,
              ),
            );
   }

   Widget elegirSitio() {
    return  ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
             // leading: Icon(Icons.adjust,color:Colors.deepPurple),
              title: Text('Seleccione el sitio:',style: Theme.of(context).textTheme.headline1,),
              trailing: DropdownButton(
                value: sitioID,
                onChanged: (String newValue) {
                  setState(() {
                    sitioID = newValue;
                  });
                },
                items: this.dropDownSitios,
              ),
            );
   }

  Widget elegirZonas() {
    return  ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
             // leading: Icon(Icons.adjust,color:Colors.deepPurple),
              title: Text('Seleccione la zona:',style: Theme.of(context).textTheme.headline1,),
              trailing: DropdownButton(
                value: zonaID,
                onChanged: (String newValue) {
                  setState(() {
                    zonaID = newValue;
                  });
                },
                items: this.dropDownZonas,
              ),
            );
   }
   Widget numeroCuadrilla() {
      return  ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
             // leading: Icon(Icons.format_list_numbered,color:Colors.deepPurple),
              title: Text('Numero de cuadrilla:',style: Theme.of(context).textTheme.headline1),
              trailing: DropdownButton(
                value: numeroCuadrillaId,
                onChanged: (String newValue) {
                  setState(() {
                    numeroCuadrillaId = newValue;
                  });
                },
                items: this.dropDownMenuNumeroCuadrillas,
              ),
            );
  } 

  void sendBaseDatos() async{
    //String idRuta = idRutaController.text;
    //String idReserva = proyectosID;
    String idOS ='';
    String tiempoEstimado = idDiasController.text;
    String objetivo = objetivoController.text;
  
    idOS= await datosRedFibra.getUltimoNumueroPrefactibilidad();
   // if(idOS!='00000'){
   
  
   // }
    Map<String, dynamic> datosOrdenWifiSantaMarta= new Map();
    Map<String, dynamic> datosOrdenWifiCienaga= new Map();
    Map<String, dynamic> datosOrdenAudicol= new Map();


    if (tiempoEstimado.isNotEmpty  || objetivo.isNotEmpty) {

      
     if(proyectosID=='Conectividad Wifi'&&sitioID=='Santa Marta'){
         datosOrdenWifiSantaMarta['nombreProyecto']=proyectosID;
         datosOrdenWifiSantaMarta['sitio']=sitioID;
         datosOrdenWifiSantaMarta['zona']=zonaID;
         datosOrdenWifiSantaMarta['cargo']=roleId;
         if(roleId =='Jefe de cuadrilla'){
          datosOrdenWifiSantaMarta['numeroCuadrilla']=numeroCuadrillaId;
         }
         if(roleId =='Contratista'){
          datosOrdenWifiSantaMarta['nombreContratista']=contratistasID;
         }
     }
     if(proyectosID=='Conectividad Wifi'&&sitioID=='Cienaga'){
         datosOrdenWifiCienaga['nombreProyecto']=proyectosID;
         datosOrdenWifiCienaga['sitio']=sitioID;
         datosOrdenWifiCienaga['cargo']=roleId;
         if(roleId =='Jefe de cuadrilla'){
          datosOrdenWifiCienaga['numeroCuadrilla']=numeroCuadrillaId;
         }
         if(roleId =='Contratista'){
          datosOrdenWifiCienaga['nombreContratista']=contratistasID;
         }
     }

     if(proyectosID=='Audicol'){
         datosOrdenAudicol['nombreProyecto']=proyectosID;
         datosOrdenAudicol['sitio']=sitioID;
         datosOrdenAudicol['cargo']=roleId;
         if(roleId =='Jefe de cuadrilla'){
          datosOrdenAudicol['numeroCuadrilla']=numeroCuadrillaId;
         }
         if(roleId =='Contratista'){
          datosOrdenAudicol['nombreContratista']=contratistasID;
         }
     }
    

 
      prefactibilidad
        .document(idOS)
        .setData({
        'orden'          : 'prefactibilidad',
        'proyecto'       : proyectosID,
        'NumeroOS'       : idOS,
        'datosOrden'     : proyectosID=='Conectividad Wifi'&&sitioID=='Cienaga'?datosOrdenWifiCienaga:
                           proyectosID=='Conectividad Wifi'&&sitioID=='Santa Marta'?datosOrdenWifiSantaMarta:
                           datosOrdenAudicol, 
        'tiempoEstimado' : tiempoEstimado,
        'objetivo'       : objetivo,
        'tipo'           : 'Adición de fibra óptica',
        'Estado'         : 'No iniciada',
        'Prioridad'      : prioridadID,
        'insumos'        : 'No solicitados',
        'timestamp'      : DateTime.now(),
        
      });
 
      Fluttertoast.showToast(
          msg: 'El estudio de prefactibilidad fue guardado con exito!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 13,
          backgroundColor: Colors.grey
      );

     
      idDiasController.clear();
      objetivoController.clear();
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: 'LLene todos los campos!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 13,
          backgroundColor: Colors.grey
      );
    }
  }
}