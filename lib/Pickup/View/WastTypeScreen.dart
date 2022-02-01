import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smart_apaga/Pickup/Model/Wast.dart';
import 'package:smart_apaga/Pickup/View/SchedulScreen.dart';
import 'package:smart_apaga/Pickup/View/Widgets/provider.dart';

class WastTypeScreen extends StatefulWidget {
  final String barcode;

  WastTypeScreen({
    this.barcode,
  });

  @override
  WastTypeScreenState createState() => WastTypeScreenState(
        barcode: barcode,
      );
}

class WastTypeScreenState extends State<WastTypeScreen> {
  String barcode;

  int gestureTag = 0;
  PickupBag pickupBag;
  //List<int> countwast = [];
  var wastes = <PickupBag>[];
  // var listWastes = <PickupBag>[];
  void pickupBagLib(String types, String bagCode) {
    wastes.addAll([new PickupBag(wasteType: types, bagCode: bagCode)]);
    inspect(wastes);
  }

  List<dynamic> types = ['plastic', 'paper', 'glass'];

  WastTypeScreenState({this.barcode});

  @override
  Widget build(BuildContext context) {
    //var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text(AppLocalizations.of(context).wastTypeText),
          backgroundColor: Colors.green[300],
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          child: Column(
            children: [
              Text(AppLocalizations.of(context).belowText,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Plastic
                    // AddBagsButton(
                    //   gestureTag: 0,
                    //   bagCode: barcode,
                    //   types: types[0],
                    // ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          gestureTag = 0;
                        });
                        pickupBagLib(types[0], barcode);
                        context.read<PickupBagProvider>().addBags(new PickupBag(
                            wasteType: types[0], bagCode: barcode));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: gestureTag == 0
                                ? Colors.green[100]
                                : Colors.white,
                            border: Border.all(color: Colors.green)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image(
                                      image: AssetImage(
                                          "assets/images/plastic2.png")),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).plasticText,
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 20),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //Paper
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          gestureTag = 1;
                        });
                        pickupBagLib(types[1], barcode);
                        context.read<PickupBagProvider>().addBags(new PickupBag(
                            wasteType: types[1], bagCode: barcode));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: gestureTag == 1
                                ? Colors.green[100]
                                : Colors.white,
                            border: Border.all(color: Colors.green)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image(
                                      image: AssetImage(
                                          "assets/images/paper2.png")),
                                  SizedBox(
                                    width: 24,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).paperText,
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //Glass
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          gestureTag = 2;
                        });
                        pickupBagLib(types[2], barcode);
                        // _onGesturTap(gestureTag);
                        context.read<PickupBagProvider>().addBags(new PickupBag(
                            wasteType: types[2], bagCode: barcode));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: gestureTag == 2
                                ? Colors.green[100]
                                : Colors.white,
                            border: Border.all(
                              color: Colors.green,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image(
                                      image: AssetImage(
                                          "assets/images/glass2.png")),
                                  SizedBox(
                                    width: 42,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).glassText,
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 20),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //
                    //buy bag
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 12.0,
                        ),
                        ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: double.infinity),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.green)),
                              primary: Colors.green,
                              textStyle: TextStyle(
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(8.0),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppLocalizations.of(context).orederBagsButtonText,
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              // constraints: BoxConstraints(
                              //     minWidth: screenSize.width * 0.3),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.green)),
                                  primary: Colors.green,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, wastes);
                                },
                                child: Text(
                                  AppLocalizations.of(context)
                                      .addAnotherBagText,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              // constraints: BoxConstraints(
                              //     minWidth: screenSize.width * 0.4),
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
                                onPressed: () {
                                  // _onGestureTap();
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => SchedulScreen(
                                  //           gestureTag: gestureTag,
                                  //           bagCode: barcode,
                                  //           pickupBags: wastes,
                                  //         )));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SchedulScreen()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .nextButtonText,
                                      style: TextStyle(fontSize: 14)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                    //
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<List<Waste>> _sendWastes() async {
  //   List<Waste> wastes = [];
  //   try {
  //     dynamic token = FlutterSession().get('token');
  //     var url = Uri.parse(ApiEndpoints.pickupAdd);
  //     final response = await http.post(
  //       url,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     print(response.body);

  //     var body = jsonDecode(response.body);
  //     inspect(body);
  //     if (response.statusCode == 200) {
  //       return wastes = List<Waste>.from(body.map((e) => Pickup.fromJson(e)));
  //     } else {
  //       throw Exception("Fadiled create");
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  //   return wastes;
  // }
}
