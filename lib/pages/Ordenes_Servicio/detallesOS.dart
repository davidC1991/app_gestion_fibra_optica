import 'package:audicol_fiber/bloc/provider.dart';
import 'package:audicol_fiber/pages/selector_pantalla.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetallesOrdenServicio extends StatefulWidget {
  DocumentSnapshot dato1;
  
  DetallesOrdenServicio(this.dato1);
  @override
  _DetallesOrdenServicioState createState() => _DetallesOrdenServicioState();
}

class _DetallesOrdenServicioState extends State<DetallesOrdenServicio> {
  Color colorTextTitulo= Colors.grey[700];
  Color colorText= Colors.grey[500];
  String fecha;
  Map<String,dynamic> item=new Map();
  List<String> listaKey=new List();
  List<String> listaValue=new List();
  List<Map<String,dynamic>> listaCantidadesEntregadas=new List();
  List<Map<String,dynamic>> listaItemsNombres=new List();
  List<Map<String,dynamic>> listaItemsCantidad=new List();
  List<Map<String,dynamic>> listaEntregables=new List();
  
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fecha= DateTime.fromMillisecondsSinceEpoch(widget.dato1['timestamp'].seconds*1000,isUtc : false).toString();
  }
    
  
  

    
    
    
   
  @override
  Widget build(BuildContext context) {
   
    double anchoPantalla=MediaQuery.of(context).size.width;
    double altoPantalla=MediaQuery.of(context).size.height;
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
       // padding: EdgeInsets.only(top: 10, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titulo('GENERAL'),
              
              subTitulo('Catergoria de Orden',widget.dato1['orden']),
              subTitulo('Tipo de Orden',widget.dato1['tipo']),
              subTitulo('Estado',widget.dato1['Estado']),
              subTitulo('Prioridad',widget.dato1['Prioridad']),
              subTitulo('Insumos',widget.dato1['insumos']),
              subTitulo('Fecha de Creación',fecha ),
              titulo('REQUERIMIENTOS'),
              subTitulo('Sitio',widget.dato1['datosOrden']['sitio']),
              subTitulo('Tiempo Estimado',widget.dato1['tiempoEstimado']+' dias'),
              subTitulo('Nombre Proyecto',widget.dato1['datosOrden']['nombreProyecto']),
              widget.dato1['datosOrden']['nombreProyecto']=='Conectividad Wifi'?subTitulo('Zona',widget.dato1['datosOrden']['zona']):Container(),
              subTitulo('Cargo',widget.dato1['datosOrden']['cargo']),
              widget.dato1['datosOrden']['cargo']=='Contratista'?subTitulo('Nombre',widget.dato1['datosOrden']['nombreContratista']):Container(),
              widget.dato1['datosOrden']['cargo']=='Jefe de cuadrilla'?subTitulo('Numero de Cuadrilla',widget.dato1['datosOrden']['numeroCuadrilla']):Container(),
              subTitulo('Objetivo',widget.dato1['objetivo']),
              historialSolicitudesInsumos(anchoPantalla,true),
              //historialSolicitudesInsumos(anchoPantalla,false)


              
            ],
          ),
        )),
    );
  }

  StreamBuilder<QuerySnapshot> historialSolicitudesInsumos(double anchoPantalla,bool esEntregable) {
    return StreamBuilder<QuerySnapshot>(
              stream: prefactibilidad.document(widget.dato1['NumeroOS']).collection('insumos').snapshots(),
              builder: (context, AsyncSnapshot <QuerySnapshot>snapshot) {
                
                if(snapshot.hasData){
                   List<DocumentSnapshot> docs=snapshot.data.documents;
                    return ListView.builder(
                       physics: NeverScrollableScrollPhysics(),
                       shrinkWrap: true,
                       itemCount: docs.length,
                       itemBuilder: (context, j){
                         String tituloSolicitud=docs[j].data['id'];
                         item= snapshot.data.documents[j].data['materiales']; 
                          listaKey.clear();
                          listaValue.clear();
                          listaCantidadesEntregadas.clear();

                          item.forEach((key, value) { 
                           listaKey.add(key);
                           listaValue.add(value[0]);
                           listaCantidadesEntregadas.add({key:value[2]});
                           });
                       
                       List<String> entregables=new List(); 
                       listaCantidadesEntregadas.forEach((element) { 
                         element.forEach((key, value) { 
                           entregables.add(value);
                           });
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
                       // Map<String,List<String,List<String>>> mapReceptores=new Map();
                       //TENER EN CUENTA QUE NO HAY RECEPTORES CUANDO SE RECIEN CREA LA SOLICITUD DE INSUMOS 
                       //Y PUEDE QUE ESTE VACIO Y CAUSAR ERRORES
                       Map<String,dynamic> datos=docs[j].data;
                       List<Map<String,List<String>>> listaInsumosEntregdos= List();
                          datos.forEach((key, value) { 
                            String fecha='';
                            String nombreFecha='';
                           if(key.contains('Receptor')){
                            fecha=key.substring(9); 
                            
                            //print(key); 
                            //print(value);
                            value.forEach((key1,value1){
                              nombreFecha=key1+'|'+fecha;
                              value1.forEach((element){
                               // print(element.values.toList()[0][0]);
                               // print(element.values.toList()[0][1]);
                                //print(value1[0].values.toList()[0][2]);
                                listaInsumosEntregdos.add({nombreFecha:[element.values.toList()[0][0].toString(),
                                                                      element.values.toList()[0][1].toString(),
                                                                      element.values.toList()[0][2].toString(),
                                                                      element.keys.toString()
                                                                      ]});
                              });
                              
                              

                            }); 
                           }
                         }); 

                         return  Column(
                          children: [
                            titulo(docs[j].data['id']),
                            Container(
                              alignment: Alignment.center,
                              //color: Colors.purple,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  tituloTablaIsumos(anchoPantalla*0.11,'ITEM',Colors.red),
                                  tituloTablaIsumos(anchoPantalla*0.8,'E',Colors.blue), 
                                  tituloTablaIsumos(anchoPantalla*0.051,'S',Colors.yellow),
                                ],
                              ),
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: listaItemsNombres[j][tituloSolicitud].length,
                              itemBuilder: (context, i){
                                 if(esEntregable){ 
                                 return solicitudInsumos(listaInsumosEntregdos,listaEntregables[j][tituloSolicitud][i],listaItemsNombres[j][tituloSolicitud][i],listaItemsCantidad[j][tituloSolicitud][i],anchoPantalla,i,tituloSolicitud,j);
                                 }
                              }
              
                              ),
                           ],
                         ); 
                       });



                      

                }else{return Container();}
              });
  }


   Widget solicitudInsumos(List<Map<String,List<String>>> insumosEntregdos,String entregables,String nombre, String cantidad,double anchoPantalla, int i,String tituloSolicitud,int j) {
                return SingleChildScrollView(
                  child: materialesSolicitados( insumosEntregdos,entregables, i, nombre, anchoPantalla, cantidad, tituloSolicitud,j),
                    
                  );
              }
                

   Column materialesSolicitados(List<Map<String,List<String>>> insumosEntregdos,String entregables, int i, String nombre, double anchoPantalla, String cantidad, String tituloSolicitud,int j) {
                String nombreReceptor='';
                String fechaRecepcion='';
                String item='';
                String cantidadEntregada='';
                String mediaUrl='';
                String idOrden='';
                List<String> nombreYFecha=List(); 
                List<Widget> listWidget= List();
               // print(insumosEntregdos);
               insumosEntregdos.forEach((element) { 
                element.forEach((key, value) { 
                  nombreYFecha=key.split('|');
                  nombreReceptor=nombreYFecha[0];
                  fechaRecepcion=nombreYFecha[1];
                  item=value[0];
                  cantidadEntregada=value[1];
                  mediaUrl=value[2];
                  idOrden=value[3];
                  if(nombre==item&&idOrden.contains(tituloSolicitud)){
                    listWidget.add(itemHistorial(nombreReceptor,fechaRecepcion,cantidadEntregada,anchoPantalla,mediaUrl));
                  }
                });
                });
               return Column(
                      children: [
                        Divider(height: 25.0,color: Colors.black),
                        Container(
                               //color: insumosEntregados>=insumosSolicitados? Colors.grey[200]:Colors.white,
                               child:ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 0),
                               visualDensity: VisualDensity(vertical: 0.0, horizontal: 0.0),
                              // contentPadding: EdgeInsets.only(top: 0.0,bottom: 5.0,right: 10.0, left: 10.0),
                              
                               title:  Padding(
                                 padding: const EdgeInsets.only(top: 30),
                                 child: Container(child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(nombre[0].toUpperCase()+nombre.substring(1),style: TextStyle(color: Colors.grey[600],fontSize: 18,fontWeight: FontWeight.bold)),
                                     //Container(color: Colors.yellow,child: Text('ff')),
                                   ],
                                 )),
                               ),
                               subtitle: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: listWidget,
                               ),
                               trailing: Container(
                               alignment: Alignment.centerRight,
                                 //color: Colors.yellow,
                                 width: anchoPantalla*0.4,
                                 child: Container(
                                   //color: Colors.red,
                                   width: anchoPantalla*0.4,
                                   
                                   alignment: Alignment.centerRight,
                                   child: Container(
                                     //color: Colors.blue,
                                     
                                     //width:anchoPantalla*0.4,
                                    /*  width: firebaseBloc.anchoPantallaController.value*0.6,
                                     height: firebaseBloc.altoPantallaController.value*0.1, */
                                     child: Row(
                                     mainAxisAlignment: MainAxisAlignment.end,
                                     children: [
                                       SizedBox(width: anchoPantalla*0.03),
                                       Text(entregables,style: TextStyle(color:Colors.black,),),
                                       SizedBox(width: anchoPantalla*0.03),
                                       Text(cantidad,style: TextStyle(color: Colors.black,)),
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

 
                                       
                                       
                                      
  Container tituloTablaIsumos(double anchoPantalla,String text, Color color) {
    return Container(
             //margin: EdgeInsets.only(left: anchoPantalla,top: 10),
             alignment: Alignment.centerRight,
             width: anchoPantalla,
             //padding: EdgeInsets.only(left: 30),
             child:Text(text,style: TextStyle(color: Colors.grey[600],fontSize: 16,fontWeight: FontWeight.bold),),
            // color: color,
           );
      }    
   itemHistorial(String nombre, String fecha,String cantidad,double anchoPantalla,String mediaUrl){
     return Column(
       children: [
         Divider(),
         ListTile(
           contentPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0),
           visualDensity: VisualDensity(vertical: 0.0, horizontal: 0.0),
           title:Text(nombre),
           subtitle: Row(
             children: [
               Text(fecha),
                IconButton(
                 icon:Icon(Icons.album),
                 tooltip: 'Presione par ver el recibido',
                 onPressed: (){
                   showDialog<String>(
                     context: context,
                     builder: (BuildContext context)=> SimpleDialog(
                       contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 0),
                       titlePadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                       title: Text('Firma de recibido'),
                       children: [
                         Divider(),
                         Container(
                          height: MediaQuery.of(context).size.height*0.4,
                          width: MediaQuery.of(context).size.width*0.85,
                          decoration: BoxDecoration(
                                  color: Colors.white, 
                                  borderRadius: new BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: NetworkImage(mediaUrl),
                                    fit: BoxFit.contain,
                                  ),
                                 /*  boxShadow: [
                                    new BoxShadow(
                                      //SOMBRA
                                      color: Color(0xffA4A4A4),
                                      offset: Offset(1.0, 5.0),
                                      blurRadius: 3.0,
                                    ),
                                  ]), */
                          )
                        )
                       ],
                     )
                   );
                 },
                )
             ],
           ),
           trailing: Text(cantidad),
            /* trailing: Container(child: Row(
             children: [
               Text(cantidad),
              // Icon(Icons.album)
             ],
           )
           ),  */
         ),
       ],
     );
   }   

   titulo(String subTitulo) {
        
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
 
   subTitulo(String encabezado,String texto) {
     return Padding(
       padding: const EdgeInsets.only(left: 10),
       child: Container(
         padding: EdgeInsets.all(3),
         child: Text(
              '$encabezado: $texto',
              style: Theme.of(context).textTheme.headline1
         ),
       ),
     );
   }

}
              
       
               