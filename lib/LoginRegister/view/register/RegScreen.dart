import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_apaga/LoginRegister/view/login/LoginScrean.dart';
import 'package:smart_apaga/l10n/L10n.dart';
import 'package:smart_apaga/l10n/locale_provider.dart';

import 'RegFormIndividual.dart';
import 'package:smart_apaga/LoginRegister/Bloc/RegisterBloc/RegisterBloc.dart';
import 'package:smart_apaga/LoginRegister/Bloc/RegisterBloc/UserRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'RegFromCompany.dart';

class RegScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  bool passwordVisible = false;
  bool submitted = false;
  int sharedValue = 0;
  bool boolEmail = false,
      boolPass = false,
      boolName = false,
      boolUser = false,
      invalidError = false,
      passwordError = false;

  @override
  void initState() {
    super.initState();
  }

  UserRepository _userRepository;

  dasfadf(int item) {
    switch (item) {
      case 0:
        return Container(child: RegisterIndividualForm());
        break;
      case 1:
        return Container(
          child: RegFromCompany(),
        );

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, Widget> widgets = {
      0: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2),
        child: Text(
          AppLocalizations.of(context).signUpAsanIndividualText,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        ),
      ),
      1: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        child: Text(
          AppLocalizations.of(context).signUpAsAnOrganizationText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    };

    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? Locale('hy');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: _userRepository),
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            height: MediaQuery.of(context).size.width * 0.2,
                            image: AssetImage('assets/images/logo.png'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'SMARTAPAGA LLC',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 22),
                            ),
                            Text(
                              'Waste Managment Solutions',
                              style: TextStyle(
                                  color: Colors.green[700], fontSize: 16),
                            )
                          ]),
                          SizedBox(
                            width: 10,
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: locale,
                              icon: Container(width: 12),
                              items: L10n.all.map(
                                (locale) {
                                  final flag =
                                      L10n.getFlag(locale.languageCode);

                                  return DropdownMenuItem(
                                    child: Center(
                                      child: Text(
                                        flag,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.green.shade300,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    value: locale,
                                    onTap: () {
                                      final provider =
                                          Provider.of<LocaleProvider>(context,
                                              listen: false);

                                      provider.setLocale(locale);
                                    },
                                  );
                                },
                              ).toList(),
                              onChanged: (_) {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Text(
                          AppLocalizations.of(context).congratulationsText,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(AppLocalizations.of(context).signUpText,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.green.shade300))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 500.0,
                              child: CupertinoSegmentedControl<int>(
                                borderColor: Colors.green.shade300,
                                selectedColor: Colors.green.shade300,
                                pressedColor: Colors.green.shade100,
                                children: widgets,
                                onValueChanged: (int val) {
                                  setState(() {
                                    sharedValue = val;
                                  });
                                },
                                groupValue: sharedValue,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 25.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: dasfadf(sharedValue),
                            ),
                          ],
                        ),
                      ),

                      // Container(
                      //   child: RegisterForm(),
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ));
                                    },
                                    child: Text(
                                      AppLocalizations.of(context).loginText,
                                      style: TextStyle(
                                          color: Colors.green.shade300,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                      //maxLines: 2,
                                    )),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: TextButton(
                                      onPressed: null,
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .termsOfuseText,
                                          style:
                                              TextStyle(color: Colors.black))),
                                ),
                                Container(
                                    height: 15,
                                    child:
                                        VerticalDivider(color: Colors.black)),
                                Expanded(
                                    child: TextButton(
                                  onPressed: null,
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .privacyPolicyText,
                                      style: TextStyle(color: Colors.black)),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void usernameError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[800],
              ),
              height: 190,
              child: Column(
                children: [
                  Container(
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            'Username Not Available',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 25, top: 15),
                          child: Text(
                            "The username you entered is not available.",
                            style: TextStyle(color: Colors.white60),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0,
                    height: 0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Try Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
