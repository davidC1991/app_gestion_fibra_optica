
import 'package:audicol_fiber/bloc/provider.dart';
import 'package:audicol_fiber/pages/selector_pantalla.dart';
import 'package:audicol_fiber/search/search_delegateGos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class EntregaInsumos extends StatefulWidget {
  
  DocumentSnapshot item;
  
  EntregaInsumos({this.item});
  @override
  _EntregaInsumosState createState() => _EntregaInsumosState();
}

class _EntregaInsumosState extends State<EntregaInsumos> {
  List<Widget> listWidgetItems= new List();
  List<DocumentSnapshot> listItems= new List();
  List<TextEditingController> listTextEditingController= new List();
  FirebaseBloc bloc=FirebaseBloc();
  DocumentSnapshot datoItem=null;
  String solicitudInsumoId= Uuid().v4();

  TextEditingController itemController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
   super.initState();
   datoItem=widget.item;
  
   
  }
 
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  } 

  @override
  Widget build(BuildContext context) {
      final firebaseBloc  = Provider.firebaseBloc(context);
      final anchoPantalla= MediaQuery.of(context).size.width;
      final altoPantalla= MediaQuery.of(context).size.height;
      
     
      if(datoItem!=null){
       //listItems.add(datoItem);
       if(firebaseBloc.itemsSeleccionadosController.value!=null){
          for (var i = 0; i < firebaseBloc.itemsSeleccionadosController.value.length; i++) {
                listItems.add(firebaseBloc.itemsSeleccionadosController.value[i]);
                listTextEditingController.add(TextEditingController());
          }} 
       
       int contItemRepetido=0;
       for (var i = 0; i < listItems.length; i++) {
         if(datoItem.data['nombreProducto']==listItems[i].data['nombreProducto']){
           
           mensajePantalla('ya tiene este item en la lista!');
           contItemRepetido=1;
           break;
         }
        
       }
       if(contItemRepetido==0){ 
       listItems.add(datoItem);  
       firebaseBloc.itemsSeleccionadosController.sink.add(listItems);
       listTextEditingController.add(TextEditingController());
       }
       datoItem=null; 
       
      }   

   

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
     body: SingleChildScrollView(
       child: Column(
         children: [
           Row(
             
             children: [
             tituloTablaIsumos( anchoPantalla*0.04,'FOTO'),
             tituloTablaIsumos( anchoPantalla*0.2,'ITEM'),
             tituloTablaIsumos( anchoPantalla*0.30,'CANTIDAD'),
             
           ],),
            listItems.isNotEmpty?ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: listItems.length,
            itemBuilder: (context, i){
            
            return  itemInsumo(listItems[i],anchoPantalla,listTextEditingController[i], i);
          }  
          ):Container(),
           /* ListView(
           shrinkWrap: true,
           physics: NeverScrollableScrollPhysics(),
           children: listWidgetItems
          )  */
                      
           
         ],
       ),
     ), 
     floatingActionButton:RaisedButton(
            child: Text('Guardar',style: TextStyle(color: Colors.white),),
            onPressed: ()=>sendDatos(firebaseBloc)
          ),
    );
  }

  Container tituloTablaIsumos(double anchoPantalla,String text) {
    return Container(
             margin: EdgeInsets.only(left: anchoPantalla,top: 10),
             //padding: EdgeInsets.only(left: 30),
             child:Text(text,style: TextStyle(color: Colors.grey[600],fontSize: 16,fontWeight: FontWeight.bold),),
             //color: Colors.red,
           );
  }

  itemInsumo(DocumentSnapshot item, double anchoPantalla, TextEditingController controller, int i) {
    
    String itemKey=item['nombreProducto']+(i*3).toString();
   // print(itemKey);
    return Dismissible(
      key: Key(itemKey),
      onDismissed: (DismissDirection dir){
        listTextEditingController.removeAt(i);
        listItems.removeAt(i);
        setState(() {});
      },
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      child: ListTile(
        contentPadding: EdgeInsets.only(top: 10.0,bottom: 5.0,right: 10.0, left: 10.0),
        leading: FadeInImage(
                image: NetworkImage(item['mediaUrl']),
                placeholder: AssetImage('assets/cargando.gif'),
                width: 50.0,
                fit: BoxFit.contain,
                ), 
        title: Row(
          children: [
            //SizedBox(width:anchoPantalla*0.08),
            Text(item['nombreProducto']),
          ],
        ),
        subtitle:  Text(item['descripcionProducto']),
        trailing: Container(
         // color:Colors.blue,
          alignment: Alignment.center,
          height: 70,
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
              controller: controller,
             
          ),
        ) , 
      ),
    );
  }
  sendDatos(FirebaseBloc firebaseBloc){
    bool camposVacios=false;
    for (var i = 0; i < listTextEditingController.length; i++) {
        if(listTextEditingController[i].text.isEmpty){
          camposVacios=true;
          break;
        }
    }
    if(!camposVacios){
    Map<String,dynamic> materiales= Map();
    for (var i = 0; i < listItems.length; i++) {
       materiales[listItems[i].data['nombreProducto']]=listTextEditingController[i].text;
    }
    
    String solicitudInsumoN='insumo-'+ DateTime.now().toString();
    String numeroOs=firebaseBloc.numeroOrdenServicioController.value;
    print(solicitudInsumoN);
    print(numeroOs);
    
    prefactibilidad.
      document(numeroOs).
      collection('insumos').
      document(solicitudInsumoN).
        setData({
          'materiales'      : materiales,
          'timestamp'       : DateTime.now(),
          'id'              : solicitudInsumoN,
          'ordenServicioId' : numeroOs
        }); 
       
       
       prefactibilidad
            .document(numeroOs)
            .updateData({
            'insumos': 'En espera-'+ DateTime.now().day.toString() +  DateTime.now().month.toString(),
            'Estado' : 'Iniciado'
            }); 
       
       
        listItems.clear();
        listTextEditingController.clear();
        firebaseBloc.itemsSeleccionadosController.sink.add(null);
        mensajePantalla('Solicitud de insumos registrada!');
        Navigator.pop(context);
        }else{
          mensajePantalla('Ingrese las cantidades de todos los items!');
        }
        // firebaseBloc.itemsSeleccionadosController.sink.add(null);
      }
          
           void mensajePantalla(String mensaje) {
           Fluttertoast.showToast(
                  msg: mensaje,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  fontSize: 15,
                  backgroundColor: Colors.grey
            );  
         }
       
          
        }
        
       