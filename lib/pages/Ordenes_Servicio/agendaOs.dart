import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:audicol_fiber/bloc/dbBloc.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/GestionOs.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/detallesOS.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PantallaOrdenesServicio extends StatefulWidget {
  @override
  _PantallaOrdenesServicioState createState() => _PantallaOrdenesServicioState();
}

class _PantallaOrdenesServicioState extends State<PantallaOrdenesServicio> {


  
  FirebaseBloc dbBloc = FirebaseBloc();
  
  Color colorText= Colors.grey[500];
  int cont_tarjetas=0;
  List<Color> coloresTarjetas=[
    Colors.blue.withOpacity(0.1),
   /*  Colors.blue.withOpacity(0.1),
    Colors.blue.withOpacity(0.1),
    Colors.blue.withOpacity(0.1), */
    Colors.purple.withOpacity(0.1),
    Colors.green.withOpacity(0.1),
    Colors.grey.withOpacity(0.1)
  ];

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
    dbBloc.getOservicios();
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
     body:  streamAgendaOrdenes()
  );
  }

  StreamBuilder<List<DocumentSnapshot>> streamAgendaOrdenes() {
    return StreamBuilder<List<DocumentSnapshot>>(
     stream: dbBloc.ordenServicioStream,
     builder: (context, snapshot){
    
    if(snapshot.hasData){
      List<DocumentSnapshot> datosOs=snapshot.data;
      //print(snapshot.data[0].data);
      //return Container();
      return ListView.builder(
        //physics: NeverScrollableScrollPhysics(),
        //shrinkWrap: true,
        itemCount: datosOs.length,
        itemBuilder: (context, i){
          return  _crearBotonRedondeado(Colors.blue, datosOs[i],context, i);
        }  
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
          
         

  Widget _crearBotonRedondeado(Color color,  DocumentSnapshot datoOs, BuildContext context, int i){
     //final widthPantalla = MediaQuery.of(context).size.width;
     cont_tarjetas++;
     if (cont_tarjetas==1){
       color=coloresTarjetas[0];
     }else if(cont_tarjetas==2){
       color=coloresTarjetas[1];
     }else if(cont_tarjetas==3){
       color=coloresTarjetas[2];
     }else if(cont_tarjetas==4){
       color=coloresTarjetas[3];
      cont_tarjetas=0;
     }
     String imagen; 
     if(datoOs.data['proyecto'].toString().contains('Conectividad Wifi')){
       imagen='assets/ordenCasa2.png';
       print(imagen);
       
     }else  if(datoOs.data['proyecto'].toString().contains('Audicol')){
      imagen='assets/cliente.png';
      print(imagen);
     }
    return tarjetas(color, datoOs, imagen, context);
  }

   tarjetas(Color color, DocumentSnapshot datoOs, String imagen, BuildContext context) {
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
                      PopupMenuButton<String>(
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
                      )
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
        
      

}
              
        
           
                       
                 