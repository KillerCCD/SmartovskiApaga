import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import 'package:smart_apaga/LoginRegister/Bloc/Validators.dart';
import 'package:smart_apaga/LoginRegister/view/login/ForgotPassword/VeriffyCodeScreen.dart';
import 'package:smart_apaga/LoginRegister/view/login/LoginScrean.dart';
import 'package:smart_apaga/globals.dart';

class NewPasswordScreen extends StatefulWidget {
  final String smsCode;
  final String paramers;
  const NewPasswordScreen({
    Key key,
    this.smsCode,
    this.paramers,
  }) : super(key: key);
  @override
  _NewPasswordState createState() => _NewPasswordState(smsCode, paramers);
}

class _NewPasswordState extends State<NewPasswordScreen> {
  final String smsCode;
  final String paramers;

  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _verifyPasswordController = TextEditingController();

  _NewPasswordState(this.smsCode, this.paramers);

  @override
  void initState() {
    super.initState();

    _newPasswordController.addListener(_onNewPasswordChange);
    _verifyPasswordController.addListener(_onVerifyPasswordChange);
  }

  bool isButtonActive = false;
  bool isValedNewPassword = true;
  bool isValedVerifyPassword = true;
  final _myKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(children: <Widget>[
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'SMARTAPAGA LLC',
                        style: TextStyle(color: Colors.green, fontSize: 22),
                      ),
                      Text(
                        'Waste Managment Solutions',
                        style:
                            TextStyle(color: Colors.green[700], fontSize: 16),
                      )
                    ]),
                  ],
                ),
                SizedBox(height: 50),
                Form(
                    key: _myKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !Validators.isValidPassword(value)) {
                              // buildAppBar(context, value);

                              return AppLocalizations.of(context).invalidText +
                                  ' ' +
                                  AppLocalizations.of(context).passwordText;
                            }
                            return null;
                          },
                          controller: _newPasswordController,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green[700]),
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                            labelText: AppLocalizations.of(context).newText +
                                ' ' +
                                AppLocalizations.of(context).passwordText,
                            hintText:
                                AppLocalizations.of(context).passwordErrorText,
                            hintStyle: TextStyle(
                                color: Colors.grey[500], fontSize: 13),
                            // errorText:
                            //     isValedNewPassword ? null : 'Invalid password',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !Validators.isValidPassword(value)) {
                              // buildAppBar(context, value);

                              return AppLocalizations.of(context).invalidText +
                                  ' ' +
                                  AppLocalizations.of(context).passwordText;
                            }
                            return null;
                          },
                          controller: _verifyPasswordController,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green[700]),
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                            labelText: AppLocalizations.of(context).verify +
                                ' ' +
                                AppLocalizations.of(context).passwordText,
                            hintText:
                                AppLocalizations.of(context).passwordErrorText,
                            hintStyle: TextStyle(
                                color: Colors.grey[500], fontSize: 13),
                            // errorText: isValedVerifyPassword
                            //     ? null
                            //     : 'Invalid password',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                        ),
                      ],
                    )),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(minWidth: screenSize.width * 0.3),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.grey.shade300)),
                          primary: Colors.grey[600],
                          textStyle: TextStyle(
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(8.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)
                              .cancelButton
                              .toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.18),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(minWidth: screenSize.width * 0.4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          textStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: isButtonActive ? _onContinueTapped : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              AppLocalizations.of(context).save.toUpperCase(),
                              style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Image(image: AssetImage('assets/images/sad_man2.png')),
                SizedBox(height: 20)
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _onNewPasswordChange() {
    var text = _newPasswordController.text;
    final isButtonActive =
        text.isNotEmpty && _verifyPasswordController.text.isNotEmpty;
    setState(() {
      this.isButtonActive = isButtonActive;
      isValedNewPassword = Validators.isValidPassword(text);
    });
  }

  void _onVerifyPasswordChange() {
    String newPassword = _newPasswordController.text;
    String verifyPassword = _verifyPasswordController.text;
    final isButtonActive =
        newPassword.isNotEmpty && _verifyPasswordController.text.isNotEmpty;
    setState(() {
      this.isButtonActive = isButtonActive;
      isValedVerifyPassword = newPassword == verifyPassword;
    });
  }

  void _onContinueTapped() {
    String newPassword = _newPasswordController.text;
    String verifyPassword = _verifyPasswordController.text;
    if (newPassword.contains(verifyPassword) &&
        verifyPassword.contains(newPassword)) {
      Map parametr = {
        'password': newPassword,
        'passwordConfirm': verifyPassword,
        'phone': paramers,
        'code': smsCode,
      };
      if (_myKey.currentState.validate()) {
        if (parametr != null) {
          _makeRequest(parametr, (status) {
            if (status == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );

              print(status);
            }
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1500),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Text(
                        AppLocalizations.of(context).theFieldsdoNotMatchText)),

                Icon(Icons.error),
                // CircularProgressIndicator(
                //   valueColor:
                //       AlwaysStoppedAnimation<
                //               Color>(
                //           Colors.white),
                // )
              ],
            ),
            backgroundColor: Colors.red.shade500,
          ),
        );
    }
  }

  void _makeRequest(Map parametrs, Function closure) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.resetPassword),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(parametrs),
      );
      print(response.body);
      var data = jsonDecode(response.body);
      closure(data['status']);
    } catch (error) {
      print(error);
    }
  }
}
