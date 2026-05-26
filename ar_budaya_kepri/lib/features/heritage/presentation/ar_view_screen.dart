import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

import '../../../core/theme.dart';

class ARViewScreen extends StatefulWidget {
  final String id;

  const ARViewScreen({
    super.key,
    required this.id,
  });

  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> {
  UnityWidgetController? _unityWidgetController;
  bool _isUnityLoaded = false;

  @override
  void dispose() {
    // Strict memory cleanup to avoid native process leaks and OOM crashes on < 4GB RAM devices
    try {
      _unityWidgetController?.pause();
      _unityWidgetController?.unload();
      _unityWidgetController?.dispose();
    } catch (e) {
      debugPrint('Error occurred during Unity Controller disposal: $e');
    }
    super.dispose();
  }

  void _onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
    setState(() => _isUnityLoaded = true);
    debugPrint('AR BRIDGE: Unity Controller created, waiting for READY handshake...');
  }

  void _sendHeritageIdToUnity() {
    try {
      _unityWidgetController?.postMessage(
        'FlutterBridgeReceiver',
        'OnHeritageReceived',
        widget.id,
      );
      debugPrint('AR BRIDGE: Sent heritage ID "${widget.id}" to Unity GameObject "FlutterBridgeReceiver"');
    } catch (e) {
      debugPrint('Failed to send heritage ID to Unity: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black, // Dark focus for AR overlay transitions
      body: Stack(
        children: [
          // Live Embedded Unity Widget Subview
          UnityWidget(
            onUnityCreated: _onUnityCreated,
            onUnityMessage: (message) {
              debugPrint('AR BRIDGE: Received message from Unity: $message');
              if (message == 'exit') {
                Navigator.of(context).pop();
              } else if (message == 'READY') {
                _sendHeritageIdToUnity();
              }
            },
            onUnitySceneLoaded: (scene) {
              debugPrint('AR BRIDGE: Unity Scene Loaded: ${scene?.name}');
            },
          ),

          // Custom visual overlay layout
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Premium Floating Exit Key
                CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    tooltip: 'Exit AR View',
                    onPressed: () {
                      _unityWidgetController?.unload();
                      Navigator.of(context).pop();
                    },
                  ),
                ),

                // Connected status overlay
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _isUnityLoaded ? AppTheme.emeraldAccent : Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isUnityLoaded ? 'AR Active: ${widget.id}' : 'Loading Engine...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Loading cover while Unity binaries are initialization
          if (!_isUnityLoaded)
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        color: AppTheme.oceanTealLight,
                        strokeWidth: 4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Initializing Unity AR Layer',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Setting up 360° virtual overlay. Please wait...',
                      style: TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
