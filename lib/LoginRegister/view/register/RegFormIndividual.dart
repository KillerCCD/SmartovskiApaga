import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smart_apaga/Home/Home/HomeScreen.dart';
import 'package:smart_apaga/LoginRegister/Bloc/RegisterBloc/RegisterBloc.dart';
import 'package:smart_apaga/LoginRegister/Bloc/RegisterBloc/RegisterEvent.dart';
import 'package:smart_apaga/LoginRegister/Bloc/RegisterBloc/RegisterState.dart';
import 'package:smart_apaga/LoginRegister/model/Company.dart';

import 'package:smart_apaga/LoginRegister/model/User.dart';

import '../../../globals.dart';

class RegisterIndividualForm extends StatefulWidget {
  const RegisterIndividualForm({Key key}) : super(key: key);
  @override
  _RegisterIndividualFormState createState() => _RegisterIndividualFormState();
}

class _RegisterIndividualFormState extends State<RegisterIndividualForm> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '+(###) ##-##-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  _RegisterIndividualFormState();

  bool isButtonActive = false;
  bool isCompany = false;
  bool isHiddenPassword = true;
  bool disclimer = false;
  String values = '';
  int groupedValue = 0;
  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _fullNameController.text.isNotEmpty &&
      _phoneNumberController.text.isNotEmpty;

  // ignore: missing_return
  // bool isButtonEnabled() {
  //   if (disclimer) {
  //     showClickDicklimer();
  //     return !disclimer;
  //   }
  // }

  bool isButtonEnabled(context, RegisterState state) {
    if (!disclimer) {
      showClickDicklimer();
      return disclimer;
    }
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  RegisterState states = RegisterState();
  RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);

    _fullNameController.addListener(_onFullNameChange);
    _phoneNumberController.addListener(_onPhoneChange);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    _registerBloc = BlocProvider.of<RegisterBloc>(context);

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Register Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.green.shade300,
              ),
            );
        }

        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Registering...'),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ],
                ),
                backgroundColor: Colors.green.shade300,
              ),
            );
        }

        if (state.isSuccess) {
          // BlocProvider.of<AuthenticationBloc>(context).add(
          //   AuthenticationLoggedIn(),
          // );
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('TextField AlertDemo'),
                  content: TextField(
                    controller: codeController,
                    decoration:
                        InputDecoration(hintText: "TextField in Dialog"),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Activate'),
                      onPressed: () {
                        print("adfasdfjklasdhfjkasdhf${codeController.text}");
                        _smsCodePost(codeController.text);
                      },
                    )
                  ],
                );
              });
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          states = state;
          return
              // child: Form(

              Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _fullNameController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !state.isFullNameValid) {
                                buildAppBar(context, value);

                                return AppLocalizations.of(context)
                                        .invalidText +
                                    ' ' +
                                    AppLocalizations.of(context).fullNameText;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green[700]),
                              ),
                              labelText:
                                  AppLocalizations.of(context).fullNameText,
                              hintText: 'Davit Poghosyan',
                              hintStyle: TextStyle(
                                  color: Colors.grey[500], fontSize: 13),
                              prefixIcon: Icon(
                                Icons.account_circle,
                                color: Colors.green[200],
                              ),

                              // errorText: !state.isFullNameValid
                              //     ? '${AppLocalizations.of(context).invalidText} ${AppLocalizations.of(context).fullNameText}'
                              //     : null,
                            ),
                            keyboardType: TextInputType.name,
                            autocorrect: false,
                          ),
                          TextFormField(
                            controller: _phoneNumberController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  maskFormatter.getUnmaskedText().length !=
                                      11) {
                                buildAppBar(context, value);
                                return AppLocalizations.of(context)
                                        .invalidText +
                                    ' ' +
                                    AppLocalizations.of(context).phoneNumText;
                              }
                              return null;
                            },
                            inputFormatters: [maskFormatter],
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green[700]),
                              ),
                              labelText:
                                  AppLocalizations.of(context).phoneNumText,
                              hintText: '0000000',
                              hintStyle: TextStyle(
                                  color: Colors.grey[500], fontSize: 13),

                              // errorText: !state.isPhoneValid
                              //     ? '${AppLocalizations.of(context).invalidText} ${AppLocalizations.of(context).phoneNumText}'
                              //     : null,
                              //prefixText: '+(374) ',
                              prefixStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(
                                Icons.call,
                                color: Colors.green[200],
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            autocorrect: false,
                          ),
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !state.isEmailValid) {
                                buildAppBar(context, value);
                                return AppLocalizations.of(context)
                                        .invalidText +
                                    ' ' +
                                    AppLocalizations.of(context).emailText;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              labelText: AppLocalizations.of(context).emailText,
                              // errorText: !state.isEmailValid
                              //     ? '${AppLocalizations.of(context).invalidText} ${AppLocalizations.of(context).emailText}'
                              //     : null,
                              hintText: 'example@gmail.com',
                              hintStyle: TextStyle(
                                  color: Colors.grey[500], fontSize: 13),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green[700]),
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.green[200],
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !state.isPasswordValid) {
                                buildAppBar(context, value);
                                return AppLocalizations.of(context)
                                    .passwordErrorText;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green[700]),
                              ),
                              hintText: '**********',
                              hintStyle: TextStyle(
                                  color: Colors.grey[500], fontSize: 13),
                              labelText:
                                  AppLocalizations.of(context).passwordText,
                              suffixIcon: InkWell(
                                onTap: _togglePassword,
                                child: isHiddenPassword
                                    ? Icon(
                                        Icons.visibility_off,
                                        color: Colors.green[200],
                                      )
                                    : Icon(
                                        Icons.visibility,
                                        color: Colors.green[200],
                                      ),
                              ),
                              // errorText: !state.isPasswordValid
                              //     ? ' ${AppLocalizations.of(context).passwordErrorText}'
                              //     : null,
                              prefixIcon: Icon(
                                Icons.security,
                                color: Colors.green[200],
                              ),
                            ),
                            obscureText: isHiddenPassword,
                          ),

                          SizedBox(height: 15),
                          Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: GestureDetector(
                                        child: disclimer
                                            ? Icon(
                                                Icons.check,
                                                size: 18,
                                                color: Colors.green[500],
                                              )
                                            : null,
                                        onTap: () => setState(() {
                                          disclimer = !disclimer;
                                        }),
                                      )),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Text(
                                    AppLocalizations.of(context).authorizedText,
                                    textAlign: TextAlign.center,
                                    // overflow: TextOverflow.fade,
                                    // textAlign: TextAlign.start,
                                  ),
                                ),
                              ])),
                          //     SizedBox(
                          //       width: 20,
                          //     ),
                          //     Expanded(
                          //       flex: 5,
                          //       child: SelectableText(
                          //         AppLocalizations.of(context).authorizedText,
                          //       ),
                          //     ),
                          //   ],
                          // )),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isButtonActive && disclimer
                                  ? () {
                                      if (_formKey.currentState.validate()) {
                                        if (isButtonEnabled(context, state)) {
                                          _onFormSubmitted();
                                        }
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green.shade300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context).registerText,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ], //
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onFullNameChange() {
    final isButtonActive = _fullNameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
    setState(() {
      this.isButtonActive = isButtonActive;
    });
    _registerBloc
        .add(RegisterFullNameChanged(fullName: _fullNameController.text));
  }

  void _onPhoneChange() {
    final isButtonActive = _fullNameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
    setState(() {
      this.isButtonActive = isButtonActive;
    });
    _registerBloc.add(RegisterPhoneChanged(phone: _phoneNumberController.text));
  }

  void _onEmailChange() {
    final isButtonActive = _phoneNumberController.text.isNotEmpty &&
        _fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
    setState(() {
      this.isButtonActive = isButtonActive;
    });
    _registerBloc.add(RegisterEmailChanged(email: _emailController.text));
  }

  void _onPasswordChange() {
    final isButtonActive = _fullNameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
    setState(() {
      this.isButtonActive = isButtonActive;
    });
    _registerBloc
        .add(RegisterPasswordChanged(password: _passwordController.text));
  }

  void showClickDicklimer() {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text('Click Disclimer.'),
              ),
              Icon(Icons.error),
            ],
          ),
          backgroundColor: Colors.red.shade500,
        ),
      );
  }

  void _onFormSubmitted() {
    final fullName = _fullNameController.text;
    final phone = maskFormatter.getUnmaskedText();

    final email = _emailController.text;
    final password = _passwordController.text;
    Company company = Company();
    User user = User(
      fullname: fullName,
      phoneNumber: phone,
      email: email,
      password: password,
      company: isCompany ? company : null,
    );
    _registerBloc.add(RegisterSubmitted(user: user));
  }

  void _togglePassword() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> _smsCodePost(String smsCode) async {
    final code = smsCode;
    dynamic token = await FlutterSession().get('token');
    try {
      var response = await http.post(Uri.parse(ApiEndpoints.sendRegCode),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{'code': code}));
      var body = jsonDecode(response.body);
      var status = body['status'];
      if (response.statusCode == 200 && status == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text('invalid code'),
                  ),
                  Icon(Icons.error),
                ],
              ),
              backgroundColor: Colors.red.shade500,
            ),
          );
      }
    } catch (e) {}
  }
}

void buildAppBar(BuildContext context, String value) {
  if (value.isEmpty) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text('empty blank'),
              ),
              Icon(Icons.error),
            ],
          ),
          backgroundColor: Colors.red.shade500,
        ),
      );
  }
}
