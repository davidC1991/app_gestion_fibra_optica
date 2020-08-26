

import 'dart:io';

import 'package:audicol_fiber/pages/inventario/crear_producto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// ignore: camel_case_types
class TomarFoto{
  
 // ignore: non_constant_identifier_names
 File file_path;
 String productoId= Uuid().v4();
 bool isUploading= false;
 final picker = ImagePicker();

 Future<File> getFoto(BuildContext context)async {
     Navigator.pop(context);
     final file = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    file_path=File(file.path);
    return file_path;
 }

 Future<File> getGallery(BuildContext context) async {
    Navigator.pop(context);
    final file = await picker.getImage(source: ImageSource.gallery);
    file_path=File(file.path);
    return file_path;
 }

 Future<File>compressImage(File file)async{
    
    final tempDir = await getTemporaryDirectory();
    print('file--------------3---------------->$file');
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile= File('$path/img_$productoId.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile,quality: 85));
    file=compressedImageFile;
    return file;
  }
 
Future<String> uploadImage(File imageFile) async{
   StorageUploadTask uploadTask = storageRef.child('post_$productoId.jpg').putFile(imageFile);
   StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
   String downloadUrl = await storageSnap.ref.getDownloadURL();
   return downloadUrl;
 }
   
       
 

}