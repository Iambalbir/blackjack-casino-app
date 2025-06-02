abstract class SlotMachineEvent {}

class InitializeSlotMachine extends SlotMachineEvent {
  final int initialChips;

  InitializeSlotMachine(this.initialChips);
}

class SpinReelsEvent extends SlotMachineEvent {
  final int betAmount;

  SpinReelsEvent(this.betAmount);
}

class UpdateBetAmount extends SlotMachineEvent {
  final int newBetAmount;

  UpdateBetAmount(this.newBetAmount);
}

class DoubleBetAmount extends SlotMachineEvent {
  final int betAmount;

  DoubleBetAmount(this.betAmount);
}
class ClearResultMessage extends SlotMachineEvent {}