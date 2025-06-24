import 'package:flutter/material.dart';

class LoseOverlay {
  static LoseOverlay? _instance;

  LoseOverlay._createObject();

  factory LoseOverlay() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = LoseOverlay._createObject();
      return _instance!;
    }
  }

  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;

  void _buildOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: <Widget>[
            Container(
              color: Colors.black.withOpacity(0.5), // Background overlay
            ),
            // Centered Lose Text with emoji
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '😢', // Sad emoji
                    style: TextStyle(
                      fontSize: 80, // Adjust emoji size
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'You Lose!',
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: "luck",
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black54,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void show(BuildContext context) {
    _overlayState = Overlay.of(context);
    if (_overlayEntry == null) {
      _buildOverlay();
    }
    _overlayState!.insert(_overlayEntry!);
  }

  void hide() {
    try {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
    } catch (_) {}
  }
}
