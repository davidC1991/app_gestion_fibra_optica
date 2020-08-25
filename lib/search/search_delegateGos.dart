import 'package:audicol_fiber/bloc/dbBloc.dart';
import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/GestionOs.dart';
import 'package:audicol_fiber/pages/selector_pantalla.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataSearch_OS extends SearchDelegate {
  String seleccion = '';
  DatosRedFibra datosRedFibra = new DatosRedFibra();
  FirebaseBloc firebaseBloc = FirebaseBloc();
  @override
  List<Widget> buildActions(BuildContext context) {
    // las acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //son las sugerencias que aparecen cuando la persona escribe

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: datosRedFibra.getListaProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
           List<String> listaItem= new List();
          //final cliente = snapshot.data;
           final datos=snapshot.data;
           for (var item in datos) {
             listaItem.add(item.data['nombreProducto']);
           }
            
          
          final clientesFiltrados =
              listaItem.where((c) => c.toLowerCase().startsWith(query)).toList();
          //print('clientesFiltrados: $clientesFiltrados');
          return ListView(
              children: clientesFiltrados.map((item) {
               
            return ListTile(
              /*  leading: FadeInImage(
              image: NetworkImage(pelicula.getPosterImg(),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              width: 50.0,
              fit: BoxFit.contain,
            ), */
              title: Text(item),
              //subtitle: Text(),
              onTap: () {
                close(context, null);
                int i= listaItem.indexWhere((element) => element==item);
                print('------>i$i');
                //firebaseBloc.itemsSeleccionadosController.sink.add(datos[i]);
               firebaseBloc.getItemsSeleccionados(item);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GestionOrdenServicio(item:item, datos:datos[i])));

                //Navigator.pop(context);
              },
            );
          }).toList());
        } else {
          print('hola');
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
