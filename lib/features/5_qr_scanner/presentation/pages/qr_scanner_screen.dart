// File: lib/features/5_qr_scanner/presentation/pages/qr_scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/2_chat/data/repositories/chat_repository_impl.dart';
import 'package:flutter_task/features/5_qr_scanner/cubit/qr_scanner_cubit.dart';
import 'package:flutter_task/features/5_qr_scanner/cubit/qr_scanner_state.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrScannerCubit(ChatRepositoryImpl()),
      child: const QrScannerView(),
    );
  }
}

class QrScannerView extends StatefulWidget {
  const QrScannerView({super.key});

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView> {
  final MobileScannerController controller = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: BlocListener<QrScannerCubit, QrScannerState>(
        listener: (context, state) {
          if (state.status == QrStatus.success && state.chatRoomId != null) {
            // Navigate to the chat screen on success
            context.go('/chats/${state.chatRoomId}');
          }
          if (state.status == QrStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
            );
            // Reset processing flag to allow another scan
             setState(() {
              _isProcessing = false;
            });
          }
        },
        child: Stack(
          children: [
            MobileScanner(
              controller: controller,
              onDetect: (capture) {
                if (_isProcessing) return;

                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  setState(() {
                    _isProcessing = true;
                  });
                  context.read<QrScannerCubit>().onQrCodeScanned(barcodes.first.rawValue!);
                }
              },
            ),
            // Overlay with a cutout
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (_isProcessing)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
