class MainScreenStates {
  bool isLoading = false;
  bool isRoomCreated = false;
  String roomCode;
  Map<String, dynamic> host;

  MainScreenStates(
      {required this.isLoading,
      required this.isRoomCreated,
      required this.host,
      required this.roomCode});

  factory MainScreenStates.initialState() {
    return MainScreenStates(
        isLoading: false, isRoomCreated: false, roomCode: '', host: {});
  }

  MainScreenStates copyWith({isLoading, isRoomCreated, roomCode, host}) {
    return MainScreenStates(
        isLoading: isLoading ?? this.isLoading,
        host: host ?? this.host,
        roomCode: roomCode ?? this.roomCode,
        isRoomCreated: isRoomCreated ?? this.isRoomCreated);
  }
}
