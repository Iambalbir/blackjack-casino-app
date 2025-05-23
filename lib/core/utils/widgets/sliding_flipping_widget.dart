import 'package:app/app/modules/games/screens/play_blackjack_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';

class SlidingFlippingCard extends StatefulWidget {
  final double left;
  final double top;
  final Duration slideDuration;
  final String card;
  final String face;
  final double width;
  final double height;
  final bool isFlipped;
  final VoidCallback? onAnimationEnd;

  const SlidingFlippingCard({
    Key? key,
    required this.left,
    required this.top,
    required this.slideDuration,
    required this.card,
    required this.face,
    required this.isFlipped,
    required this.width,
    required this.height,
    this.onAnimationEnd,
  }) : super(key: key);

  @override
  _SlidingFlippingCardState createState() => _SlidingFlippingCardState();
}

class _SlidingFlippingCardState extends State<SlidingFlippingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    if (widget.face == kFaceUpCard && widget.isFlipped) {
      _flipController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant SlidingFlippingCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart flip animation if card face has changed
    if (oldWidget.face != widget.face) {
      if (widget.face == kFaceUpCard) {
        Future.delayed(const Duration(milliseconds: 900), () {
          if (mounted) _flipController.forward();
        });
      } else {
        _flipController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: widget.left,
      top: widget.top,
      duration: widget.slideDuration,
      curve: Curves.decelerate,
      onEnd: () {
        // Trigger flip if face-up and animation hasn't started
        if (widget.face == kFaceUpCard && _flipController.value == 0.0) {
          Future.delayed(const Duration(milliseconds: 900), () {
            if (mounted)
              _flipController.forward().then((_) {
                widget.onAnimationEnd?.call();
              });
          });
        }
      },
      child: AnimatedBuilder(
        animation: _flipController,
        builder: (context, child) {
          final angle = _flipController.value * 3.1416;
          final isFront = _flipController.value < 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? cardBuilder(
                    widget.width, widget.height, widget.card, kFaceDownCard)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.1416),
                    child: cardBuilder(
                        widget.width, widget.height, widget.card, kFaceUpCard),
                  ),
          );
        },
      ),
    );
  }
}
