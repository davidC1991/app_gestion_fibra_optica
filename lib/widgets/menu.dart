

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Menu extends StatelessWidget {
  Map<String,dynamic> datos;
  Menu({this.datos});

   
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      
      child: Column(
       /*  padding: EdgeInsets.zero,
        shrinkWrap: true, */
        children: [
         drawerHeader(),
         //-------------------------------------------
         datos['cargo']=='Coordinador'||datos['cargo']=='Jefe de inventario'?ListTile(
           leading: Icon(Icons.pages,color:Colors.blue),
           title: Text('Inventario'),
            onTap: (){ 
             Navigator.pop(context);
             Navigator.pushNamed(context, 'CrearProducto');
           },
         ):Container(),
         datos['cargo']=='Coordinador'?ListTile(
           leading: Icon(Icons.people,color:Colors.blue),
           title: Text('Usuarios'),
           onTap: (){
             Navigator.pop(context);
             Navigator.pushNamed(context, 'CrearUsuario');
           },
         ):Container(),
         datos['cargo']=='Coordinador'||datos['cargo']=='Jefe de cuadrilla'||datos['cargo']=='Contratista'?ListTile(
           leading: Icon(Icons.settings,color:Colors.blue),
           title: Text('OTDR'),
           onTap: (){ 
             Navigator.pop(context);
             Navigator.pushNamed(context, 'CalculoCoordenada');
           }
         ):Container(),
         ListTile(
           leading: Icon(Icons.account_balance_wallet,color:Colors.blue),
           title: Text('Agenda'),
           onTap: (){},
         ),
         datos['cargo']=='Coordinador'?ListTile(
           leading: Icon(Icons.accessibility,color:Colors.blue),
           title: Text('Crear Orden de Servicio'),
           onTap: (){
             Navigator.pop(context);
             Navigator.pushNamed(context, 'CrearOS');
           },
         ):Container(), 
         datos['cargo']=='Coordinador'?ListTile(
           leading: Icon(Icons.album,color:Colors.blue),
           title: Text('Crear Estudio de Prefactibilidad'),
           onTap: (){
             Navigator.pop(context);
             Navigator.pushNamed(context, 'CrearPrefactibilidad');
           },
         ):Container(), 
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.bottomLeft,
              //color: Colors.red,
              child: ListTile(
               leading: Text('Cerrar sesion'),
               onTap: (){
                 Navigator.of(context).pushNamedAndRemoveUntil('LoginPage', (Route<dynamic> route) => false);
               },
         ),
            ),
          ),
         
        ],
      ),
    );
  }
   drawerHeader( ){
     print(datos);
     return UserAccountsDrawerHeader(
     
      accountName: Text(datos['nombres']+' '+datos['apellidos'], style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0  ),),
      accountEmail: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(datos['cargo']),
          Text(datos['correo']),
        ],
      ),
      currentAccountPicture:Container(
        margin: EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        //padding: EdgeInsets.only(bottom: 40.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
             image: AssetImage('assets/audicol.PNG'),
             fit: BoxFit.cover 
          )
        ),      
      )
    );
   }

}
       
        
      