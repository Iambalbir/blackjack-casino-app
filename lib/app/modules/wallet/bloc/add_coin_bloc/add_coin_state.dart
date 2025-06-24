class AddCoinState {
  dynamic totalCoins;

  AddCoinState({required this.totalCoins});

  factory AddCoinState.initialState() {
    return AddCoinState(totalCoins: 0);
  }

  AddCoinState copyWith({totalCoins}) {
    return AddCoinState(totalCoins: totalCoins ?? this.totalCoins);
  }
}
