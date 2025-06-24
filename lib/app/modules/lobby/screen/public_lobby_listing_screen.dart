import 'package:app/core/utils/dialogs/show_leader_board_dialog.dart';
import 'package:app/export_file.dart';

class PublicLobbyListScreen extends StatefulWidget {
  const PublicLobbyListScreen({super.key});

  @override
  State<PublicLobbyListScreen> createState() => _PublicLobbyListScreenState();
}

class _PublicLobbyListScreenState extends State<PublicLobbyListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final PublicLobbyBloc _bloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final bloc = context.read<PublicLobbyBloc>();
    _bloc = bloc;
    bloc.add(PublicLobbyInitialEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PublicLobbyBloc, PublicLobbyState>(
      listener: (context, state) {
        if (!state.isLoading && state.isGameStarted) {
          if (bankAmount.value < 20) {
            showToast(
                "You don't have enough funds to join the lobby(Minimum required wallet amount is 20.)");
          } else {
            Navigator.pushReplacementNamed(
              context,
              RouteName.multiPlayerBlackJackScreenRoute,
              arguments: {
                "roomCode": state.roomCode,
                "players": state.playerList,
                "isGameActiveStatus": false
              },
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kBackground,
          appBar: AppBar(
            actions: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: RoomAccessScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(margin_10),
                  child: Icon(Icons.add),
                ),
              ),
            ],
            title: TextView(
              text: 'Join Lobby',
              textStyle: textStyleHeadingMedium(context),
            ),
            backgroundColor: kBackground,
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Public Lobbies'),
                Tab(text: 'My Lobbies'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildPublicLobbies(state),
              _buildMyLobbies(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPublicLobbies(PublicLobbyState state) {
    return state.lobbyListingStreaming == null
        ? const Center(child: CircularProgressIndicator())
        : StreamBuilder<QuerySnapshot>(
            stream: state.lobbyListingStreaming,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              final filteredDocs = snapshot.data?.docs
                  .where((doc) =>
                      doc['status'] != 'finished' &&
                      doc['host.uid'] != currentUserModel.uid)
                  .toList();

              if (filteredDocs == null || filteredDocs.isEmpty) {
                return Center(
                  child: TextView(
                    text: "No public rooms available",
                    textStyle: textStyleBodyMedium(context)
                        .copyWith(color: Colors.white70),
                  ),
                );
              }

              return _buildLobbyList(filteredDocs, state);
            },
          );
  }

  Widget _buildMyLobbies(PublicLobbyState state) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            dividerHeight: 0,
            tabs: [
              Tab(text: 'Public'),
              Tab(text: 'Private'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildMyPublicLobbies(state),
                _buildMyPrivateLobbies(state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyPublicLobbies(PublicLobbyState state) {
    final myPublicLobbiesStream = FirebaseFirestore.instance
        .collection(roomCollectionPath)
        .where('host.uid', isEqualTo: currentUserModel.uid)
        .where("type", isEqualTo: "public")
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: myPublicLobbiesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error loading your public lobbies.",
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Center(
            child: Text(
              "You have not created any public lobbies yet.",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          );
        }

        return _buildLobbyList(docs, state);
      },
    );
  }

  Widget _buildMyPrivateLobbies(PublicLobbyState state) {
    final myPrivateLobbiesStream = FirebaseFirestore.instance
        .collection(roomCollectionPath)
        .where('host.uid', isEqualTo: currentUserModel.uid)
        .where("type", isEqualTo: "private")
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: myPrivateLobbiesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error loading your private lobbies.",
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Center(
            child: Text(
              "You have not created any private lobbies yet.",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          );
        }

        return _buildPrivateLobbyView(docs, state);
      },
    );
  }

  Widget _buildLobbyList(List<dynamic> rooms, PublicLobbyState state) {
    return ListView.separated(
      padding: EdgeInsets.all(margin_15),
      separatorBuilder: (_, __) => const Divider(color: Colors.white30),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        final roomCode = room['roomCode'];
        final groupName = room['groupName'];
        final host = room['host']['nickname'] ?? 'Unknown';
        final hostUid = room['host']['uid'] ?? '';
        final maxPlayers = room['maxPlayers'] ?? "";
        final players = (room['players_listing'] ?? []) as List;
        final joinedUserListing = (room['joined_listing'] ?? []) as List;
        final currentCount = players.length;
        return ListTile(
          leading: const Icon(Icons.videogame_asset, color: Colors.greenAccent),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextView(
                text: groupName ?? '',
                textStyle: textStyleBodyMedium(context).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextView(
                text: "Room: $roomCode",
                textStyle: textStyleBodyMedium(context).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          subtitle: TextView(
            text: "Host: $host  \n$currentCount / $maxPlayers players",
            textStyle:
                textStyleBodySmall(context).copyWith(color: Colors.white),
          ),
          trailing: hostUid == currentUserModel.uid
              ? InkWell(
                  onTap: () async {
                    if (currentCount > 1 && room['status'] != 'finished') {
                      context
                          .read<PublicLobbyBloc>()
                          .add(StartGameEvents(roomCode, context));
                    } else if (room['status'] == 'finished') {
                      customLoader.show(context);
                      final docRef = FirebaseFirestore.instance
                          .collection('games')
                          .doc(roomCode);

                      var dataSnapShot = await docRef.get();
                      var data = dataSnapShot.data() as Map<String, dynamic>;

                      final players = data['players'] as List<dynamic>;
                      final playerNames = {
                        for (var player in players)
                          player['uid']: player['nickname']
                      };
                      customLoader.hide();
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => LeaderboardDialog(
                          onCloseTap: () {
                            Navigator.pop(context);
                          },
                          playerResults: data['playerResults'],
                          playerPayouts: data['playerPayouts'],
                          playerNames: playerNames,
                        ),
                      );
                    } else {
                      showToast("No other player have joined yet!");
                    }
                  },
                  child: Container(
                    width: width_90,
                    padding: EdgeInsets.all(margin_5),
                    decoration: BoxDecoration(
                      color: room['status'] == 'finished'
                          ? Colors.white
                          : Colors.transparent,
                      border: Border.all(color: Colors.white, width: width_2),
                      borderRadius: BorderRadius.circular(radius_6),
                    ),
                    child: TextView(
                      text: room['status'] == 'active'
                          ? "In Progress"
                          : room['status'] == 'finished'
                              ? "Finished"
                              : "Start Game",
                      textAlign: TextAlign.center,
                      textStyle: textStyleBodySmall(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: currentCount < 1 ? Colors.black38 : Colors.black,
                      ),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    if (room['status'] == 'waiting' &&
                        !joinedUserListing.contains(currentUserModel.uid) &&
                        int.parse(currentCount.toString()) !=
                            int.parse(maxPlayers.toString())) {
                      if (bankAmount.value < 20) {
                        showToast(
                            "You don't have enough funds to join the lobby(Minimum required wallet amount is 20.)");
                      } else {
                        context
                            .read<PublicLobbyBloc>()
                            .add(JoinLobbyEvent(context, roomCode));
                      }
                    } else if (room['status'] == 'active' &&
                        joinedUserListing.contains(currentUserModel.uid)) {
                      if (bankAmount.value < 20) {
                        showToast(
                            "You don't have enough funds to join the lobby(Minimum required wallet amount is 20.)");
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          RouteName.multiPlayerBlackJackScreenRoute,
                          arguments: {
                            "roomCode": roomCode,
                            "players": players,
                            "isGameActiveStatus": true
                          },
                        );
                      }
                    } else {
                      showToast("Lobby has reached max players! ");
                    }
                  },
                  child: Container(
                    width: width_90,
                    height: height_30,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(margin_5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: width_2),
                      borderRadius: BorderRadius.circular(radius_6),
                    ),
                    child: TextView(
                      textAlign: TextAlign.center,
                      text: room['status'] == 'waiting' &&
                              !joinedUserListing
                                  .contains(currentUserModel.uid) &&
                              int.parse(currentCount.toString()) !=
                                  int.parse(maxPlayers.toString())
                          ? "Join"
                          : room['status'] == 'active'
                              ? 'In Progress'
                              : room['status'] == 'finished'
                                  ? "Match Finished"
                                  : !joinedUserListing
                                              .contains(currentUserModel.uid) &&
                                          int.parse(currentCount.toString()) ==
                                              int.parse(maxPlayers.toString())
                                      ? "Lobby full"
                                      : 'Joined',
                      textStyle: textStyleBodySmall(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildPrivateLobbyView(List<dynamic> rooms, PublicLobbyState state) {
    return ListView.separated(
      padding: EdgeInsets.all(margin_15),
      separatorBuilder: (_, __) => const Divider(color: Colors.white30),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index].data() as Map<String, dynamic>;
        final roomCode = room['roomCode'];
        final groupName = room['groupName'];
        final roomType = room['roomType'];
        final hostUid = room['host']['uid'] ?? '';
        final players = (room['players_listing'] ?? []) as List;
        dynamic leftUsers;
        if (room.containsKey('leftUsers')) {
          leftUsers = (room['leftUsers'] ?? []) as List;
        } else {
          leftUsers = [];
        }

        final currentCount = players.length;

        return ListTile(
          leading: const Icon(Icons.videogame_asset, color: Colors.greenAccent),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextView(
                text: groupName ?? '',
                textStyle: textStyleBodyMedium(context).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextView(
                text: "Room: $roomCode",
                textStyle: textStyleBodyMedium(context).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          trailing: hostUid == currentUserModel.uid
              ? InkWell(
                  onTap: () async {
                    if (room['status'] != 'finished' &&
                        !leftUsers.contains(currentUserModel.uid)) {
                      if (roomType == TYPE_SINGLE_PLAYER) {
                        final List<Map<String, dynamic>> playerList = [
                          room['host'],
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
                        Navigator.pushReplacementNamed(
                            context, RouteName.waitingRoomScreenRoute,
                            arguments: {"roomCode": roomCode});
                      }
                    } else if (leftUsers.contains(currentUserModel.uid)) {
                      showToast("You have left the game!");
                    } else {
                      customLoader.show(context);
                      final docRef = FirebaseFirestore.instance
                          .collection('games')
                          .doc(roomCode);

                      var dataSnapShot = await docRef.get();
                      var data = dataSnapShot.data() as Map<String, dynamic>;

                      final players = data['players'] as List<dynamic>;
                      final playerNames = {
                        for (var player in players)
                          player['uid']: player['nickname']
                      };
                      customLoader.hide();
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => LeaderboardDialog(
                          onCloseTap: () {
                            Navigator.pop(context);
                          },
                          playerResults: data['playerResults'],
                          playerPayouts: data['playerPayouts'],
                          playerNames: playerNames,
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: width_90,
                    padding: EdgeInsets.all(margin_5),
                    decoration: BoxDecoration(
                      color: room['status'] == 'finished'
                          ? Colors.white
                          : Colors.transparent,
                      border: Border.all(color: Colors.white, width: width_2),
                      borderRadius: BorderRadius.circular(radius_6),
                    ),
                    child: TextView(
                      text: leftUsers.contains(currentUserModel.uid)
                          ? "Leaved"
                          : room['status'] == 'active'
                              ? "In Progress"
                              : room['status'] == 'finished'
                                  ? "Finished"
                                  : "Start Game",
                      textAlign: TextAlign.center,
                      textStyle: textStyleBodySmall(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: currentCount > 1 ? Colors.black38 : Colors.black,
                      ),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, RouteName.waitingRoomScreenRoute,
                        arguments: {"roomCode": roomCode});
                  },
                  child: Container(
                    width: width_90,
                    height: height_30,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(margin_5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: width_2),
                      borderRadius: BorderRadius.circular(radius_6),
                    ),
                    child: TextView(
                      textAlign: TextAlign.center,
                      text: room['status'] == 'waiting'
                          ? "Join"
                          : room['status'] == 'active'
                              ? 'In Progress'
                              : room['status'] == 'finished'
                                  ? "Match Finished"
                                  : 'Joined',
                      textStyle: textStyleBodySmall(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
