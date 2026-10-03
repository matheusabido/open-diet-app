import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:open_diet/components/input/barcode_input.dart';
import 'package:open_diet/theme/colors.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  static final _barcodePattern = RegExp(r'^\d{8,14}$');

  final scanner = MobileScannerController(
    formats: [.ean13, .ean8, .upcA, .upcE],
  );
  final controller = TextEditingController();

  bool found = false;
  String? errorMessage;

  void onDetect(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value != null) return select(value);
    }
  }

  void submit() {
    select(controller.text.trim());
  }

  void select(String barcode) {
    if (found) return;

    if (!_barcodePattern.hasMatch(barcode)) {
      setState(() {
        errorMessage = 'Código de barras deve ter entre 8 e 14 dígitos';
      });
      return;
    }

    found = true;
    Navigator.of(context).pop(barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Ler código de barras'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.grey.shade200,
      ),
      body: SafeArea(
        child: Padding(
          padding: .all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 16,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: MobileScanner(controller: scanner, onDetect: onDetect),
                ),
              ),
              Text(
                'Aponte a câmera para o código de barras do produto',
                textAlign: .center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              BarcodeInput(controller: controller, onSubmit: submit),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  textAlign: .center,
                  style: TextStyle(color: Colors.red.shade300),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scanner.dispose();
    controller.dispose();
    super.dispose();
  }
}
