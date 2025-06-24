import '../../../../export_file.dart';

abstract class MainScreenEvents {}

class CreateSinglePlayerRoomEvent extends MainScreenEvents {
  BuildContext context;

  CreateSinglePlayerRoomEvent(this.context);
}
