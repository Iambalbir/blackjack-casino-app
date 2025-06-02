class WaitingRoomEvents {}

class InitialWaitingRoomEvent extends WaitingRoomEvents {
  final String roomCode;

  InitialWaitingRoomEvent(this.roomCode);
}
