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
 int cont_aux=0;
 bool cargando=false;
 bool modificar=false;
 String fotoPosteString='';
 String fotoCajaEmpalmeString='';
 

  static const spinkit = SpinKitRotatingCircle(
  color: Colors.blue,
  size: 50.0,
  );

  TomarFoto takePhoto=  TomarFoto();
  static const opcionesPoste = [
    'Detalles',
    'Modificar',
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
          appBar: header('Gestion',context,'mapa'),
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
      return ListView.builder(
        //physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: datosPostes.length,
        itemBuilder: (context, i){
          return _crearBotonRedondeado(Colors.blue, datosPostes,context, i, firebaseBloc);
        }  
      );
    }else{
      return Center(child:Text('Aun no hay información en esta orden de servicio'),);
    }
  },
);
  } 
          
  
      mostrarCuadroOopciones(BuildContext context, FirebaseBloc firebaseBloc) {
        DocumentSnapshot dato= firebaseBloc.posteSeleccionadoController.value;
      
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
                title: Center(child: Text('Cartera de información fisica')),
                content: Container(
                  //color: Colors.brown,
                  width: firebaseBloc.anchoPantallaController.value*0.9,
                  height: firebaseBloc.altoPantallaController.value*0.8,
                  child: ListView(
                    //itemExtent: 35.0,
                    //cacheExtent: 85.0,
                    children:[
                      
                   
                       Divider(),
                       subTitulos('Georefenciación',Icon(Icons.golf_course, color: Colors.white), 'geo', firebaseBloc),
                       
                       textFormDoble(latitud.isEmpty?'Latitud':latitud,
                                     'latitud',
                                      latitudController,
                                      longitud.isEmpty?'Longitud':longitud,
                                      'Longitud',
                                      longitudController,
                                      false),

                       Divider(color: Colors.black, height: 15.0),
                       subTitulos('Abscisas', Icon(Icons.gesture, color: Colors.white), '', firebaseBloc),
                      
                       textFormDoble(modificar?dato['abscisas']['inicial']:'Inicial',
                                     'Inicial', 
                                     abscisaInicialController,
                                     modificar?dato['abscisas']['final']:'Final',
                                     'Final',
                                     abscisaFinalController,
                                     false),
                      
                       Divider(color: Colors.black, height: 15.0),
                       subTitulos('Identificacion de Fotografia',Icon(Icons.photo_library, color: Colors.white), 'cajaEmpalme', firebaseBloc),
                      
                       textFormDoble(  modificar?dato['cajaEmpalme']['reserva']:'Reserva (Metros)',
                                       'Reserva (Metros)', 
                                       reservaController,
                                       modificar?dato['cajaEmpalme']['hilosIntervalo']:'Intervalo de Hilos',
                                       'Intervalo de Hilos',
                                       intervaloHilosController,
                                       false),
                      
                       textForm(cajaEmpalmeController,
                                'Id caja de empalme',
                                modificar?dato['cajaEmpalme']['idCajaEmpalme']:'Id caja de empalme',
                                true), 
                      
                       SizedBox(height: 10,),
                       fotografiaEvidenciaCajaEmpalme(context, firebaseBloc, 'cajaEmpalme'),
                       Divider(color: Colors.black, height: 15.0),
                       subTitulos('Fibra Optica',Icon(Icons.linear_scale, color: Colors.white), '', firebaseBloc),
                       
                       textFormDoble(modificar?dato['fibra']['span']:'Span',
                                     'Span',
                                     spanController,
                                     modificar?dato['fibra']['hilosCantidad']:'Cantidad de Hilos',
                                     'Cantidad de Hilos',
                                     cantidadHilosController,
                                     false),
                       
                       checkBoxDoble('Aerea:',checkBoxAerea, firebaseBloc.checkBoxAereaController,  'Canalizada', checkBoxCanalizada, firebaseBloc.checkBoxCanalizadaController),
                       
                       Divider(),
                       subTitulos('Materiales utilizados',Icon(Icons.linear_scale, color: Colors.white), '', firebaseBloc), 
                       SizedBox(height: 20,),
                       
                       textFormDoble(modificar?dato['materiales']['herrajeRetencion']:'Herraje de retención',
                                     'Herraje de retención', 
                                     herrajeRetencionController,
                                     modificar?dato['materiales']['herrajeSupension']:'Herraje de suspensión',
                                     'Herraje de suspensión',
                                     herrajeSuspensionController,
                                     false),
                       
                       textFormDoble(modificar?dato['materiales']['marquillas']:'Marquillas',
                                     'Marquillas', 
                                     marquillasController,
                                     modificar?dato['materiales']['amortiguador']:'Amortiguador',
                                     'Amortiguador',
                                     amortiguadorController,
                                     false),
                       
                       textFormDoble(modificar?dato['materiales']['brazoExtensor']:'Brazo extensor',
                                     'Brazo extensor', 
                                     brazoExtensorController,
                                     modificar?dato['materiales']['coronaCoil']:'Corona coil',
                                     'Corona coil',
                                     coronaCoilController,
                                     false),
                       
                       textForm(abrazaderaController,
                                'Abrazadera para poste collarin',
                                modificar?dato['materiales']['abrazaderaCollarin']:'Abrazadera para poste collarin',
                                false), 
                       
                       Divider(),
                       subTitulos('Caracteristica poste',Icon(Icons.linear_scale, color: Colors.white), '', firebaseBloc), 
                       SizedBox(height: 20,),
                       dropDownBottomDoble('Altura:',  alturaPostesID, firebaseBloc.alturaPostesIDController, dropDownAlturaPostes, '         Rotura:', firebaseBloc.resistenciaPostesIDController, resistenciaPostesID, dropDownResistenciaPostes,firebaseBloc),
                       Divider(),
                       dropDownBottomDoble('Tipo:', tipoPosteID, firebaseBloc.tipoPosteIDController, dropDownTipoPostes, 'Material:', firebaseBloc.materialPosteIDController, materialPosteID, dropDownMaterialPostes,firebaseBloc),
                       Divider(),
                       dropDownBottomDoble('Voltaje:', lineaTransmisionPosteID, firebaseBloc.lineaTransmisionPosteIdController, dropDownLineaTransmisionPostes, 'Estado:', firebaseBloc.estadoPostesIDController, estadoPostesID, dropDownEstadoPostes,firebaseBloc),
                       Divider(),
                       subTitulos('Proveedor de poste',Icon(Icons.linear_scale, color: Colors.white), 'proveedorPoste', firebaseBloc), 
                       SizedBox(height: 20,),
                       
                       textFormDoble(modificar?dato['proveedorPoste']['propietario']:'Propietario',
                                     'Propietario', 
                                     propietarioController,
                                     modificar?dato['proveedorPoste']['idPoste']:'Id poste',
                                     'Id poste',
                                     idPosteController,
                                     true),
                       
                       textForm(observacionesController,
                                'Observaciones',
                                modificar?dato['proveedorPoste']['observaciones']: 'Observaciones',
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
                    child: Text('Guardar'),
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
      
       textFormDoble(String textoModificado1, String texto1,TextEditingController controller1, String textoModificado2, String texto2, TextEditingController controller2, bool numeroText ) {
        return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
        return ListTile(
           contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
           title: Container(width: 20, height: 45,child: textForm(controller1,textoModificado1, texto1,numeroText)),
           trailing: Container(width: 180, height: 45,child: textForm(controller2,textoModificado2, texto2,numeroText))
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
        
    
       subTitulos(String subTitulo, Icon icono, String foto, FirebaseBloc firebaseBloc) {
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
                  
                    
                  trailing: foto=='geo'||foto=='proveedorPoste' || foto== 'cajaEmpalme' ?GestureDetector(
                    onTap: (){
                      if(foto=='geo'){
                         cargando=true;
                         getLocalization(firebaseBloc);  
                         
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
           
           
    
      TextFormField textForm(TextEditingController controller,String textoModificado, String label, bool numeroText) {
        return TextFormField(
                    keyboardType: numeroText?TextInputType.text:TextInputType.number,
                    decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8), 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    filled: false,
                    hintText: label,
                    labelText: modificar&&textoModificado!=''?textoModificado:label
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
                          if(opcionPosteId=='Detalles'){
                             Navigator.push(context, MaterialPageRoute(builder: (context)=> DetallesPoste(datos:dato[i])));
                             }
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
                           if(opcionPosteId=='Modificar'){
                             firebaseBloc.posteSeleccionadoController.sink.add(dato[i]);
                             firebaseBloc.idPosteController.sink.add(dato[i]['posteID']);
                             
                              modificar=true;
                              latitud=dato[i]['georeferenciacion']['latitud'];
                              longitud=dato[i]['georeferenciacion']['longitud'];

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
  if (latitud.isEmpty){
    latitud=latitudController.text;
  }
   if (longitud.isEmpty){
    longitud=longitudController.text;
  }

  //-------------------------------------------------------
   SharedPreferences prefs = await SharedPreferences.getInstance();
   estadoOrdenServicio= prefs.getString('estadoOs');
  //-------------------------------------------------------
  
  Map <String, dynamic>  cuantificarPostes= new Map();
  String posteNumero='';
  
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

  ordenesServicio
    .document(widget.numeroOrdenS)
    .collection('postes')
    .document(posteNumero)
    .setData({
       
        'posteID':posteNumero,
        'georeferenciacion'   : {'latitud': latitud, 'longitud': longitud},
        'abscisas'            : {'inicial':abscisaInicialController.text, 'final':abscisaFinalController.text},
        'mediaUrl'            : {'mediaUrlPoste': mediaUrlPoste, 'mediaUrlCajaEmpalme':mediaUrlCajaEmpalme},
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
        'timestamp'           : DateTime.now(),
        'proveedorPoste'      : {
                                'propietario':propietarioController.text,
                                'idPoste':idPosteController.text,
                                'observaciones':observacionesController.text
        } 
    }
    ); 

    Fluttertoast.showToast(
          msg: 'Los datos fueron guardados con exito!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 15,
          backgroundColor: Colors.grey
    );
  
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

 borrarVariables(FirebaseBloc firebaseBloc){
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
            
                 
        
     
     

   

     
     
            
        
      
       
               