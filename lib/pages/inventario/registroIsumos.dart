import 'package:audicol_fiber/bloc/provider.dart';
import 'package:audicol_fiber/pages/selector_pantalla.dart';
import 'package:audicol_fiber/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:slimy_card/slimy_card.dart';

class RegistroInsumos extends StatefulWidget {
  String numeroOS;
  RegistroInsumos({this.numeroOS});
  @override
  _RegistroInsumosState createState() => _RegistroInsumosState();
}

class _RegistroInsumosState extends State<RegistroInsumos> {
  bool aux=false; 
  List<TextEditingController> listaController=new List();
  List<Map<String,TextEditingController>> listaCampoCantidadController=new List();
  List<Map<String,TextEditingController>> listaCampoCantidadControllerFinal=new List();
  List<Widget> listaCampos= new List();
  List<bool> listaCheckBoxes= new List();
  Map <String,dynamic> mapCampos= new Map();
  Map <String,dynamic> mapCamposAnterior= new Map();
  String idSolicitud='';
  Map<String,dynamic> item=new Map();
  List<Map<String,dynamic>> listaMapaItems= List();
  Map<String,dynamic> mapItems= Map();
  List<Map<String,dynamic>> listaItemsNombres=new List();
  List<Map<String,dynamic>> listaItemsCantidad=new List();
  List<Map<String,dynamic>> listaEntregables=new List();
  List<Map<String,dynamic>> listaCantidadesEntregablesCopia=new List();
  List<bool> listaBool=new List();
  List<String> listaKey=new List();
  List<String> listaValue=new List();
  List<Map<String,dynamic>> listaCantidadesEntregadas=new List();

   
  @override
  Widget build(BuildContext context) {
     final firebaseBloc  = Provider.firebaseBloc(context);
    double anchoPantalla=MediaQuery.of(context).size.width;
    double altoPantalla=MediaQuery.of(context).size.height;
    print(widget.numeroOS);
    return Scaffold(
      appBar:header('Registro de Insumos',context,''),
      body:  StreamBuilder<QuerySnapshot>(
        stream: prefactibilidad.document(widget.numeroOS).collection('insumos').snapshots(),
        builder: (context, AsyncSnapshot <QuerySnapshot>snapshot) {
          print('--------------');
          if(snapshot.hasData){
          List<DocumentSnapshot> docs=snapshot.data.documents;
         
          //listaMapaItems.clear();
          print(docs);
          return ListView.builder(
            //physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: docs.length,
            itemBuilder: (context, j){
            String insumosEstado=docs[j].data['insumos'];
            String tituloSolicitud=docs[j].data['id'];
           
            item= snapshot.data.documents[j].data['materiales']; 
           // print(item);
            //firebaseBloc.ultimaRegistroInsumoController.sink.add(item);
           
         
           if(aux==false){
             // listaItemsNombres.clear();
             // listaItemsCantidad.clear();
              if(j==docs.length-1){
                aux=true;
               
                }
              listaKey.clear();
              listaValue.clear();
              listaBool.clear();
              listaCantidadesEntregadas.clear();
              //listaCampoCantidadController.clear();
              

              item.forEach((key, value) { 
                listaKey.add(key);
                listaValue.add(value[0]);
                listaBool.add(value[1]);
                listaCantidadesEntregadas.add({key:value[2]});
                listaCampoCantidadController.add({tituloSolicitud+'|'+key:TextEditingController()});
              });
               List<String> entregables=new List(); 
              listaCantidadesEntregadas.forEach((element) { 
                element.forEach((key, value) { 
                  listaCantidadesEntregablesCopia.add({tituloSolicitud+'|'+key:value});
                   entregables.add(value);
                });
                
              });
              
           
           
             List<bool> boleanos=new List();    
            listaBool.forEach((element) { 
              boleanos.add(element);
            });

            List<String> nombres=new List();    
            listaKey.forEach((element) { 
              nombres.add(element);
            });

            List<String> cantidades=new List();    
            listaValue.forEach((element) { 
              cantidades.add(element);
            });
            listaItemsNombres.add({tituloSolicitud:nombres});  
            listaEntregables.add({tituloSolicitud:entregables});
            listaItemsCantidad.add({tituloSolicitud:cantidades});
            listaMapaItems.add({tituloSolicitud:boleanos});
            print(listaItemsNombres);
            print(listaEntregables);
            print(listaMapaItems);
           
            
           }else{
            
              /* listaCampoCantidadController.clear();
              item.forEach((key, value) { 
                listaCampoCantidadController.add({tituloSolicitud+'|'+key:TextEditingController()});
              }); */
              
           }
            if(docs.length-1==j){
              idSolicitud=docs[j].data['id'];
            }
            
            return  Column(
              children: [
                subTitulos(docs[j].data['id']),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listaItemsNombres[j][tituloSolicitud].length,
                  itemBuilder: (context, i){
                    
                     return solicitudInsumos(listaEntregables[j][tituloSolicitud][i],listaItemsNombres[j][tituloSolicitud][i],listaItemsCantidad[j][tituloSolicitud][i],anchoPantalla,i,insumosEstado,tituloSolicitud,firebaseBloc,listaMapaItems[j][tituloSolicitud][i],j);
                  }
                
                 ),
              ],
            ); 
            }
          
           );
          }
            
                      /* return ListView(
                        children:[
                        SlimyCard(
                          color: Colors.grey,
                          width: anchoPantalla*0.8,
                          topCardHeight: altoPantalla*0.2,
                          bottomCardHeight: altoPantalla*0.6,
                          borderRadius: 15,
                          topCardWidget: Text('Arriba'),
                          bottomCardWidget: Text('Abajo'),
                          slimeEnabled: true,
                        ),
                        
                        ] 
                      ); */
                    }
                  ),
            floatingActionButton:RaisedButton(
            child: Text('Registrar',style: TextStyle(color: Colors.white),),
            onPressed: ()=>sendDatos(firebaseBloc)
          ),      
                );
              }
            
              Widget solicitudInsumos(String entregables,String nombre, String cantidad,double anchoPantalla, int i,String insumos,String tituloSolicitud,FirebaseBloc firebaseBloc, bool checkBox, int j) {
               // bool aux_1=false;

              
                return GestureDetector(
                  onTap: () {
                    if(nombre.contains('router')){
                     
                     aux=true;
                     firebaseBloc.itemNombreController.sink.add(nombre);
                     listaCampos.clear();
                     listaController.clear();
                     for (var i = 0; i < int.parse(cantidad); i++) {
                          listaController.add(TextEditingController());
                          listaCampos.add(textFormMac(listaController[i],'Ingrese la mac del $nombre ${i+1}!'));
                          mapCampos[nombre+(i+1).toString()+'|'+tituloSolicitud]=listaController[i];  
                         
                      }
                      print(listaCheckBoxes);
                      mostrarCuadroOopciones(context, firebaseBloc);
                     // setState(() {});
                    }
                  },
                  
                  child: SingleChildScrollView(
                    child: materialesSolicitados(entregables,insumos, i, nombre, anchoPantalla, cantidad,firebaseBloc, checkBox,tituloSolicitud,j),
                      
                    ),
                  );
                
              }

              Column materialesSolicitados(String entregables,String insumos, int i, String nombre, double anchoPantalla, String cantidad, FirebaseBloc firebaseBloc,bool checkBox, String tituloSolicitud,int j) {
                // print(listaCampoCantidadController);
                 List<String> varCamposCantidades= new List();
                 TextEditingController controller;
                 listaCampoCantidadController.forEach((element) {
                  Map <String,TextEditingController>a= element;
                  element.forEach((key, value) { 
                   // print('$key--${value.text}');
                     varCamposCantidades=key.toString().substring(0,key.toString().length).split('|');
                     if(varCamposCantidades[0]==tituloSolicitud&&varCamposCantidades[1]==nombre){
                       controller=value;
                      }
                      
                  });
                  
                  
                  
                  });
                return Column(
                      children: [
                        
                        Container(
                                
                               //color: Colors.blue,
                               child:ListTile(
                               contentPadding: EdgeInsets.only(top: 0.0,bottom: 5.0,right: 10.0, left: 10.0),
                               leading: Checkbox(
                                /*  tristate: insumos!='Preparados'?false:true,
                                 value: insumos!='Preparados'?listaCheckBoxes[i]:null,
                                 onChanged: insumos!='Preparados'?(bool value){ */
                                //tristate: insumos!='Preparados'?false:true,
                                 value: checkBox,  //no puede ser el contador i
                                 onChanged: (bool dato){
                                   aux=true;
                                   setState(() {
                                    // mapItems.update(tituloSolicitud, (value) => null)
                                    List listBool=new List();
                                  
                                  
                                    
                                   
                                    for (var n = 0; n < listaMapaItems[j][tituloSolicitud].length; n++) {
                                      if(n==i){
                                         listBool.add(dato);
                                       }else{
                                       listBool.add(listaMapaItems[j][tituloSolicitud][n]);
                                       }
                                    }

                                     
                                     
                                     listaMapaItems[j]={tituloSolicitud:listBool};
                                     print(listaMapaItems);
                                     //listaCheckBoxes[i]=dato;
                                     //aux=true;
                                   });
                                 }
                               ),
                               title:  Container(child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text(nombre[0].toUpperCase()+nombre.substring(1)),
                                   //Container(color: Colors.yellow,child: Text('ff')),
                                 ],
                               )),
                                 
                                
                               
                               trailing: Container(
                               alignment: Alignment.center,
                                 //color: Colors.yellow,
                                 width: anchoPantalla*0.4,
                                 child: nombre.contains('router')?Container(
                                   //color:Colors.blue,
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.end,
                                     children: [
                                       Icon(Icons.control_point_duplicate),
                                       SizedBox(width: anchoPantalla*0.03),
                                       textForm(controller,'',firebaseBloc,),
                                     
                                       Text(entregables), 
                                       SizedBox(width: anchoPantalla*0.03),
                                       Text(cantidad),
                                     ],
                                   ),
                                 ):Container(
                                   alignment: Alignment.center,
                                   width: anchoPantalla*0.4,
                                   child: Container(
                                     //color: Colors.blue,
                                     
                                     //width:anchoPantalla*0.4,
                                    /*  width: firebaseBloc.anchoPantallaController.value*0.6,
                                     height: firebaseBloc.altoPantallaController.value*0.1, */
                                     child: Row(
                                     mainAxisAlignment: MainAxisAlignment.end,
                                     children: [
                                       
                                       SizedBox(width: anchoPantalla*0.03),
                                       
                                       textForm(controller,'',firebaseBloc,),
                                       Text(entregables),
                                       SizedBox(width: anchoPantalla*0.03),
                                       Text(cantidad),
                                       SizedBox(width: anchoPantalla*0.02),
                                     ],
                                   )),
                                 ),
                                   
                               ),
                          ),
                        ),
                      
                               
                      ],
                    );
              }

      textFormMac(TextEditingController controller, String label) {
        return Padding(
                     padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                      keyboardType:TextInputType.text,
                      decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      filled: false,
                      hintText: label,
                      labelText: label
                      ),
                      controller: controller,
                      ),
        );
      }

      textForm(TextEditingController controller, String label, FirebaseBloc firebaseBloc) {
        return Padding(
                     padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: firebaseBloc.anchoPantallaController.value*0.095,
                        height: firebaseBloc.altoPantallaController.value*0.04,
                        child: TextFormField(
                        keyboardType:TextInputType.number,
                        decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5), 
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        filled: false,
                        hintText: label,
                        labelText: label
                        ),
                        controller: controller,
                        ),
                      ),
        );
      }

    sendDatos(firebaseBloc){
      /* print(listaItemsNombres);
      print(listaItemsNombres[0].keys);
      print(listaItemsCantidad);
      print(listaMapaItems);
    */
      listaCantidadesEntregablesCopia.forEach((element) {
        element.forEach((key, value) {
          print('$key--$value');
         });
       });   


      List<Map<String,dynamic>> materialesRegistrados=new List();
      List<List<dynamic>> materialesIndividuales=new List();
      Map<String,dynamic> detallesRegistrados=new Map();
     // final item=firebaseBloc.ultimaRegistroInsumoController.value;
       
       //print(item);
       List<dynamic> listValues=new List();
       List<dynamic> listCantidad=new List();
       List<dynamic> listBooleanos=new List();
       for (var i = 0; i < listaItemsNombres.length; i++) {
         listValues.clear();
         listBooleanos.clear();
         listCantidad.clear();
         listValues=listaItemsNombres[i].values.toList();
         listBooleanos=listaMapaItems[i].values.toList();
         listCantidad=listaItemsCantidad[i].values.toList();
         materialesIndividuales.clear();
         for (var g = 0; g < listValues[0].length; g++) {
         /*  print(listValues[0][g]);
          print(listCantidad[0][g]);
          print(listBooleanos[0][g]); */
          materialesIndividuales.add([listValues[0][g],listCantidad[0][g],listBooleanos[0][g]]);
         }
         //print(materialesIndividuales);
          List<dynamic> lista=new List();
         materialesIndividuales.forEach((element) { 
          lista.add(element);
         });
         String idFecha=listaItemsNombres[i].keys.toString();
         idFecha=idFecha.substring(1,idFecha.length-1);
         materialesRegistrados.add({idFecha:lista});
       }
          
        
          
      
        //print(materialesRegistrados); 
        //print(materialesRegistrados[0].keys.toString()); 
        //print( materialesRegistrados[0].values.toList());   
           
        mapCampos.forEach((key, value) { 
         print('$key-->${value.text}');
         detallesRegistrados[key]=value.text;
        });    
        //print(detallesRegistrados);    
        //print('id->$idSolicitud');
       List<dynamic>listAux= new List();
     for (var i = 0; i < materialesRegistrados.length; i++){  


        String idFecha1=materialesRegistrados[i].keys.toString();
        idFecha1=idFecha1.substring(1,idFecha1.length-1);
        Map<String,dynamic> detalles= new Map();   
        detallesRegistrados.forEach((key, value) { 
          List<String> varAux=key.split('|');

          if(key.contains(idFecha1)){
            detalles[varAux[0]]=value;
          }
        });
        List<String> varCamposCantidades=new List();
        Map<String,dynamic> mapAux= new Map();
        String valor='';
        listaCampoCantidadController.forEach((element) { 
         
         element.forEach((key, value) { 
           
           varCamposCantidades=key.toString().substring(0,key.toString().length).split('|');
          if(varCamposCantidades[0]==idFecha1){ 
           if(value.text.isEmpty){
              listaCantidadesEntregablesCopia.forEach((element) { 
                element.forEach((key, value) { 
                  List<String> lisAux2=new List();
                  lisAux2=key.toString().split('|');
                  if(lisAux2[0]==idFecha1&&lisAux2[1]==varCamposCantidades[1]){
                    valor=value;
                  }
                });
              });
               
           }else{
             valor=value.text;
           }
           mapAux[varCamposCantidades[1]]=valor;
          }
          });

        });
        
        Map<String,List<dynamic>> listaMap=new Map();
        
        //print(materialesRegistrados[i].values.toList()[0]);
       
        listAux=materialesRegistrados[i].values.toList()[0];
        
        //print(listAux[0][0]);
        for (var n = 0; n <  listAux.length; n++) {
          
          listaMap[listAux[n][0]]=[listAux[n][1],listAux[n][2],mapAux[listAux[n][0]]];
        } 
       
         
       if(detalles.isNotEmpty){ 
        String detallesEtiqueta='detalles|${DateTime.now().day}|${DateTime.now().month}|${DateTime.now().hour}|${DateTime.now().minute}';    
       prefactibilidad.
        document(widget.numeroOS).
        collection('insumos').
        document(idFecha1).
          updateData({
            'insumos'         : 'Preparados-'+ DateTime.now().day.toString() +'|'+  DateTime.now().month.toString()+'|'+  DateTime.now().hour.toString(),
            'timestamp'       : DateTime.now(),
            'materiales'      : listaMap,
            detallesEtiqueta  : detalles
          });   
      }else{
         prefactibilidad.
        document(widget.numeroOS).
        collection('insumos').
        document(idFecha1).
          updateData({
            'insumos'         : 'Preparados-'+ DateTime.now().day.toString() +'|'+  DateTime.now().month.toString()+'|'+  DateTime.now().hour.toString()+'|'+DateTime.now().minute.toString(),
            'timestamp'       : DateTime.now(),
            'materiales'      : listaMap,
           
          });   
      }
         prefactibilidad
            .document(widget.numeroOS)
            .updateData({
            'insumos': 'Preparados-'+ DateTime.now().day.toString() +'|'+  DateTime.now().month.toString()+'|'+  DateTime.now().hour.toString(),
            'Estado' : 'Iniciado'
            });       
 
        
      }  
      mensajePantalla('Insumos registrados exitosamente!');
      //aux=false;
      Navigator.pop(context);
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
    subTitulos(String subTitulo) {
        
        return Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          elevation: 8.0,
          child: ListTile(
                   contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 0),
                   visualDensity: VisualDensity(vertical: 0.0, horizontal: 0.0),
                   dense: true,
                   title: Center(
                     child: Text(
                             subTitulo,
                             style: TextStyle(
                                     fontSize: 16.0,
                                     fontWeight: FontWeight.bold,
                                     //color: Colors.grey[600]
                                     color: Colors.white
                             )
                  ),
                   ),
                ),
            );
          }
                  
        mostrarCuadroOopciones(BuildContext context, FirebaseBloc firebaseBloc) {
      
        return showDialog(
          context: context,
          builder: (context)=>StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) { 
              return GestureDetector(
                onTap: (){
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: AlertDialog(
                titlePadding: EdgeInsets.all(15.0),  
                insetPadding: EdgeInsets.all(0.0),
                actionsPadding: EdgeInsets.all(0.0),
                contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),   
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Center(child: Text('Ingrese la informacion!')),
                content: Container(
                  //color: Colors.brown,
                  width: firebaseBloc.anchoPantallaController.value*0.75,
                  height: firebaseBloc.altoPantallaController.value*0.55,
                  child: ListView(
                    //itemExtent: 35.0,
                    //cacheExtent: 85.0,
                    children:[
                       //---INGRESANDO 'geo' se activa la opcion de toma de coordenadas por el celular---------------
                       Divider(),
                       Container(
                          //color: Colors.brown,
                          width: 300,
                          child: Column(children:listaCampos),
                           )
                   ]
                  ),  
                ),
                      
            actions: <Widget>[
                FlatButton(
                    child: Text('Cancelar'),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                FlatButton(
                    child:Text('Guardar'),
                    onPressed: (){
                    
                   // setState(() { });
                    Navigator.pop(context);
                    },
                  ),  
            ],  
            ),
              );
             },
             
          )
        );
      }           
                                            
                   

}