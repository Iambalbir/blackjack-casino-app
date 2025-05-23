import '../../../export_file.dart';

Future<void> showGameModeDialog(
    BuildContext context, Function(String) onSelectMode) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),side: BorderSide(color: Colors.white,width: width_2)),
        title: Text(
          "Choose Mode",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModeOptionTile(
              icon: Icons.person,
              title: "Single Player",
              subtitle: "Play against AI Dealer or Opponents",
              onTap: () {
                Navigator.pop(context);
                onSelectMode(TYPE_SINGLE);
              },
            ),
            SizedBox(height: 10),
            ModeOptionTile(
              icon: Icons.group,
              title: "Multiplayer",
              subtitle: "Join others in real-time match",
              onTap: () {
                Navigator.pop(context);
                onSelectMode(TYPE_MULTI);
              },
            ),
          ],
        ),
      );
    },
  );
}

class ModeOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ModeOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue[100],
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          textStyleBodyMedium(context)),
                  Text(subtitle,
                      style: textStyleBodySmall(context)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
