import 'package:audicol_fiber/pages/calculo_punto.dart';
import 'package:audicol_fiber/pages/mapa_fiber.dart';
import 'package:audicol_fiber/pages/configuracion_rutas.dart';
import 'package:audicol_fiber/pages/registro_cliente.dart';
import 'package:audicol_fiber/pages/registro_reserva.dart';
import 'package:audicol_fiber/pages/registro_sangria.dart';
import 'package:audicol_fiber/pages/registro_vertices.dart';
import 'package:audicol_fiber/pages/selector_pantalla.dart';
import 'package:audicol_fiber/provider/direcctionsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DirectionProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: 'SelectorPantalla',
        routes: {
          'mapa': (BuildContext context) => MapaRutas(),
          'calculoCoordenada': (BuildContext context) => CalculoCoordenada(),
          'registroRutas': (BuildContext context) => ResgistrarRuta(),
          'registroVertices': (BuildContext context) => RegistrarVertice(),
          'registroReservas': (BuildContext context) => RegistrarReserva(),
          'registroSangrias': (BuildContext context) => RegistrarSangria(),
          'SelectorPantalla': (BuildContext context) => SelectorPantalla(),
          'RegistroClientes': (BuildContext context) => RegistrarCliente(),
        },
      ),
    );
  }
}
