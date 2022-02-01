import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session/flutter_session.dart' show FlutterSession;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:smart_apaga/Extention/MenuButton.dart';
import 'package:smart_apaga/Home/Home/HomeScreen.dart';
import 'package:smart_apaga/LoginRegister/Bloc/AddressBloc/AddressBloc.dart';
import 'package:smart_apaga/LoginRegister/Bloc/PhoneNumberBloc/PhoneNmBloc.dart';
import 'package:smart_apaga/LoginRegister/Bloc/PhoneNumberBloc/PhoneNmEvent.dart';
import 'package:smart_apaga/LoginRegister/Bloc/PhoneNumberBloc/PhoneNmState.dart';
import 'package:smart_apaga/LoginRegister/model/Address.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_apaga/LoginRegister/model/Contacts.dart';
import 'package:smart_apaga/LoginRegister/view/overal/AddressConfirmationScreen.dart';
import 'package:smart_apaga/Pickup/Model/Pickup.dart';
import 'package:smart_apaga/globals.dart';

class ContactInfoForm extends StatefulWidget {
  ContactInfoFormState createState() => ContactInfoFormState();
}

class ContactInfoFormState extends State<ContactInfoForm> {
  Pickup _pickup = Pickup();
  PhoneNmBloc _phoneNmBloc;
  Future<List<Address>> _futureAddress;
  Future<List<Contact>> _futureContacts;
  var addressLt = <Address>[];
  Contact address;
  AddressBloc addressBloc;

  TextEditingController _phoneNmController = TextEditingController();

  initState() {
    _phoneNmBloc = BlocProvider.of<PhoneNmBloc>(context);
    super.initState();

    _phoneNmController.addListener(_onPhoneNmChanged);

    _futureAddress = fetchAddress();
    _futureContacts = fetchPhoneNm();
  }

  Widget build(context) {
    final _phoneNmBloc = BlocProvider.of<PhoneNmBloc>(context);

    return Scaffold(
      endDrawer: MenuButton(),
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        iconTheme: IconThemeData(color: Colors.green.shade700),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: fetchPhoneNm,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: <Widget>[
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.all(12.0)),
                  Image(
                    height: MediaQuery.of(context).size.width * 0.15,
                    image: AssetImage("assets/images/logo.png"),
                  ),
                  SizedBox(
                    width: 55,
                  ),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).contatcIfno,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.add_call,
                        color: Colors.green.shade300,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  actions: [
                                    BlocConsumer<PhoneNmBloc, PhoneNmState>(
                                      bloc: _phoneNmBloc,
                                      listener: (context, state) {
                                        if (state.isFailure = true &&
                                            _phoneNmController.text.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                            ..removeCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text('Adding is Failure'),
                                                    Icon(Icons.error),
                                                  ],
                                                ),
                                                backgroundColor:
                                                    Colors.green.shade300,
                                              ),
                                            );
                                        }
                                        if (state.isAdding = true &&
                                            _phoneNmController
                                                .text.isNotEmpty) {
                                          ScaffoldMessenger.of(context)
                                            ..removeCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text('Adding...'),
                                                    CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                    )
                                                  ],
                                                ),
                                                backgroundColor:
                                                    Colors.green.shade300,
                                              ),
                                            );
                                        }
                                        if (state.isAdded) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()),
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        return Container(
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: _phoneNmController,
                                                decoration: InputDecoration(
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText:
                                                      AppLocalizations.of(
                                                              context)
                                                          .phoneNumText,
                                                  errorText:
                                                      !state.isPhoneNmValid
                                                          ? 'invalid number'
                                                          : null,
                                                ),
                                                keyboardType:
                                                    TextInputType.phone,
                                                autocorrect: true,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextButton(
                                                        child: Text('Ok'),
                                                        onPressed: () {
                                                          if (_phoneNmController
                                                              .text
                                                              .isNotEmpty) {
                                                            addNmBloc();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          } else {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }
                                                        }),
                                                  ),
                                                  Expanded(
                                                    child: TextButton(
                                                        child: Text('Cancel'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )),
                        child: Text(
                          AppLocalizations.of(context).phoneNumText,
                          style: TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.add_location_alt_sharp,
                          size: 25.0,
                          color: Colors.green.shade300,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Text(
                            AppLocalizations.of(context).addressText,
                            style: TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.normal),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    AddressConfirmationScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.green.shade300,
                thickness: 2,
                indent: 5,
                endIndent: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.all(10.0)),
                  Text(
                    AppLocalizations.of(context).addressText,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                ],
              ),
              Container(
                child: addressList(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                color: Colors.green.shade300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.all(10.0)),
                  Text(
                    AppLocalizations.of(context).phoneNumText,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                ],
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    child: _phoneNmList(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
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
                        AppLocalizations.of(context).cancelText,
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.green)),
                          primary: Colors.green,
                          textStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context).confirmText,
                              style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void addNmBloc() {
    final phonNmText = _phoneNmController.text;
    Contact contact = Contact(
      number: phonNmText,
    );
    _phoneNmBloc.add(PhoneNmAdded(phoneNm: contact));
  }

  Widget _phoneNmList() {
    return FutureBuilder<List<Contact>>(
        future: _futureContacts,
        builder: (context, snapshot) {
          List<Widget> children;
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.green.shade300,
              ),
            );
          } else if (snapshot.hasData) {
            children = <Widget>[
              SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                      controller: null,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        Contact contactList = snapshot.data[index];
                        return Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            color: Colors.red,
                            child: Align(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    " Delete",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                              alignment: Alignment.centerRight,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            await deletePhones(contactList.id);
                            setState(() {
                              snapshot.data.remove(contactList);
                            });
                          },
                          child: Card(
                            child: ListTile(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: Colors.green.shade300,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text('${contactList.number}'),
                                ],
                              ),
                            ),
                          ),
                        );
                        // return ListTile(
                        //   title: Text('${snapshot.data[index].streetName}'),
                        // );
                      },
                    ),
                  ],
                ),
              ),
            ];
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
        });
  }

  Widget addressList() {
    return FutureBuilder<List<Address>>(
        future: _futureAddress,
        builder: (context, snapshot) {
          List<Widget> children;
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.green.shade300,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              children = <Widget>[
                SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        controller: null,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Address addressList = snapshot.data[index];
                          return Dismissible(
                            key: Key(snapshot.data[index].id.toString()),
                            background: Container(
                              color: Colors.red,
                              child: Align(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      " Delete",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            confirmDismiss: (DismissDirection direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Delete Confirmation"),
                                    content: const Text(
                                        "Are you sure you want to delete this item?"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () async {
                                            bool result = await deleteAddress(
                                                addressList.id);
                                            if (result) {
                                              Navigator.of(context).pop(true);
                                            } else {
                                              //showDeletAddress(context);
                                              Navigator.of(context).pop(false);
                                            }
                                          },
                                          child: const Text("Delete")),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("Cancel"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {},
                            child: Card(
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.apartment_rounded,
                                      color: Colors.green[300],
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                          ' ${snapshot.data[index].customerAddress}' ??
                                              ''),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                          // return ListTile(
                          //   title: Text('${snapshot.data[index].streetName}'),
                          // );
                        },
                      ),
                    ],
                  ),
                ),
              ];
            }
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
        });
  }

  // ignore: missing_return
  List<Address> parseAddress(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    var asd = parsed.map<Address>((json) => Address.fromJson(json)).toList();
    print('Parsed_ Address  = $asd');
    return asd;
  }

  List<Contact> parseContact(String reponseBody) {
    final parsed = jsonDecode(reponseBody).cast<Map<String, dynamic>>();
    return parsed.map<Contact>((json) => Contact.fromJson(json)).toList();
  }

  // ignore: missing_return
  Future<List<Address>> fetchAddress() async {
    try {
      dynamic token = await FlutterSession().get('token');

      final response = await http.get(
        Uri.parse(ApiEndpoints.address),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      // var body = jsonDecode(response.body);
      print('Contact_Address_StatuseCode = ${response.statusCode}');
      var body = jsonDecode(response.body);
      print(body);
      if (body['status'] == 1) {
        dynamic data = body['data'];

        data.forEach((element) {
          Address address = Address.fromJson(element);
          addressLt.add(address);
        });

        return addressLt;
      } else {
        throw Exception("Can't load address");
      }
    } catch (error) {
      print(error);
    }
  }

  Future deleteAddress(int id) async {
    dynamic token = await FlutterSession().get('token');

    final response = await http.delete(
      Uri.parse(ApiEndpoints.addressDelete + '/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json;  charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    var body = jsonDecode(response.body);
    var status = body['status'];
    if (response.statusCode == 200 && status == 1) {
      return true;
    } else if (response.statusCode == 200 && status == 0) {
      return false;
      //showDeletAddress(context, status);
    } else {
      throw Exception('Failed to delete address.');
    }
  }

  Future<List<Contact>> fetchPhoneNm() async {
    dynamic token = await FlutterSession().get('token');
    List<Contact> contact = [];
    final response = await http.get(
      Uri.parse(ApiEndpoints.phones),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var body = jsonDecode(response.body);
    print('Contact_Address_StatuseCode = ${response.statusCode}');
    print(body);
    if (body['status'] == 1) {
      dynamic data = body['data'];

      data.forEach((element) {
        address = Contact.fromJson(element);
        contact.add(address);
      });
    } else {
      print("Error ");
    }
    return contact;
  }

  Future<void> deletePhones(int id) async {
    dynamic token = await FlutterSession().get('token');

    http.Response response = await http.delete(
      Uri.parse(ApiEndpoints.phones + '/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json;  charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    print("Response status:${response.statusCode}");
    print(response.body);
  }

  void _onPhoneNmChanged() {
    _phoneNmBloc.add(PhoneNmChanged(phoneText: _phoneNmController.text));
  }

  @override
  void dispose() {
    _phoneNmController.dispose();
    super.dispose();
  }
}

void showDeletAddress(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text("Can't delete address"),

            //content: const Text('Scan or the type correct code'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('OK'),
              ),
            ],
          ));
}
