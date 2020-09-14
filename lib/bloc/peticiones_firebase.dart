import 'package:audicol_fiber/pages/selector_pantalla.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audicol_fiber/pages/calculo_punto.dart';
import 'package:geo/geo.dart' as geo;
import 'package:shared_preferences/shared_preferences.dart';

class DatosRedFibra {
  
  
  getGestionOsPostes(String numeroOs)async{
    List<DocumentSnapshot> vacio= new List();
    print('-------postes detalles--------');
      QuerySnapshot snapshot= await ordenesServicio.document(numeroOs).
                            collection('postes').orderBy('timestamp', descending: false).
                            getDocuments();
    if(snapshot.documents.isEmpty){
      
      ordenesServicio
          .document(numeroOs)
          .updateData({
            'Estado': 'No iniciada',
          });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('estadoOs', 'No iniciada');      
      vacio=[];
      return vacio;
    }
    print(snapshot.documents[0].documentID);
    
     return snapshot.documents; 
  }
 
  Future <Map <String, dynamic>> getNumeroPoste(String numeroOs, bool eliminar)async{
    
    List<String> listaPostes= new List();
    String posteNumero=''; 
    int numero=0; 
     QuerySnapshot snapshot= await ordenesServicio.document(numeroOs).get().then((value)  {
       print(value.data);
       List long=value.data['postes'];
       posteNumero=value.data['postes'][long.length-1];
       
       posteNumero=posteNumero.substring(6);
       if(eliminar){
        numero= int.parse(posteNumero);   
       for (var i = 0; i < long.length; i++) {
        listaPostes.add(long[i]);
       }
       }else{
          numero= int.parse(posteNumero)+1;
          posteNumero= numero.toString();
          print('poste-->$posteNumero'); 
        for (var i = 0; i < numero; i++) {
          listaPostes.add('poste-${i+1}');
        }
       }

      

       /* print(value.data);
       List long=value.data['postes'];

       for (var i = 0; i < long.length; i++) {
         listaPostes.add('poste-${i+1}');
       }
      
       if(eliminar){
        
       }else{
       posteNumero=listaPostes[listaPostes.length-1];
       posteNumero=posteNumero.substring(6);
       numero= int.parse(posteNumero)+1;
       posteNumero= numero.toString();
       listaPostes.add('poste-'+ posteNumero); 
       }
 */       

       
       
     });
    
     print(listaPostes);

     return {'listaPostes':listaPostes, 'posteActual':posteNumero};
   }

   getOrdenesServicio()async{

     List<DocumentSnapshot> oSs= new List();
      QuerySnapshot snapshot = await ordenesServicio.getDocuments(); 
    // print(snapshot.documents[0].data);
      oSs=snapshot.documents;
      return oSs;
   }

    getDatosUsuario(String id)async{

      DocumentSnapshot datos;
       await usuarios.document(id).get().then((value) {
                       datos=value; 
                       //print(datos.data);
                     }); 
    return datos.data;
     
   }
           
  Future<String> getUltimoNumueroOrdenes()async{
    String ultimoNumeroOrden='';
    QuerySnapshot snapshot= await ordenesServicio.getDocuments();

    if(snapshot.documents.length==0){
      return '00000';
    }
    ultimoNumeroOrden=snapshot.documents[snapshot.documents.length-1].documentID;

    int numeroOs= int.parse(ultimoNumeroOrden)+1;
    print('numeroOs: $numeroOs');

    if(numeroOs>9){
      ultimoNumeroOrden='000' + numeroOs.toString();
    }else if(numeroOs>99){
      ultimoNumeroOrden='00' + numeroOs.toString();
    }else if(numeroOs>999){
      ultimoNumeroOrden='0' + numeroOs.toString();
    }else{
      ultimoNumeroOrden='0000' + numeroOs.toString();
    }
    /* if(snapshot.documents.length==1){
      ultimoNumeroOrden=snapshot.documents[0].documentID;
    }else{ */
        //}
    print(ultimoNumeroOrden);
    return ultimoNumeroOrden;
  }  
    

      



  Future<List<String>> getCliente() async {
    QuerySnapshot snapshot = await clientes.getDocuments();
    List<String> clientesList = new List();

    for (var i = 0; i < snapshot.documents.length; i++) {
      clientesList.add(snapshot.documents[i].documentID);
    }

    //print(snapshot.documents[0].documentID);
    //return snapshot.documents;
    return clientesList;
  }

  // ignore: missing_return
  getClienteAux(String query) async {
    Map<String, Object> datosClientes = new Map();
    QuerySnapshot snapshot = await clientes.document(query).get().then((value) {
      // value.data['nombre'];
      // print('----');
      value.data.forEach((key, value) {
        datosClientes[key] = value;
      });
      //print(datosClientes);
      if (value.exists) {
        /*  for (var i = 0; i < value.data.length; i++) {
          materiasYcursos[b.data['cursoInd'][i]] = b.data['curso'][b.data['cursoInd'][i]];
        } */
      }
    }).catchError((error) {});
    return datosClientes;
  }

  getVertices(List<dynamic> rutasCliente) async {
    // QuerySnapshot snapshot = await rutas.getDocuments();
    QuerySnapshot snapshot;

    List<DocumentSnapshot> listVertices = new List();
    // ignore: missing_return
    //QuerySnapshot snapshot = await rutas.getDocuments();

    for (var i = 0; i < rutasCliente.length; i++) {
      // print('uno');
      snapshot = await rutas
          .document(rutasCliente[i])
          .collection('muflas')
          .getDocuments();
      for (var i = 0; i < snapshot.documents.length; i++) {
        listVertices.add(snapshot.documents[i]);
      }
    }

    //print('longitud de la cantidad de rutas: ${listVertices.length}');
    // print(listVertices[0].data);
    //print(snapshot.documents[0].data[snapshot.documents[0].documentID]['latitud']);
    //print(snapshot.documents);
    return listVertices;
  }

  getReservas(List<dynamic> rutasCliente) async {
    QuerySnapshot snapshot;
    print('------CREANDO EL VECTOR DE RESERVAS-------');
    List<DocumentSnapshot> listReservas = new List();

    for (var i = 0; i < rutasCliente.length; i++) {
      print('n');
      snapshot = await rutas
          .document(rutasCliente[i])
          .collection('reservas')
          .getDocuments()
          .catchError((onError) {
        print('error en reserva, no existe para la ruta ${rutasCliente[i]}');
      });
      //print('snapshot $i : ${snapshot.documents}');
      for (var i = 0; i < snapshot.documents.length; i++) {
        listReservas.add(snapshot.documents[i]);
      }
    }

    if (listReservas == null) {
      return [];
    }
    //print('longitud de la cantidad de rutas: ${listVertices.length}');

    //print(snapshot.documents[0].data[snapshot.documents[0].documentID]['latitud']);
    return listReservas;
  }

  getItemInventario()async{
     QuerySnapshot snapshot = await inventario
        .document('productos')
        .collection('productoA')
        .getDocuments();

        print('snapshot: ${snapshot.documents[0].data}');
        return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> getListaProductos()async{

     QuerySnapshot snapshot = await inventario
        .document('productos')
        .collection('productoA')
        .getDocuments();
       
     
        return snapshot.documents;
  }
       
          
        
     

  getSangria(String cliente, List<dynamic> rutasCliente, String sangria) async {
    QuerySnapshot snapshot;
    print('');
    print('');
    print(
        '------CREANDO LA LISTA DE VERTICES DE LA SANGRIA DEL CLIENTE: $cliente -------');
    List<DocumentSnapshot> listVerticesSangria = new List();

    snapshot = await rutas
        .document(rutasCliente[rutasCliente.length - 1])
        .collection('sangrias')
        .document(sangria)
        .collection(cliente)
        .getDocuments()
        .catchError((onError) {
      print('error en la la sangria: $onError');
    });

    if (snapshot == null) {
      return [];
    }

    for (var i = 0; i < snapshot.documents.length; i++) {
      listVerticesSangria.add(snapshot.documents[i]);
    }

    //print(listVerticesSangria);

    return listVerticesSangria;
  }

  // ignore: missing_return
  Future<List<String>> codificarRutas() async {
    QuerySnapshot _rutas = await rutas.getDocuments();
    List<QuerySnapshot> listVertices = new List();
    print(_rutas.documents);
    List<geo.LatLng> listLatLng = List();
    geo.LatLng coordenada;
    double lat;
    double lng;
    String encode;

    for (var i = 0; i < _rutas.documents.length; i++) {
      QuerySnapshot vertices = await rutas
          .document(_rutas.documents[i].documentID)
          .collection('muflas')
          .getDocuments();
      print('ruta : ${_rutas.documents[i].documentID} ---------');
      listLatLng.clear();
      for (var j = 0; j < vertices.documents.length; j++) {
        lat = vertices.documents[j].data['latitud'];
        lng = vertices.documents[j].data['longitud'];
        coordenada = geo.LatLng(lat, lng);
        listLatLng.add(coordenada);
      }

      encode = const geo.PolylineCodec().encode(listLatLng);

      rutas
          .document(_rutas.documents[i].documentID)
          .setData({'polyline': encode});
      print(encode);
    }

 
  


    
 
  }
}
