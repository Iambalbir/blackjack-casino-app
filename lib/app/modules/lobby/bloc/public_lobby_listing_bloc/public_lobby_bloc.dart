import 'package:app/export_file.dart';

class PublicLobbyBloc extends Bloc<PublicLobbyEvents, PublicLobbyState> {
  PublicLobbyBloc() : super(PublicLobbyState.initialState()) {
    on<PublicLobbyInitialEvent>(_initialEvent);
    on<JoinLobbyEvent>(_joinLobbyEvent);
    on<StartGameEvents>(_startGameEvent);
  }

  Future<void> _startGameEvent(
      StartGameEvents event, Emitter<PublicLobbyState> emit) async {
    emit(state.copyWith(isLoading: true));
    final roomDoc = FirebaseFirestore.instance
        .collection(roomCollectionPath)
        .doc(event.roomCode);

    final snapshot = await roomDoc.get();

    if (!snapshot.exists) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text("Room does not exist.")),
      );
      return;
    }

    final data = snapshot.data()!;
    final hostUid = data['host']['uid'];



    await roomDoc.update({
      'status': 'active',
      'turnId': 1,
      'currentTurn': hostUid,
      'gameStartedAt': DateTime.now().millisecondsSinceEpoch,
    });

    final invitedUsers =
        List<Map<String, dynamic>>.from(data[playersListing] ?? []);
    /* final host = data['host'];
    final List<Map<String, dynamic>> playerList = [host, ...invitedUsers];*/
    emit(state.copyWith(
        isLoading: false,
        isGameStarted: true,
        playerList: invitedUsers,
        roomCode: event.roomCode));
  }

  _initialEvent(PublicLobbyInitialEvent event, Emitter<PublicLobbyState> emit) {
    dynamic lobbyListingStream;

    lobbyListingStream = FirebaseFirestore.instance
        .collection(roomCollectionPath)
        .where("type", isEqualTo: "public")
        .snapshots();

    emit(state.copyWith(lobbyListingStreaming: lobbyListingStream));
  }

  Future<void> _joinLobbyEvent(
      JoinLobbyEvent event, Emitter<PublicLobbyState> emit) async {
    final roomDoc = FirebaseFirestore.instance
        .collection(roomCollectionPath)
        .doc(event.roomCode);

    final snapshot = await roomDoc.get();

    if (!snapshot.exists) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text("Room no longer exists.")),
      );
      return;
    }

    final data = snapshot.data()!;
    final players = List.from(data['players_listing'] ?? []);
    final joined = List<String>.from(data['joined_listing'] ?? []);
    final maxPlayers = data['maxPlayers'] ?? 5;

    final newPlayer = {
      'uid': currentUserModel.uid,
      'nickname': currentUserModel.nickname,
      'email': currentUserModel.email,
      "status": "accepted",
      'joinedAt': DateTime.now().millisecondsSinceEpoch,
    };

    // Add full player info to players_listing
    final alreadyInPlayers =
        players.any((p) => p['uid'] == currentUserModel.uid);
    if (!alreadyInPlayers &&
        players.length < int.parse(maxPlayers.toString())) {
      players.add(newPlayer);
      await roomDoc.update({'players_listing': players});
    }

    // Add only UID to joined_listing
    if (!joined.contains(currentUserModel.uid)) {
      joined.add(currentUserModel.uid);
      await roomDoc.update({'joined_listing': joined});
    }

    await roomDoc
        .update({'lastUpdated': DateTime.now().millisecondsSinceEpoch});
  }
}
