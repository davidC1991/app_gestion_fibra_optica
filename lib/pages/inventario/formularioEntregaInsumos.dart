
import 'package:audicol_fiber/bloc/provider.dart';
import 'package:audicol_fiber/search/search_delegateGos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EntregaInsumos extends StatefulWidget {
 
  @override
  _EntregaInsumosState createState() => _EntregaInsumosState();
}

class _EntregaInsumosState extends State<EntregaInsumos> {
  List<Widget> listWidgetItems= new List();
  List<DocumentSnapshot> listItems= new List();
  TextEditingController itemController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
   
  }
 

  @override
  Widget build(BuildContext context) {
      final firebaseBloc  = Provider.firebaseBloc(context);
      final anchoPantalla= MediaQuery.of(context).size.width;
      final altoPantalla= MediaQuery.of(context).size.height;
      listItems=firebaseBloc.itemsSeleccionadosController.value;
      if(listItems!=null){
      for (var i = 0; i < listItems.length; i++) {
        listWidgetItems.add(itemInsumo(listItems[i],anchoPantalla));
      }}

   

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
     body: Column(
       children: [
         Row(
           
           children: [
           Container(
             margin: EdgeInsets.only(left: anchoPantalla*0.04,top: 10),
             //padding: EdgeInsets.only(left: 30),
             child:Text('FOTO',style: TextStyle(color: Colors.grey[600],fontSize: 16,fontWeight: FontWeight.bold),),
             //color: Colors.red,
           ),
           Container(
             margin: EdgeInsets.only(left: anchoPantalla*0.2,top: 10),
             child:Text('ITEM',style: TextStyle(color: Colors.grey[600],fontSize: 16,fontWeight: FontWeight.bold)),
            // color: Colors.yellow,
           ),
           Container(
              margin: EdgeInsets.only(left: anchoPantalla*0.30,top: 10),
             child:Text('CANTIDAD',style: TextStyle(color: Colors.grey[600],fontSize: 16,fontWeight: FontWeight.bold)),
             //color: Colors.blue,
           )
         ],),
         ListView(
           shrinkWrap: true,
           children: listWidgetItems
         ),
       ],
     ), 
    );
  }

  itemInsumo(DocumentSnapshot item, double anchoPantalla) {
    
    
    return ListTile(
      contentPadding: EdgeInsets.only(top: 10.0,bottom: 5.0,right: 10.0, left: 10.0),
      leading: FadeInImage(
              image: NetworkImage(item['mediaUrl']),
              placeholder: AssetImage('assets/cargando.gif'),
              width: 50.0,
              fit: BoxFit.contain,
              ), 
      title: Row(
        children: [
          SizedBox(width:anchoPantalla*0.08),
          Text(item['nombreProducto']),
        ],
      ),
      trailing: Container(
        //color:Colors.blue,
        height: 30,
        width: 100,
         child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hoverColor:Colors.red,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                //filled: false,
               // hintText: 'Codigo de 4 digitos',
               // labelText: 'Codigo del producto'),
            ),
            controller: itemController,
           
        ),
      ) , 
    );
  }
}