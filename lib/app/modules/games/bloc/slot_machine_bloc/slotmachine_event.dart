abstract class SlotMachineEvent {}

class SpinReelsEvent extends SlotMachineEvent {
  final int betAmount;

  SpinReelsEvent(this.betAmount);
}

class UpdateBetEvent extends SlotMachineEvent {
  final int newBet;

  UpdateBetEvent(this.newBet);
}
