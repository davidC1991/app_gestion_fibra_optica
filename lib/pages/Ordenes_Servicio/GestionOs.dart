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
 final picker = ImagePicker();



  TomarFoto takePhoto=  TomarFoto();

  static const opciones = [
    'Poste',
    'Fibra',
    'Cliente'
  ];

 final List<DropdownMenuItem<String>> dropDownProyectos = opciones
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String opcionesID='Poste';

 @override
  void initState() {
    
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    final anchoPantalla = MediaQuery.of(context).size.width;
    final altoPantalla = MediaQuery.of(context).size.height;
    final firebaseBloc  = Provider.firebaseBloc(context);

    firebaseBloc.altoPantallaController.sink.add(altoPantalla);   
    firebaseBloc.anchoPantallaController.sink.add(anchoPantalla);  

    firebaseBloc.itemsSeleccionadosStream.listen((event) {datosItem=event;});
   
    print('latitudController:${latitudController.text}');
    print('longitudController:${longitudController.text}');
    print('File:$file');
   
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
          contentPadding: EdgeInsets.only(left: 25.0, right: 25.0),   
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: cont_aux==0?Text('Escoger una opción'):Text('Registre los siguientes datos'),
          content: Container(
            //color: Colors.brown,
            width: firebaseBloc.anchoPantallaController.value*0.8,
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
                 Divider(),
                
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
              setState(() { });
              },
            ),  
        ],  
        );
         },
         
      )
    );
  }

  ListTile textFormDoble(String texto1,TextEditingController controller1, String texto2, TextEditingController controller2 ) {
    return ListTile(
       contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
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
      color: Theme.of(context).primaryColor.withOpacity(0.5),
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
    

 
}
            
                 
        
     
     

   

     
     
            
        
      
       
               