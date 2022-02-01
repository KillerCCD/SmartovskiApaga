import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_apaga/Home/Home/HomeScreen.dart';
import 'package:smart_apaga/LoginRegister/Bloc/AddressBloc/AddressBloc.dart';
import 'package:smart_apaga/LoginRegister/Bloc/LoginBloc/LoginBloc.dart';
import 'package:smart_apaga/LoginRegister/Bloc/PhoneNumberBloc/PhoneNmBloc.dart';
import 'package:smart_apaga/LoginRegister/Bloc/RegisterBloc/RegisterBloc.dart';
import 'package:smart_apaga/LoginRegister/Bloc/RegisterBloc/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_apaga/LoginRegister/view/login/LoginScrean.dart';
import 'package:smart_apaga/Pickup/View/Widgets/provider.dart';
import 'package:smart_apaga/SplashScreen.dart';
import 'package:smart_apaga/l10n/L10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'Pickup/PickupBloc/PickupBloc.dart';

import 'l10n/locale_provider.dart';

void main() {
  // final UserRepository userRepository = UserRepository();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MainScreen());
  });
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String isHomeScreen = '';
  SplashScreen splashScreen = SplashScreen();
  UserRepository _userRepository;

  Future<void> checkFirstScreen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isHomeScreen = pref.getString('token') ?? '';

      super.deactivate();
    });
  }

  @override
  void initState() {
    checkFirstScreen();
    super.initState();
  }

  var locales = L10n.all;
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        return MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>(
              create: (BuildContext context) => LoginBloc(_userRepository),
            ),
            BlocProvider<RegisterBloc>(
              create: (BuildContext context) => RegisterBloc(),
            ),
            BlocProvider<AddressBloc>(
              create: (BuildContext context) => AddressBloc(),
            ),
            BlocProvider<PhoneNmBloc>(
              create: (BuildContext context) => PhoneNmBloc(),
            ),
            BlocProvider<PickupBloc>(
              create: (BuildContext context) => PickupBloc(),
            ),
          ],
          child: ChangeNotifierProvider(
            create: (_) => PickupBagProvider(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              locale: provider.locale,
              supportedLocales: L10n.all,

              home: isHomeScreen.isNotEmpty ? HomeScreen() : LoginScreen(),

              // routes: {
              //   'HomeScreen': (context) =>
              //       isHomeScreen.isNotEmpty ? HomeScreen() : LoginScreen()
              // },
            ),
          ),
        );
      });
}
