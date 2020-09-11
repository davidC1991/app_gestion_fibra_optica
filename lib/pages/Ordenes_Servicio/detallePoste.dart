import 'package:audicol_fiber/bloc/provider.dart';
import 'package:audicol_fiber/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetallesPoste extends StatefulWidget {
  DocumentSnapshot datos;
  DetallesPoste({@required this.datos});
  @override
  _DetallesPosteState createState() => _DetallesPosteState();
}

class _DetallesPosteState extends State<DetallesPoste> {
  Color colorTextTitulo= Colors.grey[700];
  Color colorText= Colors.grey[500];
  List valuesHilosEmpalme= new List();
  List keysHilosEmpalme= new List();
  
  Map<String,dynamic> mapHilos= new Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int contAux=0;  
    // if(widget.datos['cartaEmpalme'].length>0){
        mapHilos=widget.datos['cartaEmpalme'];
      
        mapHilos.keys.forEach((element) {
          keysHilosEmpalme[contAux]=element;
          contAux++;
       });
      /* contI=0;
       mapHilos.values.forEach((element) {
          valuesHilosEmpalme[contI]=element;
          contI++;
       });  */
    //} 
  }
  @override
  Widget build(BuildContext context) {
    
    final widthPantalla = MediaQuery.of(context).size.width;
   
    print(mapHilos);
    return Scaffold(
      
      appBar:header('Informacion del ${widget.datos['posteID']}',context,''),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              titulo('Georeferenciacion',Icon(Icons.golf_course, color: Colors.grey[600])),
              Divider(),
              subTitulo('Latitud',widget.datos['georeferenciacion']['latitud']),
              
              subTitulo('Longitud',widget.datos['georeferenciacion']['longitud']), 
              
              titulo('Caja de empalme',Icon(Icons.photo_library, color: Colors.grey[600])),
              Divider(),
              subTitulo('Intervalo de hilos',widget.datos['cajaEmpalme']['hilosIntervalo']),
             
              subTitulo('Id',widget.datos['cajaEmpalme']['idCajaEmpalme']),
              
              subTitulo('Reserva',widget.datos['cajaEmpalme']['reserva']),
              widget.datos['cartaEmpalme'].length>0?  Column(
                                                        children: [
                                                          titulo('Cartera de empalme',Icon(Icons.photo_library, color: Colors.grey[600]))  ,
                                                          ListView.builder(
                                                             shrinkWrap: true,
                                                             itemCount: widget.datos['cartaEmpalme'].length,
                                                             itemBuilder: (context, i){

                                                               return Container();//subTitulo(widget.datos['cartaEmpalme'][i].keys,widget.datos['cartaEmpalme'][i].value);
                                                             }    
                                                          )            
                                                        ],):Container(),
              SizedBox(height: 10,),
              Center(child:fotografiaEvidencia(context,widget.datos['mediaUrl']['mediaUrlCajaEmpalme'])),
              titulo('Abscisas',Icon(Icons.gesture, color: Colors.grey[600])),
              Divider(),
              subTitulo('Inicial',widget.datos['abscisas']['inicial']),
              
              subTitulo('Final',widget.datos['abscisas']['final']),
              
              titulo('Fibra',Icon(Icons.linear_scale, color: Colors.grey[600])),
              Divider(),
              subTitulo('Aerea',widget.datos['fibra']['aerea']?'Si':'No'),
              
              subTitulo('Canalizada',widget.datos['fibra']['canalizada']?'Si':'No'),
              
              subTitulo('Numero de hilos',widget.datos['fibra']['hilosCantidad']),
              
              subTitulo('Span',widget.datos['fibra']['span']),
              
              titulo('Materiales',Icon(Icons.linear_scale, color: Colors.grey[600])),
              Divider(),
              subTitulo('Herraje de retención',widget.datos['materiales']['herrajeRetencion']),
              
              subTitulo('Herraje de suspensión',widget.datos['materiales']['herrajeSupension']),
              
              subTitulo('Amortiguador',widget.datos['materiales']['amortiguador']),
              
              subTitulo('Brazo extensor',widget.datos['materiales']['brazoExtensor']),
              
              subTitulo('Corona coil',widget.datos['materiales']['coronaCoil']),
              
              subTitulo('Marquillas',widget.datos['materiales']['marquillas']),
              
              subTitulo('Abrazadera collarin',widget.datos['materiales']['abrazaderaCollarin']),
             
              titulo('Caracteristicas del poste',Icon(Icons.linear_scale, color: Colors.grey[600])),
              Divider(),
              subTitulo('Altura',widget.datos['caracteristicasPoste']['altura']),
              
              subTitulo('Estado',widget.datos['caracteristicasPoste']['estado']),
              
              subTitulo('Material',widget.datos['caracteristicasPoste']['material']),
              
              subTitulo('Rotura',widget.datos['caracteristicasPoste']['rotura']),
              
              subTitulo('Tipo',widget.datos['caracteristicasPoste']['tipo']),
              
              subTitulo('Voltaje',widget.datos['caracteristicasPoste']['voltaje']),
            
              titulo('Proveedor del poste',Icon(Icons.linear_scale, color: Colors.grey[600])),
              Divider(),
              subTitulo('Propietario',widget.datos['proveedorPoste']['propietario']),
              
              subTitulo('Id',widget.datos['proveedorPoste']['idPoste']),
              
              subTitulo('Observaciones',widget.datos['proveedorPoste']['observaciones']),
              Center(child:fotografiaEvidencia(context,widget.datos['mediaUrl']['mediaUrlPoste'])),
              //

            ],
          )),
      ),
    );
  }


 titulo(String texto, Icon icon) {
     return ListTile(
     contentPadding: EdgeInsets.symmetric(horizontal: 0),  
     leading: icon,  
     title: Text(
              texto,
               style: TextStyle(
                        fontSize: 17.0,
                        //fontWeight: FontWeight.bold,
                       // color: colorText
                )
            ),

     );
   }
subTitulo(String encabezado,String texto) {
     return Container(
       padding: EdgeInsets.all(3),
       child: Text(
            '$encabezado: $texto',
            style: Theme.of(context).textTheme.headline1
       ),
     );
   }

   fotografiaEvidencia(BuildContext context,String foto){
        return (foto == '')
          ? Container()
          : Container(
            height: MediaQuery.of(context).size.height*0.25,
            width: MediaQuery.of(context).size.width*0.95,
            decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: new BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage(foto),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      new BoxShadow(
                        //SOMBRA
                        color: Color(0xffA4A4A4),
                        offset: Offset(1.0, 5.0),
                        blurRadius: 3.0,
                      ),
                    ]),
          
          );
      }
}
        
        
        
        
        
       

        
        
              
       
               