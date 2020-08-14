import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:audicol_fiber/bloc/dbBloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PantallaOrdenesServicio extends StatefulWidget {
  @override
  _PantallaOrdenesServicioState createState() => _PantallaOrdenesServicioState();
}

class _PantallaOrdenesServicioState extends State<PantallaOrdenesServicio> {


  DatosRedFibra datosRedFibra= DatosRedFibra();
  FirebaseBloc dbBloc = FirebaseBloc();

  @override
  Widget build(BuildContext context) {
    dbBloc.getOservicios();
    return Scaffold(
      body: StreamBuilder<List<DocumentSnapshot>>(
    stream: dbBloc.ordenServicioStream,
    builder: (context, snapshot){
      if(snapshot.hasData){
        
        print(snapshot.data[0].data);
        //return Container();
        return Container();
      }else{
        return Center(child:CircularProgressIndicator(),);
      }
    },
  )
  );
  }
}