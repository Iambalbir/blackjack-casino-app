import '../../../../../export_file.dart';

class SlotMachineBloc extends Bloc<SlotMachineEvent, SlotMachineState> {
  final List<FixedExtentScrollController> controllers = List.generate(
    3,
    (_) => FixedExtentScrollController(),
  );

  final List<String> symbols = ['🍒', '🍋', '🔔', '🍉', '⭐', '💎'];

  SlotMachineBloc() : super(SlotMachineState.initial()) {
    on<InitializeSlotMachine>((event, emit) {
      emit(state.copyWith(selectedBet: event.initialChips));
    });

    on<UpdateBetAmount>(_updatedBetAmount);

    on<SpinReelsEvent>(_onSpinReels);

    on<DoubleBetAmount>(_onDoubleBetAmount);
    on<ClearResultMessage>(
        (ClearResultMessage event, Emitter<SlotMachineState> emit) {
      emit(state.copyWith(resultMessage: ""));
    });
  }

  Future<void> _updatedBetAmount(
      UpdateBetAmount event, Emitter<SlotMachineState> emit) async {
    emit(state.copyWith(selectedBet: event.newBetAmount));
  }

  Future<void> _onDoubleBetAmount(
      DoubleBetAmount event, Emitter<SlotMachineState> emit) async {
    var doubleAmount = state.selectedBet + state.selectedBet;

    if (bankAmount.value > doubleAmount) {
      Future.microtask(() {
        add(UpdateBetAmount(doubleAmount));
      });
      emit(state.copyWith(selectedBet: doubleAmount));
    }
  }

  Future<void> _onSpinReels(
    SpinReelsEvent event,
    Emitter<SlotMachineState> emit,
  ) async {
    if (state.isSpinning) return;

    emit(state.copyWith(
      isSpinning: true,
      resultMessage: '',
    ));

    await Future.delayed(Duration(milliseconds: 300));

    bool isWin = Random().nextDouble() < 0.2;

    List<int> indices;
    if (isWin) {
      int winningIndex = Random().nextInt(symbols.length);
      indices = List.filled(3, winningIndex);
    } else {
      // Ensure not all symbols are the same
      do {
        indices = List.generate(3, (_) => Random().nextInt(symbols.length));
      } while (indices.every((index) => index == indices[0]));
    }

    // Animate the reels
    for (int i = 0; i < indices.length; i++) {
      controllers[i].animateToItem(
        indices[i],
        duration: Duration(milliseconds: 800 + i * 200),
        curve: Curves.easeOut,
      );
    }

    await Future.delayed(Duration(milliseconds: 1500));

    int updatedChips = state.selectedBet;
    String resultMessage;
    int coinsChange;

    if (isWin) {
      int reward = event.betAmount;
      int halfOfBet = event.betAmount ~/ 2;
      bankAmount.value += halfOfBet;
      updatedChips += reward;
      coinsChange = reward;
      resultMessage = "You won! 🎉";
    } else {
      bankAmount.value -= state.selectedBet;
      int loss = event.betAmount;
      updatedChips -= loss;
      coinsChange = -loss;
      resultMessage = "Try again!";
    }

    Future.microtask(() {
      add(UpdateBetAmount(updatedChips));
    });

    emit(state.copyWith(
      selectedBet: updatedChips,
      currentIndices: indices,
      resultMessage: resultMessage,
      isSpinning: false,
    ));

    // 🔥 Save session data
    await _saveUserSession(
      isWin: isWin,
      coinsChange: coinsChange,
    );
  }

  Future<void> _saveUserSession({
    required bool isWin,
    required int coinsChange,
  }) async {
    await apiRepository.saveGameSession(
      userId: currentUserModel.uid,
      nickname: currentUserModel.nickname,
      gameType: TYPE_SLOT_MACHINE,
      isWin: isWin,
      coinsChange: coinsChange,
      isMultiplayer: false,
    );
  }
}
