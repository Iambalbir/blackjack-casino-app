import '../../../export_file.dart';

Future<bool> showLosingDialog(BuildContext context) async {
  final shouldRebet = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedOpacity(
                opacity: 1,
                duration: Duration(milliseconds: 600),
                child: Icon(Icons.sentiment_dissatisfied,
                    color: Colors.redAccent, size: 60),
              ),
              SizedBox(height: 16),
              Text("You Lost!",
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              SizedBox(height: 10),
              Text("Try again!",
                  style: TextStyle(color: Colors.white54, fontSize: 16)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext, false);
                      Navigator.pop(dialogContext, true);
                    },
                    child: Text("OK"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext, true); // ✅ Rebet
                      // ✅ Rebet
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text("Rebet"),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );

  return shouldRebet ?? false;
}
