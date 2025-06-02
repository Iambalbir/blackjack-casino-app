import '../export_file.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings route) {
    switch (route.name) {
      case RouteName.splashScreenRoute:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case RouteName.loginScreenRoute:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RouteName.streamUserStateScreenRoute:
        return MaterialPageRoute(
            builder: (context) => UserStateChangeHandlerStream());
      case RouteName.playBlackJackScreenRoute:
        return MaterialPageRoute(builder: (context) => PlayBlackJackScreen());
      case RouteName.playSlotMachineScreenRoute:
        return MaterialPageRoute(
            builder: (context) => SlotMachineGameScreen(
                data: route.arguments as Map<String, dynamic>));
      case RouteName.settingsScreenRoute:
        return MaterialPageRoute(builder: (context) => SettingsScreen());
      case RouteName.walletScreenRoute:
        return MaterialPageRoute(builder: (context) => WalletScreen());
      case RouteName.leaderBoardScreenRoute:
        return MaterialPageRoute(builder: (context) => LeaderboardScreen());
      case RouteName.playersLobbyScreenRoute:
        return MaterialPageRoute(
            builder: (context) => MultiplayerLobbyScreen());
      case RouteName.waitingRoomScreenRoute:
        return MaterialPageRoute(
            builder: (context) => WaitingRoomScreen(
                  mapData: route.arguments as Map<String, dynamic>,
                ));
      case RouteName.createPrivateRoomScreenRoute:
        return MaterialPageRoute(builder: (context) => CreatePrivateRoomView());
      case RouteName.activeGamesScreenRoute:
        return MaterialPageRoute(builder: (context) => ActiveGamesScreen());
      case RouteName.invitationScreenRoute:
        return MaterialPageRoute(builder: (context) => InvitationScreen());
      case RouteName.multiPlayerBlackJackScreenRoute:
        return MaterialPageRoute(
            builder: (context) => MultiPlayerBlackjackGameScreen(
                  data: route.arguments as Map<String, dynamic>,
                ));
      default:
        return MaterialPageRoute(builder: (context) => SizedBox());
    }
  }
}
