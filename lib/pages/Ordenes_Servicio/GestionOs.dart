import 'dart:async';
import 'dart:io';

import 'package:audicol_fiber/pages/Ordenes_Servicio/detallePoste.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';
import 'package:audicol_fiber/pages/selector_pantalla.dart';
import 'package:audicol_fiber/widgets/header.dart';
import 'package:audicol_fiber/widgets/linearProgress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audicol_fiber/bloc/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audicol_fiber/clases/tomarFoto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';


class GestionOrdenServicio extends StatefulWidget {
 String numeroOrdenS;
 String estado;
 GestionOrdenServicio({@required this.numeroOrdenS, @required this.estado});
  
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
 TextEditingController herrajeRetencionController = TextEditingController();
 TextEditingController herrajeSuspensionController = TextEditingController();
 TextEditingController marquillasController = TextEditingController();
 TextEditingController amortiguadorController = TextEditingController();
 TextEditingController brazoExtensorController = TextEditingController();
 TextEditingController coronaCoilController = TextEditingController();
 TextEditingController abrazaderaController = TextEditingController();
 TextEditingController propietarioController = TextEditingController();
 TextEditingController idPosteController = TextEditingController();
 TextEditingController observacionesController = TextEditingController();
 TextEditingController reservaController = TextEditingController();
 
 
 DocumentSnapshot datosItem;
 String estadoOrdenServicio='';
 String mediaUrlPoste='';
 String mediaUrlCajaEmpalme='';
 bool gestionando=false;
 File filePoste;
 File fileCajaEmpalme;
 bool isUploading= false;
 bool checkBoxAerea= false;
 bool checkBoxCanalizada= false;
 final picker = ImagePicker();
 String posteSerialDB= Uuid().v4();
 String latitud='',longitud='';
 // ignore: non_constant_identifier_names
 int cont_aux=0;
 bool cargando=false;
 bool modificar=false;
 String fotoPosteString='';
 String fotoCajaEmpalmeString='';
 List<Widget> lisWidgettHilosUtilizados= new List();
 List<TextEditingController> listTextEditingController= new List();
 int contHilosUtilizados=0;
 Map <String,dynamic> listaFinalEmpalme= new Map();
 int contI=0;
  

  TomarFoto takePhoto=  TomarFoto();
  static const opcionesPoste = [
    'Detalles',
    'Eliminar',
  ];
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

  final List<PopupMenuItem<String>> popupOpcionesPoste = opcionesPoste
      .map((String value) => PopupMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ))
      .toList();
  String opcionPosteId='';
  DatosRedFibra datosRedFibra= DatosRedFibra();
 
 @override
  void initState() {
    
    super.initState();
    inicializarVariables();
    
  }
  
  inicializarVariables()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('estadoOs', widget.estado);
  }
  @override
  Widget build(BuildContext context) {
    final anchoPantalla = MediaQuery.of(context).size.width;
    final altoPantalla = MediaQuery.of(context).size.height;
    final firebaseBloc  = Provider.firebaseBloc(context);
    
    inicializarVariablesBloc(firebaseBloc,altoPantalla,anchoPantalla);
    firebaseBloc.getDetallePosteInstalado(widget.numeroOrdenS);
    print('listaPostesIdController:${firebaseBloc.listaPostesIdController.value}');
        return Scaffold(
          appBar: header('Orden ${widget.numeroOrdenS}',context,'mapa'),
          body: streamAgendaOrdenes(firebaseBloc),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: ()=>mostrarCuadroOopciones(context,firebaseBloc)
          ),
        );
      }
            

     StreamBuilder<List<DocumentSnapshot>> streamAgendaOrdenes(FirebaseBloc firebaseBloc) {
    return StreamBuilder<List<DocumentSnapshot>>(
     stream: firebaseBloc.listaPostesOSControllerStream,
     builder: (context, snapshot){
    
    if(snapshot.hasData && snapshot.data.isNotEmpty){
      List<DocumentSnapshot> datosPostes=snapshot.data;
      //print(datosPostes[0].data);
      //print(datosPostes.length);
      //return Container();
      return RefreshIndicator(
        onRefresh: actualizar,
        child: ListView.builder(
          //physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: datosPostes.length,
          itemBuilder: (context, i){
            return _crearBotonRedondeado(Colors.blue, datosPostes,context, i, firebaseBloc);
          }  
        ),
      );
    }else{
      return Center(child:Text('Aun no hay información en esta orden de servicio'),);
    }
  },
);
  } 
  Future<Null> actualizar()async{
    final duration= new Duration(seconds: 2);
    new Timer(duration,(){
      setState(() {  });
    });
    return Future.delayed(duration);
  }            
  Widget hiloLibres(){
    if(cantidadHilosController.text!=''){
     int catidadHilos=int.parse(cantidadHilosController.text.toString());
     return Text('  ${catidadHilos-listaFinalEmpalme.length} hilos libres de $catidadHilos en total',style: Theme.of(context).textTheme.headline1);
    }
    return Text('');
  }
      mostrarCuadroOopciones(BuildContext context, FirebaseBloc firebaseBloc) {
        DocumentSnapshot dato= firebaseBloc.posteSeleccionadoController.value;
        bool agregarHilo=firebaseBloc.agregadarHiloController.value;
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
                title: Center(child: Text('Cartera de información fisica ${firebaseBloc.idPosteController.value}')),
                content: Container(
                  //color: Colors.brown,
                  width: firebaseBloc.anchoPantallaController.value*0.95,
                  height: firebaseBloc.altoPantallaController.value*0.95,
                  child: ListView(
                    //itemExtent: 35.0,
                    //cacheExtent: 85.0,
                    children:[
                       //---INGRESANDO 'geo' se activa la opcion de toma de coordenadas por el celular---------------
                       Divider(),
                       subTitulos('Georefenciación',Icon(Icons.golf_course, color: Colors.white), 'geoo', firebaseBloc, false),
                       
                       textFormDoble(
                                     'latitud',
                                      latitudController,
                                      'Longitud',
                                      longitudController,
                                      false),
                                     

                       Divider(color: Colors.black, height: 15.0),
                       subTitulos('Abscisas', Icon(Icons.gesture, color: Colors.white), '', firebaseBloc, false),
                      
                       textFormDoble(
                                     'Inicial', 
                                     abscisaInicialController,
                                     'Final',
                                     abscisaFinalController,
                                     false),
                                     
                      
                       Divider(color: Colors.black, height: 15.0),
                       subTitulos('Caja de Empalme',Icon(Icons.add, color: Colors.white), '', firebaseBloc, true),

                       textFormDoble(  
                                      'Reserva (Metros)', 
                                       reservaController,
                                       'Intervalo de Hilos',
                                       intervaloHilosController,
                                       false),
                        textForm(cajaEmpalmeController,
                                'Id caja de empalme',
                                true),
                       
                                      
                       agregarHilo!=null && agregarHilo==true?Container(
                         /* height: 60,
                         width: 300, */
                         child: Column(
                           children: [
                             Divider(color: Colors.black, height: 10.0),
                             contHilosUtilizados>0?subTitulos('Relación de Empalme Hilos',Icon(Icons.add_box, color: Colors.white), '', firebaseBloc, true):Container(),
                             contHilosUtilizados>0?ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true, 
                              children: lisWidgettHilosUtilizados
                             ):Container(),
                             contHilosUtilizados>0?hiloLibres():Container(),
                           ],
                         ),
                       ):Container(), 
                       
                          
                         
                               
                       
                       SizedBox(height: 0,),
                       //fotografiaEvidenciaCajaEmpalme(context, firebaseBloc, 'cajaEmpalme'),
                       Divider(color: Colors.black, height: 5.0),
                       subTitulos('Fibra Optica',Icon(Icons.linear_scale, color: Colors.white), '', firebaseBloc, false),
                       
                       textFormDoble(
                                     'Span',
                                     spanController,
                                     'Cantidad de Hilos',
                                     cantidadHilosController,
                                     false),
                                    
                       
                       checkBoxDoble('Aerea:',checkBoxAerea, firebaseBloc.checkBoxAereaController,  'Canalizada', checkBoxCanalizada, firebaseBloc.checkBoxCanalizadaController),
                       
                       Divider(),
                       subTitulos('Materiales utilizados',Icon(Icons.linear_scale, color: Colors.white), '', firebaseBloc, false), 
                       SizedBox(height: 20,),
                       
                       textFormDoble(
                                     'Herraje de retención', 
                                     herrajeRetencionController,
                                     'Herraje de suspensión',
                                     herrajeSuspensionController,
                                     false),
                                    
                       
                       textFormDoble(
                                     'Marquillas', 
                                     marquillasController,
                                     'Amortiguador',
                                     amortiguadorController,
                                     false),
                                    
                       
                       textFormDoble(
                                     'Brazo extensor', 
                                     brazoExtensorController,
                                     'Corona coil',
                                     coronaCoilController,
                                     false),
                       
                                    
                       textForm(
                                abrazaderaController,
                                'Abrazadera para poste collarin',
                                false), 
                                
                       
                       Divider(),
                       subTitulos('Caracteristica poste',Icon(Icons.linear_scale, color: Colors.white), '', firebaseBloc, false), 
                       SizedBox(height: 20,),
                       dropDownBottomDoble('Altura:',  alturaPostesID, firebaseBloc.alturaPostesIDController, dropDownAlturaPostes, '         Rotura:', firebaseBloc.resistenciaPostesIDController, resistenciaPostesID, dropDownResistenciaPostes,firebaseBloc),
                       Divider(),
                       dropDownBottomDoble('Tipo:', tipoPosteID, firebaseBloc.tipoPosteIDController, dropDownTipoPostes, 'Material:', firebaseBloc.materialPosteIDController, materialPosteID, dropDownMaterialPostes,firebaseBloc),
                       Divider(),
                       dropDownBottomDoble('Voltaje:', lineaTransmisionPosteID, firebaseBloc.lineaTransmisionPosteIdController, dropDownLineaTransmisionPostes, 'Estado:', firebaseBloc.estadoPostesIDController, estadoPostesID, dropDownEstadoPostes,firebaseBloc),
                       Divider(),
                       subTitulos('Proveedor de poste',Icon(Icons.linear_scale, color: Colors.white), 'proveedorPoste', firebaseBloc, false), 
                       SizedBox(height: 20,),
                       
                       textFormDoble(
                                     'Propietario', 
                                     propietarioController,
                                     'Id poste',
                                     idPosteController,
                                     true),
                       
                                    
                       textForm(observacionesController,
                                'Observaciones',
                                true),
                               

                       SizedBox(height: 10,),
                       fotografiaEvidenciaPoste(context, firebaseBloc, 'proveedorPoste'),
                       isUploading ? linearProgress(context) : Text(''),
                       
                        
                       
                       
                   ]
                  ),  
                ),
                      
            actions: <Widget>[
                FlatButton(
                    child: Text('Cancelar'),
                    onPressed: (){
                      borrarVariables(firebaseBloc);
                      Navigator.pop(context);
                    },
                  ),
                FlatButton(
                    child: modificar?Text('Actualizar'):Text('Guardar'),
                    onPressed: (){
                    sendDatos(firebaseBloc);
                    
                    setState(() { });
                    //Navigator.pop(context);
                    },
                  ),  
            ],  
            ),
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
                              hint: Text(controllerBloc1.value),
                              onChanged: (String newValue) {

                              controllerBloc1.sink.add(newValue);
                             // filtroSink(texto1, newValue, firebaseBloc);  
                              setState(() {
                               
                              });
                            },
                            items: opciones1,
                          ),  
                          SizedBox(width: 40),
                          Text(texto2, style: TextStyle(color: Colors.grey[600])),
                          SizedBox(width: 12),
                          DropdownButton(
                              hint: Text(controllerBloc2.value),
                              onChanged: (String newValue) {
                              controllerBloc2.sink.add(newValue);  
                             // filtroSink(texto2, newValue, firebaseBloc); 
                              setState(() {
                               
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
      
       textFormDoble(String texto1,TextEditingController controller1,  String texto2, TextEditingController controller2, bool numeroText ) {
        return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
        return ListTile(
           contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
           title: Container(width: 20, height: 45,child: textForm(controller1,texto1,numeroText)),
           trailing: Container(width: 180, height: 45,child: textForm(controller2,texto2,numeroText))
          );
         }
        );
      }
           
    
      fotografiaEvidenciaPoste(BuildContext context, FirebaseBloc firebaseBloc, String foto){
        
        File fotoPoste= firebaseBloc.fotoPosteController.value;
        
       
        return Container(
                 width: MediaQuery.of(context).size.width*0.8,
                 height: MediaQuery.of(context).size.height*0.25,
                 decoration: BoxDecoration(
                  // color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                     image: modificar&&fotoPosteString!=''&&fotoPoste==null?NetworkImage(fotoPosteString):
                            modificar==false&&filePoste==null?AssetImage('assets/no-image.jpg'):
                            fotoPoste!=null?FileImage(fotoPoste):
                            AssetImage('assets/no-image.jpg'),
                     fit: filePoste==null?BoxFit.cover:BoxFit.fill
                )
              ),
            );
      }
           
         fotografiaEvidenciaCajaEmpalme(BuildContext context, FirebaseBloc firebaseBloc, String foto){
        
        File fotocajaEmpalme= firebaseBloc.fotoCajaEmpalmeController.value;

        return Container(
                 width: MediaQuery.of(context).size.width*0.8,
                 height: MediaQuery.of(context).size.height*0.25,
                 decoration: BoxDecoration(
                  // color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                     image:  modificar&&fotoCajaEmpalmeString!=''&&fotocajaEmpalme==null?NetworkImage(fotoCajaEmpalmeString):
                             modificar==false&&fileCajaEmpalme==null?AssetImage('assets/no-image.jpg'):
                             fotocajaEmpalme!=null?FileImage(fotocajaEmpalme):
                             AssetImage('assets/no-image.jpg'),
                     fit: fileCajaEmpalme==null?BoxFit.cover:BoxFit.fill
                )
              ),
            );
      }
        
    
       subTitulos(String subTitulo, Icon icono, String foto, FirebaseBloc firebaseBloc, bool agregarHilo) {
        
        return Card(
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          elevation: 8.0,
          child: ListTile(
                   contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 0),
                   leading: agregarHilo?GestureDetector(
                                            onTap: (){
                                             
                                             
                                              contHilosUtilizados=contHilosUtilizados+2;
                                              firebaseBloc.agregadarHiloController.sink.add(true);
                                           
                                              
                                              listTextEditingController.add(TextEditingController());
                                              listTextEditingController.add(TextEditingController());
                                             
                                              lisWidgettHilosUtilizados.add( textFormDoble( 'Del hilo numero', listTextEditingController[contHilosUtilizados-2],
                                                                                            'Al hilo numero',listTextEditingController[contHilosUtilizados-1],
                                                                                            false));
                                              Navigator.pop(context);                                         
                                              mostrarCuadroOopciones(context, firebaseBloc);                                       
                                            },
                                            child: icono,
                                            ):icono,
                                            
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
                  
                    
                  trailing: foto=='geo'||foto=='proveedorPoste' || foto== 'cajaEmpalme' ?GestureDetector(
                    onTap: (){
                      if(foto=='geo'){
                         cargando=true;
                        // getLocalization(firebaseBloc);  
                         
                      }
                      else{
                      handleTakePhoto(firebaseBloc, foto);
                      }
                      
                      setState((){});
                    } ,
                    child: foto=='geo'?Icon(Icons.pin_drop, color: Colors.white):Icon(Icons.photo_camera, color: Colors.white,)
                  ):null,
                 
                ),
        );
      }

      getLocalization(FirebaseBloc firebaseBloc) async {
        Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        print('Latitud: ${position.latitude}---Longitud: ${position.longitude}');
        latitud=position.latitude.toString();
        longitud=position.longitude.toString();
        Navigator.pop(context);
       
        mostrarCuadroOopciones(context, firebaseBloc);
        setState((){});
      }

     

           //showSearch(context: context, delegate: DataSearch_OS());
           
           
    
      TextFormField textForm(TextEditingController controller, String label, bool numeroText) {
        return TextFormField(
                    maxLines: label=='Observaciones'?4:1,
                    keyboardType: numeroText?TextInputType.text:TextInputType.number,
                    decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8), 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    filled: false,
                    hintText: label,
                    labelText: label
                    ),
                    controller: controller,
                    );
      }
    
      handleTakePhoto(FirebaseBloc firebaseBloc, String foto) async {
        print('---');
        
       
        if(foto.contains('cajaEmpalme')){
          fileCajaEmpalme= await takePhoto.getFoto(context);
          firebaseBloc.fotoCajaEmpalmeController.sink.add(fileCajaEmpalme);
          
         
        }else  if(foto.contains('proveedorPoste')){
          filePoste= await takePhoto.getFoto(context);
          firebaseBloc.fotoPosteController.sink.add(filePoste);
           
          
        }
        mostrarCuadroOopciones(context, firebaseBloc);
        setState((){ }); 
      }
    
      void inicializarVariablesBloc(FirebaseBloc firebaseBloc, double altoPantalla, double anchoPantalla) {
         
        firebaseBloc.anchoPantallaController.sink.add(anchoPantalla); 
        firebaseBloc.altoPantallaController.sink.add(altoPantalla); 
        firebaseBloc.listaPostesIdController.sink.add(null);
         
      if(cont_aux==0){  
      cont_aux=1;
      firebaseBloc.checkBoxAereaController.sink.add(checkBoxAerea);
      firebaseBloc.checkBoxCanalizadaController.sink.add(checkBoxCanalizada);
      firebaseBloc.alturaPostesIDController.sink.add(alturaPostesID);
      firebaseBloc.resistenciaPostesIDController.sink.add(resistenciaPostesID);
      firebaseBloc.tipoPosteIDController.sink.add(tipoPosteID);
      firebaseBloc.materialPosteIDController.sink.add(materialPosteID);
      firebaseBloc.lineaTransmisionPosteIdController.sink.add(lineaTransmisionPosteID);
      firebaseBloc.estadoPostesIDController.sink.add(estadoPostesID); 
      }
        /*  firebaseBloc.alturaPostesIDController.sink.add('');
         firebaseBloc.resistenciaPostesIDController.sink.add('');
         firebaseBloc.tipoPosteIDController.sink.add('');
         firebaseBloc.materialPosteIDController.sink.add('');
         firebaseBloc.lineaTransmisionPosteIdController.sink.add('');
         firebaseBloc.estadoPostesIDController.sink.add('');
         firebaseBloc.checkBoxAereaController.sink.add(false);
         firebaseBloc.checkBoxCanalizadaController.sink.add(false); */
        firebaseBloc.itemsSeleccionadosStream.listen((event) {datosItem=event;});
      }  
    
     Widget _crearBotonRedondeado(Color color,  List<DocumentSnapshot> datosPostes, BuildContext context, int i, FirebaseBloc firebaseBloc){
     //final widthPantalla = MediaQuery.of(context).size.width;
    
     String imagen; 
     imagen='assets/ordenCasa2.png';
     
    return tarjetas(color, datosPostes, imagen, context, firebaseBloc, i);
  }

   tarjetas(Color color, List<DocumentSnapshot> datosPostes, String imagen, BuildContext context, firebaseBloc, int i) {
    final widthPantalla = MediaQuery.of(context).size.width;
    final heightPantalla = MediaQuery.of(context).size.height;
    return Container(
        //alignment: Alignment.center, 
       // height: heightPantalla-600, 
        //heightPantalla-450,
       // width: widthPantalla,
         margin: EdgeInsets.only(left:20.0,right: 20.0,top: 10,bottom: 10),
         decoration: BoxDecoration(
          //color: color,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: <BoxShadow>[
                      BoxShadow(
                      color: Colors.white,
                      blurRadius: 1.0,
                      offset: Offset(2.0, 2.0),
                      spreadRadius: 1.0
                      ),
                   ]  
         ), 
         child: subtituloTarjeta(datosPostes,firebaseBloc,i), 
              
             
        );
  }

   Text tituloTarjeta(String texto) {
     return Text(
              'Poste # $texto',
               style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                       // color: colorText
                )
            );
   }
   
   obtenerNumeroPostes(FirebaseBloc firebaseBloc)async{
         
         await firebaseBloc.getListaPostes(widget.numeroOrdenS, true);
       
       
      
     } 
   subtituloTarjeta(List<DocumentSnapshot> dato, FirebaseBloc firebaseBloc, int i) {
     
     return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              leading: Icon(Icons.format_paint, size: 35.0),
              title: Text(
                'Id: ${dato[i]['posteID']}',
                style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]
                )
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                'Latitud: ${dato[i]['georeferenciacion']['latitud']}',
                style: TextStyle(
                        fontSize: 16.0,
                        //fontWeight: FontWeight.bold,
                        color: Colors.grey[600]
                )
              ),
               Text(
                'Longitud: ${dato[i]['georeferenciacion']['longitud']}',
                style: TextStyle(
                        fontSize: 16.0,
                        //fontWeight: FontWeight.bold,
                        color: Colors.grey[600]
                )
              ),
                ],
              ),
              trailing:  PopupMenuButton<String>(
                        elevation: 85.0,
                        icon: Icon(Icons.more_vert),
                        padding: EdgeInsets.only(right: 0),
                         shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onSelected: (String newValue)async{
                         opcionPosteId=newValue;
                          /* if(opcionPosteId=='Detalles'){
                             Navigator.push(context, MaterialPageRoute(builder: (context)=> DetallesPoste(datos:dato[i])));
                             } */
                           if(opcionPosteId=='Eliminar'){
                              List<String> listaNueva= new List();
                              ordenesServicio
                              .document(widget.numeroOrdenS)
                              .collection('postes')
                              .document(dato[i]['posteID'])
                              .delete();
                            
                              await obtenerNumeroPostes(firebaseBloc);
                              
                              final listaPostes1=firebaseBloc.listaPostesIdController.value;
                              print('listaPostes1------------------------>$listaPostes1');
                              if(listaPostes1!=null){
                              for (var n = 0; n < listaPostes1.length; n++) {
                                if(listaPostes1[n]!=dato[i]['posteID']){
                                   listaNueva.add(listaPostes1[n]);
                                }
                              }
                               print('postes---->$listaNueva');
                              firebaseBloc.listaPostesIdController.sink.add(null);
 
                                ordenesServicio
                              .document(widget.numeroOrdenS)
                              .updateData({
                                'postes':listaNueva
                              });  
                              }
                           
                           }  
                           if(opcionPosteId=='Detalles'){
                             firebaseBloc.posteSeleccionadoController.sink.add(dato[i]);
                             firebaseBloc.idPosteController.sink.add(dato[i]['posteID']);
                          
                             
                              modificar=true;
                              latitudController.text=dato[i]['georeferenciacion']['latitud'];
                              longitudController.text=dato[i]['georeferenciacion']['longitud'];
                              abscisaInicialController.text=dato[i]['abscisas']['inicial'];   
                              abscisaFinalController.text=dato[i]['abscisas']['final'];     
                              cajaEmpalmeController.text=dato[i]['cajaEmpalme']['idCajaEmpalme'];      
                              spanController.text=dato[i]['fibra']['span'];             
                              cantidadHilosController.text=dato[i]['fibra']['hilosCantidad'];    
                              intervaloHilosController.text=dato[i]['cajaEmpalme']['hilosIntervalo'];   
                              herrajeRetencionController.text=dato[i]['materiales']['herrajeRetencion']; 
                              herrajeSuspensionController.text=dato[i]['materiales']['herrajeSupension'];
                              marquillasController.text=dato[i]['materiales']['marquillas'];       
                              amortiguadorController.text=dato[i]['materiales']['amortiguador'];     
                              brazoExtensorController.text=dato[i]['materiales']['brazoExtensor'];    
                              coronaCoilController.text=dato[i]['materiales']['coronaCoil'];       
                              abrazaderaController.text=dato[i]['materiales']['abrazaderaCollarin'];       
                              propietarioController.text=dato[i]['proveedorPoste']['propietario'];      
                              idPosteController.text=dato[i]['proveedorPoste']['idPoste'];          
                              observacionesController.text=dato[i]['proveedorPoste']['observaciones'];    
                              reservaController.text=dato[i]['cajaEmpalme']['reserva'];          

                              //---ALGORITMO PARA ACTUALIZAR LOS CONTROLADORES DE LOS CAMPOS DE TEXTO DE LA CARTERA DE EMPALME--------
                              
                              listaFinalEmpalme=dato[i]['cartaEmpalme'];
                            if(listaFinalEmpalme!=null||listaFinalEmpalme.isNotEmpty){
                              lisWidgettHilosUtilizados.clear();
                              listTextEditingController.clear();
                              for (var i = 0; i < listaFinalEmpalme.length*2; i++) {
                                listTextEditingController.add(TextEditingController());
                                }
                                
                              listaFinalEmpalme.keys.forEach((element) {
                                  
                                  listTextEditingController[contI].text=element;
                                  contI=contI+2;
                               });
                              contI=1;
                               listaFinalEmpalme.values.forEach((element) {
                                  
                                  listTextEditingController[contI].text=element;
                                  
                                   contI=contI+2;
                               });
                               contI=0;
                               firebaseBloc.agregadarHiloController.sink.add(true);
                               for (var i = 0; i < listaFinalEmpalme.length; i++) {
                                lisWidgettHilosUtilizados.add( textFormDoble( 'Del hilo numero', listTextEditingController[contI],
                                 
                               
                                                                              'Al hilo numero', listTextEditingController[contI+1],
                                                                                       false));
                                contI=contI+2;   
                               } 
                               contI=0;  
                               contHilosUtilizados=listaFinalEmpalme.length*2;
                              } 
                                   

                              fotoPosteString=dato[i]['mediaUrl']['mediaUrlPoste'];
                              fotoCajaEmpalmeString=dato[i]['mediaUrl']['mediaUrlCajaEmpalme'];
                              firebaseBloc.alturaPostesIDController.sink.add(dato[i]['caracteristicasPoste']['altura']);
                              firebaseBloc.resistenciaPostesIDController.sink.add(dato[i]['caracteristicasPoste']['rotura']);
                              firebaseBloc.tipoPosteIDController.sink.add(dato[i]['caracteristicasPoste']['tipo']);
                              firebaseBloc.materialPosteIDController.sink.add(dato[i]['caracteristicasPoste']['material']);
                              firebaseBloc.lineaTransmisionPosteIdController.sink.add(dato[i]['caracteristicasPoste']['voltaje']);
                              firebaseBloc.estadoPostesIDController.sink.add(dato[i]['caracteristicasPoste']['estado']);
                              firebaseBloc.checkBoxAereaController.sink.add(dato[i]['fibra']['aerea']);
                              firebaseBloc.checkBoxCanalizadaController.sink.add(dato[i]['fibra']['canalizada']);        
                                      
                              mostrarCuadroOopciones(context, firebaseBloc);
                             
                             }     
                        setState(() {
                         
                        });
                        },
                        itemBuilder: (BuildContext context)=> popupOpcionesPoste
                      )
            );
     
     /* 
     Container(
              height: 20,
              width: 300,
              //color: Colors.red,
              child: Text(
               '$titulo: $dato',
                style: TextStyle(
                        fontSize: 13.0,
                       // color: colorText
                )
              ),
            );
 */   }
 

 sendDatos(FirebaseBloc firebaseBloc) async {



if(longitudController.text.isEmpty||latitudController.text.isEmpty){
   mensajePantalla('Complete las coordenadas!');
   return Container();
}else if(longitudController.text.contains('.')==false||latitudController.text.contains('.')==false){
   mensajePantalla('Ingrese las coordenadas en decimales!');
   return Container();
}else if(longitudController.text.length<8||latitudController.text.length<8){
    mensajePantalla('Ingrese minimo 6  decimales!');
    return Container(); 
}else if(abscisaInicialController.text.isEmpty){
   mensajePantalla('Ingrese la abscisa inicial incluyendo la reserva, si es el caso!');
   return Container();
}else if(intervaloHilosController.text.isEmpty){
   mensajePantalla('Ingrese el intervalo de hilos utilizados de la estación central que pasan por este poste! ejemplo: 12-32');
   return Container();
}else if(intervaloHilosController.text.contains('-')==false){
   mensajePantalla('Escriba el intervalo de hilos separados por un guión, ejemplo: 12-32');
   return Container();
}else if(cantidadHilosController.text.isEmpty){
   mensajePantalla('Ingrese la cantidad de hilos de la fibra que pasa por el poste!');
   return Container();
}else if(cantidadHilosController.text.contains('.')==true){
   mensajePantalla('Ingrese la cantidad de hilos sin puntos');
   return Container();
}else if(propietarioController.text.isEmpty){
   mensajePantalla('Ingrese el propietario del poste!');
   return Container();
}else if(idPosteController .text.isEmpty){
   mensajePantalla('Ingrese el id del poste, si no tiene escriba 0000!');
   return Container();
}else{
  
   listaFinalEmpalme.clear();
  for (var i = 0; i < listTextEditingController.length; i=i+2) {
    if(listTextEditingController[i].text!=''){
    listaFinalEmpalme[listTextEditingController[i].text]=listTextEditingController[i+1].text;
    }
  }
  arregloControladores(firebaseBloc); 
  setState(() {
     isUploading= true;
    });

 if (filePoste!=null){
  filePoste= await takePhoto.compressImage(filePoste);
   mediaUrlPoste = await takePhoto.uploadImage(filePoste);
 }else if(modificar&&fotoPosteString!=''){
   mediaUrlPoste=fotoPosteString;
 }
 if (fileCajaEmpalme!=null){
   fileCajaEmpalme= await takePhoto.compressImage(fileCajaEmpalme);
   mediaUrlCajaEmpalme = await takePhoto.uploadImage(fileCajaEmpalme);
 }else if(modificar&&fotoCajaEmpalmeString!=''){
   mediaUrlCajaEmpalme=fotoCajaEmpalmeString;
 }


  //--------Validacion si el usuario tomo coordenadas automaticamente-----
  /*  if (latitud.isNotEmpty&&modificar){
    latitud=latitudController.text;
  }else{
    latitud=latitudController.text;
  }
   if (longitud.isNotEmpty&&modificar){
    longitud=longitudController.text;
  }else{
    longitud=longitudController.text;
  } */ 

  //-------------------------------------------------------
   SharedPreferences prefs = await SharedPreferences.getInstance();
   estadoOrdenServicio= prefs.getString('estadoOs');
  //-------------------------------------------------------
  
  Map <String, dynamic>  cuantificarPostes= new Map();
  String posteNumero='';
  String fechaModificacion='';

  if(modificar){
    fechaModificacion='fechaModificada';
  }else{
    fechaModificacion='timestamp';
  }
  print('estado:$estadoOrdenServicio');
  
  if(estadoOrdenServicio=='No iniciada'){
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('estadoOs', 'En proceso');
    posteNumero='poste-1';
    ordenesServicio
          .document(widget.numeroOrdenS)
          .updateData({
            'Estado': 'En proceso',
            'postes': ['poste-1']
          });
  }else if(modificar==false){
    cuantificarPostes= await datosRedFibra.getNumeroPoste(widget.numeroOrdenS, false);
    print(cuantificarPostes);
    posteNumero='poste-' + cuantificarPostes['posteActual'];
    //ACTUALIZA LA LISTA DE POSTES EN EL DOCUMENTO DE LA ORDEN DE SERVICIO ELEGIDA
     ordenesServicio
          .document(widget.numeroOrdenS)
          .updateData({
            'postes': cuantificarPostes['listaPostes']
          });
  }else{
    posteNumero= firebaseBloc.idPosteController.value;
  }
  if(modificar){
     ordenesServicio
    .document(widget.numeroOrdenS)
    .collection('postes')
    .document(posteNumero)
    .updateData({
       
        'posteID':posteNumero,
        'georeferenciacion'   : {'latitud': latitudController.text, 'longitud': longitudController.text},
        'abscisas'            : {'inicial':abscisaInicialController.text, 'final':abscisaFinalController.text},
        //'mediaUrl'            : {'mediaUrlPoste': mediaUrlPoste, 'mediaUrlCajaEmpalme':mediaUrlCajaEmpalme},
        'mediaUrl'            : {'mediaUrlPoste': mediaUrlPoste},
        'cajaEmpalme'         : {
                                 'reserva':reservaController.text ,
                                 'hilosIntervalo':intervaloHilosController.text,
                                 'idCajaEmpalme':cajaEmpalmeController.text
        },
        'fibra'               : {
                                 'span': spanController.text ,
                                 'hilosCantidad': cantidadHilosController.text,
                                 'aerea':firebaseBloc.checkBoxAereaController.value,
                                 'canalizada':firebaseBloc.checkBoxCanalizadaController.value
        },
        'cartaEmpalme'        :listaFinalEmpalme,
        'materiales'          : {
                                 'herrajeRetencion':herrajeRetencionController.text,
                                 'herrajeSupension':herrajeSuspensionController.text,
                                 'marquillas':marquillasController.text,
                                 'amortiguador':amortiguadorController.text,
                                 'brazoExtensor':brazoExtensorController.text,
                                 'coronaCoil':coronaCoilController.text,
                                 'abrazaderaCollarin':abrazaderaController.text
        },
        'caracteristicasPoste': {
                                 'altura': firebaseBloc.alturaPostesIDController.value,
                                 'rotura': firebaseBloc.resistenciaPostesIDController.value,
                                 'tipo': firebaseBloc.tipoPosteIDController.value,
                                 'material': firebaseBloc.materialPosteIDController.value,
                                 'voltaje': firebaseBloc.lineaTransmisionPosteIdController.value,
                                 'estado': firebaseBloc.estadoPostesIDController.value,
        },
        fechaModificacion: DateTime.now(),
        'proveedorPoste'      : {
                                'propietario':propietarioController.text,
                                'idPoste':idPosteController.text,
                                'observaciones':observacionesController.text
        } 
    }
    ); 
    mensajePantalla('Los datos fueron actualizados con exito!');
   
  }else{
     ordenesServicio
    .document(widget.numeroOrdenS)
    .collection('postes')
    .document(posteNumero)
    .setData({
       
        'posteID':posteNumero,
        'georeferenciacion'   : {'latitud': latitudController.text, 'longitud': longitudController.text},
        'abscisas'            : {'inicial':abscisaInicialController.text, 'final':abscisaFinalController.text},
        //'mediaUrl'            : {'mediaUrlPoste': mediaUrlPoste, 'mediaUrlCajaEmpalme':mediaUrlCajaEmpalme},
        'mediaUrl'            : {'mediaUrlPoste': mediaUrlPoste},
        'cajaEmpalme'         : {
                                 'reserva':reservaController.text ,
                                 'hilosIntervalo':intervaloHilosController.text,
                                 'idCajaEmpalme':cajaEmpalmeController.text
        },
        'fibra'               : {
                                 'span': spanController.text ,
                                 'hilosCantidad': cantidadHilosController.text,
                                 'aerea':firebaseBloc.checkBoxAereaController.value,
                                 'canalizada':firebaseBloc.checkBoxCanalizadaController.value
        },
        'cartaEmpalme'        :listaFinalEmpalme,
        'materiales'          : {
                                 'herrajeRetencion':herrajeRetencionController.text,
                                 'herrajeSupension':herrajeSuspensionController.text,
                                 'marquillas':marquillasController.text,
                                 'amortiguador':amortiguadorController.text,
                                 'brazoExtensor':brazoExtensorController.text,
                                 'coronaCoil':coronaCoilController.text,
                                 'abrazaderaCollarin':abrazaderaController.text
        },
        'caracteristicasPoste': {
                                 'altura': firebaseBloc.alturaPostesIDController.value,
                                 'rotura': firebaseBloc.resistenciaPostesIDController.value,
                                 'tipo': firebaseBloc.tipoPosteIDController.value,
                                 'material': firebaseBloc.materialPosteIDController.value,
                                 'voltaje': firebaseBloc.lineaTransmisionPosteIdController.value,
                                 'estado': firebaseBloc.estadoPostesIDController.value,
        },
        fechaModificacion: DateTime.now(),
        'proveedorPoste'      : {
                                'propietario':propietarioController.text,
                                'idPoste':idPosteController.text,
                                'observaciones':observacionesController.text
        } 
    }
    ); 
   
    mensajePantalla('Los datos fueron guardados con exito!!');
     
  }
 
  
  borrarVariables(firebaseBloc); 
  
         

    setState(() {
      
      mediaUrlPoste='';
      mediaUrlCajaEmpalme='';
      filePoste=null;
      fileCajaEmpalme=null;
      isUploading=false;
      posteSerialDB= Uuid().v4();
      Navigator.pop(context);
    });


}
 
  
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

 borrarVariables(FirebaseBloc firebaseBloc){
  listaFinalEmpalme.clear();
  contHilosUtilizados=0;
  lisWidgettHilosUtilizados.clear();
  listTextEditingController.clear();
  modificar=false;
  cargando=false;
  latitud='';
  longitud='';
  fotoPosteString='';
  fotoCajaEmpalmeString='';
  latitudController.clear();          
  longitudController.clear();         
  abscisaInicialController.clear();   
  abscisaFinalController.clear();     
  cajaEmpalmeController.clear();      
  spanController.clear();             
  cantidadHilosController.clear();    
  intervaloHilosController.clear();   
  herrajeRetencionController.clear(); 
  herrajeSuspensionController.clear();
  marquillasController.clear();       
  amortiguadorController.clear();     
  brazoExtensorController.clear();    
  coronaCoilController.clear();       
  abrazaderaController.clear();       
  propietarioController.clear();      
  idPosteController.clear();          
  observacionesController.clear();    
  reservaController.clear();          

 firebaseBloc.agregadarHiloController.sink.add(false);
 firebaseBloc.fotoPosteController.sink.add(null);
 firebaseBloc.fotoCajaEmpalmeController.sink.add(null);
 firebaseBloc.alturaPostesIDController.sink.add('');
 firebaseBloc.resistenciaPostesIDController.sink.add('');
 firebaseBloc.tipoPosteIDController.sink.add('');
 firebaseBloc.materialPosteIDController.sink.add('');
 firebaseBloc.lineaTransmisionPosteIdController.sink.add('');
 firebaseBloc.estadoPostesIDController.sink.add('');
 firebaseBloc.checkBoxAereaController.sink.add(false);
 firebaseBloc.checkBoxCanalizadaController.sink.add(false);
  
 }
 arregloControladores(FirebaseBloc firebaseBloc){
 
  if(longitudController.text==null){
      longitudController.text='';
   }
   if(abscisaInicialController.text==null){
      abscisaInicialController.text='';
   }
   if(abscisaFinalController.text==null){
      abscisaFinalController.text='';
   }
   if(cajaEmpalmeController.text==null){
      cajaEmpalmeController.text='';
   }
   if(spanController.text==null){
      spanController.text='';
   }
   if(cantidadHilosController.text==null){
      cantidadHilosController.text='';
   }
   if(intervaloHilosController.text==null){
      intervaloHilosController.text='';
   }
   if(herrajeRetencionController.text==null){
      herrajeRetencionController.text='';
   }         
   if(herrajeSuspensionController.text==null){
      herrajeSuspensionController.text='';
   }         
   if(marquillasController.text==null){
      marquillasController.text='';
   }         
   if(amortiguadorController.text==null){
      amortiguadorController.text='';
   }         
   if(brazoExtensorController.text==null){
      brazoExtensorController.text='';
   }         
   if(coronaCoilController.text==null){
      coronaCoilController.text='';
   }         
   if(abrazaderaController.text==null){
      abrazaderaController.text='';
   }         
   if(propietarioController.text==null){
      propietarioController.text='';
   }         
   if(idPosteController.text==null){
      idPosteController.text='';
   }         
   if(observacionesController.text==null){
      observacionesController.text='';
   }         
   if(reservaController.text==null){
      reservaController.text='';
   }         
   /*    if(firebaseBloc.alturaPostesIDController.value==null){
          firebaseBloc.alturaPostesIDController.value='';
      }         
      if(firebaseBloc.resistenciaPostesIDController.value==null){
          firebaseBloc.resistenciaPostesIDController.value='';
      }         
      if(firebaseBloc.tipoPosteIDController.value==null){
          firebaseBloc.tipoPosteIDController.value='';
      }         
      if(firebaseBloc.materialPosteIDController.value==null){
          firebaseBloc.materialPosteIDController.value='';
      }         
      if(firebaseBloc.lineaTransmisionPosteIdController.value==null){
          firebaseBloc.lineaTransmisionPosteIdController.value='';
      }         
      if(firebaseBloc.estadoPostesIDController.value==null){
          firebaseBloc.estadoPostesIDController.value='';
      }         
   if(firebaseBloc.checkBoxAereaController.value==null){
      firebaseBloc.checkBoxAereaController.value=false;
   }         
   if(firebaseBloc.checkBoxCanalizadaController.value==null){
      firebaseBloc.checkBoxCanalizadaController.value=false;
   }          */
         

 }

 
}
            
                 
        
     
     

   

     
     
            
        
      
       
               