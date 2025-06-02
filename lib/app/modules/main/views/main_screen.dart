import 'package:app/app/modules/games/screens/multiplayer_screen.dart';

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
            SizedBox(height: height_20),

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
                        Navigator.pushNamed(
                            context, RouteName.playersLobbyScreenRoute);
                      }
                    });
                  }),
                  _gameTile(context, "Slots", Icons.casino, () {
                    showBetDialog(context, 0, (amount) {
                      Navigator.pop(context);

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

            SizedBox(height: height_20),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rooms')
                  .where("status", isEqualTo: "active")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final activeGames = snapshot.data?.docs ?? [];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteName.activeGamesScreenRoute);
                      },
                      child: TextView(
                        text:
                            '🎮 ${activeGames.length} Active Game${activeGames.length == 1 ? '' : 's'}',
                        textStyle: textStyleBodyMedium(context).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),

            // Other Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomOptionTile(context, "Leaderboard", Icons.leaderboard,
                    RouteName.leaderBoardScreenRoute),
                _bottomOptionTile(context, "Settings", Icons.settings,
                    RouteName.settingsScreenRoute),
                _bottomOptionTile(context, "Wallet",
                    Icons.account_balance_wallet, RouteName.walletScreenRoute),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("invitations")
                        .where("to.uid", isEqualTo: currentUserModel.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      dynamic invitationsListing = snapshot.data?.docs ?? [];

                      return _bottomOptionTile(context, "Invitations",
                          Icons.mail_outline, RouteName.invitationScreenRoute,
                          countIcon: invitationsListing.length == 0
                              ? SizedBox()
                              : Container(
                                  margin: EdgeInsets.only(bottom: margin_9),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kBackground,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(margin_4),
                                    child: TextView(
                                        text: "${invitationsListing.length}",
                                        textStyle: textStyleBodyMedium(context)
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ));
                    }),
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
      BuildContext context, String label, IconData icon, String routeName,
      {countIcon}) {
    return GestureDetector(
      onTap: () {
        apiRepository.checkCurrentUser();
        Navigator.of(context).pushNamed(routeName);
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            children: [
              Icon(icon, size: 30),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
          Positioned(top: -5, child: countIcon ?? SizedBox())
        ],
      ),
    );
  }
}
