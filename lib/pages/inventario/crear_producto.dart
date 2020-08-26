
import 'dart:io';

import 'package:audicol_fiber/clases/tomarFoto.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';
import 'package:audicol_fiber/pages/selector_pantalla.dart';
import 'package:audicol_fiber/widgets/linearProgress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final StorageReference storageRef = FirebaseStorage.instance.ref();

class CrearProducto extends StatefulWidget {
 
  @override
  _CrearProductoState createState() => _CrearProductoState();
}

class _CrearProductoState extends State<CrearProducto> {

 TextEditingController codigoController = TextEditingController();
 TextEditingController nombreProductoController = TextEditingController();
 TextEditingController descripcionProductoController = TextEditingController();
 TextEditingController existenciaController = TextEditingController();
 TextEditingController valorProductoController = TextEditingController();
 File file;
 String productoId= Uuid().v4();
 bool isUploading= false;
 final picker = ImagePicker();

  TomarFoto takePhoto=  TomarFoto();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         iconTheme: CupertinoIconThemeData(color: Colors.grey),
         title: Center(
           child: Text(
                'Agregar producto Inventario',
                 style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey[400]
                  )
               
        ),
         ), 
        backgroundColor: Colors.white24,
        elevation: 0.0,
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.camera_alt,size: 30.0, color: Colors.blue,),
              onPressed: ()=> selectImage(context),
            )
        ],
      ),
      body: ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 10,right:10),
      //physics: ScrollPhysics(),
        children: <Widget>[
          //SizedBox(height: 20),
         isUploading ? linearProgress(context) : Text(''),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hoverColor:Colors.red,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                //filled: false,
                hintText: 'Codigo de 4 digitos',
                labelText: 'Codigo del producto'),
            controller: codigoController,
          ),
          SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.number,
            
            decoration: InputDecoration(
              hoverColor: CupertinoColors.activeBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                //filled: false,
                hintText: 'Ingresar el nombre del producto',
                labelText: 'Producto'),
            controller: nombreProductoController,
          ),
          SizedBox(height: 20),
           TextFormField(
            keyboardType: TextInputType.number,
            
            decoration: InputDecoration(
                hoverColor: Theme.of(context).hoverColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                //filled: false,
                hintText: 'Ingrese la cantidad inicial',
                labelText: 'Cantidad'),
            controller: existenciaController,
          ),
          SizedBox(height: 20),
           
           TextFormField(
            keyboardType: TextInputType.number,
            
            decoration: InputDecoration(
                //hoverColor: Colors.brown,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                //filled: false,
                hintText: 'Ingrese el valor del producto',
                labelText: 'Precio'),
            controller: valorProductoController,
          ),
          SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.text,
            maxLines: 2,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                //filled: false,
                hintText: 'Descripcion del producto',
                labelText: 'Descripción '),
            controller: descripcionProductoController,
          ),
          SizedBox(height: 10),
          
          tomarFoto(),
          botonCrear()
         
       
        ],
      ),
    );
  }

  GestureDetector tomarFoto() {
    return GestureDetector(
              onTap: (){
                selectImage(context);
              },
              child: Container(
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
              ),
            );
  }
                      

   Widget botonCrear() {
    print('--------$isUploading--------------');

    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          color: Colors.blueAccent.withOpacity(0.5),
          elevation: 15,
          child: Text('Crear'),
          onPressed: file==null ? null :  () => handleSubmit() ,
        )
      ],
    );
  }

 

 
   handleSubmit() async{
  
  if (codigoController.text.isNotEmpty || nombreProductoController.text.isNotEmpty ||
    existenciaController.text.isNotEmpty ||  valorProductoController.text.isNotEmpty ||
    descripcionProductoController.text.isNotEmpty || file==null ) {
 
    setState(() {
     isUploading= true;
    });

    file= await takePhoto.compressImage(file);
    String mediaUrl = await takePhoto.uploadImage(file);
     createPostInFirestore(
      mediaUrl: mediaUrl,
      codigoProducto: codigoController.text,
      nombreProducto: nombreProductoController.text,
      existenciaProducto: existenciaController.text,
      valorProducto: valorProductoController.text,
      descripcionProducto: descripcionProductoController.text,
    );

     }else {
     String mensaje='';
     if (file==null){
       mensaje='Tome una foto al producto';
     }else{
       mensaje='LLene todo los campos';
     }

      Fluttertoast.showToast(
          msg: mensaje,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 20,
          backgroundColor: Colors.grey);
    }

    }

  handleTakePhoto() async {
    
    file= await takePhoto.getFoto(context);
    setState((){ }); 
  }  
    

  handleChooseFromGallery()async{
     file = await takePhoto.getGallery(context);
     setState((){ });
  }    
        
  createPostInFirestore({mediaUrl,codigoProducto,nombreProducto, existenciaProducto,valorProducto,descripcionProducto}){
       
    inventario
    .document('productos')
    .collection('productoA')
    .document(productoId)
    .setData({

        'productoId'          : productoId,
        'codigoProducto'      : codigoProducto,
        'mediaUrl'            : mediaUrl,
        'nombreProducto'      : nombreProducto,
        'existenciaProducto'  : existenciaProducto,
        'revisado'            : true,
        'valorProducto'       : valorProducto,
        'timestamp'           : DateTime.now(),
        'descripcionProducto' : descripcionProducto
    }
    );

    Fluttertoast.showToast(
          msg: 'El producto fue guardado con exito!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 10,
          backgroundColor: Colors.grey);


    codigoController.clear();
    nombreProductoController.clear();
    descripcionProductoController.clear();
    existenciaController.clear();
    valorProductoController.clear();
  
         

    setState(() {
      file=null;
      isUploading=false;
      productoId= Uuid().v4();
      //Navigator.pop(context);
    });


  
 }

 clearImage(){
    setState(() {
      file= null;
    });
  }

   
  
 


  selectImage(parentContext){
    return showDialog(
      context: parentContext,
      builder: (context){
        return SimpleDialog(
          title: Text('Crear Post'),
          children: <Widget>[
            SimpleDialogOption(
               child: Text('Foto de Camara'),
               onPressed: handleTakePhoto
            ),
            SimpleDialogOption(
               child: Text('Imagen de Galeria'),
               onPressed: handleChooseFromGallery,
            ),
            SimpleDialogOption(
               child: Text('Cancelar'),
               onPressed: ()=> Navigator.pop(context),
            ),
          ],
        );
      }

    );
  }
 
}