import 'package:audicol_fiber/bloc/login_bloc.dart';
import 'package:audicol_fiber/bloc/provider.dart';
import 'package:audicol_fiber/pages/selector_pantalla.dart';
import 'package:audicol_fiber/provider/Usuario_Validacion.dart';
import 'package:audicol_fiber/utils/utils.dart';
import 'package:audicol_fiber/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CrearUsuario extends StatefulWidget {

  @override
  _CrearUsuarioState createState() => _CrearUsuarioState();
}

class _CrearUsuarioState extends State<CrearUsuario> {
  final usuarioProvider = new UsuarioProvider();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController celularController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
 

  static const rolesMenu = [
    'Jefe de cuadrilla',
    'Coordinador',
    'Auditor',
    'Jefe de inventario',
   ];

  final List<DropdownMenuItem<String>> dropDownMenuItems = rolesMenu
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.grey[600]
            )),
          ))
      .toList();
  String roleId = 'Auditor';

  
  static const cuadrillasMenu = [
    '1',
    '2',
    '3',
    '4',
   ];

  final List<DropdownMenuItem<String>> dropDownMenuNumeroCuadrillas = cuadrillasMenu
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.grey[600]
            )),
          ))
      .toList();
  String numeroCuadrillaId = '1';

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header('Crear nuevo usuario', context,''),
       body: _loginForm(context),     
    );

   
  }

    Widget _loginForm(BuildContext context) {
      final bloc = Provider.of(context);  
      final size = MediaQuery.of(context).size;
      print('role  $roleId');
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
             Center(
              child: Container(
                width: size.width* 0.95,
                height:size.height* 0.95, 
                //margin: EdgeInsets.symmetric(vertical:50.0),
                //padding: EdgeInsets.symmetric(vertical:50.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0
                    ),
                  ]
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    nombreUsuario(),
                    apellidosUsuario(),
                    celularUsuario(),
                    _crearEmail(bloc),
                      SizedBox(height: 10.0),
                    _crearPassword(bloc),
                      SizedBox(height: 20.0),
                     role(),
                     SizedBox(height: 10.0),
                    roleId=='Jefe de cuadrilla'?numeroCuadrilla():Container(),  
                    SizedBox(height: 30.0),
                    _crearBoton(bloc),
                   
                    
                  ],
                ),
              ),
            ),
          ],
        ) ,
      );
    }


                
          
          


    Widget nombreUsuario(){

      return Container(
                padding: EdgeInsets.symmetric(horizontal:20.0),
                child: TextField(
                         controller: nombresController,
                         keyboardType: TextInputType.text,
                         decoration: InputDecoration(
                         icon: Icon(Icons.arrow_forward, color:Colors.deepPurple),
                         hintText: 'Carlos Arturo',
                         labelText: 'Nombres',
                         //counterText: snapshot.data,
                         //errorText: snapshot.error,
                         ),
                         onChanged: (value) {
                           print(value);
                          if(value.isEmpty){
                            apellidosController.clear();
                          }
                    },
                ) ,
               
            );
     
    
   }

   Widget apellidosUsuario(){

      return Container(
                padding: EdgeInsets.symmetric(horizontal:20.0),
                child: TextField(
                         controller: apellidosController,
                         keyboardType: TextInputType.text,
                         decoration: InputDecoration(
                         icon: Icon(Icons.arrow_forward, color:Colors.deepPurple),
                         hintText: 'Naranjo Restrepo',
                         labelText: 'Apellidos',
                         //counterText: snapshot.data,
                         //errorText: snapshot.error,
                         ),
                         onChanged: (value) {
                          if(value.isEmpty){
                            apellidosController.clear();
                          }
                    },
                ) ,
               
            );
   } 

   Widget celularUsuario(){

      return Container(
                padding: EdgeInsets.symmetric(horizontal:20.0),
                child: TextField(
                         controller: celularController,
                         keyboardType: TextInputType.number,
                         decoration: InputDecoration(
                         icon: Icon(Icons.settings_phone, color:Colors.deepPurple),
                         hintText: '3012345673',
                         labelText: 'Celular',
                         //counterText: snapshot.data,
                         //errorText: snapshot.error,
                         ),
                    onChanged: (value) {
                      if(value.isEmpty){
                        celularController.clear();
                      }
                    },
                ) ,
               
            );
     
    
   }   

   Widget _crearEmail(LoginBloc bloc){

    return StreamBuilder(
       stream: bloc.emailStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
            return Container(
                padding: EdgeInsets.symmetric(horizontal:20.0),
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                        decoration: InputDecoration(
                         icon: Icon(Icons.alternate_email, color:Colors.deepPurple),
                         hintText: 'ejemplo@correo.com',
                         labelText: 'Correo electrónico',
                         //counterText: snapshot.data,
                         //errorText: snapshot.error,
                         ),
                   onChanged: (value) => bloc.changeEmail(value),
                ) ,
               
            );
      },
     );
    
   }

Widget _crearPassword(LoginBloc bloc){
  return StreamBuilder(
    stream: bloc.passwordStream ,
    
    builder: (BuildContext context, AsyncSnapshot snapshot){
      return Container(
       padding: EdgeInsets.symmetric(horizontal:20.0),
       child: TextField(
         obscureText:  true,
         controller: passwordController,
         decoration: InputDecoration(
           icon: Icon(Icons.lock_outline, color:Colors.deepPurple),
           labelText: 'Contraseña',
           //counterText: snapshot.data,
           //errorText: snapshot.error,
         ),
         onChanged: bloc.changePassword,
       ) ,
     );  
    },
  );
     
   }

 

  Widget _crearBoton(LoginBloc bloc){

     return StreamBuilder(
             stream: bloc.formValidStream ,
             builder: (BuildContext context, AsyncSnapshot snapshot){
               return RaisedButton(
                   child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                      child: Text('Ingresar'),
                    ),
              shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)
                      ),
                    elevation: 0.0,   
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                    onPressed: snapshot.hasData ? () => _register(bloc, context) : null,
          );
       },
     );

  }  

    _register(LoginBloc bloc, BuildContext context) async {
      if(nombresController.text.isNotEmpty&& apellidosController.text.isNotEmpty&&celularController.text.isNotEmpty){
         final info = await usuarioProvider.nuevoUsuario(bloc.email, bloc.password);
      
         if (info['ok']){
         // Navigator.pushReplacementNamed(context, 'LoginPage');
          usuarios.
           document(info['id']).
           setData({
           'nombres'          : nombresController.text,
           'apellidos'        : apellidosController.text,
           'celular'          : celularController.text,
           'cargo'            : roleId,
           'numeroCuadrilla'  : roleId.contains('cuadrilla')?numeroCuadrillaId:'',
           'correo'           : info['correo']
        });   

            nombresController.clear();
            apellidosController.clear();
            celularController.clear();
            bloc.emailController.sink.add(null);
            bloc.passwordController.sink.add(null);
            emailController.clear();
            passwordController.clear();
             mensajePantalla('Registro de usuario exitoso!');
           }else{
           mostrarAlerta(context, info['mensaje']);
            }
        // print(info['id']);   
 
       
      }else{
        mensajePantalla('LLene todo los campos!');
      }
       


    }
 void mensajePantalla(String mensaje) {
   Fluttertoast.showToast(
          msg: mensaje,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          fontSize: 15,
          backgroundColor: Colors.grey
    );  
 }
 Widget role() {
    return  ListTile(
              contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
              leading: Icon(Icons.adjust,color:Colors.deepPurple),
              title: Text('Seleccione el cargo:',style: Theme.of(context).textTheme.headline1,),
              trailing: DropdownButton(
                value: roleId,
                onChanged: (String newValue) {
                  setState(() {
                    roleId = newValue;
                  });
                },
                items: this.dropDownMenuItems,
              ),
            );
  }

  Widget numeroCuadrilla() {
      return  ListTile(
              contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
              leading: Icon(Icons.format_list_numbered,color:Colors.deepPurple),
              title: Text('Numero de cuadrilla:',style: Theme.of(context).textTheme.headline1),
              trailing: DropdownButton(
                value: numeroCuadrillaId,
                onChanged: (String newValue) {
                  setState(() {
                    numeroCuadrillaId = newValue;
                  });
                },
                items: this.dropDownMenuNumeroCuadrillas,
              ),
            );
  }
}