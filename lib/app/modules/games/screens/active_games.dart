import '../../../../export_file.dart';

class ActiveGamesScreen extends StatelessWidget {
  const ActiveGamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gamesCollection =
        FirebaseFirestore.instance.collection(roomCollectionPath);

    return Scaffold(
      appBar: AppBar(
        title: TextView(
          text: 'Active Games',
          textStyle: textStyleHeadingMedium(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            gamesCollection.where("status", isEqualTo: "active").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading active games.'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final activeGames = snapshot.data?.docs ?? [];

          if (activeGames.isEmpty) {
            return Center(
              child: Text(
                'No active games!',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(12),
            itemCount: activeGames.length,
            separatorBuilder: (_, __) => Padding(
              padding: EdgeInsets.symmetric(
                  vertical: margin_5, horizontal: margin_8),
              child: SizedBox(),
            ),
            itemBuilder: (context, index) {
              final game = activeGames[index];
              final data = game.data() as Map<String, dynamic>;
              final roomCode = game.id;
              final gameState = data['game'] ?? '';
              final roomType = data['roomType'];
              final lastUpdatedTimestamp = data['lastUpdated'];
              final lastUpdated =
                  lastUpdatedTimestamp != null ? lastUpdatedTimestamp : null;
              dynamic leftUsers;
              if (data.containsKey('leftUsers')) {
                leftUsers = (data['leftUsers'] ?? []) as List;
              } else {
                leftUsers = [];
              }

              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(radius_10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: radius_2,
                          spreadRadius: radius_1)
                    ]),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(
                          text: game['groupName'] ?? "",
                          textStyle: textStyleBodyMedium(context)
                              .copyWith(fontWeight: FontWeight.bold)),
                      TextView(
                          text: '#$roomCode',
                          textStyle: textStyleBodyMedium(context).copyWith(
                              fontWeight: FontWeight.bold, color: kBackground)),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(
                        text: '${gameState}',
                        textStyle: textStyleBodySmall(context).copyWith(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      leftUsers.contains(currentUserModel.uid)
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: margin_5),
                              child: TextView(
                                text: 'You have already left the game!',
                                textStyle: textStyleBodySmall(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: font_10,
                                    color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  trailing: leftUsers.contains(currentUserModel.uid)
                      ? SizedBox()
                      : Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    if (!leftUsers.contains(currentUserModel.uid)) {
                      if (roomType == TYPE_SINGLE_PLAYER) {
                        final List<Map<String, dynamic>> playerList = [
                          data['host'],
                        ];
                        Navigator.pushNamed(
                          context,
                          RouteName.multiPlayerBlackJackScreenRoute,
                          arguments: {
                            "roomCode": roomCode,
                            "players": playerList,
                            "isGameActiveStatus": true,
                            "type": "private",
                            "roomType": TYPE_SINGLE_PLAYER
                          },
                        );
                      } else {
                        Navigator.pushNamed(
                            context, RouteName.waitingRoomScreenRoute,
                            arguments: {
                              "roomCode": roomCode,
                              "isGameActiveStatus": true
                            });
                      }
                    } else {
                      showToast("You have already left the game!");
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
