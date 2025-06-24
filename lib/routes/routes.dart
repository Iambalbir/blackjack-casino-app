import 'package:app/app/modules/games/screens/poker_game_screen.dart';
import 'package:app/app/modules/wallet/screens/add_coins_view.dart';

import '../export_file.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings route) {
    switch (route.name) {
      case RouteName.splashScreenRoute:
        return CustomPageRoute(builder: (context) => SplashScreen());
      case RouteName.noInternetScreenRoute:
        return CustomPageRoute(
            builder: (context) => NoNetworkConnectionScreen());
      case RouteName.loginScreenRoute:
        return CustomPageRoute(builder: (context) => LoginScreen());
      case RouteName.singUpScreenRoute:
        return CustomPageRoute(builder: (context) => RegisterScreen());
      case RouteName.streamUserStateScreenRoute:
        return CustomPageRoute(
            builder: (context) => UserStateChangeHandlerStream());
      case RouteName.playBlackJackScreenRoute:
        return CustomPageRoute(builder: (context) => PlayBlackJackScreen());
      case RouteName.playSlotMachineScreenRoute:
        return CustomPageRoute(
            builder: (context) => SlotMachineGameScreen(
                data: route.arguments as Map<String, dynamic>));
      case RouteName.settingsScreenRoute:
        return CustomPageRoute(builder: (context) => SettingsScreen());
      case RouteName.walletScreenRoute:
        return CustomPageRoute(builder: (context) => WalletScreen());
      case RouteName.leaderBoardScreenRoute:
        return CustomPageRoute(builder: (context) => LeaderboardScreen());
      case RouteName.playersLobbyScreenRoute:
        return CustomPageRoute(builder: (context) => RoomAccessScreen());
      case RouteName.waitingRoomScreenRoute:
        return CustomPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => WaitingRoomBloc(),
                  child: WaitingRoomScreen(
                    mapData: route.arguments as Map<String, dynamic>,
                  ),
                ));
      case RouteName.createPrivateRoomScreenRoute:
        return CustomPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => CreateRoomBloc(),
                  child: CreatePrivateRoomView(),
                ));
      case RouteName.createPublicRoomScreenRoute:
        return CustomPageRoute(builder: (context) => CreatePublicRoomScreen());
      case RouteName.activeGamesScreenRoute:
        return CustomPageRoute(builder: (context) => ActiveGamesScreen());
      case RouteName.invitationScreenRoute:
        return CustomPageRoute(builder: (context) => InvitationScreen());
      case RouteName.addCoinsScreenRoute:
        return CustomPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => AddCoinBloc(),
                  child: AddCoinsScreen(),
                ));
      case RouteName.publicLobbyListingScreenRoute:
        return CustomPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => PublicLobbyBloc(),
                  child: PublicLobbyListScreen(),
                ));
      case RouteName.multiPlayerBlackJackScreenRoute:
        return CustomPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => MultiPlayerBlackjackBloc(),
            child: MultiPlayerBlackjackGameScreen(
              data: route.arguments as Map<String, dynamic>,
            ),
          ),
        );

      case RouteName.pokerGamePlayScreen:
        return CustomPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => PokerBloc(),
            child: PokerGameScreen(
              data: route.arguments as Map<String, dynamic>,
            ),
          ),
        );
      default:
        return CustomPageRoute(builder: (context) => SizedBox());
    }
  }
}
