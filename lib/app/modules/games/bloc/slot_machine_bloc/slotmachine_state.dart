import 'dart:ui';

abstract class SlotMachineState {
  final int playerChips;
  final int selectedBet;
  final List<String> symbols;
  final List<int> currentIndices;
  final String resultMessage;
  final bool isSpinning;
  final VoidCallback onInit;

  const SlotMachineState({
    required this.playerChips,
    required this.onInit,
    required this.selectedBet,
    required this.symbols,
    required this.currentIndices,
    required this.resultMessage,
    required this.isSpinning,
  });

  SlotMachineState copyWith(
      {int? playerChips,
      int? selectedBet,
      List<String>? symbols,
      List<int>? currentIndices,
      String? resultMessage,
      bool? isSpinning,
      VoidCallback? onInit});
}

class SlotMachineRunning extends SlotMachineState {
  const SlotMachineRunning({
    required int playerChips,
    required int selectedBet,
    required List<String> symbols,
    required List<int> currentIndices,
    required String resultMessage,
    required bool isSpinning,
    required VoidCallback onInit,
  }) : super(
          playerChips: playerChips,
          selectedBet: selectedBet,
          symbols: symbols,
          currentIndices: currentIndices,
          resultMessage: resultMessage,
          isSpinning: isSpinning,
          onInit: onInit,
        );

  @override
  SlotMachineRunning copyWith(
      {int? playerChips,
      int? selectedBet,
      List<String>? symbols,
      List<int>? currentIndices,
      String? resultMessage,
      bool? isSpinning,
      VoidCallback? onInit}) {
    return SlotMachineRunning(
        playerChips: playerChips ?? this.playerChips,
        selectedBet: selectedBet ?? this.selectedBet,
        symbols: symbols ?? this.symbols,
        currentIndices: currentIndices ?? this.currentIndices,
        resultMessage: resultMessage ?? this.resultMessage,
        isSpinning: isSpinning ?? this.isSpinning,
        onInit: onInit ?? this.onInit);
  }
}
