import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:smart_apaga/Pickup/Model/Wast.dart';

class PickupBagProvider extends ChangeNotifier {
  var pickupBags = <PickupBag>[];
  var codeBag = <dynamic>[''];
  int plastic = 0;
  int paper = 0;
  int glass = 0;
  int get plastics => plastic;
  int get papers => paper;
  int get glasess => glass;
  List<dynamic> get bagCodes => codeBag ?? ['0000'];
  List<PickupBag> get pickups => pickupBags;

  void addBags(PickupBag bags) {
    pickupBags.add(bags);
    plastic = pickupBags
        .where((e) => e.wasteType.contains('plastic'))
        .toList()
        .length;
    paper =
        pickupBags.where((e) => e.wasteType.contains('glass')).toList().length;
    glass =
        pickupBags.where((e) => e.wasteType.contains('paper')).toList().length;
    saveBackCodeForCheck();
    inspect(pickupBags);
    notifyListeners();
  }

  void initPickupBas() {
    paper = 0;
    glass = 0;
    plastic = 0;
    pickupBags.clear();
    notifyListeners();
  }

  void deletWastType() {
    if (pickupBags.isNotEmpty) {
      pickupBags.removeLast();
    }

    inspect(pickupBags);
    notifyListeners();
  }

  // void updateBag(String type) {
  //   for (var i = 0; i < pickupBags.length; i++) {
  //     for (var j = 0; j < codeBag.length - 1; i++) {
  //       var ii = pickupBags[i].wasteType;
  //       print(ii);
  //       //var pp = ii.indexOf(codeBag[i]);
  //       // pickupBags[pp].wasteType = type;
  //     }
  //   }
  //   inspect(pickupBags);
  //   notifyListeners();
  // }

  void saveBackCodeForCheck() {
    var codesBags = pickupBags.last.bagCode;
    if (codeBag.isNotEmpty) {
      codeBag.add(codesBags);
    } else if (codeBag == null) {
      return null;
    }
    notifyListeners();
  }

  void codeBagss(String result) {
    codeBag.add(result);
    inspect(pickupBags);
    notifyListeners();
  }
}
