

import 'package:flutter/material.dart';

class Menu extends StatelessWidget {


   final drawerHeader= UserAccountsDrawerHeader(
     
      accountName: Text('Jesus David Callejas C.', style: TextStyle(color:Colors.blue, fontWeight: FontWeight.bold, fontSize: 15.0  ),),
      accountEmail: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ingeniero Electrónico'),
          Text('CallejasDavid@audicol.com'),
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
  @override
  Widget build(BuildContext context) {
    return Drawer(
      
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
         drawerHeader,
         ListTile(
           leading: Icon(Icons.pages,color:Colors.blue),
           title: Text('Inventario'),
            onTap: (){ 
             Navigator.pop(context);
             Navigator.pushNamed(context, 'CrearProducto');
           },
         ),
         ListTile(
           leading: Icon(Icons.people,color:Colors.blue),
           title: Text('Usuarios'),
           onTap: (){},
         ),
         ListTile(
           leading: Icon(Icons.settings,color:Colors.blue),
           title: Text('OTDR'),
           onTap: (){ 
             Navigator.pop(context);
             Navigator.pushNamed(context, 'CalculoCoordenada');
           }
         ),
         ListTile(
           leading: Icon(Icons.account_balance_wallet,color:Colors.blue),
           title: Text('Agenda'),
           onTap: (){},
         ),
        ],
      ),
    );
  }
}
       
        
      