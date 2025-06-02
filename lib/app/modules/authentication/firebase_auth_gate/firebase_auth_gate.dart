import '../../../../export_file.dart';

class UserStateChangeHandlerStream extends StatelessWidget {
  UserStateChangeHandlerStream({super.key});

  var currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToast("Press again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    apiRepository.checkCurrentUser();
    return WillPopScope(
      onWillPop: onWillPop,
      child: FutureBuilder<bool>(
        future: isGuestUser(),
        builder: (context, guestSnapshot) {
          if (guestSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (authSnapshot.hasData) {
                return MainScreen();
              }

              // Guest user
              if (guestSnapshot.data == true) {
                return MainScreen();
              }

              return LoginScreen();
            },
          );
        },
      ),
    );
  }
}

Future<bool> isGuestUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_guest') ?? false;
}
