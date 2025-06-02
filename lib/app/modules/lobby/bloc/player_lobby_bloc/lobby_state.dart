class LobbyState {
  dynamic data;

  LobbyState({required this.data});

  factory LobbyState.initial() {
    return LobbyState(data: "");
  }

  LobbyState copyWith({data}) {
    return LobbyState(data: this.data);
  }
}
