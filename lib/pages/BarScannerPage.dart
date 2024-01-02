import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../widgets/CircularScannerClip.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final GlobalKey _barcodeKey = GlobalKey(debugLabel: 'Barcode');
  QRViewController? _barcodeController;
  String scanMessage = "Please position the Barcode within the camera view";
  String lastScanResult = "";

  @override
  void dispose() {
    _barcodeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double boxSize = MediaQuery.of(context).size.width * 0.9; // Adjust as needed

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 100.0, left: 20.0,right: 20.0),
        color: Colors.white,
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 100,
                  child: QRView(
                    key: _barcodeKey,
                    onQRViewCreated: (controller) {
                      setState(() {
                        _barcodeController = controller;
                      });
                      controller.scannedDataStream.listen((Barcode scanData) {
                        if (scanData.code!.isNotEmpty) {
                          if (scanData.format == BarcodeFormat.qrcode) {
                            setState(() {
                              scanMessage = "It's a QR Code. Please try again with a Barcode.";
                            });
                          } else {
                            // Handle barcode scan here
                            setState(() {
                              scanMessage = "Barcode Detected";
                              lastScanResult = scanData.code!;
                            });
                          }
                        } else {
                          setState(() {
                            scanMessage = "Please position the Barcode within the camera view";
                          });
                        }
                      });
                    },
                  ),
                ),
                Center(
                  child: Container(
                    width: boxSize,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipPath(
                      clipper: CircularScannerClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(

              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    scanMessage,
                    style: const TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  if (scanMessage == "Barcode Detected")
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          scanMessage = "Please position the Barcode within the camera view";
                        });
                        // Navigate to a different page and pass the barcode value
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BarcodeResultPage(lastScanResult),
                          ),
                        );
                      },
                      child: const Text('Scan Now'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _barcodeController?.toggleFlash();
        },
        child: const Icon(Icons.flash_on),
      ),
    );
  }
}

class BarcodeResultPage extends StatelessWidget {
  final String barcodeResult;

  const BarcodeResultPage(this.barcodeResult);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            // Top section with "Successfully Scanned!!" text
            const Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Successfully Scanned!!',
                style: TextStyle(fontSize: 18.0, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),

            // Centered section with barcode result, a bit higher than the center
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 70.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Barcode Value',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        barcodeResult,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


void main() {
  runApp(const MaterialApp(
    home: BarcodeScannerPage(),
  ));
}
