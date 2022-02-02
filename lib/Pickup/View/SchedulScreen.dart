import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:smart_apaga/Extention/MenuButton.dart';
import 'package:smart_apaga/Home/Home/HomeScreen.dart';
import 'package:smart_apaga/LoginRegister/model/Address.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:smart_apaga/LoginRegister/view/overal/AddressConfirmationScreen.dart';
import 'package:smart_apaga/Pickup/Model/Pickup.dart';
import 'package:smart_apaga/Pickup/Model/Wast.dart';
import 'package:smart_apaga/Pickup/PickupBloc/PickupBloc.dart';
import 'package:smart_apaga/Pickup/PickupBloc/pickupEvent.dart';
import 'package:smart_apaga/Pickup/PickupBloc/pickupState.dart';
import 'package:smart_apaga/Pickup/View/Widgets/provider.dart';
import 'package:smart_apaga/globals.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SchedulScreen extends StatefulWidget {
  final int gestureTag;
  final String bagCode;
  final int bagCount;
  final List<PickupBag> pickupBags;
  SchedulScreen(
      {Key key, this.pickupBags, this.gestureTag, this.bagCode, this.bagCount})
      : super(key: key);
  @override
  _SchedulScreenState createState() =>
      _SchedulScreenState(pickupBags, gestureTag, bagCode, bagCount);
}

class _SchedulScreenState extends State<SchedulScreen> {
  int gestureTag;
  // int plastic = 0;
  // int paper = 0;
  // int glass = 0;
  String bagCode;
  int bagCount;
  final List<PickupBag> pickupBags;
  bool notEqalTmie = false;
  List<PickupBag> wastes = [];

  Future<List<Address>> futureAddres;
  Address addressSeletion = Address();
  List<Address> addresLs = [];
  int addressMenuid = 0;
  List<String> types = ['plastic', 'paper', 'glass'];
  Address address;

  _SchedulScreenState(
      this.pickupBags, this.gestureTag, this.bagCode, this.bagCount);

  PickupBloc _pickupBloc;

  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = new DateFormat("HH:mm");

  String date;
  Pickup pickup;
  TimeOfDay selectedTime = TimeOfDay.now();
  String timeBegin;
  String timeEnd;
  DateTime start;
  DateTime end;
  DateTime endEnglish;
  Address addressFromMenu = Address();
  DateTime now = DateTime.now();

  TextEditingController _noteTextFieldController = TextEditingController();

  List<dynamic> list;
  List<PickupBag> waste;

  // void _onGestureTap() {
  //   if (gestureTag == 0 || gestureTag == 1 || gestureTag == 2) {
  //     waste = [PickupBag(wasteType: types[gestureTag], bagCode: bagCode)];
  //     inspect(waste);
  //   }
  // }

  @override
  void initState() {
    _pickupBloc = BlocProvider.of<PickupBloc>(context);
    futureAddres = fetchAddress();

    date = DateFormat("yMd").format(selectedDate);
    timeBegin =
        formatDate(DateTime(DateTime.now().year, 08, 1, 10, 00), [hh, ':', nn])
            .toString();
    timeEnd =
        formatDate(DateTime(DateTime.now().year, 08, 1, 0, 00), [hh, ':', nn])
            .toString();

    super.initState();

    _noteTextFieldController.addListener(_onNoteFieldChanged);
  }

  Future<Null> _selectTime(BuildContext context, bool timeBegin) async {
    start = dateFormat.parse('10:00 AM');
    end = dateFormat.parse('22:00 PM');
    endEnglish = dateFormat.parse("10:00 PM");
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial);
    if (picked != null) {
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
          // this.timeEnd = formatDate(
          //     DateTime(2019, 08, 1, selectedTime.hour + 1, selectedTime.minute),
          //     [hh, ':', nn]).toString();
          setState(() {
            notEqalTmie = !notEqalTmie;
            showDialog(
                barrierDismissible: false,
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
                            notEqalTmie = !notEqalTmie;

                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ));
          });
        } else if (selectedTime.hour.compareTo(start.hour) == -1) {
          print("0");
          setState(() {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        AppLocalizations.of(context).periodTextBox,
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
                            this.timeBegin = formatDate(
                                DateTime(2019, 08, 1, 10, selectedTime.minute),
                                [hh, ':', nn]).toString();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ));
          });
        } else if ((end.hour.compareTo(selectedTime.hour) == 0 ||
                end.hour.compareTo(selectedTime.hour) == -1) &&
            (end.minute.compareTo(selectedTime.minute) == 0 ||
                end.minute.compareTo(selectedTime.minute) == -1)) {
          print("sad   asd}");
          setState(() {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        AppLocalizations.of(context).periodTextBox2,
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
        } else {
          notEqalTmie = false;
        }
      });
    }
  }

  Future<Null> _selectDate(
    BuildContext context,
  ) async {
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

  // ignore: missing_return
  Future<List<Address>> fetchAddress() async {
    try {
      String token = await FlutterSession().get('token');
      // List<Address> addressLt = [];
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
      inspect(body);
      if (body['status'] == 1) {
        dynamic data = body['data'];
        setState(() {
          data.forEach((element) {
            Address address = Address.fromJson(element);

            addresLs.add(address);
          });
        });

        return addresLs;
      } else {
        throw Exception("Can't load address");
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // var screenSizeHeight = screenSize.height - AppBar().preferredSize.height;
    final plastic = context.select((PickupBagProvider value) => value.plastics);
    final paper = context.select((PickupBagProvider value) => value.papers);
    final glass = context.select((PickupBagProvider value) => value.glasess);

    return BlocBuilder<PickupBloc, PickupState>(
        bloc: BlocProvider.of<PickupBloc>(context),
        builder: (context, state) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                  title: Text(AppLocalizations.of(context).shchedulMenuText),
                  backgroundColor: Colors.grey[400],
                  automaticallyImplyLeading: true,
                  //actions: [MenuButton()],
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      context.read<PickupBagProvider>().deletWastType();
                      Navigator.pop(context, true);
                    },
                  )),
              endDrawer: MenuButton(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      height: screenSize.height - 14,
                      width: screenSize.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          /**

                Addresses

                    */
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: screenSize.width * 0.75),
                                  child: SelectionMenu<Address>(
                                    closeMenuOnItemSelected: true,
                                    //  showSelectedItemAsTrigger: true,
                                    //initiallySelectedItemIndex: 0,
                                    closeMenuWhenTappedOutside: true,
                                    itemsList: addresLs,
                                    onItemSelected: (Address value) {
                                      print(value.id);
                                      inspect(value);
                                      addressMenuid = value.id;
                                      addressSeletion = value;
                                      // addressFromMenu = value;
                                    },
                                    itemBuilder: (BuildContext context,
                                        Address item,
                                        OnItemTapped onItemTapped) {
                                      return Material(
                                        color: Colors.white24,
                                        child: InkWell(
                                          onTap: onItemTapped,
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.add_location,
                                                      color:
                                                          Colors.green.shade300,
                                                    ),
                                                    Flexible(
                                                      fit: FlexFit.loose,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.0),
                                                        child: Text(
                                                          item.customerAddress,
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.grey.shade300,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    selectionMenuController:
                                        SelectionMenuController(),
                                    componentsConfiguration:
                                        DropdownComponentsConfiguration<
                                            Address>(
                                      // menuFlexValues: MenuFlexValues(
                                      //     searchingIndicator: 1,
                                      //     searchBar: 1,
                                      //     listView: 1,
                                      //     searchField: 1),
                                      menuSizeConfiguration:
                                          MenuSizeConfiguration(
                                              maxHeight: 180,
                                              minHeight: 60,
                                              maxHeightFraction: 0.5,
                                              minHeightFraction: 0.5,
                                              minWidthFraction: 0.3,
                                              maxWidthFraction: 0.5,
                                              requestAvoidBottomInset: true,
                                              enforceMinWidthToMatchTrigger:
                                                  true,
                                              enforceMaxWidthToMatchTrigger:
                                                  true,
                                              requestConstantHeight: true),
                                      triggerComponent: TriggerComponent(
                                          builder: _triggerBuilder),
                                    ),
                                    closeMenuInsteadOfPop: true,
                                    closeMenuOnEmptyMenuSpaceTap: false,
                                    showSelectedItemAsTrigger: true,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              Expanded(
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    // side: BorderSide(
                                    //     color: Colors.grey.shade300)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.add_circle,
                                        color: Colors.green.shade300,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        'Add address',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddressConfirmationScreen()));
                                  },
                                ),
                              )
                            ],
                          ),

                          /**

                 Date

                 */
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context).pickupDateText,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Colors.grey[300])),
                                    child: Text(
                                      date,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Image(
                                  image:
                                      AssetImage("assets/images/calendar.png"),
                                ),
                              ],
                            ),
                          ),
                          /**

                 Time

                 */
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  AppLocalizations.of(context).pickupTimeText,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[300])),
                                  child: MaterialButton(
                                    child: Text(
                                      timeBegin,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    onPressed: () {
                                      _selectTime(context, true);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                "To",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[300])),
                                  child: MaterialButton(
                                    child: Text(
                                      timeEnd == null ? '00:00' : timeEnd,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    onPressed: () {
                                      _selectTime(context, false);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Image(
                                image: AssetImage("assets/images/clock.png"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context).intervalText,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),

                          /**

                 Type Count

                 */
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          "assets/images/plastic1.png"),
                                      // height: 70,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text('$plastic'),
                                    // gestureTag == 0
                                    //     ? Text(
                                    //         'x 1',
                                    //         style: TextStyle(
                                    //             color: Colors.green,
                                    //             fontSize: 20),
                                    //       )
                                    //     : Text(
                                    //         'x 0',
                                    //         style: TextStyle(
                                    //             color: Colors.green,
                                    //             fontSize: 20),
                                    //       ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          "assets/images/paper1.png"),
                                      // height: 70,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text('$paper'),
                                    // gestureTag == 1
                                    //     ? Text(
                                    //         'x 1',
                                    //         style: TextStyle(
                                    //             color: Colors.green,
                                    //             fontSize: 20),
                                    //       )
                                    //     : Text(
                                    //         'x 0',
                                    //         style: TextStyle(
                                    //             color: Colors.green,
                                    //             fontSize: 20),
                                    //       ),
                                    // initlaWast(1),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          "assets/images/glass1.png"),
                                      // height: 70,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),

                                    Text('$glass'),
                                    // gestureTag == 2
                                    //     ? Text(
                                    //         'x 1',
                                    //         style: TextStyle(
                                    //             color: Colors.green,
                                    //             fontSize: 20),
                                    //       )
                                    //     : Text(
                                    //         'x 0',
                                    //         style: TextStyle(
                                    //             color: Colors.green,
                                    //             fontSize: 20),
                                    //       ),
                                    // initlaWast(2),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          "assets/images/bag_icon.png"),
                                      // height: 70,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    // gestureTag == 2
                                    // bagCount == null
                                    //     ? Text(
                                    //         'x 0',
                                    //         style: TextStyle(
                                    //             color: Colors.green,
                                    //             fontSize: 20),
                                    //       )
                                    //     : Text(
                                    //         'x  $bagCount',
                                    //         style: TextStyle(
                                    //             color: Colors.green,
                                    //             fontSize: 20),
                                    //      ),

                                    // initlaWast(2),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          /**

                 Note For Driver

                 */
                          SizedBox(
                            height: 40,
                          ),
                          Expanded(
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey[300])),
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    color: Colors.grey,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          AppLocalizations.of(context).noteText,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Expanded(
                                          child: SizedBox.shrink(),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5.0),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: _noteTextFieldController,
                                        maxLines: 100,
                                        cursorColor: Colors.grey,
                                        decoration: InputDecoration(
                                          hintText: AppLocalizations.of(context)
                                              .noteCommentText,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 13),
                                          border: InputBorder.none,
                                        ),
                                        autocorrect: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          /**

                 Bottom Buttons

                 */

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  // constraints: BoxConstraints(
                                  //     minWidth: screenSize.width * 0.3),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: Colors.grey.shade300),
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
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side:
                                              BorderSide(color: Colors.green)),
                                      primary: Colors.green,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      // getValues(pickup);
                                      setState(() {
                                        var start = dateFormat.parse('10:00');
                                        var ent = dateFormat.parse('22:00');
                                        print(
                                            "DAdate${start.hour}+++asds${selectedTime.hour}");
                                        if (selectedTime.hour.compareTo(
                                                        start.hour) ==
                                                    -1 &&
                                                selectedTime.minute.compareTo(
                                                        start.minute) ==
                                                    1
                                            //&&
                                            // (ent.hour.compareTo(
                                            //             selectedTime.hour) ==
                                            //         0 ||
                                            //     ent.hour.compareTo(
                                            //             selectedTime.hour) ==
                                            //         -1) &&
                                            // (ent.minute.compareTo(
                                            //             selectedTime.minute) ==
                                            //         0 ||
                                            //     ent.minute.compareTo(
                                            //             selectedTime.minute) ==
                                            //         -1)
                                            ) {
                                          ScaffoldMessenger.of(context)
                                            ..removeCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                duration: Duration(
                                                    milliseconds: 1500),
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .periodTextBox),
                                                    ),

                                                    Icon(Icons.error),
                                                    // CircularProgressIndicator(
                                                    //   valueColor:
                                                    //       AlwaysStoppedAnimation<
                                                    //               Color>(
                                                    //           Colors.white),
                                                    // )
                                                  ],
                                                ),
                                                backgroundColor:
                                                    Colors.red.shade500,
                                              ),
                                            );
                                        } else if ((end?.hour?.compareTo(
                                                        selectedTime.hour) ==
                                                    0 ||
                                                end?.hour?.compareTo(
                                                        selectedTime.hour) ==
                                                    -1) &&
                                            (end?.minute?.compareTo(
                                                        selectedTime?.minute) ==
                                                    0 ||
                                                end?.minute?.compareTo(
                                                        selectedTime.minute) ==
                                                    -1)) {
                                          ScaffoldMessenger.of(context)
                                            ..removeCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                duration: Duration(
                                                    milliseconds: 1500),
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .periodTextBox2,
                                                      ),
                                                    ),

                                                    Icon(Icons.error),
                                                    // CircularProgressIndicator(
                                                    //   valueColor:
                                                    //       AlwaysStoppedAnimation<
                                                    //               Color>(
                                                    //           Colors.white),
                                                    // )
                                                  ],
                                                ),
                                                backgroundColor:
                                                    Colors.red.shade500,
                                              ),
                                            );
                                        } else {
                                          _buttonSumbitted();
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .confirmText,
                                          style: TextStyle(fontSize: 14)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        });
  }

  static Widget _triggerBuilder(TriggerComponentData data) {
    return TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          primary: Colors.black87,
          textStyle: TextStyle(
            color: Colors.white,
          ),
          // padding: EdgeInsets.all(8.0),
        ),
        onPressed: data.triggerMenu,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Padding(
            //   padding: EdgeInsets.all(0.0),
            //child:

            //),
            Text(
              'Choose address',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
                child: Icon(
              Icons.expand_more,
              size: 16.0,
            )),
          ],
        ));
  }

  void _buttonSumbitted() {
    // _onGestureTap();

    final addressId = addressMenuid;
    final dates = date;
    final timeBegins = timeBegin;
    final timeEnds = timeEnd;
    final noteText = _noteTextFieldController.text;
    final bagsCount = 0;
    final wastes = context.read<PickupBagProvider>().pickups;
    print("wastessssss$wastes");
    Pickup pickup = Pickup(
      address: addressSeletion != null ? addressSeletion : Address(),
      addressId: addressId,
      date: dates,
      timeBegin: timeBegins,
      timeEnd: timeEnds,
      noteForDriver: noteText,
      bagCount: bagsCount,
      newBags: null,
      pickupBag: wastes ?? null,
    );
//    inspect();

    if (addressSeletion != null &&
        addressId > 0 &&
        dates != null &&
        dates.isNotEmpty &&
        timeBegins != null &&
        timeBegin.isNotEmpty &&
        timeEnd.isNotEmpty &&
        timeEnd != null &&
        wastes != null &&
        wastes.isNotEmpty) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Pickup successfully added'),
                //content: const Text('Scan or the type correct code'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context).cancelText)),
                  TextButton(
                    onPressed: () {
                      _pickupBloc.add(PickupSumbited(pickup: pickup));
                      Future.delayed(Duration(microseconds: 1000), () {
                        context.read<PickupBagProvider>().initPickupBas();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false,
                        );

                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => HomeScreen(),
                        // ));
                      });
                    },
                    child: const Text('OK'),
                  ),
                ],
              ));
    } else {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1500),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: notEqalTmie
                      ? Text(AppLocalizations.of(context).periodTimeText)
                      : Text(AppLocalizations.of(context).fieldErrorText),
                ),

                Icon(Icons.error),
                // CircularProgressIndicator(
                //   valueColor:
                //       AlwaysStoppedAnimation<
                //               Color>(
                //           Colors.white),
                // )
              ],
            ),
            backgroundColor: Colors.red.shade500,
          ),
        );
      // Future.delayed(Duration(seconds: 3),
      //     () {

    }

    // _getValues(pickup);
  }

  _onNoteFieldChanged() {
    _pickupBloc.add(PicupNoteChanged(note: _noteTextFieldController.text));
  }

  @override
  void dispose() {
    _noteTextFieldController.dispose();
    super.dispose();
  }
}
//  DropdownButton(
//                 items: snapshot.data.map((value) {
//                   return new DropdownMenuItem(
//                     value: value,
//                     child: new Text(
//                       'value.street',
//                     ),
//                   );
//                 }).toList(),
//                 value: select_dataItem == "" ? null : select_dataItem,
//                 onChanged: (v) {
//                   FocusScope.of(context).requestFocus(new FocusNode());
//                   setState(() {
//                     select_dataItem = v;
//                     print("selected $select_dataItem");
//                   });
//                 },
//                 isExpanded: true,
//                 hint: Text(
//                   'Select Source',
//                 ),
//               ),
