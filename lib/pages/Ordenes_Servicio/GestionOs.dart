import 'dart:io';

import 'package:audicol_fiber/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audicol_fiber/bloc/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audicol_fiber/clases/tomarFoto.dart';


class GestionOrdenServicio extends StatefulWidget {
 
  
  @override
  _GestionOrdenServicioState createState() => _GestionOrdenServicioState();
}

class _GestionOrdenServicioState extends State<GestionOrdenServicio> {
 TextEditingController latitudController = TextEditingController();
 TextEditingController longitudController = TextEditingController();
 TextEditingController abscisaInicialController = TextEditingController();
 TextEditingController abscisaFinalController = TextEditingController();
 TextEditingController cajaEmpalmeController = TextEditingController();
 TextEditingController spanController = TextEditingController();
 TextEditingController cantidadHilosController = TextEditingController();
 TextEditingController intervaloHilosController = TextEditingController();
 
 
 DocumentSnapshot datosItem;
 bool gestionando=false;
 File file;
 bool isUploading= false;
 bool checkBoxAerea= false;
 bool checkBoxCanalizada= false;
 final picker = ImagePicker();



  TomarFoto takePhoto=  TomarFoto();

  static const opciones = [
    'Poste',
    'Fibra',
    'Cliente'
  ];
   static const alturaPostes = [
    '8',
    '9',
    '10',
    '12',
    '14'
  ];
   static const resistenciaPostes = [
    '510',
    '750',
    '1050',
    '1350',
  ];
   static const tipoPostes = [
    'Tipo "i"',
    'Tipo "H"',
    'Torrecilla',
    'Torres',
  ];
  static const materialPostes = [
    'Madera',
    'Metalico',
    'Concreto',
  ];  
  static const estadoPostes = [
    'Bueno',
    'Malo',
  ];  
  static const lineaTransmisionPostes = [
    '110V',
    '220V',
    '13,2KV'
  ];  

 final List<DropdownMenuItem<String>> dropDownLineaTransmisionPostes = lineaTransmisionPostes
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String lineaTransmisionPosteID='220V';

 final List<DropdownMenuItem<String>> dropDownProyectos = opciones
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String opcionesID='Poste';

  final List<DropdownMenuItem<String>> dropDownAlturaPostes = alturaPostes
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String alturaPostesID='9';

   final List<DropdownMenuItem<String>> dropDownResistenciaPostes = resistenciaPostes
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String resistenciaPostesID='510';

   final List<DropdownMenuItem<String>> dropDownTipoPostes = tipoPostes
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String tipoPosteID='Tipo "i"';

  final List<DropdownMenuItem<String>> dropDownMaterialPostes = materialPostes
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String materialPosteID='Concreto';

    final List<DropdownMenuItem<String>> dropDownEstadoPostes = estadoPostes
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String estadoPostesID='Bueno';


 @override
  void initState() {
    
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    final anchoPantalla = MediaQuery.of(context).size.width;
    final altoPantalla = MediaQuery.of(context).size.height;
    final firebaseBloc  = Provider.firebaseBloc(context);

    inicializarVariablesBloc(firebaseBloc,altoPantalla,anchoPantalla);
       
       
        
       
        return Scaffold(
          appBar: header('Gestion',context),
          body: ListView(
            itemExtent: 50,
            shrinkWrap: true,
            children: [
              DropdownButton(
                  hint: Text(opcionesID),
                  onChanged: (String newValue) {
                  setState(() {
                    opcionesID = newValue;
                  });
                },
                items: this.dropDownProyectos,
              ),  
              Container(
                width: 30,
                height: 100,
                color: Colors.brown,
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: ()=>mostrarCuadroOopciones(context,firebaseBloc)
          ),
        );
      }
    
      mostrarCuadroOopciones(BuildContext context, FirebaseBloc firebaseBloc) {
        String tituloCuadro='Registrando datos';
        int cont_aux=0;
       
    
        print('opcionsId:$opcionesID');
        print('cont_aux:$cont_aux');
        print('File:$file');
    
        return showDialog(
          context: context,
          builder: (context)=>StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) { 
              return AlertDialog(
              titlePadding: EdgeInsets.all(15.0),  
              insetPadding: EdgeInsets.all(0.0),
              actionsPadding: EdgeInsets.all(0.0),
              contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),   
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: cont_aux==0?Center(child: Text('Cartera de información fisica de la red de fibra optica Zona 1')):Text('Registre los siguientes datos'),
              content: Container(
                //color: Colors.brown,
                width: firebaseBloc.anchoPantallaController.value*0.9,
                height: firebaseBloc.altoPantallaController.value*0.8,
                child: ListView(
                  //itemExtent: 35.0,
                  //cacheExtent: 85.0,
                  children:[
                    
                    /*  Visibility(
                       visible: cont_aux==0?true:false,
                       child: DropdownButton(
                        hint: Text(opcionesID),
                        onChanged: (String newValue) {
                        setState(() {
                          opcionesID = newValue;
                        });
                      },
                        items: this.dropDownProyectos,
                      ),
                     ), */
                     Divider(),
                     subTitulos('Georefenciación',Icon(Icons.golf_course, color: Colors.white), false, firebaseBloc),
                     textFormDoble('Latitud', latitudController, 'Longitud', longitudController),
                     Divider(color: Colors.black, height: 15.0),
                     subTitulos('Abscisas', Icon(Icons.gesture, color: Colors.white), false, firebaseBloc),
                     textFormDoble('Inicial', abscisaInicialController, 'Final', abscisaFinalController),
                     Divider(color: Colors.black, height: 15.0),
                     subTitulos('Identificacion de Fotografia',Icon(Icons.photo_library, color: Colors.white), true, firebaseBloc),
                     textFormDoble('Id caja de empalme', cajaEmpalmeController, 'Intervalo de Hilos', intervaloHilosController),
                     textForm(longitudController, 'Reserva (Metros)'), 
                     SizedBox(height: 10,),
                     fotografiaEvidencia(context),
                     Divider(color: Colors.black, height: 15.0),
                     subTitulos('Fibra Optica',Icon(Icons.linear_scale, color: Colors.white), false, firebaseBloc),
                     textFormDoble('Span', spanController, 'Cantidad de Hilos', cantidadHilosController),
                     checkBoxDoble('Aerea:',checkBoxAerea, firebaseBloc.checkBoxAereaController,  'Canalizada', checkBoxCanalizada, firebaseBloc.checkBoxCanalizadaController),
                     Divider(),
                     subTitulos('Caracteristica poste',Icon(Icons.linear_scale, color: Colors.white), false, firebaseBloc), 
                     SizedBox(height: 20,),
                     dropDownBottomDoble('Altura:',  alturaPostesID, firebaseBloc.alturaPostesIDController, dropDownAlturaPostes, '         Rotura:', firebaseBloc.resistenciaPostesIDController, resistenciaPostesID, dropDownResistenciaPostes,firebaseBloc),
                     Divider(),
                     dropDownBottomDoble('Tipo:', tipoPosteID, firebaseBloc.tipoPosteIDController, dropDownTipoPostes, 'Material:', firebaseBloc.materialPosteIDController, materialPosteID, dropDownMaterialPostes,firebaseBloc),
                     Divider(),
                     dropDownBottomDoble('Voltaje:', lineaTransmisionPosteID, firebaseBloc.lineaTransmisionPosteIdController, dropDownLineaTransmisionPostes, 'Estado:', firebaseBloc.estadoPostesIDController, estadoPostesID, dropDownEstadoPostes,firebaseBloc),
    
                     
                    
                     
                     
                    
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
                  child: Text('Siguiente'),
                  onPressed: (){
    
                  if(opcionesID=='Poste') cont_aux=1;
                  if(opcionesID=='Fibra') cont_aux=2;
                  if(opcionesID=='Cliente') cont_aux=3;
     
                  print(cont_aux);
                  print(firebaseBloc.alturaPostesIDController.value);
                  print(firebaseBloc.resistenciaPostesIDController.value);
                  print(firebaseBloc.tipoPosteIDController.value);
                  print(firebaseBloc.materialPosteIDController.value);
                  print(firebaseBloc.lineaTransmisionPosteIdController.value);
                  print(firebaseBloc.estadoPostesIDController.value);
                  print(firebaseBloc.checkBoxAereaController.value);
                  print(firebaseBloc.checkBoxCanalizadaController.value);
                  setState(() { });
                  },
                ),  
            ],  
            );
             },
             
          )
        );
      }
    
       checkBoxDoble(String texto1, bool checkBox1, final controllerBloc1, String texto2, bool checkBox2, final controllerBloc2) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
             return Container(
                       padding: EdgeInsets.all(0),
                       //color: Colors.red,
                       width: 20,
                       height: 20,
                       child: Row(
                         
                         children: [
                           SizedBox(width: 4),
                           Text(texto1, style: TextStyle(color: Colors.grey[600])),
                           Checkbox(
                            value: controllerBloc1.value==null?checkBox1:controllerBloc1.value,
                            onChanged: (bool value){
                            controllerBloc1.sink.add(value);  
                            setState(()=> checkBox1 = value);
                         }
                        ),
                        Text(texto2, style: TextStyle(color: Colors.grey[600])),
                           Checkbox(
                            value:  controllerBloc2.value==null?checkBox1:controllerBloc2.value,
                            onChanged: (bool value){
                            controllerBloc2.sink.add(value);    
                            setState(()=> checkBox2 = value);
                         }) 
                       ],
                      )
                     );
            },
         
        );
      }
    
       dropDownBottomDoble(String texto1, String opcionId1, final controllerBloc1, List<DropdownMenuItem<String>> opciones1,String texto2, final controllerBloc2, String opcionId2, List<DropdownMenuItem<String>> opciones2, FirebaseBloc firebaseBloc) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Container(
                      // padding: EdgeInsets.all(0),
                       //color: Colors.red,
                       //alignment: Alignment.topLeft,
                       width: 20,
                       height: 20,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           SizedBox(width: 4),
                           Text(texto1, style: TextStyle(color: Colors.grey[600])),
                           SizedBox(width: 12),
                           DropdownButton(
                              hint: controllerBloc1.value!=null?Text(controllerBloc1.value):Text(opcionId1),
                              onChanged: (String newValue) {
                              controllerBloc1.sink.add(newValue);
                             // filtroSink(texto1, newValue, firebaseBloc);  
                              setState(() {
                                opcionId1 = newValue;
                              });
                            },
                            items: opciones1,
                          ),  
                          SizedBox(width: 40),
                          Text(texto2, style: TextStyle(color: Colors.grey[600])),
                          SizedBox(width: 12),
                          DropdownButton(
                              hint: controllerBloc2.value!=null?Text(controllerBloc2.value):Text(opcionId2),
                              onChanged: (String newValue) {
                              controllerBloc2.sink.add(newValue);  
                             // filtroSink(texto2, newValue, firebaseBloc); 
                              setState(() {
                                opcionId2 = newValue;
                              });
                            },
                            items: opciones2,
                          ),  
                       ],
                      )
                     );
            },
          
        );
      }
      filtroSink(String texto, String valor, FirebaseBloc firebaseBloc){
       
        switch(texto){
         case 'Altura:': { firebaseBloc.alturaPostesIDController.sink.add(valor);}
           break;
         case '         Rotura:': {firebaseBloc.resistenciaPostesIDController.sink.add(valor);}
           break;
         case 'Tipo:': {firebaseBloc.tipoPosteIDController.sink.add(valor);}
           break;  
         case 'Material:': {firebaseBloc.materialPosteIDController.sink.add(valor);}
           break; 
         case 'Voltaje:': {firebaseBloc.lineaTransmisionPosteIdController.sink.add(valor);}
           break; 
         case 'Estado:': {firebaseBloc.estadoPostesIDController.sink.add(valor);}
           break;   
        }  
      }
      ListTile textFormDoble(String texto1,TextEditingController controller1, String texto2, TextEditingController controller2 ) {
        return ListTile(
           contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
           title: Container(width: 20, height: 45,child: textForm(controller1, texto1)),
           trailing: Container(width: 150, height: 45,child: textForm(controller2, texto2))
        );
      }
           
    
      fotografiaEvidencia(BuildContext context) {
        return Container(
                 width: MediaQuery.of(context).size.width*0.8,
                 height: 180,
                 decoration: BoxDecoration(
                  // color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                     image: file==null?AssetImage('assets/no-image.jpg'):FileImage(file),
                     fit: file==null?BoxFit.cover:BoxFit.fill
                )
              ),
            );
      }
           
          
        
    
       subTitulos(String subTitulo, Icon icono, bool foto, FirebaseBloc firebaseBloc) {
        return Card(
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          elevation: 8.0,
          child: ListTile(
                   contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 0),
                   leading: icono,
                   visualDensity: VisualDensity(vertical: 0.0, horizontal: 0.0),
                   dense: true,
                   title: Text(
                       subTitulo,
                       style: TextStyle(
                               fontSize: 16.0,
                               fontWeight: FontWeight.bold,
                               //color: Colors.grey[600]
                               color: Colors.white
                       )
                  ),
                  trailing: foto?GestureDetector(
                    onTap: (){
                      handleTakePhoto(firebaseBloc);
                      setState((){});
                    } ,
                    child: Icon(Icons.photo_camera, color: Colors.white,)
                  ):null,
                 
                ),
        );
      }
           //showSearch(context: context, delegate: DataSearch_OS());
           
           
    
      TextFormField textForm(TextEditingController controller, String label) {
        return TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8), 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    filled: false,
                    //hintText: label,
                    labelText: label
                    ),
                    controller: controller,
                    );
      }
    
      handleTakePhoto(FirebaseBloc firebaseBloc) async {
        print('---');
        
        file= await takePhoto.getFoto(context);
        mostrarCuadroOopciones(context, firebaseBloc);
        setState((){ }); 
      }
    
      void inicializarVariablesBloc(FirebaseBloc firebaseBloc, double altoPantalla, double anchoPantalla) {

        firebaseBloc.altoPantallaController.sink.add(altoPantalla);   
        firebaseBloc.anchoPantallaController.sink.add(anchoPantalla);  
        firebaseBloc.checkBoxAereaController.sink.add(checkBoxAerea);
        firebaseBloc.checkBoxCanalizadaController.sink.add(checkBoxCanalizada);
        firebaseBloc.alturaPostesIDController.sink.add(alturaPostesID);
        firebaseBloc.resistenciaPostesIDController.sink.add(resistenciaPostesID);
        firebaseBloc.tipoPosteIDController.sink.add(tipoPosteID);
        firebaseBloc.materialPosteIDController.sink.add(materialPosteID);
        firebaseBloc.lineaTransmisionPosteIdController.sink.add(lineaTransmisionPosteID);
        firebaseBloc.estadoPostesIDController.sink.add(estadoPostesID);
        firebaseBloc.itemsSeleccionadosStream.listen((event) {datosItem=event;});
      }  
    

 
}
            
                 
        
     
     

   

     
     
            
        
      
       
               