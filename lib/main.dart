import 'package:audicol_fiber/bloc/provider.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:audicol_fiber/pages/calculo_punto.dart';
//import 'package:audicol_fiber/pages/mapa_fiber.dart';
import 'package:audicol_fiber/pages/configuracion_rutas.dart';
import 'package:audicol_fiber/pages/registro_cliente.dart';
import 'package:audicol_fiber/pages/registro_reserva.dart';
import 'package:audicol_fiber/pages/registro_sangria.dart';
import 'package:audicol_fiber/pages/registro_vertices.dart';
//import 'package:audicol_fiber/pages/selector_pantalla.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/estudioPrefactibilidad.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/detallesOS.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/CrearOS.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/visualizarOs.dart';
//import 'package:audicol_fiber/provider/direcctionsProvider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
     // create: (BuildContext context) => DirectionProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: 'PantallaOrdenesServicio',
        routes: {
          //'mapa': (BuildContext context) => MapaRutas(),
          //'calculoCoordenada': (BuildContext context) => CalculoCoordenada(),
          'registroRutas': (BuildContext context) => ResgistrarRuta(),
          'registroVertices': (BuildContext context) => RegistrarVertice(),
          'registroReservas': (BuildContext context) => RegistrarReserva(),
          'registroSangrias': (BuildContext context) => RegistrarSangria(),
          //'SelectorPantalla': (BuildContext context) => SelectorPantalla(),
          'RegistroClientes': (BuildContext context) => RegistrarCliente(),
          'EstudioPrefactibilidad': (BuildContext context) => EstudioPrefactibilidad(),
          'CrearOS': (BuildContext context) => CrearOS(),
          'DetallesOSadicionFibra': (BuildContext context) => DetallesOSadicionFibra(),
          'PantallaOrdenesServicio': (BuildContext context) => PantallaOrdenesServicio(),

          
        },
      ),
    );
  }
}
