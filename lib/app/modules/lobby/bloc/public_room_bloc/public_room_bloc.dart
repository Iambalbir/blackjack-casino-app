import 'package:app/export_file.dart';

class PublicRoomBloc extends Bloc<PublicRoomEvents, PublicRoomState> {
  PublicRoomBloc() : super(PublicRoomState.initialState()) {
    on<CreatePublicRoomEvent>(_createPublicRoom);
    on<UpdateGameType>(_updateGameType);
  }

  _updateGameType(UpdateGameType event, Emitter<PublicRoomState> emit) {
    emit(state.copyWith(selectedGameType: event.gameType));
  }

  Future<void> _createPublicRoom(
      CreatePublicRoomEvent event, Emitter<PublicRoomState> emit) async {
    emit(state.copyWith(isLoading: true));

    var hostProfile = {
      'uid': currentUserModel.uid,
      'nickname': currentUserModel.nickname,
      'email': currentUserModel.email
    };

    final roomCode = generateRoomCode();
    final roomData = {
      "roomCode": roomCode,
      'game': 'Blackjack',
      "type": "public",
      "gameType": state.selectedGameType,
      "groupName": event.groupName,
      "host": hostProfile,
      "players_listing": [hostProfile],
      "joined_listing": [],
      'roomType':TYPE_MULTI_PLAYER,
      "maxPlayers": event.maxPlayers,
      "entryFee": event.entryFee,
      "status": "waiting",
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "lastUpdated": DateTime.now().millisecondsSinceEpoch,
    };

    await FirebaseFirestore.instance
        .collection(roomCollectionPath)
        .doc(roomCode)
        .set(roomData);
    emit(state.copyWith(
      isLoading: false,
    ));
    Navigator.pop(event.buildContext);
  }
}
