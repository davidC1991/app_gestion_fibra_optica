import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar header(String titulo, BuildContext context){
  return AppBar(
     title: Text(titulo,style: TextStyle(fontSize: 15.0,color: Colors.grey[600])),  
     iconTheme: CupertinoIconThemeData(color: Theme.of(context).accentColor),
     //shadowColor: Colors.red,
     //backgroundColor: Colors.white70,
     elevation: 0.0,
     actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle,size: 30.0, color: Theme.of(context).accentColor,),
              onPressed: (){},
            )
        ],
  );
}
               