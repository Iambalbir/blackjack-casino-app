import 'package:app/app/modules/games/screens/multiplayer_screen.dart';
import 'package:app/core/utils/dialogs/select_betamount_dialog.dart';

import '../../../../export_file.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🎰 Gambling Hub"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Main Menu",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Play Games Section
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _gameTile(context, "Blackjack", Icons.sports_esports, () {
                    showGameModeDialog(context, (mode) {
                      if (mode == TYPE_SINGLE) {
                        Navigator.of(context).pushNamed(
                          RouteName.playBlackJackScreenRoute,
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlackjackGameScreen()),
                        );
                      }
                    });
                  }),
                  _gameTile(context, "Slots", Icons.casino, () {
                    showBetDialog(context, 0, (amount) {
                      Navigator.pushNamed(
                          context, RouteName.playSlotMachineScreenRoute,
                          arguments: {"amount": amount});
                    });
                  }),
                  _gameTile(context, "Poker", Icons.emoji_events, () {
                    Navigator.of(context).pushNamed('/pokerModeSelector');
                  }),
                  _gameTile(context, "Multiplayer Lobby", Icons.group, () {
                    Navigator.of(context).pushNamed('/multiplayerLobby');
                  }),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Other Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomOptionTile(
                    context, "Leaderboard", Icons.leaderboard, '/leaderboard'),
                _bottomOptionTile(context, "Settings", Icons.settings,
                    RouteName.settingsScreenRoute),
                _bottomOptionTile(context, "Wallet",
                    Icons.account_balance_wallet, RouteName.walletScreenRoute),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _gameTile(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: kBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomOptionTile(
      BuildContext context, String label, IconData icon, String routeName) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(routeName),
      child: Column(
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
