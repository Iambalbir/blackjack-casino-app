import '../../../../export_file.dart';

class ActiveGamesScreen extends StatelessWidget {
  const ActiveGamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gamesCollection = FirebaseFirestore.instance.collection('rooms');

    return Scaffold(
      appBar: AppBar(
        title: Text('Active Games'),


        centerTitle: true,
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
                'No active games found',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(12),
            itemCount: activeGames.length,
            separatorBuilder: (_, __) => Divider(height: 1),
            itemBuilder: (context, index) {
              final game = activeGames[index];
              final data = game.data() as Map<String, dynamic>;
              final roomCode = game.id;
              final gameState = data['game'] ?? 'unknown';
              final lastUpdatedTimestamp = data['lastUpdated'] as Timestamp?;
              final lastUpdated = lastUpdatedTimestamp != null
                  ? lastUpdatedTimestamp.toDate()
                  : null;

              return ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                title: Text('Room: $roomCode',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Game: $gameState'),
                    if (lastUpdated != null)
                      Text('Last updated: ${lastUpdated.toLocal()}',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, RouteName.waitingRoomScreenRoute,
                      arguments: {
                        "roomCode": roomCode,
                        "isGameActiveStatus": true
                      });
                },
              );
            },
          );
        },
      ),
    );
  }
}
