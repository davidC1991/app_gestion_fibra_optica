import 'package:audicol_fiber/bloc/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetallesOrdenServicio extends StatefulWidget {
  @override
  _DetallesOrdenServicioState createState() => _DetallesOrdenServicioState();
}

class _DetallesOrdenServicioState extends State<DetallesOrdenServicio> {
  Color colorTextTitulo= Colors.grey[700];
  Color colorText= Colors.grey[500];

  @override
  Widget build(BuildContext context) {
    final widthPantalla = MediaQuery.of(context).size.width;

    return Scaffold(
      
       appBar: AppBar(
         title: Text(
           'Detalles',
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
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('GENERAL',style: TextStyle(color: colorTextTitulo, fontSize: 17, fontWeight: FontWeight.bold,)),
              ListTile(
              dense: true,  
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              leading: Text('Proyecto:',style: TextStyle(fontSize: 16.0,color: colorText)),  
              title: Text('Conectividad Wifi',style: TextStyle(fontSize: 16.0,color: colorText)),
             
            ),
             ListTile(
               dense: true,
               contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              leading: Text('Tipo:',style: TextStyle(fontSize: 16.0,color: colorText)),
              title: Text('Adición fibra',style: TextStyle(fontSize: 16.0,color: colorText)),
            ),
             ListTile(
               dense: true,
               contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              leading: Text('Numero de orden:',style: TextStyle(fontSize: 16.0,color: colorText)),
              title: Text('2',style: TextStyle(fontSize: 16.0,color: colorText)),
            ),
             ListTile(
               dense: true,
               contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              leading: Text('Prioridad:',style: TextStyle(fontSize: 16.0,color: colorText)),
              title: Text('Alta',style: TextStyle(fontSize: 16.0,color: colorText)),
            ),
           
            SizedBox(height: 8.0,),
            Text('REQUERIMIENTOS',style: TextStyle(color: colorTextTitulo, fontSize: 17, fontWeight: FontWeight.bold,)),
              ListTile(
              dense: true,  
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              leading: Text('Proyecto:',style: TextStyle(fontSize: 16.0,color: colorText)),  
              title: Text('Conectividad Wifi',style: TextStyle(fontSize: 16.0,color: colorText)),
             
            ),
             ListTile(
               dense: true,
               contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              leading: Text('Tipo:',style: TextStyle(fontSize: 16.0,color: colorText)),
              title: Text('Adición fibra',style: TextStyle(fontSize: 16.0,color: colorText)),
            ),
             ListTile(
               dense: true,
               contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              leading: Text('Numero de orden:',style: TextStyle(fontSize: 16.0,color: colorText)),
              title: Text('2',style: TextStyle(fontSize: 16.0,color: colorText)),
            ),
             ListTile(
               dense: true,
               contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              leading: Text('Prioridad:',style: TextStyle(fontSize: 16.0,color: colorText)),
              title: Text('Alta',style: TextStyle(fontSize: 16.0,color: colorText)),
            ),
            
          ],
        )),
    );
  }

  
}
              
       
               