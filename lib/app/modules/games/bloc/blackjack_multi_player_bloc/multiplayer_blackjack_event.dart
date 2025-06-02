import 'package:app/export_file.dart';

abstract class MultiPlayerBlackjackEvent {}

class MultiPlayerBlackjackInitialEvent extends MultiPlayerBlackjackEvent {
  Map<String, dynamic> argumentsData;

  MultiPlayerBlackjackInitialEvent(this.argumentsData);
}

class SaveDealingCardToFireStoreEvent extends MultiPlayerBlackjackEvent {
  List<dynamic> playersUid;

  SaveDealingCardToFireStoreEvent(this.playersUid);
}

class StartGameStreamEvent extends MultiPlayerBlackjackEvent {
  final roomCode;

  StartGameStreamEvent(this.roomCode);
}

class StartDealingEvent extends MultiPlayerBlackjackEvent {}

class UpdateHolePositionsEvent extends MultiPlayerBlackjackEvent {}

class UpdateTableDimensions extends MultiPlayerBlackjackEvent {
  BuildContext context;

  UpdateTableDimensions(this.context);
}

class UpdateTurnEvent extends MultiPlayerBlackjackEvent {
  dynamic currentTurn;
  dynamic turnStartTime;
  dynamic turnId;

  UpdateTurnEvent(
      {required this.currentTurn,
      required this.turnStartTime,
      required this.turnId});
}

class EndTurnEvent extends MultiPlayerBlackjackEvent {}

class MultiPlayerHitEvent extends MultiPlayerBlackjackEvent {
  dynamic roomCode;

  MultiPlayerHitEvent(this.roomCode);
}

class UpdateRemainingTimeInSeconds extends MultiPlayerBlackjackEvent {
  dynamic remainingTimeInSecs;

  UpdateRemainingTimeInSeconds(this.remainingTimeInSecs);
}

class SkipTurnAutomaticTurnTriggerEvent extends MultiPlayerBlackjackEvent {}

class StandTurnEvent extends MultiPlayerBlackjackEvent {}

class DealerTurnEvent extends MultiPlayerBlackjackEvent {}

class CalculateResultsEvent extends MultiPlayerBlackjackEvent {
  dynamic dealtCards;

  CalculateResultsEvent(this.dealtCards);
}

class DealerHitEvent extends MultiPlayerBlackjackEvent {
  final List<List<String>> updatedDealtCards;

  DealerHitEvent(this.updatedDealtCards);
}

class DealerStandEvent extends MultiPlayerBlackjackEvent {
  final List<List<String>> updatedDealtCards;

  DealerStandEvent(this.updatedDealtCards);
}

class DealerBustedEvent extends MultiPlayerBlackjackEvent {
  final List<List<String>> updatedDealtCards;

  DealerBustedEvent(this.updatedDealtCards);
}
