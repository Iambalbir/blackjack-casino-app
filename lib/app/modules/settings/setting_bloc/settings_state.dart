class SettingsState {
  final bool soundOn;
  final bool darkTheme;
  final String? nickname;

  SettingsState({
    required this.soundOn,
    required this.darkTheme,
    this.nickname,
  });

  SettingsState copyWith({
    bool? soundOn,
    bool? darkTheme,
    String? nickname,
  }) {
    return SettingsState(
      soundOn: soundOn ?? this.soundOn,
      darkTheme: darkTheme ?? this.darkTheme,
      nickname: nickname ?? this.nickname,
    );
  }
}
