import 'package:audicol_fiber/widgets/header.dart';
import 'package:audicol_fiber/widgets/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/tiposDeOS.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/agendaOs.dart';
import 'package:audicol_fiber/pages/configuracion_rutas.dart';
import 'package:jumping_bottom_nav_bar_flutter/jumping_bottom_nav_bar_flutter.dart';
import 'package:jumping_bottom_nav_bar_flutter/source/tab_icon.dart';

final inventario = Firestore.instance.collection('inventario');

// ignore: must_be_immutable
class SelectorPantalla extends StatefulWidget {
  String cliente;

  SelectorPantalla({this.cliente});
  @override
  _SelectorPantallaState createState() => _SelectorPantallaState();
}

class _SelectorPantallaState extends State<SelectorPantalla> {
  
  String tituloPagina='';
  int pageIndex = 0;
  DatosRedFibra datosRedFibra = DatosRedFibra();
  
   int selectedIndex = 1;

  final iconList = [
    TabIcon(
      // curveColor: Color(0xFFFFE6E6E6),
        iconData: Icons.assignment,
        startColor: Colors.white,
        endColor: Colors.white),
    TabIcon(
      // curveColor: Color(0xFFFFE6E6E6),
        iconData: Icons.settings,
        startColor: Colors.white,
        endColor: Colors.white),
    TabIcon(
      //curveColor: Color(0xFFFFE6E6E6),
        iconData: Icons.person,
        startColor: Colors.white,
        endColor: Colors.white),
  ];
  void onChangeTab(int index) {
    selectedIndex = index;
    print('entro onchange---$selectedIndex');
    setState(() {
      
    });
  }
  
  
  @override
  void initState() {
    super.initState();
    print('cliente:${widget.cliente}');
    print('indexPage$selectedIndex');
   
   /*  pageController = widget.cliente == null
        ? PageController(initialPage: 0)
        : PageController(initialPage: 2);
    if (widget.cliente == null) {
      pageIndex = 0;
    } else {
      pageIndex = 2;
    } */
   
  }

  @override
  Widget build(BuildContext context) {
    
    if(selectedIndex==1){
      tituloPagina='Agenda';
    }
      if(selectedIndex==2){
      tituloPagina='Ajustes';
    }
    if(selectedIndex==3){
      tituloPagina='Crear Orden';
    }

    return DefaultTabController(
      length: iconList.length,
      child: Scaffold(
          appBar: header(tituloPagina, context),
          drawer: Menu(),
          body: TabBarView(
            children: <Widget>[
              PantallaOrdenesServicio(),
              ResgistrarRuta(),
              CrearOS(),
            ],
          ),
          bottomNavigationBar: Jumping_Bar(
          color: Theme.of(context).accentColor,
          onChangeTab: onChangeTab,
          duration: Duration(seconds: 1),
          circleGradient: RadialGradient(
            colors: [
              Colors.blue[200],
           
               Colors.blue[200],
            ],
          ),
          items: iconList,
          selectedIndex: selectedIndex,
        ),
      )
    );
  }
}
            
         
              
             
           

  
