import 'package:app/export_file.dart';

abstract class PublicLobbyEvents {}

class PublicLobbyInitialEvent extends PublicLobbyEvents {}

class JoinLobbyEvent extends PublicLobbyEvents {
  BuildContext context;
  dynamic roomCode;

  JoinLobbyEvent(this.context, this.roomCode);
}

class StartGameEvents extends PublicLobbyEvents {
  dynamic roomCode;
  BuildContext context;

  StartGameEvents(this.roomCode, this.context);
}
