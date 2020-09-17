import 'dart:async';
import 'dart:ui';
import 'package:audicol_fiber/bloc/provider.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';
import 'package:audicol_fiber/pages/inventario/formularioEntregaInsumos.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//import 'package:audicol_fiber/bloc/dbBloc.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/GestionOs.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/detallesOS.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PantallaOrdenesServicio extends StatefulWidget {
  @override
  _PantallaOrdenesServicioState createState() => _PantallaOrdenesServicioState();
}

class _PantallaOrdenesServicioState extends State<PantallaOrdenesServicio> {


  
  //FirebaseBloc dbBloc = FirebaseBloc();
  
  Color colorText= Colors.grey[500];
  int cont_tarjetas=0;
  List<Color> coloresTarjetas=[
    Colors.blue.withOpacity(0.1),
   /*  Colors.blue.withOpacity(0.1),
    Colors.blue.withOpacity(0.1),
    Colors.blue.withOpacity(0.1), */
    //Colors.purple.withOpacity(0.1),
    //Colors.green.withOpacity(0.1),
    Colors.grey.withOpacity(0.1)
  ];
  static const estadosInsumos = [
    'Entregado 10%',
    'Entregado 30%',
    'Entregado 50%',
    'Entregado 70%',
    'Entregado 90%',
    'Entregado 100%',
    'Bodega',
  ];

   final List<PopupMenuItem<String>> popupMenuEstadoInsumos = estadosInsumos
      .map((String value) => PopupMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ))
      .toList();
  String estadoInsumoID='Bodega';
  static const estadoOs = [
    'Iniciar',
    'Pausar',
    'Continuar',
  ];
  String estadoId='';

  final List<PopupMenuItem<String>> popupMenuEstado = estadoOs
      .map((String value) => PopupMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ))
      .toList();

  @override
  void initState() {
    super.initState();
   // dbBloc.getOservicios();
    
  }

  @override
  Widget build(BuildContext context) {
     final firebaseBloc  = Provider.firebaseBloc(context);
     firebaseBloc.getOservicios();
    return Scaffold(
     body:  streamAgendaOrdenes(firebaseBloc)
  );
  }

  StreamBuilder<List<DocumentSnapshot>> streamAgendaOrdenes(FirebaseBloc firebaseBloc) {
    return StreamBuilder<List<DocumentSnapshot>>(
     stream: firebaseBloc.ordenServicioStream,
     builder: (context, snapshot){
    
    if(snapshot.hasData){
      List<DocumentSnapshot> datosOs=snapshot.data;
      //print(snapshot.data[0].data);
      //return Container();
      return RefreshIndicator(
        onRefresh: actualizar,
        child: ListView.builder(
          //physics: NeverScrollableScrollPhysics(),
          //shrinkWrap: true,
          itemCount: datosOs.length,
          itemBuilder: (context, i){
            return  _crearBotonRedondeado(Colors.blue, datosOs[i],context, i,firebaseBloc);
          }  
        ),
      );
    }else{
      return SpinKitRotatingCircle(
            color: Colors.blue,
            size: 50.0,
      );
      //Center(child:CircularProgressIndicator(),);
    }
  },
);
  }
          
  Future<Null> actualizar()async{
    final duration= new Duration(seconds: 2);
    new Timer(duration,(){
      setState(() {  });
    });
    return Future.delayed(duration);
  }       

  Widget _crearBotonRedondeado(Color color,  DocumentSnapshot datoOs, BuildContext context, int i, FirebaseBloc firebaseBloc){
     //final widthPantalla = MediaQuery.of(context).size.width;
    
     cont_tarjetas++;
     if (cont_tarjetas==1){
       color=coloresTarjetas[0];
     }else if(cont_tarjetas==2){
       color=coloresTarjetas[1];
       cont_tarjetas=0;
     }/* else if(cont_tarjetas==3){
       color=coloresTarjetas[2];
     }else if(cont_tarjetas==4){
       color=coloresTarjetas[3];
      cont_tarjetas=0;
     } */
     String imagen; 
     if(datoOs.data['proyecto'].toString().contains('Conectividad Wifi')){
       imagen='assets/ordenCasa2.png';
       //print(imagen);
       
     }else  if(datoOs.data['proyecto'].toString().contains('Audicol')){
      imagen='assets/cliente.png';
      //print(imagen);
     }
    return tarjetas(color, datoOs, imagen, context, firebaseBloc);
  }

   tarjetas(Color color, DocumentSnapshot datoOs, String imagen, BuildContext context, FirebaseBloc firebaseBloc) {
     String cargo=firebaseBloc.datosUsuarioController.value['cargo'];
    final widthPantalla = MediaQuery.of(context).size.width;
    final heightPantalla = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
            alignment: Alignment.center, 
            height: heightPantalla*0.3,
            width: widthPantalla,
            margin: EdgeInsets.only(left:20.0,right: 20.0,top: 10,bottom: 10),
             decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: <BoxShadow>[
                          BoxShadow(
                          color: Colors.white,
                          blurRadius: 1.0,
                          offset: Offset(2.0, 2.0),
                          spreadRadius: 1.0
                          ),
                       ]  
             ), 
             child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 8,),
                  Text(
                    'Orden de Servicio # ${datoOs.data['NumeroOS']}',
                     style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: colorText
                      )
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 20,
                    width: 300,
                    //color: Colors.red,
                    child: Text(
                      'Proyecto: ${datoOs.data['proyecto']}',
                       style: TextStyle(
                              fontSize: 13.0,
                              color: colorText
                      )
                    ),
                  ), 
                   Container(
                    height: 20,
                    width: 300,
                    //color: Colors.red,
                    child: Text(
                      'Tipo: ${datoOs.data['tipo']}',
                       style: TextStyle(
                              fontSize: 13.0,
                              color: colorText
                      )
                    ),
                  ), 
                  
                   Container(
                    height: 20,
                    width: 300,
                    //color: Colors.red,
                    child: Text(
                      'Estado: ${datoOs.data['Estado']}',
                       style: TextStyle(
                              fontSize: 13.0,
                              color: colorText
                      )
                    ),
                  ), 
                   Container(
                    height: 20,
                    width: 300,
                    //color: Colors.red,
                    child: Text(
                      'Prioridad: ${datoOs.data['Prioridad']}',
                       style: TextStyle(
                              fontSize: 13.0,
                              color: colorText
                      )
                    ),
                  ), 
                 Container(
                    height: 20,
                    width: 300,
                    //color: Colors.red,
                    
                    child: Text(
                      'Insumos: ${datoOs.data['insumos']}',
                       style: TextStyle(
                       fontSize: 13.0,
                       color: colorText
                      )
                    ),
                  ), 
                   Container(
                    height: 20,
                    width: 300,
                    //color: Colors.red,
                    child: datoOs.data['datosOrden']['cargo']=='Jefe de cuadrilla'?Text(
                      'Cargo: ${datoOs.data['datosOrden']['cargo']} ${datoOs.data['datosOrden']['numeroCuadrilla']}',
                       style: TextStyle(
                       fontSize: 13.0,
                       color: colorText
                      )
                    ):Text(
                      'Cargo: ${datoOs.data['datosOrden']['cargo']}',
                       style: TextStyle(
                       fontSize: 13.0,
                       color: colorText
                      )
                    ),
                  ), 
                   Container(
                    height: 20,
                    width: 300,
                    //color: Colors.red,
                    child: datoOs.data['datosOrden']['cargo']=='Contratista'?Text(
                      'Nombre: ${datoOs.data['datosOrden']['nombreContratista']}',
                       style: TextStyle(
                       fontSize: 13.0,
                       color: colorText
                      )
                    ):Text(''),
                  ), 
                  SizedBox(height: 0),
                /*  ClipRRect(
                     borderRadius: BorderRadius.circular(10),
                     child: Container(
                       alignment: Alignment.topCenter,
                       //color: Colors.blue,
                       height: heightPantalla*0.19,
                       width:widthPantalla*0.7835,
                       child: Image.asset(imagen)
                     ),
                 ),     */                 
                 
                 SizedBox(height: 4),
                 Container(
                   height: heightPantalla*0.04,
                   width:widthPantalla*0.9,
                   //alignment: Alignment.centerRight,
                   decoration: BoxDecoration(
                    //color: Color.fromRGBO(62,66,107,0.7).withOpacity(0.2),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(10),bottomRight:  Radius.circular(10)),
                       boxShadow: <BoxShadow>[
                          BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5.0,
                          offset: Offset(2.0, 2.0),
                          spreadRadius: 1.0
                          ),
                       ] 
                   ), 
                    
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 50,),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DetallesOrdenServicio()));
                        },
                        child: Text(
                          'Leer mas',
                          style: TextStyle(
                                    fontSize: 15.0,
                                    color: Theme.of(context).accentColor,
                            )
                        ),
                      ),
                      cargo=='Jefe de inventario'?insumosOpciones(datoOs.data['NumeroOS']):popupMenuButtonOrdenesServicio(context, datoOs)
                    ],
                  ),
                 ),
               ],
             ),  
            ),
            Divider()
      ],
    );
  }

   PopupMenuButton<String> popupMenuButtonOrdenesServicio(BuildContext context, DocumentSnapshot datoOs) {
     return PopupMenuButton<String>(
                      elevation: 85.0,
                      icon: Icon(Icons.linear_scale,size: 30.0, color:Theme.of(context).accentColor),
                      padding: EdgeInsets.only(right: 0),
                       shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onSelected: (String newValue){
                      setState(() {
                        estadoId=newValue;
                        if(estadoId=='Iniciar'){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=> GestionOrdenServicio(numeroOrdenS:datoOs.data['NumeroOS'], estado:datoOs.data['Estado'])));
                           }
                      });
                      },
                      itemBuilder: (BuildContext context)=> popupMenuEstado
                    );
   }
   updateEstadoInsumo(String numeroOS){
     ordenesServicio
          .document(numeroOS)
          .updateData({
            'insumos': estadoInsumoID,
              
          });
   }         

  insumosOpciones(String numeroOS){
    return   PopupMenuButton<String>(
             elevation: 85.0,
             icon: Icon(Icons.linear_scale,size: 30.0, color:Theme.of(context).accentColor),
             padding: EdgeInsets.only(right: 0),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(10.0),
             ),
             onSelected: (String newValue){
             setState(() {
               estadoInsumoID=newValue;
               //updateEstadoInsumo(numeroOS);
               Navigator.push(context, MaterialPageRoute(builder: (context)=> EntregaInsumos()));
                           
             });
             },
             itemBuilder: (BuildContext context)=> popupMenuEstadoInsumos
           );
  }
                            

                    
                               
        
      

}
              
        
           
                       
                 