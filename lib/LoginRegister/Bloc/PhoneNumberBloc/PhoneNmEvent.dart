import 'package:equatable/equatable.dart';
import 'package:smart_apaga/LoginRegister/model/Contacts.dart';

abstract class PhoneNmEvent extends Equatable {}

class PhoneNmChanged extends PhoneNmEvent {
  final String phoneText;

  PhoneNmChanged({this.phoneText});

  @override
  List<Object> get props => [phoneText];
}

class PhoneNmAdded extends PhoneNmEvent {
  final Contact phoneNm;
  PhoneNmAdded({this.phoneNm});

  @override
  List<Object> get props => [phoneNm];
}
