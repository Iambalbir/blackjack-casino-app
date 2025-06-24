import 'package:app/export_file.dart';

class LeaderboardDialog extends StatelessWidget {
  final Map<String, dynamic>
      playerResults; // uid -> result like "win", "lose", "bust", "push"
  final Map<dynamic, dynamic>
      playerNames; // uid -> player display name (optional)
  final Map<String, dynamic> playerPayouts;
  dynamic onCloseTap; // uid -> payout amount

  LeaderboardDialog({
    required this.playerResults,
    required this.playerNames,
    this.onCloseTap,
    required this.playerPayouts,
  });

  Color _getResultColor(String result) {
    switch (result.toLowerCase()) {
      case 'win':
        return Colors.green;
      case 'lose':
        return Colors.red;
      case 'bust':
        return Colors.orange;
      case 'push':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  IconData _getResultIcon(String result) {
    switch (result.toLowerCase()) {
      case 'win':
        return Icons.emoji_events; // trophy icon
      case 'lose':
        return Icons.close; // cross icon
      case 'bust':
        return Icons.warning; // warning icon
      case 'push':
        return Icons.remove; // dash icon for tie
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Game Results'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: playerResults.length,
          itemBuilder: (context, index) {
            final uid = playerResults.keys.elementAt(index);
            final result = playerResults[uid] ?? 'unknown';
            final playerName = playerNames[uid] ?? uid;
            final payout =
                playerPayouts[uid] ?? 0.0; // Get payout, default to 0.0

            return ListTile(
              leading: Icon(
                _getResultIcon(result),
                color: _getResultColor(result),
              ),
              title: Text(playerName),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    result.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getResultColor(result),
                    ),
                  ),
                  uid == "dealer" || result == "lose"
                      ? SizedBox()
                      : Text(
                          '\$${payout.toStringAsFixed(2)}', // Display payout
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Or any color you prefer
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCloseTap ??
              () => Navigator.pushNamedAndRemoveUntil(
                  context, RouteName.streamUserStateScreenRoute, (v) => false),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
