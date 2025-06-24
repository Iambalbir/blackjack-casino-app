import 'package:app/export_file.dart';

abstract class PokerEvents {}

class PokerTableDimensionsEvent extends PokerEvents {
  BuildContext context;

  PokerTableDimensionsEvent(this.context);
}

class UpdatePokerTableHolePositionsEvent extends PokerEvents {
  BuildContext context;

  UpdatePokerTableHolePositionsEvent(this.context);
}
