import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:smart_apaga/Pickup/Model/Pickup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_apaga/Pickup/PickupBloc/PickupBlocWithEnum.dart';
import 'package:smart_apaga/globals.dart';

import 'Home/edit_Screen.dart';

class PickupList extends StatefulWidget {
  final Pickup pickups;
  final bool isPassed;
  @override
  State<StatefulWidget> createState() {
    return PickupListState(pickups, isPassed);
  }

  PickupList({Key key, this.isPassed, this.pickups}) : super(key: key);
}

class PickupListState extends State<PickupList> {
  Pickup pickups;
  bool isPassed;
  PickupBlocs pickupBlocs = PickupBlocs();
  TextEditingController _addressCotroller = TextEditingController();
  TextEditingController _dateCotroller = TextEditingController();
  TextEditingController _beginCotroller = TextEditingController();
  TextEditingController _endCotroller = TextEditingController();
  final _pickupBlocs = PickupBlocs();
  TimeOfDay time;
  DateTime selectedDate = DateTime.now();
  String date;
  bool notEqalTmie = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  String timeBegin;
  String timeEnd;
  PickupListState(this.pickups, this.isPassed);
  DateFormat dateFormat = DateFormat("HH:mm");
  // Future<List<Pickup>> _futurePickup;

  @override
  void initState() {
    date = DateFormat.yMd().format(selectedDate);
    timeBegin = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn]).toString();
    timeEnd = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour + 1, DateTime.now().minute),
        [hh, ':', nn]).toString();
    //  _futurePickup = _fetchPickup(pickup.id);

    super.initState();
  }

  Future<void> _selectTime(
      BuildContext context, bool timeBegin, StateSetter setState) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial);
    if (picked != null)
      setState(() {
        selectedTime = picked;
        if (timeBegin) {
          this.timeBegin = formatDate(
              DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
              [hh, ':', nn]).toString();
        } else {
          this.timeEnd = formatDate(
              DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
              [hh, ':', nn]).toString();
        }
        if (this.timeBegin.contains(this.timeEnd)) {
          setState(() {
            notEqalTmie = !notEqalTmie;
            this.timeEnd = formatDate(
                DateTime(
                    2019, 08, 1, selectedTime.hour + 1, selectedTime.minute),
                [hh, ':', nn]).toString();
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        AppLocalizations.of(context).periodTimeText,
                      ),
                      //content: const Text('Scan or the type correct code'),
                      actions: <Widget>[
                        // TextButton(
                        //   onPressed: () => Navigator.pop(context, 'Cancel'),
                        //   child: const Text('Cancel'),
                        // ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ));
          });
        } else if (this.timeEnd.compareTo(this.timeBegin) == 0) {
        } else {
          notEqalTmie = false;
        }
      });
  }

  // _selectDate(BuildContext context, Function setState) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       //initialDatePickerMode: DatePickerMode.day,
  //       initialEntryMode: DatePickerEntryMode.input,
  //       firstDate: DateTime(2015),
  //       lastDate: DateTime(2101));
  //   if (picked != null)
  //     setState(() {
  //       selectedDate = picked;
  //       date = DateFormat.yMd().format(selectedDate);
  //     });
  // }

  _selectDate(BuildContext context, Function setState) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        date = DateFormat.yMd().format(selectedDate);
      });
  }

  @override
  void dispose() {
    _addressCotroller.dispose();
    _dateCotroller.dispose();
    _beginCotroller.dispose();
    _endCotroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final plastic = pickups.pickupBag
            .where((element) => element.wasteType.contains('plastic'))
            .toList()
            .length ??
        0;
    final paper = pickups.pickupBag
            .where((element) => element.wasteType.contains('paper'))
            .toList()
            .length ??
        0;
    final glass = pickups.pickupBag
            .where((element) => element.wasteType.contains('glass'))
            .toList()
            .length ??
        0;

    return Column(
      children: [
        SizedBox(height: 10.0),
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey[300])),
          child: Column(
            children: [
              Container(
                color: Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage('assets/images/calendar.png')),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        //pickup.date,
                        '${pickups.date}',
                        style: TextStyle(backgroundColor: Colors.grey.shade300),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Image(image: AssetImage('assets/images/clock.png')),
                      Text(
                        //pickup.timeBegin,
                        '${pickups.timeBegin}',
                        style: TextStyle(backgroundColor: Colors.grey.shade300),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text('To'),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        //pickup.timeEnd,
                        '${pickups.timeEnd}',
                        style: TextStyle(backgroundColor: Colors.grey.shade300),
                      ),
                    ],
                  ),
                ),
              ),
              //Address
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Address',
                          style: TextStyle(color: Colors.green),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Flexible(
                          child: Text(
                            pickups.address.customerAddress,
                            maxLines: 1,
                            style: TextStyle(
                              backgroundColor: Colors.white12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              //waste type
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Pickup Description',
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Image(image: AssetImage('assets/images/plastic1.png')),
                        SizedBox(
                          width: 10,
                        ),
                        Text('$plastic'),
                        SizedBox(
                          width: 20.0,
                        ),
                        Image(image: AssetImage('assets/images/paper1.png')),
                        SizedBox(
                          width: 10,
                        ),
                        Text('$paper'),
                        SizedBox(
                          width: 20,
                        ),
                        Image(image: AssetImage('assets/images/glass1.png')),
                        SizedBox(
                          width: 10,
                        ),
                        Text('$glass'),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              //Bags
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Bags',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          width: 83,
                        ),
                        Image(image: AssetImage('assets/images/bag_icon.png')),
                        SizedBox(
                          width: 10,
                        ),
                        pickups.bagCount == null
                            ? Text(
                                'x 0',
                                style: TextStyle(color: Colors.green),
                              )
                            : Text(
                                'x  ${pickups.bagCount}',
                                style: TextStyle(color: Colors.green),
                              ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    )
                  ],
                ),
              ),

              isPassed
                  ? SizedBox(
                      height: 0,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: screenSize.width * 0.3),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Colors.grey.shade300)),
                                primary: Colors.grey[600],
                                textStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(8.0),
                              ),
                              onPressed: () async {
                                showBar(context);
                              },
                              child: Text(
                                AppLocalizations.of(context).cancelButton,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: screenSize.width * 0.3),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green.shade300,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Colors.green.shade300)),
                                primary: Colors.white,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(8.0),
                              ),
                              onPressed: () async {
                                // showBarEdit(context);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditScreen(
                                          pickups: pickups,
                                        )));
                              },
                              child: Text(
                                AppLocalizations.of(context).editButtonText,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                      ],
                    ),

              SizedBox(height: isPassed ? 5 : 20),
            ],
          ),
        ),
      ],
    );
  }

  Future<dynamic> showBar(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text(AppLocalizations.of(context).cancelText2),
        content: Text(AppLocalizations.of(context).confirmCacel),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context).noText)),
          TextButton(
              onPressed: () async {
                _pickupBlocs.eventSink
                    .add(ApiEndpoints.pickupCancel(pickups.id));

                Navigator.of(context).pop(true);
                final snackBar = SnackBar(
                  backgroundColor: Colors.green.shade300,
                  content: Row(
                    children: [
                      Expanded(
                          child: Text(
                              AppLocalizations.of(context).pickupCancelText)),
                      SizedBox(
                        width: 19.0,
                        height: 19.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      ),
                    ],
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text(AppLocalizations.of(context).okText)),
        ],
      ),
    );
  }

  Future<dynamic> showBarEdit(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (contex, setState) => new AlertDialog(
          title: containerPopupMenu(),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context).cancelText)),
            TextButton(
                onPressed: () {
                  var start = dateFormat.parse('10:00');
                  var end = dateFormat.parse('22:00');
                  setState(() {
                    if (selectedTime.hour.compareTo(start.hour) == -1 &&
                        selectedTime.minute.compareTo(start.minute) == 1) {
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
                                      .periodTextBox),
                                ),
                                Icon(Icons.error),
                              ],
                            ),
                            backgroundColor: Colors.red.shade500,
                          ),
                        );
                    } else if ((end.hour.compareTo(selectedTime.hour) == 0 ||
                            end.hour.compareTo(selectedTime.hour) == 1) &&
                        (end.minute.compareTo(selectedTime.minute) == 0 ||
                            end.minute.compareTo(selectedTime.minute) == 1)) {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            duration: Duration(milliseconds: 1500),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  AppLocalizations.of(context).periodTextBox2,
                                )),
                                Icon(Icons.error),
                              ],
                            ),
                            backgroundColor: Colors.red.shade500,
                          ),
                        );
                    } else {
                      Pickup pickup = Pickup(
                          addressId: pickups.addressId,
                          address: pickups.address,
                          date: date,
                          timeBegin: timeBegin,
                          timeEnd: timeEnd,
                          pickupBag: pickups.pickupBag,
                          bagCount: pickups.bagCount,
                          noteForDriver: pickups.noteForDriver);
                      setState(() {
                        _pickupBlocs.editPickup(
                            pickup: pickup,
                            url: ApiEndpoints.pickupEdit(pickups.id));
                      });
                    }
                  });

                  Navigator.of(context).pop(true);

                  final snackBar = SnackBar(
                    backgroundColor: Colors.green.shade300,
                    content: Row(
                      children: [
                        Expanded(
                            child: Text(
                                AppLocalizations.of(context).periodTimeText)),
                        SizedBox(
                          width: 19.0,
                          height: 19.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ),
                      ],
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text(AppLocalizations.of(context).replaceText)),
            //  TextButton(onPressed: () async {}, child: Text('Yes')),
          ],
          content: Text(AppLocalizations.of(context).editText),
        ),
      ),
    );
  }

  Widget containerPopupMenu() {
    return StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectDate(context, setState);
              });
            },
            child: Column(
              children: [
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  AppLocalizations.of(context).pickupDateText,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey[300])),
                        child: Text(
                          date,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Image(
                      image: AssetImage("assets/images/calendar.png"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /**
    
                   Time
    
                   */
          SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(context).pickupTimeText,
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: 70.0,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300])),
                  child: MaterialButton(
                    child: Text(
                      timeBegin,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {
                      // setState(()  =>   _selectTime(context, true, setState));
                      setState(() {
                        _selectTime(context, true, setState);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "To",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300])),
                  child: MaterialButton(
                    child: Text(
                      timeEnd,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {
                      //  setState(() => _selectTime(context, false, setState));

                      setState(() {
                        _selectTime(context, false, setState);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Image(
                image: AssetImage("assets/images/clock.png"),
              ),
            ],
          ),

          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).intervalText,
              style: TextStyle(fontSize: 12),
            ),
          ),

          SizedBox(height: 10.0),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: <Widget>[
          //     Text(
          //       'Bags',
          //       style: TextStyle(
          //           // color: Colors.green,
          //           fontWeight: FontWeight.normal,
          //           fontSize: 12.0),
          //     ),
          //     SizedBox(
          //       width: 43,
          //     ),
          //     SizedBox(
          //       width: 15.0,
          //       height: 15.0,
          //       child: Image(image: AssetImage('assets/images/bag_icon.png')),
          //     ),
          //     SizedBox(width: 8.0),
          //     pickups.bagCount == null
          //         ? Text(
          //             'x 0',
          //             style: TextStyle(color: Colors.green, fontSize: 12),
          //           )
          //         : Text(
          //             'x  $pickups.bagCount',
          //             style: TextStyle(color: Colors.green, fontSize: 12),
          //           ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
