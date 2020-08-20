import 'dart:ui';

import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
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


  DatosRedFibra datosRedFibra= DatosRedFibra();
  FirebaseBloc dbBloc = FirebaseBloc();
  Color colorText= Colors.grey[500];
  int cont_tarjetas=0;
  List<Color> coloresTarjetas=[
    Colors.blue.withOpacity(0.1),
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
            child: Text(value),
          ))
      .toList();

  @override
  void initState() {
    super.initState();
    
    
  }

  @override
  Widget build(BuildContext context) {
    dbBloc.getOservicios();
    return Scaffold(
      appBar: AppBar(
        /*  title: Center(
           child: Text(
                'Agenda de Trabajo',
                 style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey[400]
                  )
               
        ),
         ),  */
        backgroundColor: Colors.white24,
        elevation: 0.0,
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle,size: 30.0, color: Colors.blue,),
              onPressed: (){},
            )
        ],
      ),
      body: streamAgendaOrdenes()
  );
  }

  StreamBuilder<List<DocumentSnapshot>> streamAgendaOrdenes() {
    return StreamBuilder<List<DocumentSnapshot>>(
     stream: dbBloc.ordenServicioStream,
     builder: (context, snapshot){
    
    if(snapshot.hasData){
      List<DocumentSnapshot> datosOs=snapshot.data;
      print(snapshot.data[0].data);
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
      return Center(child:CircularProgressIndicator(),);
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
    return GestureDetector(
      onTap: (){
             
      },
      child: Container(
        //margin: EdgeInsets.only(left:20.0,right: 20.0,top: 10,bottom: 10),
        //color:Colors.blue.withOpacity(0.2),
       height: 430.0,
      width: 10.0,
      margin: EdgeInsets.only(left:20.0,right: 20.0,top: 10,bottom: 10),
      
       decoration: BoxDecoration(
         
       boxShadow: [
          BoxShadow(
            color: color,
            spreadRadius:3,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
       ],
        //color: Color.fromRGBO(62,66,107,0.7).withOpacity(0.2),
        //color: color,
        borderRadius: BorderRadius.circular(15.0)
       ), 
       child: Column(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         mainAxisSize: MainAxisSize.max,
         crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(),
            Text(
              'Orden de Servicio # ${datoOs.data['NumeroOS']}',
               style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: colorText
                )
            ),
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
              //height: 50,
              width: 300,
              //color: Colors.red,
              child: Text(
                'Objetivo: ${datoOs.data['objetivo']}',
                 style: TextStyle(
                        fontSize: 13.0,
                        color: colorText
                )
              ),
            ),
           Card(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
               shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
             child: ClipRRect(
               borderRadius: BorderRadius.circular(40),
               child: Image.asset(imagen),
                
             ),
           ),
           //
           Container(
             height: 35,
             width:355,
             //alignment: Alignment.centerRight,
             decoration: BoxDecoration(
              //color: Color.fromRGBO(62,66,107,0.7).withOpacity(0.2),
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(10),bottomRight:  Radius.circular(10)),
              
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
                              color: Colors.blue[600]
                      )
                  ),
                ),
                PopupMenuButton<String>(
                  elevation: 20.0,
                  icon: Icon(Icons.linear_scale,size: 30.0, color: Colors.blue[400],),
                  padding: EdgeInsets.only(right: 0),
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onSelected: (String newValue){
                  setState(() {
                    estadoId=newValue;
                    if(estadoId=='Iniciar'){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> GestionOrdenServicio()));
                       }
                  });
                  },
                  itemBuilder: (BuildContext context)=> popupMenuEstado
                )
              ],
            ),
           )

                   
             
         ],
       ),  
      ),
    );
  }
        
      

}