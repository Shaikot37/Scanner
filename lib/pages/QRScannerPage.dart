import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../widgets/CircularScannerClip.dart';

class QrcodeScannerPage extends StatefulWidget {
  const QrcodeScannerPage({Key? key}) : super(key: key);

  @override
  _QrcodeScannerPageState createState() => _QrcodeScannerPageState();
}

class _QrcodeScannerPageState extends State<QrcodeScannerPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrViewController;
  String scanMessage = "Please position the QR code within the camera view";
  String lastScanResult = "";

  @override
  void dispose() {
    _qrViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double boxSize = MediaQuery.of(context).size.width * 0.9; // Adjust as needed

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 100.0, left: 20.0,right: 20.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(

                children: [
                  QRView(
                    key: _qrKey,
                    onQRViewCreated: (controller) {
                      setState(() {
                        _qrViewController = controller;
                      });
                      controller.scannedDataStream.listen((Barcode scanData) {
                        if (scanData.code!.isNotEmpty) {
                          if (scanData.format != BarcodeFormat.qrcode) {
                            setState(() {
                              scanMessage = "It's a Barcode. Please try again with a QR code.";
                            });
                          } else {
                            // Handle barcode scan here
                            setState(() {
                              scanMessage = "QR Code Detected";
                              lastScanResult = scanData.code!;
                            });
                          }
                        } else {
                          setState(() {
                            scanMessage = "Please position the QR code within the camera view";
                          });
                        }
                      });
                    },
                  ),
                  Center(

                    child: Container(
                      width: boxSize,
                      height: boxSize,
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
            ),
            Container(
              height: 300, // Set the desired height for the barcode scanner
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    scanMessage,
                    style: const TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  if (scanMessage == "QR Code Detected")
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          scanMessage = "Please position the QR code within the camera view";
                        });
                        // Navigate to a different page and pass the barcode value
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QrcodeResultPage(lastScanResult),
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
          _qrViewController?.toggleFlash();
        },
        child: const Icon(Icons.flash_on),
      ),
    );
  }
}

class QrcodeResultPage extends StatelessWidget {
  final String qrcodeResult;

  const QrcodeResultPage(this.qrcodeResult);

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
                margin: const EdgeInsets.only(top: 70.0), // Adjust the top margin as needed
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'QR Code Value',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        qrcodeResult,
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
    home: QrcodeScannerPage(),
  ));
}
