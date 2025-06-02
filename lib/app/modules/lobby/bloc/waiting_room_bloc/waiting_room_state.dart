class WaitingRoomState {
  final String? roomCode;

  WaitingRoomState({required this.roomCode});

  WaitingRoomState copyWith({roomCode}) {
    return WaitingRoomState(roomCode: roomCode ?? this.roomCode);
  }

  factory WaitingRoomState.initialState() {
    return WaitingRoomState(roomCode: '');
  }
}
