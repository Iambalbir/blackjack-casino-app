import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiOverlay {
  static ConfettiOverlay? _instance;

  ConfettiOverlay._createObject();

  factory ConfettiOverlay() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = ConfettiOverlay._createObject();
      return _instance!;
    }
  }

  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;
  ConfettiController? _confettiController;

  void _buildOverlay() {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: <Widget>[
            Container(
              color: Colors.black.withOpacity(0.5), // Background overlay
            ),
            // Position confetti widget at top-left corner
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: ConfettiWidget(
                confettiController: _confettiController!,
                blastDirection: 0.75 * 3.14,
                // ~135 degrees down-left
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.05,
                numberOfParticles: 100,
                maxBlastForce: 20,
                minBlastForce: 8,
                gravity: 0.1,
                particleDrag: 0.05,
                // Customize colors
                colors: [
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.purple,
                  Colors.orange,
                  Colors.pink,
                ],
              ),
            ),
            // Centered Victory Text with zoom-in animation
            Center(
              child: AnimatedScale(
                scale: 1.5,
                // Final scale
                duration: const Duration(seconds: 2),
                // Duration of the animation
                curve: Curves.easeInOut,
                // Animation curve
                child: Text(
                  'Victory!',
                  style: TextStyle(
                    fontSize: 40,
                    // Adjust font size as needed
                    fontFamily: "luck",
                    fontWeight: FontWeight.bold,
                    color: kBackground,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
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
    _confettiController!.play();
  }

  void hide() {
    try {
      if (_overlayEntry != null) {
        _confettiController?.dispose();
        _overlayEntry!.remove();
        _overlayEntry = null;
        _confettiController = null;
      }
    } catch (_) {}
  }
}
