class WaitingRoomEvents {}

class InitialWaitingRoomEvent extends WaitingRoomEvents {
  final String roomCode;

  InitialWaitingRoomEvent(this.roomCode);
}

class RemoveUserEvent extends WaitingRoomEvents {
  dynamic userId;

  RemoveUserEvent(this.userId);
}
