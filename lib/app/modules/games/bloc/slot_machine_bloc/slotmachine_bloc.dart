import '../../../../../export_file.dart';

class SlotMachineBloc extends Bloc<SlotMachineEvent, SlotMachineState> {
  final Random random = Random();

  final List<String> symbols = ['🍒', '🍋', '🔔', '🍉', '⭐', '💎'];

  final List<FixedExtentScrollController> controllers =
      List.generate(3, (_) => FixedExtentScrollController(initialItem: 0));
  final Map<String, dynamic> data;

  SlotMachineBloc(this.data)
      : super(SlotMachineRunning(
          playerChips: data['amount'] ?? 50,
          selectedBet: data['amount'] ?? 50,
          onInit: () {},
          symbols: ['🍒', '🍋', '🔔', '🍉', '⭐', '💎'],
          currentIndices: [0, 0, 0],
          resultMessage: '',
          isSpinning: false,
        )) {
    on<UpdateBetEvent>((event, emit) {
      emit(state.copyWith(
        selectedBet: event.newBet,
        resultMessage: '',
      ));
    });
    on<SpinReelsEvent>(_onSpinReels);
  }

  @override
  Future<void> close() {
    for (var controller in controllers) {
      controller.dispose();
    }
    return super.close();
  }

  Future<void> _onSpinReels(
      SpinReelsEvent event, Emitter<SlotMachineState> emit) async {
    if (state.isSpinning || state.playerChips < event.betAmount) return;
    List<int> indices = List.from(state.currentIndices);
    int chips = state.playerChips - event.betAmount;

    emit(state.copyWith(
      playerChips: chips,
      selectedBet: event.betAmount,
      currentIndices: indices,
      resultMessage: '',
      isSpinning: true,
    ));

    bool forceWin = random.nextInt(100) < 10;
    int matchSymbolIndex = random.nextInt(state.symbols.length);

    for (int i = 0; i < 3; i++) {
      int spins = random.nextInt(10) + 10;
      if (forceWin) {
        indices[i] =
            matchSymbolIndex + state.symbols.length * (random.nextInt(5) + 1);
      } else {
        indices[i] = state.currentIndices[i] + spins;
      }
      controllers[i].animateToItem(
        indices[i],
        duration: Duration(milliseconds: 1500 + i * 200),
        curve: Curves.easeOutCubic,
      );
    }
    await Future.delayed(Duration(seconds: 2));
    List<String> centerSymbols = indices
        .map((index) => state.symbols[index % state.symbols.length])
        .toList();

    String message = "Try again!";
    if (centerSymbols.every((s) => s == centerSymbols[0])) {
      int multiplier = _getMultiplier(centerSymbols[0]);
      int winnings = event.betAmount * multiplier;
      chips += winnings;
      message = "Jackpot! ${centerSymbols[0]} You won $winnings chips!";
    }
    bankAmount.value = bankAmount.value-event.betAmount;
    emit(state.copyWith(
      playerChips: chips,
      selectedBet: event.betAmount,
      currentIndices: indices,
      resultMessage: message,
      isSpinning: false,
    ));

  }

  int _getMultiplier(String symbol) {
    switch (symbol) {
      case '🍒':
        return 10;
      case '🍋':
        return 8;
      case '🔔':
        return 15;
      case '🍉':
        return 12;
      case '⭐':
        return 20;
      case '💎':
        return 30;
      default:
        return 5;
    }
  }
}
