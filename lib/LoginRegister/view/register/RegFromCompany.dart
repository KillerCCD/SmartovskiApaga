import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smart_apaga/LoginRegister/Bloc/RegisterBloc/RegisterBloc.dart';
import 'package:smart_apaga/LoginRegister/Bloc/RegisterBloc/RegisterEvent.dart';
import 'package:smart_apaga/LoginRegister/Bloc/RegisterBloc/RegisterState.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_apaga/LoginRegister/model/Company.dart';
import 'package:smart_apaga/LoginRegister/model/User.dart';

import 'RegFormIndividual.dart';

class RegFromCompany extends StatefulWidget {
  RegFromCompany({
    Key key,
  }) : super(key: key);

  @override
  _RegFromCompanyState createState() => _RegFromCompanyState();
}

class _RegFromCompanyState extends State<RegFromCompany> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _taxCodeController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '+(###) ##-##-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  bool isHiddenPassword = true;
  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);

    _fullNameController.addListener(_onFullNameChange);
    _phoneNumberController.addListener(_onPhoneChange);

    _passwordController.addListener(_onPasswordChange);
    _companyNameController.addListener(_onLegalNameChange);
    _taxCodeController.addListener(_onTaxCodeChange);
    _companyEmailController.addListener(_onCompanyEmailChange);
  }

  var state = RegisterState();
  bool isButtonActive = false;
  bool disclimer = false;
  RegisterBloc _registerBloc = RegisterBloc();
  bool get isPopulated =>
      _fullNameController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _phoneNumberController.text.isNotEmpty &&
      _companyNameController.text.isNotEmpty &&
      _taxCodeController.text.isNotEmpty &&
      _companyEmailController.text.isNotEmpty;
  bool isButtonEnabled(context, RegisterState state) {
    if (!disclimer) {
      showClickDicklimer();
      return disclimer;
    }
    return isPopulated && !state.isSubmitting;
  }

  final _mayKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _mayKey,
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _companyNameController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !state.isLegalNameValid) {
                          buildAppBar(context, value);
                          return AppLocalizations.of(context).invalidText +
                              ' ' +
                              AppLocalizations.of(context).companyName;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[700]),
                        ),
                        hintText: 'InPonit',
                        hintStyle:
                            TextStyle(color: Colors.grey[500], fontSize: 13),
                        labelText: AppLocalizations.of(context).companyName,
                        // errorText: !state.isLegalNameValid
                        //     ? '${AppLocalizations.of(context).invalidText} ${AppLocalizations.of(context).companyName}'
                        //     : null,
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Colors.green[200],
                        ),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                    TextFormField(
                      controller: _taxCodeController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !state.isTaxCodeValid) {
                          buildAppBar(context, value);
                          return AppLocalizations.of(context).invalidText +
                              ' ' +
                              AppLocalizations.of(context).taxCodeText;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[700]),
                        ),
                        hintText: '16987564',
                        hintStyle:
                            TextStyle(color: Colors.grey[500], fontSize: 13),
                        labelText: AppLocalizations.of(context).taxCodeText,
                        // errorText: !state.isTaxCodeValid
                        //     ? '${AppLocalizations.of(context).invalidText} ${AppLocalizations.of(context).taxCodeText}'
                        //     : null,
                        prefixIcon: Icon(
                          Icons.description_outlined,
                          color: Colors.green[200],
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                    ),
                    TextFormField(
                      controller: _fullNameController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !state.isFullNameValid) {
                          buildAppBar(context, value);

                          return AppLocalizations.of(context).invalidText +
                              ' ' +
                              AppLocalizations.of(context).fullNameText;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[700]),
                        ),
                        labelText:
                            AppLocalizations.of(context).singingDirectorsText,
                        hintText: 'Davit Poghosyan',
                        hintStyle:
                            TextStyle(color: Colors.grey[500], fontSize: 13),

                        // errorText: !state.isFullNameValid
                        //     ? '${AppLocalizations.of(context).invalidText} ${AppLocalizations.of(context).fullNameText}'
                        //     : null,
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: Colors.green[200],
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      autocorrect: false,
                    ),
                    TextFormField(
                      controller: _phoneNumberController,
                      inputFormatters: [maskFormatter],
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            maskFormatter.getUnmaskedText().length != 11) {
                          buildAppBar(context, value);
                          return AppLocalizations.of(context).invalidText +
                              ' ' +
                              AppLocalizations.of(context).phoneNumText;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[700]),
                        ),
                        labelText: AppLocalizations.of(context).phoneNumText,
                        hintText: '+(374)93095659',
                        hintStyle:
                            TextStyle(color: Colors.grey[500], fontSize: 13),
                        // errorText: !state.isPhoneValid
                        //     ? '${AppLocalizations.of(context).invalidText} ${AppLocalizations.of(context).phoneNumText}'
                        prefixText: '+(374) ',
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
                      controller: _companyEmailController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !state.isEmailValid) {
                          buildAppBar(context, value);
                          return AppLocalizations.of(context).invalidText +
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
                        hintStyle:
                            TextStyle(color: Colors.grey[500], fontSize: 13),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[700]),
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
                          return AppLocalizations.of(context).passwordErrorText;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[700]),
                        ),
                        hintText: '**********',
                        hintStyle:
                            TextStyle(color: Colors.grey[500], fontSize: 13),
                        labelText: AppLocalizations.of(context).passwordText,
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
                        prefixIcon: Icon(
                          Icons.security,
                          color: Colors.green[200],
                        ),
                      ),
                      obscureText: isHiddenPassword,
                    ),
                    SizedBox(
                      height: 15,
                    ),
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
                                    print('Disclimerr-----$disclimer');
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
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isButtonActive && disclimer
                            ? () {
                                if (_mayKey.currentState.validate()) {
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
            );
          },
        ),
      ),
    );
  }

  void _onFormSubmitted() {
    final fullName = _fullNameController.text;
    final phone = maskFormatter.getUnmaskedText();
    final password = _passwordController.text;
    final legalName = _companyNameController.text;
    final taxCodde = _taxCodeController.text;

    final companyEmail = _companyEmailController.text;

    // if (fullName.isEmpty && fullName == '') {
    //   buildAppBar(context, 'Full name is empty');
    // }
    Company company = Company(
      fullname: fullName,
      phoneNumber: phone,
      password: password,
      name: legalName,
      taxCode: taxCodde,
      email: companyEmail,
    );

    User user = User(company: company);
    _registerBloc.add(RegisterSubmitted(user: user));
  }

  void _onFullNameChange() {
    final isButtonActive = _fullNameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _companyNameController.text.isNotEmpty &&
        _taxCodeController.text.isNotEmpty &&
        _companyEmailController.text.isNotEmpty;
    setState(() {
      this.isButtonActive = isButtonActive;
    });
    _registerBloc
        .add(RegisterFullNameChanged(fullName: _fullNameController.text));
  }

  void _onPhoneChange() {
    final isButtonActive = _fullNameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _companyNameController.text.isNotEmpty &&
        _taxCodeController.text.isNotEmpty &&
        _companyEmailController.text.isNotEmpty;
    setState(() {
      this.isButtonActive = isButtonActive;
    });
    _registerBloc.add(RegisterPhoneChanged(phone: _phoneNumberController.text));
  }

  void _onPasswordChange() {
    final isButtonActive = _fullNameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _companyNameController.text.isNotEmpty &&
        _taxCodeController.text.isNotEmpty &&
        _companyEmailController.text.isNotEmpty;
    setState(() {
      this.isButtonActive = isButtonActive;
    });
    _registerBloc
        .add(RegisterPasswordChanged(password: _passwordController.text));
  }

  void _onLegalNameChange() {
    final isButtonActive = _companyNameController.text.isNotEmpty &&
        _taxCodeController.text.isNotEmpty &&
        _companyEmailController.text.isNotEmpty &&
        _fullNameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
    setState(() {
      this.isButtonActive = isButtonActive;
    });
    _registerBloc
        .add(RegisterLegalNameChanged(legalName: _companyNameController.text));
  }

  void _onTaxCodeChange() {
    final isButtonActive = _companyNameController.text.isNotEmpty &&
        _taxCodeController.text.isNotEmpty &&
        _companyEmailController.text.isNotEmpty &&
        _fullNameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
    setState(() {
      this.isButtonActive = isButtonActive;
    });

    _registerBloc.add(RegisterTaxCodeChanged(taxCode: _taxCodeController.text));
  }

  void _onCompanyEmailChange() {
    final isButtonActive = _companyNameController.text.isNotEmpty &&
        _taxCodeController.text.isNotEmpty &&
        _companyEmailController.text.isNotEmpty &&
        _fullNameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        disclimer == true;
    setState(() {
      this.isButtonActive = isButtonActive;
    });

    _registerBloc.add(RegisterCompanyEmailChanged(
        companyEmail: _companyEmailController.text));
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

  void _togglePassword() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
}
