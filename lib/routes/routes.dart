import 'package:app/app/modules/wallet/screens/wallet_screen.dart';

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
      default:
        return MaterialPageRoute(builder: (context) => SizedBox());
    }
  }
}
