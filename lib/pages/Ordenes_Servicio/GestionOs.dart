import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:audicol_fiber/bloc/provider.dart';
import 'package:audicol_fiber/search/search_delegateGos.dart';


class GestionOrdenServicio extends StatefulWidget {
 
  String item;
  DocumentSnapshot datos;
  GestionOrdenServicio({this.item,this.datos});
  @override
  _GestionOrdenServicioState createState() => _GestionOrdenServicioState();
}

class _GestionOrdenServicioState extends State<GestionOrdenServicio> {

 DatosRedFibra datosRedFibra = DatosRedFibra();
 DocumentSnapshot datosItem;
 String item='---';
 @override
  void initState() {
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final firebaseBloc  = Provider.firebaseBloc(context);
    firebaseBloc.getItemsSeleccionados('carro');
    
    firebaseBloc.itemStream.listen((event) {
      print('sdkmsdlkss');
      item=event;
      print(item);
     /*  setState(() {
        
      }); */
    });

    print(firebaseBloc.itemsSeleccionadosController.value);

    return Scaffold(
       appBar: AppBar(
         title: Text(
           'Gestion',
            style: TextStyle(fontSize: 15.0,color: Colors.grey[600])
         ),  
               
         iconTheme: CupertinoIconThemeData(color: Colors.grey),
         shadowColor: Colors.red,
         backgroundColor: Colors.white70,
         elevation: 0.0,
         actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search,size: 30.0, color: Colors.blue,),
              onPressed: (){
                showSearch(context: context, delegate: DataSearch_OS());
              },
            )
        ],
      ),
      body:  Text(item),
    );
  }
}
            
        
      
       
               