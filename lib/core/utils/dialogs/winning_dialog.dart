import 'package:flutter/material.dart';

class WinningDialog extends StatelessWidget {
  final int reward;

  const WinningDialog({required this.reward});

  @override
  Widget build(BuildContext dialogContext) {
    return Dialog(
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: Duration(milliseconds: 400),
              scale: 1.2,
              child: Icon(Icons.star, color: Colors.amberAccent, size: 60),
            ),
            SizedBox(height: 16),
            Text("You Won!",
                style: TextStyle(color: Colors.white, fontSize: 24)),
            SizedBox(height: 10),
            Text("+$reward Chips",
                style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
                Navigator.pop(dialogContext, true);
              },
              child: Text("OK"),
            )
          ],
        ),
      ),
    );
  }
}
