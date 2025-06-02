import '../../../export_file.dart';

void showBetDialog(
    BuildContext context, int currentBet, Function(int) onBetSelected) {
  int selectedBet = currentBet;
  bool doubleBet = false;

  showDialog(
    context: context,
    useRootNavigator: true,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Select Bet Amount"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 10,
                  children: [10, 25, 50, 100]
                      .map((bet) => ChoiceChip(
                            label: Text("$bet"),
                            selected: selectedBet == bet,
                            onSelected: (_) =>
                                setState(() => selectedBet = bet),
                          ))
                      .toList(),
                ),
                SizedBox(height: 10),
                CheckboxListTile(
                  title: Text("Double the Bet"),
                  value: doubleBet,
                  onChanged: (value) => setState(() => doubleBet = value!),
                ),
                SizedBox(height: 10),
                Text(
                  "Selected Amount: \$${doubleBet ? selectedBet * 2 : selectedBet}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Confirm"),
            onPressed: () {
              if (selectedBet != 0) {
                if (selectedBet > bankAmount.value) {
                  showToast("You don't have enough chips");
                } else {
                  onBetSelected(doubleBet ? selectedBet * 2 : selectedBet);
                }
              } else {
                showToast("Please select an amount");
              }
            },
          ),
        ],
      );
    },
  );
}
