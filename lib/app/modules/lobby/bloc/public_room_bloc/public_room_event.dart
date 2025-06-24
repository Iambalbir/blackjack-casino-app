import 'package:app/export_file.dart';

abstract class PublicRoomEvents {}

class CreatePublicRoomEvent extends PublicRoomEvents {
  dynamic groupName;
  dynamic maxPlayers;
  dynamic entryFee;
  BuildContext buildContext;

  CreatePublicRoomEvent(
      {required this.buildContext,
      this.groupName,
      this.maxPlayers,
      this.entryFee});
}

class UpdateGameType extends PublicRoomEvents {
  dynamic gameType;

  UpdateGameType(this.gameType);
}
