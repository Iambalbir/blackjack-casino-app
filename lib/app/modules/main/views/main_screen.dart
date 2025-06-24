import 'package:app/app/modules/internet_check/view/no_internet_screen.dart';
import 'package:app/app/modules/main/main_bloc/main_bloc.dart';
import 'package:app/app/modules/main/main_bloc/main_events.dart';
import 'package:app/app/modules/main/main_bloc/main_state.dart';

import '../../../../export_file.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<MainScreenBloc, MainScreenStates>(
      listener: (context, state) {
        if (!state.isLoading && state.isRoomCreated && state.roomCode != '') {
          final List<Map<String, dynamic>> playerList = [
            state.host,
          ];
          Navigator.pushNamed(
            context,
            RouteName.multiPlayerBlackJackScreenRoute,
            arguments: {
              "roomCode": state.roomCode,
              "players": playerList,
              "isGameActiveStatus": false,
              "type": "private",
              "roomType": TYPE_SINGLE_PLAYER
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.all(margin_15),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [kBackground, Colors.grey],
                    begin: Alignment.topRight)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: height_40,
                ),
                TextView(
                  text: "🎰 GAMING HUB",
                  textStyle: textStyleHeadingMedium(context)
                      .copyWith(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: height_20),

                // Play Games Section
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _gameTile(context, "Blackjack ♠️", Icons.sports_esports,
                          () {
                        context
                            .read<MainScreenBloc>()
                            .add(CreateSinglePlayerRoomEvent(context));

                        ///previous game flow
                        /* Navigator.of(context).pushNamed(
                      RouteName.playBlackJackScreenRoute,
                    );*/

                        ///commented for the testing single player lobby section
                        /* showGameModeDialog(context, (mode) {
                      if (mode == TYPE_SINGLE) {
                        Navigator.of(context).pushNamed(
                          RouteName.playBlackJackScreenRoute,
                        );
                      } else {
                        Navigator.pushNamed(
                            context, RouteName.playersLobbyScreenRoute);
                      }
                    });*/ //changed to testing only
                      }),
                      _gameTile(context, "Slots 🎰", Icons.casino, () {
                        showBetDialog(context, 0, (amount) {
                          Navigator.pop(context);

                          Navigator.pushNamed(
                              context, RouteName.playSlotMachineScreenRoute,
                              arguments: {"amount": amount});
                        });
                      }),
                      _gameTile(context, "POKER 🃏", Icons.emoji_events, () {
                        Navigator.of(context).pushNamed(
                            RouteName.pokerGamePlayScreen,
                            arguments: {"players": []});
                      }),
                      _gameTile(context, "Multiplayer Lobby", Icons.group, () {
                        Navigator.of(context)
                            .pushNamed(RouteName.publicLobbyListingScreenRoute);
                      }),
                    ],
                  ),
                ),

                SizedBox(height: height_20),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RouteName.activeGamesScreenRoute);
                    },
                    child: TextView(
                      text: '🎮 Active Games',
                      textStyle: textStyleBodyMedium(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height_10),
                // Other Options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _bottomOptionTile(context, "Leaderboard", Icons.leaderboard,
                        RouteName.leaderBoardScreenRoute),
                    _bottomOptionTile(context, "Settings", Icons.settings,
                        RouteName.settingsScreenRoute),
                    _bottomOptionTile(
                        context,
                        "Wallet",
                        Icons.account_balance_wallet,
                        RouteName.walletScreenRoute),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("invitations")
                            .where("to.uid", isEqualTo: currentUserModel.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          dynamic invitationsListing;
                          invitationsListing = snapshot.data?.docs ?? [];

                          return _bottomOptionTile(
                              context,
                              "Invitations",
                              Icons.mail_outline,
                              RouteName.invitationScreenRoute,
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
                                            text:
                                                "${invitationsListing.length}",
                                            textStyle:
                                                textStyleBodyMedium(context)
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
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
      },
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
        firebaseRepository.checkCurrentUser();
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
