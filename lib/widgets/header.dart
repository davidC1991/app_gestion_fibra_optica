import 'package:audicol_fiber/bloc/provider.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/mapaPostes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo/geo.dart';

titulo(String texto, Icon icon) {
     return ListTile(
     contentPadding: EdgeInsets.symmetric(horizontal: 0),  
     leading: icon,  
     title: Text(
              texto,
               style: TextStyle(
                        fontSize: 17.0,
                        //fontWeight: FontWeight.bold,
                       // color: colorText
                )
            ),

     );
   }

 mostrarCuadroOopciones(BuildContext context, FirebaseBloc firebaseBloc, Map<String, dynamic> materiales) {
       
        return showDialog(
          context: context,
          builder: (context)=>StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) { 
              return GestureDetector(
                onTap: (){
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: AlertDialog(
                titlePadding: EdgeInsets.all(15.0),  
                insetPadding: EdgeInsets.all(0.0),
                actionsPadding: EdgeInsets.all(0.0),
                contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),   
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Center(child: Text('Informe general')),
                content: Container(
                  //color: Colors.brown,
                  width: firebaseBloc.anchoPantallaController.value*0.6,
                  height: firebaseBloc.altoPantallaController.value*0.37,
                  child: ListView(
                    //itemExtent: 35.0,
                    //cacheExtent: 85.0,
                    children:[
                     subtitulo('Cantidad Postes',materiales['postesTotal']),
                     subtitulo('Fibra',materiales['fibraTotal'].toStringAsFixed(2)),
                     subtitulo('Reserva Total',materiales['reservaTotal']),
                     subtitulo('Fibra Total',(materiales['reservaTotal']+materiales['fibraTotal']).toStringAsFixed(2)),
                     subtitulo('Abrazaderas',materiales['abrazaderaTotal']),
                     subtitulo('Amortiguadores',materiales['amortiguadorTotal']),
                     subtitulo('Brazos Extensores',materiales['brazoExtensorTotal']),
                     subtitulo('Herrajes Retencion',materiales['herrajeRetencionTotal']),
                     subtitulo('Herrajes Suspension',materiales['herrajeSuspensionTotal']),
                     subtitulo('Coronas Coil',materiales['coronaCoilTotal']),
                     subtitulo('Marquillas',materiales['marquillasTotal']),
                      
                     
                                        
                   ]
                  ),  
                ),
                      
            actions: <Widget>[
                FlatButton(
                    child: Text('OK'),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
               
            ],  
            ),
              );
             },
             
          )
        );
      }

subtitulo(String encabezado, dynamic texto) {
  return Container(
       padding: EdgeInsets.all(3),
       child: encabezado=='Fibra'||encabezado=='Fibra Total'||encabezado=='Reserva Total'?
              Text('$encabezado: $texto metros'):
              Text('$encabezado: $texto'),
     );
}
   
Map<String, dynamic> calcularMateriales(FirebaseBloc firebaseBloc){
  List<DocumentSnapshot> datos=firebaseBloc.listaPostesOSController.value;
   List<LatLng> rutaFibra = List();
   double lat;
   double lng;
   LatLng coordenada;
   double fibraTotal=0.0,
          reserva=0.0,
          abrazadera=0.0,
          amortiguador=0.0,
          brazoExtensor=0.0,
          coronaCoil=0.0,
          herrajeRetencion=0.0,
          herrajeSuspension=0.0,
          marquillas=0.0;
    int  postes=0;     

  postes=datos.length;
  for (var i = 0; i < datos.length; i++) {
      if(datos[i].data['georeferenciacion']['latitud']!=''||datos[i].data['georeferenciacion']['longitud']!=''){
           lat=double.parse(datos[i].data['georeferenciacion']['latitud']);
           lng=double.parse(datos[i].data['georeferenciacion']['longitud']);
           coordenada = LatLng(lat, lng);
           rutaFibra.add(coordenada); 
      }
    }
   for (var i = 0; i < rutaFibra.length; i++) {
     if(i!=(rutaFibra.length-1)){
     fibraTotal=fibraTotal+computeDistanceBetween(rutaFibra[i], rutaFibra[i+1]); 
     }
   }

  for (var i = 0; i < datos.length; i++) {
      if(datos[i].data['cajaEmpalme']['reserva']!=''){
        reserva=reserva+double.parse(datos[i].data['cajaEmpalme']['reserva']);}
      if(datos[i].data['materiales']['amortiguador']!=''){
          amortiguador=amortiguador+double.parse(datos[i].data['materiales']['amortiguador']);}
      if(datos[i].data['materiales']['abrazaderaCollarin']!=''){    
          abrazadera=abrazadera+double.parse(datos[i].data['materiales']['abrazaderaCollarin']);}
      if(datos[i].data['materiales']['brazoExtensor']!=''){   
          brazoExtensor=brazoExtensor+double.parse(datos[i].data['materiales']['brazoExtensor']);}
      if(datos[i].data['materiales']['coronaCoil']!=''){   
          coronaCoil=coronaCoil+double.parse(datos[i].data['materiales']['coronaCoil']);}
      if(datos[i].data['materiales']['herrajeRetencion']!=''){    
          herrajeRetencion=herrajeRetencion+double.parse(datos[i].data['materiales']['herrajeRetencion']);}
      if(datos[i].data['materiales']['herrajeSupension']!=''){   
          herrajeSuspension=herrajeSuspension+double.parse(datos[i].data['materiales']['herrajeSupension']);}
      if(datos[i].data['materiales']['marquillas']!=''){    
          marquillas=marquillas+double.parse(datos[i].data['materiales']['marquillas']);}
       
      }

      return {'fibraTotal':fibraTotal,
              'reservaTotal':reserva,
              'abrazaderaTotal':abrazadera,
              'amortiguadorTotal':amortiguador,
              'brazoExtensorTotal':brazoExtensor,
              'herrajeRetencionTotal':herrajeRetencion,
              'coronaCoilTotal':coronaCoil,
              'marquillasTotal':marquillas,
              'postesTotal':postes,
              'herrajeSuspensionTotal':herrajeSuspension};
    } 

AppBar header(String titulo, BuildContext context, String icono){
  final firebaseBloc  = Provider.firebaseBloc(context);
  return AppBar(
     title: Center(child: Text(titulo,style: TextStyle(fontSize: 17.0,color: Colors.grey[600]))),  
     iconTheme: CupertinoIconThemeData(color: Theme.of(context).accentColor),
     //shadowColor: Colors.red,
     backgroundColor: Colors.white70,
     elevation: 0.0,
     actions: <Widget>[
         icono!=''?IconButton(
              icon: Icon(Icons.account_balance_wallet,size: 30.0, color: Theme.of(context).accentColor,),
              onPressed: (){
                print('info--');
                Map<String, dynamic> materiales= Map();
                if(icono=='mapa'){
                 materiales=calcularMateriales(firebaseBloc);
                 mostrarCuadroOopciones(context,firebaseBloc, materiales);
                }
              },
            ):Container(), 
            IconButton(
              icon: icono==''?Icon(Icons.account_circle,size: 30.0, color: Theme.of(context).accentColor,):
                              Icon(Icons.map,size: 30.0, color: Theme.of(context).accentColor,),
              onPressed: (){
                print('header--');
                if(icono=='mapa'){
                 
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> MapaPostes(listaPostes:firebaseBloc.listaPostesOSController.value)));
                }
              },
            ),
         
        ],
  );

   
}
               