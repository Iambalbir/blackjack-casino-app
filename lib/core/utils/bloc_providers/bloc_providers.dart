
import '../../../export_file.dart';

class BlocProviders {
  static List<SingleChildWidget> providersListing = [
    BlocProvider(create: (_) => GameControllerBloc()),
    BlocProvider(create: (_) => LoginBloc()),
    BlocProvider(create: (_) => SplashBloc()),
    BlocProvider(create: (_) => SlotMachineBloc()),
    BlocProvider(create: (_) => SettingsBloc(prefs)),
    BlocProvider(create: (_) => CreateRoomBloc()),
    BlocProvider(create: (_) => WaitingRoomBloc()),
    BlocProvider(create: (_) => InvitationBloc()),
    BlocProvider(create: (_) => MultiPlayerBlackjackBloc()),
  ];
}
