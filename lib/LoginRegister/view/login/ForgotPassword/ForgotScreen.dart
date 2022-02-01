import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:http/http.dart' as http;
import 'package:smart_apaga/LoginRegister/view/login/ForgotPassword/VeriffyCodeScreen.dart';
import 'dart:convert';
import 'package:smart_apaga/globals.dart';

import 'package:smart_apaga/LoginRegister/Bloc/Validators.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _textFieldController = TextEditingController();
  bool isButtonActive = false;
  bool isValidText = false;
  @override
  void initState() {
    super.initState();

    _textFieldController.addListener(_onTextFieldChange);
  }

  bool isValedText = true;
  final _myKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
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
                          controller: _textFieldController,
                          validator: (value) {
                            if (!Validators.isValidEmailorPhone(value)) {
                              return AppLocalizations.of(context).invalidText +
                                  ' ' +
                                  AppLocalizations.of(context).phoneNumText +
                                  ' ' +
                                  AppLocalizations.of(context).orText +
                                  ' ' +
                                  AppLocalizations.of(context).emailText;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green[700]),
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                            labelText:
                                AppLocalizations.of(context).phoneNumText +
                                    ' ' +
                                    AppLocalizations.of(context).orText +
                                    ' ' +
                                    AppLocalizations.of(context).emailText,
                            hintText: 'Please, type your phone number or Email',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
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
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
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
                              AppLocalizations.of(context)
                                  .countinue
                                  .toUpperCase(),
                              style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Image(image: AssetImage('assets/images/sad_man2.png')),
                SizedBox(height: 20),
                Divider(
                  color: Colors.black,
                  indent: 30,
                  endIndent: 30,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Image(
                            height: 50,
                            image: AssetImage('assets/images/EU4Business.png')),
                      ),
                      Expanded(
                        child: Image(
                            height: 38,
                            image: AssetImage('assets/images/Giz.png')),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _onTextFieldChange() {
    var text = _textFieldController.text;
    final isButtonActive = text.isNotEmpty;

    setState(() {
      this.isButtonActive = isButtonActive;
      isValedText =
          Validators.isValidEmail(text) || Validators.isValidPhone(text);
    });
  }

  Map _getParametr(String text) {
    if (Validators.isValidEmail(text)) {
      return {'email': text};
    } else if (text.length != 8 || text.startsWith('0')) {
      return {'phone': text};
    }
    return null;
  }

  void _onContinueTapped() {
    String text = _textFieldController.text;

    Map parametr = _getParametr(text);
    if (Validators.isValidPhone(text) || Validators.isValidEmail(text)) {
      if (parametr != null) {
        _makeRequest(parametr, (status) {
          if (status == 1) {
            _sendCode(parametr, (s) {
              if (s == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyCodeScreen(
                            parametrs: text,
                          )),
                );
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
                              child: Text(AppLocalizations.of(context)
                                  .theFieldsdoNotMatchText)),
                          Icon(Icons.error),
                        ],
                      ),
                      backgroundColor: Colors.red.shade500,
                    ),
                  );
              }
            });
          }

          print(status);
        });
      }
    }

    // if (_myKey.currentState.validate()) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => VerifyCodeScreen(screen: 'ForgotPassword')),
    //   );
    // }
  }

  Future<void> _makeRequest(Map parametrs, Function closure) async {
    try {
      final response = await http.post(
        Uri.parse(api_url + 'exists'),
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

  void _sendCode(Map parametrs, Function closure) async {
    try {
      final response = await http.post(
        Uri.parse(api_url + 'sendCode'),
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
