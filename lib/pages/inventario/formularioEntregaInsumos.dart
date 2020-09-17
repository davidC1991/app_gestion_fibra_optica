
import 'package:audicol_fiber/search/search_delegateGos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EntregaInsumos extends StatefulWidget {
  @override
  _EntregaInsumosState createState() => _EntregaInsumosState();
}

class _EntregaInsumosState extends State<EntregaInsumos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,
        iconTheme: CupertinoIconThemeData(color: Theme.of(context).accentColor),
        title: Text('Buscar insumo',
        style: TextStyle(fontSize: 20.0, color: Colors.grey)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch_OS());
            },
          ),
        ],
      ),
    );
  }
}