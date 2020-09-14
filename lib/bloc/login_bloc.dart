import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:audicol_fiber/bloc/validators.dart';



class LoginBloc with Validators {

  final emailController =    BehaviorSubject<String>();
  final passwordController = BehaviorSubject<String>();

  
//recuperar los datos del stream   
  Stream<String>get emailStream => emailController.stream.transform(validarEmail);
  Stream<String>get passwordStream => passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream =>
     CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);


// insertar valores al stream
  Function(String) get changeEmail => emailController.sink.add;
  Function(String) get changePassword => passwordController.sink.add;

//obtener el ultimo valor ingresado a los stream

  String get email => emailController.value;
  String get password => passwordController.value;
  
dispose(){
  emailController?.close();
  passwordController?.close();
}

}