import 'package:audicol_fiber/pages/selector_pantalla.dart';
import 'package:audicol_fiber/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  List<Widget> listaCampos= new List();
  List<bool> listaCheckBoxes= new List();
  @override
  Widget build(BuildContext context) {
    
    double anchoPantalla=MediaQuery.of(context).size.width;
    double altoPantalla=MediaQuery.of(context).size.height;
    print(widget.numeroOS);
    return Scaffold(
      appBar:header('Registro de Insumos',context,''),
      body:  StreamBuilder<QuerySnapshot>(
        stream: prefactibilidad.document(widget.numeroOS).collection('insumos').snapshots(),
        builder: (context, AsyncSnapshot <QuerySnapshot>snapshot) {
          print('--------------');
          List<DocumentSnapshot> docs=snapshot.data.documents;
         
          print(docs);
          return ListView.builder(
            //physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: docs.length,
            itemBuilder: (context, i){
            String insumosEstado=docs[i].data['insumos'];
            String tituloSolicitud=docs[i].data['id'];
            List<String> listaItemsNombres=new List();
            List<String> listaItemsCantidad=new List();
            
            Map<String,dynamic> item= snapshot.data.documents[i].data['materiales']; 
              item.forEach((key, value) { 
              listaItemsNombres.add(key);  
              listaItemsCantidad.add(value);
              if(!aux&&docs[i].data['insumos']!='Entregado'){listaCheckBoxes.add(false);}  
            }); 
            
            return  ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listaItemsNombres.length,
              itemBuilder: (context, i){
                
                 return solicitudInsumos(listaItemsNombres[i],listaItemsCantidad[i],anchoPantalla,i,insumosEstado,tituloSolicitud);
              }
            
             ); 
            }
          
           );
            
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
                );
              }
            
              Widget solicitudInsumos(String nombre, String cantidad, double anchoPantalla, int i,String insumos,String tituloSolicitud) {
                

              
                return GestureDetector(
                  onTap: () {
                    if(nombre.contains('router')){
                     aux=true;
                     listaCampos.clear();
                     listaController.clear();
                      for (var i = 0; i < int.parse(cantidad); i++) {
                          listaController.add(TextEditingController());
                          listaCampos.add(textForm(listaController[i],'Ingrese la mac del $nombre ${i+1}!'));
                         
                      }
                      print(listaCheckBoxes);
                      setState(() {});
                    }
                  },
                  
                  child: SingleChildScrollView(
                    child: materialesSolicitados(insumos, i, nombre, anchoPantalla, cantidad),
                      
                    ),
                  );
                
              }

              Column materialesSolicitados(String insumos, int i, String nombre, double anchoPantalla, String cantidad) {
                return Column(
                      children: [
                        Container(
                                
                               //color: Colors.blue,
                               child:ListTile(
                               contentPadding: EdgeInsets.only(top: 0.0,bottom: 5.0,right: 10.0, left: 10.0),
                               leading: Checkbox(
                                 tristate: insumos!='Entregado'?false:true,
                                 value: insumos!='Entregado'?listaCheckBoxes[i]:null,
                                 onChanged: insumos!='Entregado'?(bool value){
                                   setState(() {
                                     listaCheckBoxes[i]=value;
                                     aux=true;
                                   });
                                 }:null
                               ),
                               title: Text(nombre[0].toUpperCase()+nombre.substring(1)),
                               trailing: Container(
                               alignment: Alignment.center,
                                 //color: Colors.yellow,
                                 width: 80,
                                 child: nombre.contains('router')?Row(
                                   children: [
                                     Icon(Icons.control_point_duplicate),
                                     SizedBox(width: anchoPantalla*0.03), 
                                     Text(cantidad),
                                   ],
                                 ):Text(cantidad),
                               ),
                          ),
                        ),
                      
                        nombre.contains('router')?Container(
                          //color: Colors.brown,
                          width: 300,
                          child: Column(children:listaCampos),
                           ):Container()         
                      ],
                    );
              }

      textForm(TextEditingController controller, String label) {
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
                      
}