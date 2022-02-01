import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:smart_apaga/LoginRegister/Bloc/PhoneNumberBloc/PhoneNmEvent.dart';
import 'package:smart_apaga/LoginRegister/Bloc/PhoneNumberBloc/PhoneNmState.dart';
import 'package:smart_apaga/LoginRegister/Bloc/RegisterBloc/UserRepository.dart';
import 'package:smart_apaga/LoginRegister/Bloc/Validators.dart';

class PhoneNmBloc extends Bloc<PhoneNmEvent, PhoneNmState> {
  UserRepository userRepository;

  PhoneNmBloc({UserRepository userRepository})
      : userRepository = userRepository,
        super(PhoneNmState.initial());

  @override
  Stream<PhoneNmState> mapEventToState(PhoneNmEvent event) async* {
    if (event is PhoneNmChanged) {
      yield* _mapPhoneNmChangedState(event.phoneText);
    } else if (event is PhoneNmAdded) {
      yield* _mapAddedtoState(event.phoneNm.toMap());
    }
  }

  Stream<PhoneNmState> _mapPhoneNmChangedState(String phones) async* {
    yield state.update(isPhoneNm: Validators.isValidContactPhoneNm(phones));
  }

  Stream<PhoneNmState> _mapAddedtoState(Map phoneNmMap) async* {
    PhoneNmState.adding(phoneNmMap);
    try {
      dynamic token = await FlutterSession().get('token');

      var url = Uri.parse(
          'https://phpstack-351614-1150808.cloudwaysapps.com/api/customer/phones/add');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(phoneNmMap),
      );
      print(response.body);
      var body = jsonDecode(response.body);

      if (body['status'] == 1) {
        yield PhoneNmState.added();
      } else {
        yield PhoneNmState.failue();
      }
    } catch (error) {
      print(error);
    }
  }
}
