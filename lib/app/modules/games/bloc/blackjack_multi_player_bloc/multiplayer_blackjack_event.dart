import 'package:app/export_file.dart';

abstract class MultiPlayerBlackjackEvent {}

class MultiPlayerBlackjackInitialEvent extends MultiPlayerBlackjackEvent {
  Map<String, dynamic> argumentsData;
  BuildContext context;

  MultiPlayerBlackjackInitialEvent(this.argumentsData, this.context);
}

class SaveDealingCardToFireStoreEvent extends MultiPlayerBlackjackEvent {
  List<dynamic> playersUid;
  BuildContext context;

  SaveDealingCardToFireStoreEvent(this.playersUid,this.context);
}

class StartGameStreamEvent extends MultiPlayerBlackjackEvent {
  final roomCode;
  dynamic context;

  StartGameStreamEvent(this.roomCode, {this.context});
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
  dynamic hostId;

  UpdateTurnEvent(
      {required this.currentTurn,
      required this.turnStartTime,
      required this.hostId,
      this.turnId = 1});
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

class ResetGameEvent extends MultiPlayerBlackjackEvent {}

class SendChatMessageEvent extends MultiPlayerBlackjackEvent {
  final String messageText;

  SendChatMessageEvent(this.messageText);
}

class AddNewMessageDataEventTrigger extends MultiPlayerBlackjackEvent {
  AddNewMessageDataEventTrigger();
}

class CheckPlayerStatus extends MultiPlayerBlackjackEvent {
  dynamic roomCode;
  dynamic isAppResumed;
  dynamic playersListing;

  CheckPlayerStatus(
      {this.roomCode, this.playersListing, this.isAppResumed = false});
}

class UserOfflineEvent extends MultiPlayerBlackjackEvent {}

class AddBettingAmountEvent extends MultiPlayerBlackjackEvent {
  dynamic betAmount;
  dynamic roomCode;
  dynamic context;

  AddBettingAmountEvent(this.betAmount, this.roomCode, this.context);
}

class LeaveGameEvent extends MultiPlayerBlackjackEvent {
  dynamic betAmount;

  LeaveGameEvent(this.betAmount);
}

class UpdateTimerCompletionStatus extends MultiPlayerBlackjackEvent {
  final bool isCompleted;

  UpdateTimerCompletionStatus(this.isCompleted);
}
