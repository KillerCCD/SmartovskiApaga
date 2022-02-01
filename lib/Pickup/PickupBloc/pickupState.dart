import 'package:equatable/equatable.dart';

import 'package:smart_apaga/Pickup/Model/Pickup.dart';

abstract class PickupStates extends Equatable {
  final PickupState pickupState;
  PickupStates({
    this.pickupState,
  });

  List<Object> get props => [pickupState];
}

// ignore: must_be_immutable
class PickupState extends PickupStates {
  String note;
  Pickup pickup;
  PickupState({this.note, this.pickup});

  List<Object> get props => [note, pickup];
  PickupState update({
    String note,
    Pickup pickup,
  }) {
    return copyWith(
      note: note,
      pickup: pickup,
    );
  }

  PickupState copyWith({
    String note,
    Pickup pickup,
  }) {
    return PickupState(note: note, pickup: pickup);
  }
}

// ignore: must_be_immutable
class PickupInitial extends PickupState {
  @override
  List<Object> get props => [];
}
