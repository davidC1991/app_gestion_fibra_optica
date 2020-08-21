import 'package:audicol_fiber/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/tiposDeOS.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/agendaOs.dart';
import 'package:audicol_fiber/pages/configuracion_rutas.dart';
import 'package:jumping_bottom_nav_bar_flutter/jumping_bottom_nav_bar_flutter.dart';
import 'package:jumping_bottom_nav_bar_flutter/source/tab_icon.dart';



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
          drawer: _crearMenu(context),
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
            
         
              
             
           

  Drawer _crearMenu(BuildContext context) {
    
    final drawerHeader= UserAccountsDrawerHeader(
     
      accountName: Text('Jesus David Callejas C.', style: TextStyle(color:Theme.of(context).accentColor, fontWeight: FontWeight.bold, fontSize: 15.0  ),),
      accountEmail: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ingeniero Electrónico'),
          Text('CallejasDavid@audicol.com'),
        ],
      ),
      currentAccountPicture:Container(
        margin: EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        //padding: EdgeInsets.only(bottom: 40.0),
        decoration: BoxDecoration(
          //color: new Color(0xFF0062ac),
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
             image: AssetImage('assets/audicol.PNG'),
             fit: BoxFit.cover 
          )
        ),      
      )
       
        
      
    ); 
    return Drawer(
      
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
         drawerHeader
        ],
      ),
    );
  }

             
              
/* 
  Widget _bottomNavigationBar(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor,
          primaryColor: Theme.of(context).accentColor,
          textTheme: Theme.of(context).textTheme.copyWith(
              caption: TextStyle(color: Theme.of(context).cursorColor))),
      child: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: onTapChangePage,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.toll, size: 30.0), title: Text('Agregar')),
          BottomNavigationBarItem(
              icon: Icon(Icons.pan_tool, size: 30.0), title: Text('Ajustes')),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle, size: 30.0),
              title: Text('Clientes'))
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  cuandoPaginaCambie(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
    // print('pagina actual: $pageIndex');
  }

  onTapChangePage(int pageIndex) {
    //pageController.jumpToPage(pageIndex);
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 200), curve: Curves.decelerate);
  } */
}
