abstract class RoomEvents {}

class InitialEvent extends RoomEvents {}

class FilterUserEvent extends RoomEvents {
  String? query;

  FilterUserEvent(this.query);
}

class CreateRoomEvent extends RoomEvents {}

class ToggleUserEvent extends RoomEvents {
  final Map<String, dynamic> user;

  ToggleUserEvent(this.user);
}
