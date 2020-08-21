import 'package:audicol_fiber/bloc/provider.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/formularioOS_adicionFibra.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/tiposDeOS.dart';
import 'package:audicol_fiber/pages/selector_pantalla.dart';
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


import 'package:audicol_fiber/pages/Ordenes_Servicio/agendaOs.dart';
//import 'package:audicol_fiber/provider/direcctionsProvider.dart';

Map<int, Color> color =
{
50:Color.fromRGBO(136,14,79, .1),
100:Color.fromRGBO(136,14,79, .2),
200:Color.fromRGBO(136,14,79, .3),
300:Color.fromRGBO(136,14,79, .4),
400:Color.fromRGBO(136,14,79, .5),
500:Color.fromRGBO(136,14,79, .6),
600:Color.fromRGBO(136,14,79, .7),
700:Color.fromRGBO(136,14,79, .8),
800:Color.fromRGBO(136,14,79, .9),
900:Color.fromRGBO(136,14,79, 1),
};

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

MaterialColor colorAppBar = MaterialColor(0xFFFFAFAFA, color);
MaterialColor colorPickEnable = MaterialColor(0xFFFF6C63FF, color);
MaterialColor colorPickDisable = MaterialColor(0xFFFFE6E6E6, color);

  @override
  Widget build(BuildContext context) {
    return Provider(
     // create: (BuildContext context) => DirectionProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        
        theme: ThemeData(
           
          primaryColor: colorAppBar,
          //primarySwatch: Colors.blue,
          //bottomAppBarColor: Colors.yellow,
          buttonColor: Colors.red,
          accentColor: colorPickEnable,
          cursorColor: colorPickDisable,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: 'SelectorPantalla',
        routes: {
          //'mapa': (BuildContext context) => MapaRutas(),
          //'calculoCoordenada': (BuildContext context) => CalculoCoordenada(),
          'registroRutas': (BuildContext context) => ResgistrarRuta(),
          'registroVertices': (BuildContext context) => RegistrarVertice(),
          'registroReservas': (BuildContext context) => RegistrarReserva(),
          'registroSangrias': (BuildContext context) => RegistrarSangria(),
          'SelectorPantalla': (BuildContext context) => SelectorPantalla(),
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
