import '../../../../export_file.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static const _keySoundOn = 'sound_on';
  static const _keyDarkTheme = 'dark_theme';
  static const _keyNickname = 'nickname';

  final SharedPreferences prefs;

  SettingsBloc(this.prefs)
      : super(SettingsState(
          soundOn: prefs.getBool(_keySoundOn) ?? true,
          darkTheme: prefs.getBool(_keyDarkTheme) ?? false,
          nickname: prefs.getString(_keyNickname),
        )) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleSound>(_onToggleSound);
    on<ToggleTheme>(_onToggleTheme);
    on<ResetNickname>(_onResetNickname);
  }

  Future<void> _onLoadSettings(
      LoadSettings event, Emitter<SettingsState> emit) async {
    final soundOn = prefs.getBool(_keySoundOn) ?? true;
    final darkTheme = prefs.getBool(_keyDarkTheme) ?? false;
    final nickname = prefs.getString(_keyNickname);
    emit(SettingsState(
      soundOn: soundOn,
      darkTheme: darkTheme,
      nickname: nickname,
    ));
  }

  Future<void> _onToggleSound(
      ToggleSound event, Emitter<SettingsState> emit) async {
    final newSoundOn = !state.soundOn;
    await prefs.setBool(_keySoundOn, newSoundOn);
    emit(state.copyWith(soundOn: newSoundOn));
  }

  Future<void> _onToggleTheme(
      ToggleTheme event, Emitter<SettingsState> emit) async {
    final newDarkTheme = !state.darkTheme;
    await prefs.setBool(_keyDarkTheme, newDarkTheme);
    emit(state.copyWith(darkTheme: newDarkTheme));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: newDarkTheme ? Colors.black : Colors.white,
      systemNavigationBarIconBrightness:
          newDarkTheme ? Brightness.light : Brightness.dark,
    ));
  }

  Future<void> _onResetNickname(
      ResetNickname event, Emitter<SettingsState> emit) async {
    await prefs.remove(_keyNickname);
    emit(state.copyWith(nickname: null));
  }
}
