import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BetSelectionDialog extends StatefulWidget {
  final bankAmount;

  const BetSelectionDialog({Key? key, required this.bankAmount})
      : super(key: key);

  @override
  _BetSelectionDialogState createState() => _BetSelectionDialogState();
}

class _BetSelectionDialogState extends State<BetSelectionDialog> {
  double _selectedBet = 0;

  void _updateBet(double value) {
    setState(() {
      _selectedBet = value;
    });
  }

  void _addToBet(double amount) {
    if (_selectedBet + amount <= widget.bankAmount) {
      setState(() {
        _selectedBet += amount;
      });
    } else {
      _showToast("You don't have enough funds.");
    }
  }

  void _doubleBet() {
    double doubledBet = _selectedBet * 2;
    if (doubledBet <= widget.bankAmount) {
      setState(() {
        _selectedBet = doubledBet;
      });
    } else {
      _showToast("You don't have enough funds.");
    }
  }

  void _confirmBet() {
    if (_selectedBet > widget.bankAmount) {
      _showToast("You don't have enough funds.");
    } else if(_selectedBet==0){
      _showToast("Please select valid amount.");

    } else {
      // Proceed with the bet
      Navigator.of(context).pop(_selectedBet);
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Select Bet Amount",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Current Bet: \$${_selectedBet.toString().split(".")[0]}",
              style: TextStyle(fontSize: 18),
            ),
            Slider(
              value: _selectedBet,
              min: 0,
              max: double.tryParse(widget.bankAmount.toString()) ?? 0.0,
              divisions: (widget.bankAmount ~/ 10).toInt(),
              label: _selectedBet.toStringAsFixed(2),
              onChanged: _updateBet,
            ),
            Wrap(
              children: [
                ElevatedButton(
                  onPressed: () => _addToBet(10),
                  child: Text("+10"),
                ),
                ElevatedButton(
                  onPressed: () => _addToBet(20),
                  child: Text("+20"),
                ),
                ElevatedButton(
                  onPressed: () => _addToBet(50),
                  child: Text("+50"),
                ),
                ElevatedButton(
                  onPressed: () => _addToBet(100),
                  child: Text("+100"),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _doubleBet,
              child: Text("Double Bet"),
            ),
          ],
        ),
      ),
      actions: [
      /*  TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),*/
        ElevatedButton(
          onPressed: _confirmBet,
          child: Text("Confirm"),
        ),
      ],
    );
  }
}
