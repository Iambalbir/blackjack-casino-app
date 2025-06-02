class SlotMachineState {
  int selectedBet;
  final bool isSpinning;
  final List<int> currentIndices;
  final String resultMessage;

  SlotMachineState({
    required this.selectedBet,
    required this.isSpinning,
    required this.currentIndices,
    required this.resultMessage,
  });

  SlotMachineState copyWith({
    int? selectedBet,
    bool? isSpinning,
    List<int>? currentIndices,
    String? resultMessage,
  }) {
    return SlotMachineState(
      selectedBet: selectedBet ?? this.selectedBet,
      isSpinning: isSpinning ?? this.isSpinning,
      currentIndices: currentIndices ?? this.currentIndices,
      resultMessage: resultMessage ?? this.resultMessage,
    );
  }

  factory SlotMachineState.initial() => SlotMachineState(
        selectedBet: 100,
        isSpinning: false,
        currentIndices: [0, 0, 0],
        resultMessage: '',
      );
}
