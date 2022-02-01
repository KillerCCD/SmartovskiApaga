import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_apaga/LoginRegister/Bloc/RegisterBloc/UserRepository.dart';

import 'dart:convert';
import '../LoginBloc/LoginEvent.dart';
import '../LoginBloc/LoginState.dart';
import 'package:smart_apaga/LoginRegister/Bloc/Validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;

  LoginBloc(this.userRepository) : super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChanged) {
      yield* _mapLoginEmailChangeToState(event.email);
    } else if (event is LoginPasswordChanged) {
      yield* _mapLoginPasswordChangeToState(event.password);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event.user);
    }
  }

  Stream<LoginState> _mapLoginEmailChangeToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<LoginState> _mapLoginPasswordChangeToState(String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<LoginState> _mapLoginSubmittedToState(Map userMap) async* {
    yield LoginState.loading(userMap);

    try {
      dynamic token = await FlutterSession().get('token');

      final response = await http.post(
        Uri.parse(api_url + '/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(userMap),
      );
      print(response.body);
      print('Status Code = ${response.statusCode}');
      var body = jsonDecode(response.body);
      var data = body['data'];
      if (body['status'] == 1) {
        String token = data['access_token'];
        await FlutterSession().set('token', token);
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool('login', true);
        print(pref);
        yield LoginState.success();
      } else {
        yield LoginState.failure();
      }
    } catch (error) {
      print(error);
      yield LoginState.failure();
    }
  }
}
