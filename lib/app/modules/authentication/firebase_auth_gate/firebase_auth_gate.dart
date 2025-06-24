import '../../../../export_file.dart';

class UserStateChangeHandlerStream extends StatefulWidget {
  UserStateChangeHandlerStream({super.key});

  @override
  State<UserStateChangeHandlerStream> createState() =>
      _UserStateChangeHandlerStreamState();
}

class _UserStateChangeHandlerStreamState
    extends State<UserStateChangeHandlerStream> {
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
    firebaseRepository.checkCurrentUser();
    return WillPopScope(
      onWillPop: onWillPop,
      child: FutureBuilder<bool>(
        future: isGuestUser(),
        builder: (context, guestSnapshot) {
          if (guestSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return StreamBuilder<User?>(
            stream: auth.authStateChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (authSnapshot.hasData) {
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('userSessions')
                      .doc(authSnapshot.data!.email)
                      .snapshots(),
                  builder: (context, sessionSnapshot) {
                    if (sessionSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (sessionSnapshot.hasData &&
                        sessionSnapshot.data!.exists) {
                      var sessionData =
                          sessionSnapshot.data!.data() as Map<String, dynamic>;
                      if (sessionData['isActive'] == false) {
                        if (FirebaseRepository.deviceID !=
                            sessionData['deviceId']) {
                          clearUserData(context);
                        }
                        return LoginScreen();
                      } else {
                        return MainScreen();
                      }
                    }
                    return MainScreen();
                  },
                );
              }

              // Guest user
              if (guestSnapshot.data == true) {
                return MainScreen();
              }
              Future.delayed(Duration(milliseconds: 900)).then((value) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteName.loginScreenRoute, (route) => false);
              });
              return Center(
                child: CircularProgressIndicator(
                  color: kBackground,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void clearUserData(BuildContext context) async {
    showToast("User session expired");
    try {
      await auth.signOut();
      currentUserModel = UserDataModel();
    } catch (e) {
      print("Error during sign out: $e");
      showToast("Error signing out. Please try again.");
    }
  }
}

Future<bool> isGuestUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_guest') ?? false;
}
