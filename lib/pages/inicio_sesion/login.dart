
import 'package:flutter/material.dart';
import 'package:audicol_fiber/bloc/login_bloc.dart';
import 'package:audicol_fiber/bloc/provider.dart';
import 'package:audicol_fiber/pages/selector_pantalla.dart';
import 'package:audicol_fiber/provider/Usuario_Validacion.dart';
import 'package:audicol_fiber/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatelessWidget {

  final usuarioProvider = UsuarioProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Stack(
         children: <Widget> [
           _crearFondo(context),
           _loginForm(context),
           
         ],
       ),     
    );

   
  }

    Widget _loginForm(BuildContext context) {
      final bloc = Provider.of(context);  
      final firebaseBloc  = Provider.firebaseBloc(context);
      final size = MediaQuery.of(context).size;

      return SingleChildScrollView(
        child: Column(
          children: <Widget>[

            SafeArea(
              child: Container(
                height: 180.0 
              ),
            ),
            Container(
              width: size.width* 0.85,
              margin: EdgeInsets.symmetric(vertical:50.0),
              padding: EdgeInsets.symmetric(vertical:50.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 2.0),
                  spreadRadius: 3.0
                  ),
                ]
              ),
              child: Column(
                children: <Widget>[
                  Text('Ingreso',style: TextStyle(fontSize:20.0)),
                  SizedBox(height: 60.0),
                  _crearEmail(bloc),
                    SizedBox(height: 30.0),
                  _crearPassword(bloc),
                    SizedBox(height: 60.0),
                  _crearBoton(bloc,firebaseBloc),
                ],
              ),
            ),
          

            FlatButton(
              child: Text('Crear una nueva cuenta'),
              onPressed: ()=> Navigator.pushReplacementNamed(context, 'RegistroPage'),
              ), 
            Text('Santa Marta D.T.C.H', style: Theme.of(context).textTheme.headline1),  
            SizedBox(height: 100.0,) 

          
          ],
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
         decoration: InputDecoration(
           icon: Icon(Icons.lock_outline, color:Colors.deepPurple),
           labelText: 'Contraseña',
          // counterText: snapshot.data,
          // errorText: snapshot.error,
         ),
         onChanged: bloc.changePassword,
       ) ,
     );  
    },
  );
     
   }

   Widget _crearFondo(BuildContext context){
      
      final size= MediaQuery.of(context).size;
      final fondoMorado= Container(
        height: size.height*0.4,
        width: double.infinity,
        decoration: BoxDecoration(
         
           gradient: LinearGradient(
            colors: <Color>[
              Theme.of(context).accentColor,
              Color.fromRGBO(63, 63, 156, 1.0),
              Color.fromRGBO(90, 70, 100, 1.0),
            ]
             ) 
        ),
      );
      
      final circulo = Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255,255,255,0.05)
        ),
      );

      return Stack(
        children: <Widget>[
          fondoMorado,
          Positioned(top: 30.0,left: 80.0,child: circulo),
          Positioned(top: -20.0, right: -60.0,child: circulo),
          Positioned(bottom: 570.0,left: -40.0,child: circulo),
          Positioned(bottom: 500.0, right: 20.0,child: circulo),
          Container(
            padding:  EdgeInsets.only(top: 80.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 120,
                  decoration: BoxDecoration(
                    image:DecorationImage(
                      image: AssetImage('assets/audicol.PNG'),
                      fit: BoxFit.cover  
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  ),
                  SizedBox(height:10.0, width: double.infinity),
                 Text('AUDICOL', style: TextStyle(color:Colors.white, fontSize:25.0, fontWeight: FontWeight.w200)), 
              ],
            ),
          ),
        ],
        );
    }
                    

  Widget _crearBoton(LoginBloc bloc, FirebaseBloc firebaseBloc){

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
                    onPressed: snapshot.hasData ? () => _login(bloc, context, firebaseBloc) : null,
          );
       },
     );

  }  


    _login(LoginBloc bloc, BuildContext context, FirebaseBloc firebaseBloc) async {

    Map info = await usuarioProvider.login(bloc.email, bloc.password);  
     print(info['email']);
     print(info['id']);
     print(info['nombreCompleto']);
     if (info['ok']){
       //Navigator.pushReplacementNamed(context, 'home');
       bloc.emailController.sink.add(null);
       bloc.passwordController.sink.add(null);
       firebaseBloc.idUsuarioController.sink.add(info['id']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('UsuarioId', info['id']);
        Navigator.pushReplacement(
          context,
         // MaterialPageRoute(builder: (context) => HomePage(email: info['email'], id: info['id'], nombre:info['nombreCompleto']))
         MaterialPageRoute(builder: (context) => SelectorPantalla())
         ); 
     }else{
       mostrarAlerta(context, info['mensaje']);
     }
     // Navigator.pushReplacementNamed(context, 'home');

    }
}