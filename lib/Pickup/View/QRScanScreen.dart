import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_session/flutter_session.dart';
import 'package:provider/provider.dart';
import 'package:smart_apaga/Pickup/View/Widgets/provider.dart';
import 'package:smart_apaga/globals.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smart_apaga/Pickup/View/WastTypeScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  Barcode result;

  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool hasData = false;
  String previewQr;

  int bagCount = 0;
  TextEditingController _textFieldController = TextEditingController();

  _QRScanScreenState();

  @override
  void initState() {
    //_textFieldController.addListener(_onTextFieldChange);
    super.initState();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    previewQr = _textFieldController.text;

    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context).scanQrCodeText),
            backgroundColor: Colors.green[300],
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                controller.stopCamera();
                Navigator.pop(context, true);
              },
            )),
        body: Column(
          children: <Widget>[
            Expanded(flex: 3, child: _buildQrView(context)),
            SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: [
                            Text(
                              'Bags',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: 23,
                            ),
                          ],
                        ),
                      ),

                      // SizedBox(
                      //   width: 50.0,
                      // ),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: screenSize.width * 0.4),
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
                            // _pushWastTypeScreen(
                            //     _textFieldController.text, context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WastTypeScreen(),
                                ));
                          },
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Text(
                                AppLocalizations.of(context).dontHaveBagsText,
                                style: TextStyle(fontSize: 14),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey),
                      labelText: AppLocalizations.of(context).bagIdText,
                      hintStyle:
                          TextStyle(color: Colors.grey[500], fontSize: 13),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green[700]),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    autocorrect: false,
                  ),
                  //
                  SizedBox(height: 20),
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: screenSize.width * 0.3),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.green),
                            ),
                            primary: Colors.green,
                            textStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.all(8.0),
                          ),
                          onPressed: () {
                            previewQr = _textFieldController.text;
                            if (_textFieldController.text != null ||
                                _textFieldController.text != '') {
                              sendQRCode(_textFieldController.text, context);
                            }
                          },
                          // _pushWastTypeScreen(null, context);
                          // openLisnk(url: 'http//:flutter.dev');

                          child: Text(
                            AppLocalizations.of(context).confirmId,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenSize.width * 0.10),
                    ],
                  ),
                  //
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: screenSize.width * 0.3,
                minHeight: screenSize.height * 0.1,
              ),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.grey),
                  onPressed: () => setState(() {
                        controller?.flipCamera();
                      }),
                  child: FutureBuilder(
                    future: controller?.getCameraInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        // return Text(
                        //     '${AppLocalizations.of(context).cameraFacingText} ${describeEnum(snapshot.data)}');
                        return Icon(Icons.switch_camera);
                      } else {
                        // return Text('loading');
                        return Icon(Icons.camera_alt);
                      }
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 500 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      cameraFacing: CameraFacing.front,
      onQRViewCreated: _onQRViewCreated,
      formatsAllowed: [BarcodeFormat.qrcode],
      //onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (result.code.isEmpty || result.code == null) {
        controller.stopCamera();
      } else {
        _textFieldController.text = result.code;
        controller.resumeCamera();
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

  Future<void> sendQRCode(String result, BuildContext context) async {
    dynamic token = await FlutterSession().get('token');
    var results = context.read<PickupBagProvider>().bagCodes;
    print('reseserasersd$results');
    var codeBag = results.last;
    print('$codeBag');
    try {
      final response = await http
          .get(Uri.parse(ApiEndpoints.exist + '?bagCode=$result'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      var body = jsonDecode(response.body);

      if (body['data'] == false) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Qr code not found'),
                  content: const Text('Scan or the type correct code'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ));
      } else {
        if (body['data'] == true && !codeBag.contains(result)) {
          _pushWastTypeScreen(result, context);

          // } else {
          //   showDialog(
          //       context: context,
          //       builder: (BuildContext context) => AlertDialog(
          //             title: const Text('Qr code not found'),
          //             content: const Text('Scan or the type correct code'),
          //             actions: <Widget>[
          //               TextButton(
          //                 onPressed: () => Navigator.pop(context, 'Cancel'),
          //                 child: const Text('Cancel'),
          //               ),
          //               TextButton(
          //                 onPressed: () => Navigator.pop(context, 'OK'),
          //                 child: const Text('OK'),
          //               ),
          //             ],
          //           ));
          // }
        } else if (codeBag.contains(result)) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(
              duration: Duration(milliseconds: 1500),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text('nuyn bagov text kaa arten'),
                  ),
                  Icon(Icons.error),
                ],
              ),
              backgroundColor: Colors.red.shade500,
            ));
        }
      }
    } catch (e) {
      return throw Exception('Failed to Scan');
    }
  }

  void _pushWastTypeScreen(String barCode, BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WastTypeScreen(
            barcode: barCode,
          ),
        ));
  }
}
