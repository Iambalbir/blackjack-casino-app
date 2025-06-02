import '../../../../export_file.dart';

class LeaderboardScreen extends StatelessWidget {
  LeaderboardScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextView(
          text: "🏆 Leaderboard",
          textStyle: textStyleHeadingMedium(context),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .orderBy('leaderboardScore', descending: true)
            .limit(50)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs;

          return Column(
            children: [
              if (currentUserModel != null) _buildCurrentUserCard(),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index].data() as Map<String, dynamic>;
                    final isCurrentUser = user['uid'] == currentUserModel.uid;

                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: margin_10, vertical: margin_4),
                      decoration: BoxDecoration(
                          color: isCurrentUser
                              ? kBackground
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(radius_8)),
                      child: ListTile(
                        leading: Text(
                          "#${index + 1}",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        title: Text(
                          user['nickname'] ?? 'Guest',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          "Wins: ${user['totalWins']} | Losses: ${user['totalLosses']}",
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: Text(
                          "💰 ${user['coins']}",
                          style: TextStyle(
                              color: Colors.amber, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCurrentUserCard() {
    return Card(
      margin: EdgeInsets.all(12),
      color: kBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("👑 You (${currentUserModel.nickname})",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("💰 Coins: ${currentUserModel.coins}",
                style: TextStyle(color: Colors.amber)),
            Text(
                "🏆 Wins: ${currentUserModel.totalWins} | ❌ Losses: ${currentUserModel.totalLosses}",
                style: TextStyle(color: Colors.white)),
            SizedBox(height: 8),
            Row(
              children: [
                _gameStat("♠ Blackjack",
                    currentUserModel.gamesPlayed?['blackjack']?.played),
                _gameStat(
                    "🎰 Slots", currentUserModel.gamesPlayed?['slots']?.played),
                _gameStat(
                    "♥ Poker", currentUserModel.gamesPlayed?['poker']?.played),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _gameStat(String label, count) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.grey[300], fontSize: 14)),
          SizedBox(height: 4),
          Text("$count",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
