import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/state.dart';
import '../../../core/theme.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  // Controller memory lifecycle must be strictly managed for memory conservation on low-spec units
  late MobileScannerController _scannerController;
  bool _isScanProcessed = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    // Explicit clean disposal to avoid native memory leakage and OOM crashes
    _scannerController.dispose();
    super.dispose();
  }

  void _processScannedValue(String? rawValue) async {
    if (_isScanProcessed || rawValue == null) return;
    
    final trimmedValue = rawValue.trim().toLowerCase();
    
    // Check if the scanned value matches one of our heritage IDs
    try {
      final heritage = await heritageRepository.getHeritageById(trimmedValue);
      
      if (!mounted) return;

      if (heritage != null) {
        setState(() => _isScanProcessed = true);
        
        // Deep-link routing. Use go() or replace() to clear the scanner from the back-stack
        // So hitting "back" from details goes to Dashboard Home instead of locking in scanner loop.
        context.replace('/heritage/${heritage.id}?fromScan=true');
      } else {
        // Show non-blocking invalid QR warning
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unknown Museum Code: "$rawValue". Please scan an active exhibit QR code.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      debugPrint('Scanner database search failed: $e');
    }
  }

  void _showManualEntryDialog() {
    final textController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        final brightness = Theme.of(context).brightness;
        return AlertDialog(
          backgroundColor: brightness == Brightness.dark ? AppTheme.cardBgDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Manual Mock QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter a heritage ID (e.g. zapin, boria, gazal, makyong, mendu, gurindam12, mandisafar) to simulate a physical scan.',
                style: TextStyle(height: 1.4, fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Heritage ID',
                  hintText: 'e.g. zapin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.oceanTealPrimary, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final input = textController.text;
                Navigator.of(context).pop();
                _processScannedValue(input);
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black, // Dark cinematic focus for scanning
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CircleAvatar(
          backgroundColor: Colors.black38,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          'Museum Scanner',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Flash toggle
          IconButton(
            icon: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: () async {
              try {
                await _scannerController.toggleTorch();
                setState(() => _isFlashOn = !_isFlashOn);
              } catch (e) {
                debugPrint('Torch toggle failed: $e');
              }
            },
          ),
          // Lens flip toggle
          IconButton(
            icon: const Icon(Icons.flip_camera_android, color: Colors.white),
            onPressed: () async {
              try {
                await _scannerController.switchCamera();
              } catch (e) {
                debugPrint('Camera switch failed: $e');
              }
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Live Camera Stream Scanner Widget
          MobileScanner(
            controller: _scannerController,
            onDetect: (BarcodeCapture capture) {
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                _processScannedValue(barcode.rawValue);
              }
            },
            errorBuilder: (context, error) {
              return Container(
                color: Colors.black87,
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam_off_rounded, size: 72, color: Colors.redAccent),
                      const SizedBox(height: 24),
                      Text(
                        'Camera Initialization Failed',
                        style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.errorCode == MobileScannerErrorCode.controllerUninitialized
                            ? 'The device camera resources are busy or unavailable.'
                            : 'Please grant camera permissions in settings to scan museum booths.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, height: 1.4),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _showManualEntryDialog,
                        icon: const Icon(Icons.edit_note_rounded),
                        label: const Text('Simulate Dynamic QR Code'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Glassmorphic Scanner Overlay Finder
          IgnorePointer(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.emeraldAccent, width: 3),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Align QR/Barcode with the frame',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Overlay dynamic mock testing shortcut
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 54,
              child: OutlinedButton.icon(
                onPressed: _showManualEntryDialog,
                icon: const Icon(Icons.keyboard_outlined, color: Colors.white),
                label: const Text(
                  'Simulation Code Entry',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white30, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Colors.black26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
