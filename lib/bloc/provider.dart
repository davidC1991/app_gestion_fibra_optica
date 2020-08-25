import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audicol_fiber/bloc/login_bloc.dart';
export 'package:audicol_fiber/bloc/login_bloc.dart';
import 'package:audicol_fiber/bloc/dbBloc.dart';
export 'package:audicol_fiber/bloc/dbBloc.dart';



class Provider extends InheritedWidget{

 
  final _loginBloc = new LoginBloc();
  final _firebaseBloc = new FirebaseBloc();
   static Provider _instancia;

  factory Provider({Key key, Widget child}){
    if (_instancia==null){
      _instancia = new Provider._internal(key:key, child: child);
    }
    return _instancia;
  }

  Provider._internal({Key key, Widget child })
  : super(key:key, child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

   static LoginBloc of (BuildContext context){
     return context.dependOnInheritedWidgetOfExactType<Provider>()._loginBloc;
  }
  
  static FirebaseBloc firebaseBloc (BuildContext context){
    return (context.dependOnInheritedWidgetOfExactType<Provider>()._firebaseBloc);
  
  }

  }

  

