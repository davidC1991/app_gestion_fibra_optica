import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class GestionOrdenServicio extends StatefulWidget {
  @override
  _GestionOrdenServicioState createState() => _GestionOrdenServicioState();
}

class _GestionOrdenServicioState extends State<GestionOrdenServicio> {
 
 
  @override
  Widget build(BuildContext context) {
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
              icon: Icon(Icons.account_circle,size: 30.0, color: Colors.blue,),
              onPressed: (){},
            )
        ],
      ),
      body:  Text("THIRD TAB"),
    );
  }
}
            
        
      
       
               