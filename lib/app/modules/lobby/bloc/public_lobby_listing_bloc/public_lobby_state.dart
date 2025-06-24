class PublicLobbyState {
  bool isLoading;
  dynamic lobbyListingStreaming;
  dynamic playerList;
  dynamic myLobbies;
  dynamic roomCode;
  bool isGameStarted;

  PublicLobbyState(
      {required this.isLoading,
      required this.lobbyListingStreaming,
      required this.roomCode,
      required this.myLobbies,
      required this.playerList,
      required this.isGameStarted});

  factory PublicLobbyState.initialState() {
    return PublicLobbyState(
        isLoading: false,
        lobbyListingStreaming: null,
        isGameStarted: false,
        playerList: [],
        myLobbies: [],
        roomCode: '');
  }

  PublicLobbyState copyWith(
      {isLoading,
      lobbyListingStreaming,
      isGameStarted,
      myLobbies,
      playerList,
      roomCode}) {
    return PublicLobbyState(
        isLoading: isLoading ?? this.isLoading,
        roomCode: roomCode ?? this.roomCode,
        myLobbies: myLobbies ?? this.myLobbies,
        playerList: playerList ?? this.playerList,
        isGameStarted: isGameStarted ?? this.isGameStarted,
        lobbyListingStreaming:
            lobbyListingStreaming ?? this.lobbyListingStreaming);
  }
}
