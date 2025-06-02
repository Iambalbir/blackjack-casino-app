import 'package:flutter/material.dart';

class LeaderboardDialog extends StatelessWidget {
  final Map<String, String> playerResults; // uid -> result like "win", "lose", "bust", "push"
  final Map<dynamic, dynamic> playerNames; // uid -> player display name (optional)

  LeaderboardDialog({
    required this.playerResults,
    required this.playerNames,
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

            return ListTile(
              leading: Icon(
                _getResultIcon(result),
                color: _getResultColor(result),
              ),
              title: Text(playerName),
              trailing: Text(
                result.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getResultColor(result),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
