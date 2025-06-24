import '../../../export_file.dart';

class BlocProviders {
  static List<SingleChildWidget> providersListing = [
    BlocProvider(create: (_) => GameControllerBloc()),
    BlocProvider(create: (_) => LoginBloc()),
    BlocProvider(create: (_) => SplashBloc()),
    BlocProvider(create: (_) => SlotMachineBloc()),
    BlocProvider(create: (_) => SettingsBloc(prefs)),
    BlocProvider(create: (_) => InvitationBloc()),
    BlocProvider(create: (_) => PublicRoomBloc()),
    BlocProvider(create: (_) => MainScreenBloc()),
    BlocProvider(create: (_) => NoInternetBloc()),
    BlocProvider(create: (_) => RegisterBloc())
  ];
}
