import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_apaga/Pickup/Model/Wast.dart';
import 'package:smart_apaga/Pickup/View/Widgets/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddBagsButton extends StatefulWidget {
  final String bagCode;
  final String types;
  final Function gestureTag;
  AddBagsButton({Key key, this.bagCode, this.gestureTag, this.types})
      : super(key: key);

  @override
  State<AddBagsButton> createState() => _AddBagsButtonState(
      bagCode: bagCode, types: types, gestureTag: gestureTag);
}

class _AddBagsButtonState extends State<AddBagsButton> {
  var bags = <PickupBag>[];
  final String bagCode;
  final String types;
  final Function gestureTag;
  List<int> numbers = [0, 1, 2];

  _AddBagsButtonState({this.bagCode, this.types, this.gestureTag});

  void pickupBagLib() {
    bags.addAll([new PickupBag(wasteType: this.types, bagCode: this.bagCode)]);
    inspect(bags);
  }

  bool gesture(int nums) {
    for (var i = 0; i < numbers.length; i++) {
      if (nums == numbers[i]) return true;
      break;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // pickupBagLib(types[0], barcode);
        // context.read<PickupBagProvider>().addBags(bags);
        print('dadas  ${this.gestureTag}');
      },
      child: Container(
        decoration: BoxDecoration(
            color: gestureTag != null ? Colors.green[100] : Colors.white,
            border: Border.all(color: Colors.green)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image(image: AssetImage("assets/images/plastic2.png")),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    AppLocalizations.of(context).plasticText,
                    style: TextStyle(color: Colors.green, fontSize: 20),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
