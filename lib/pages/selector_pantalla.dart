import 'package:audicol_fiber/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:audicol_fiber/bloc/peticiones_firebase.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/tiposDeOS.dart';
import 'package:audicol_fiber/pages/Ordenes_Servicio/agendaOs.dart';
import 'package:audicol_fiber/pages/configuracion_rutas.dart';




// ignore: must_be_immutable
class SelectorPantalla extends StatefulWidget {
  String cliente;

  SelectorPantalla({this.cliente});
  @override
  _SelectorPantallaState createState() => _SelectorPantallaState();
}

class _SelectorPantallaState extends State<SelectorPantalla> {
  
  PageController pageController;
  int pageIndex = 0;
  DatosRedFibra datosRedFibra = DatosRedFibra();
  
  
  @override
  void initState() {
    super.initState();
    print('cliente:${widget.cliente}');
    pageController = widget.cliente == null
        ? PageController(initialPage: 0)
        : PageController(initialPage: 2);
    if (widget.cliente == null) {
      pageIndex = 0;
    } else {
      pageIndex = 2;
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header('', context),
        drawer: _crearMenu(),
        body: PageView(
          
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            PantallaOrdenesServicio(),
            ResgistrarRuta(),
            CrearOS(),
            
           
          ],
          controller: pageController,
          onPageChanged: cuandoPaginaCambie,
        ),
        bottomNavigationBar: _bottomNavigationBar(context));
  }

  Drawer _crearMenu() {
    
    final drawerHeader= UserAccountsDrawerHeader(
     
      accountName: Text('usuario'),
      accountEmail: Text('usuario@audicol.com'),
      currentAccountPicture:Container(
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
  }
}
