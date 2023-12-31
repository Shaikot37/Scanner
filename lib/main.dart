import 'package:flutter/material.dart';
import 'package:scanner/widgets/Custom3DButton.dart';

import 'pages/BarScannerPage.dart';
import 'pages/QRScannerPage.dart';

void main() {
  runApp(const Scanner());
}

class Scanner extends StatelessWidget {
  const Scanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      darkTheme: ThemeData(
          brightness: Brightness.dark, primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
      Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
          colors: [
            Color(0xFFADE8B0), // Start color
            Color(0xFFFFFFFF), // End color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 300), // Set the maximum width
                width: MediaQuery.of(context).size.width * 0.8, // Responsive width
                child: Custom3DButton(
                  onPressed: () {
                    // Navigate to the first page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QrcodeScannerPage()),
                    );
                  },
                  text: 'Scan QR',
                ),
              ),
              const SizedBox(height: 20), // Add some spacing between the buttons
              Container(
                constraints: const BoxConstraints(maxWidth: 300), // Set the maximum width
                width: MediaQuery.of(context).size.width * 0.8, // Responsive width
                child: Custom3DButton(
                  onPressed: () {
                    // Navigate to the second page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
                    );
                  },
                  text: 'Scan Barcode',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



