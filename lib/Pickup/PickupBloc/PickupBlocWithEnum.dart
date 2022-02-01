import 'dart:async';
import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:smart_apaga/Pickup/Model/Pickup.dart';

import 'package:smart_apaga/globals.dart';

enum PickupAction { Ongoing, Passed, Cancel }

class PickupBlocs {
  int counter;
  Pickup pickup;
  final stateStreamController = StreamController<List<Pickup>>();
  StreamSink<List<Pickup>> get pickupSink => stateStreamController.sink;
  Stream<List<Pickup>> get pickupStream => stateStreamController.stream;

  final _eventStreamController = StreamController<String>();
  StreamSink<String> get eventSink => _eventStreamController.sink;
  Stream<String> get _eventStream => _eventStreamController.stream;

  PickupBlocs() {
    _eventStream.listen((event) async {
      String url;

      if (event == ApiEndpoints.pickupsOngoing ||
          event == ApiEndpoints.pickupsPassed) {
        try {
          if (event == ApiEndpoints.pickupsOngoing) {
            url = ApiEndpoints.pickupsOngoing;
          } else if (event == ApiEndpoints.pickupsPassed) {
            url = ApiEndpoints.pickupsPassed;
          }

          var pickups = await fetchPickup(url);
          if (pickups != null) {
            if (stateStreamController.isClosed) {
              print('Samthing went wrong');
            } else {
              pickupSink.add(pickups);
            }
          } else
            pickupSink.addError('Samthing went wrong');
        } on Exception catch (e) {
          pickupSink.addError('Samthing went wrong: $e');
        }
      } else if (event.contains('cancel')) {
        url = event.toString();
        await _cancelPickup(url);
        print('Cancel_Url');
      }
      // } else if (event.contains('edit')) {
      //   url = event.toString();
      //  // await editPickup(url: url);
      //   print('Edit_Url');
      // }
    });
  }

  void dispose() {
    stateStreamController.close();
    _eventStreamController.close();
  }

  Future<List<Pickup>> fetchPickup(String url) async {
    String token = await FlutterSession().get('token');
    List<Pickup> pickups = [];

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      var body = jsonDecode(response.body);

      if (body['status'] == 1) {
        dynamic data = body['data'];
        print(data);
        data.forEach((element) {
          Pickup pickup = Pickup.fromJson(element);
          pickups.add(pickup);
        });
        pickups = List<Pickup>.from(data.map((e) => Pickup.fromJson(e)));
        // inspect('Pickujp - $pickups');
        pickupSink.add(pickups);

        return pickups;
      }
    } catch (e) {
      print(e);
    }

    return pickups;
  }

  Future<void> _cancelPickup(String url) async {
    String token = await FlutterSession().get('token');
    //List<Pickup> pickups = [];
    // print(token);
    // if (token is String) {
    //   print("Is string");
    // }
    print('UrlEdit - $url');

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print('Response -- ${response.statusCode}');

      var body = jsonDecode(response.body);

      print('Body $body');
      if (body['status'] == 1) {
        print('sucsess');
      }
    } catch (e) {
      // return throw Exception('Failed to cancel pickup');
      print(e);
    }
    //   return pickups;
  }

  Future<Pickup> editPickup({String url, Pickup pickup}) async {
    String token = await FlutterSession().get('token');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(pickup.toMap()),
      );

      print(response.body);
      print("Statuse Code Address${response.statusCode}");

      var body = jsonDecode(response.body);

      if (body['status'] == 1) {
        return Pickup.fromJson(json.decode(response.body));
      }
    } catch (e) {
      //  return throw Exception('Failed to edit Pickup');
      print(e);
    }
  }
}
