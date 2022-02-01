import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_apaga/Pickup/PickupBloc/pickupState.dart';
import 'package:smart_apaga/globals.dart';
import 'package:smart_apaga/Home/Home/NoPickupItem.dart';
import 'package:smart_apaga/Pickup/Model/Pickup.dart';
import 'package:smart_apaga/Pickup/PickupBloc/PickupBlocWithEnum.dart';
import 'package:smart_apaga/Home/pickupList_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'OrderBagsItem.dart';

class PickupListManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PickupListManagerState();
  }
}

class PickupListManagerState extends State<PickupListManager> {
  int groupedValue = 0;
  List<Pickup> _pickups = [];

  PickupState pickupState = PickupState();
  PickupBlocs pickupBloc = PickupBlocs();
  int purchasedBagCount = 5;
  bool isPassed = false;

  int _itemCount() {
    int count = _pickups.length == 0 ? _pickups.length + 1 : _pickups.length;
    return purchasedBagCount != 0 ? count + 1 : count;
  }

  void _changeSegmentedControl(int value) {
    if (value == 0) {
      pickupBloc.eventSink.add(ApiEndpoints.pickupsOngoing);
      isPassed = false;
    } else if (value == 1) {
      isPassed = true;
      pickupBloc.eventSink.add(ApiEndpoints.pickupsPassed);
    }
  }

  @override
  void initState() {
    if (pickupBloc.stateStreamController.isPaused) {
      setState(() {
        pickupBloc.eventSink.add(ApiEndpoints.pickupsOngoing);
      });
    }

    //pickupBloc.eventSink.add(ApiEndpoints.pickupsPassed);
    super.initState();
  }

  @override
  void dispose() {
    pickupBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, Widget> segmentedItemList = {
      0: Text(AppLocalizations.of(context).ongoingText,
          style: TextStyle(color: Colors.black)),
      1: Text(AppLocalizations.of(context).passedText,
          style: TextStyle(color: Colors.black))
    };
    return StreamBuilder<List<Pickup>>(
        stream: pickupBloc.pickupStream,
        builder: (context, AsyncSnapshot<List<Pickup>> snapshot) {
          //  Widget dadas;

          if (snapshot.hasData || snapshot.data != null) {
            _pickups = snapshot.data;
            isPassed = groupedValue == 0 ? false : true;
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          //inspect(snapshot.data);
          return Column(
            children: [
              Container(
                width: 300,
                child: CupertinoSegmentedControl<int>(
                    borderColor: Colors.grey,
                    selectedColor: Colors.white,
                    unselectedColor: Colors.grey,
                    children: segmentedItemList,
                    groupValue: groupedValue,
                    onValueChanged: (value) {
                      setState(() {
                        groupedValue = value;
                        _changeSegmentedControl(value);
                        print(value);
                      });
                    }),
              ),
              Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.all(20.0),
                      itemCount: _itemCount(),
                      itemBuilder: (BuildContext context, int index) {
                        if (purchasedBagCount != 0 && index == 0) {
                          return OrderBagsItem(purchasedBagCount);
                        }

                        if (_pickups.length != 0) {
                          int i = purchasedBagCount != 0 ? index - 1 : index;

                          return PickupList(
                            pickups: _pickups[i],
                            isPassed: isPassed,
                          );
                        }

                        return NoPickupItem();
                      })),
            ],
          );

          //return dadas;
        });
  }
}
