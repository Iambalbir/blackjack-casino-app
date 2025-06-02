import 'package:app/core/utils/values/theme_config.dart';
export 'package:device_preview/device_preview.dart';

import 'export_file.dart';

final APIRepository apiRepository = APIRepository();
FirebaseAuth auth = FirebaseAuth.instance;
User? currentUser = auth.currentUser;
UserDataModel currentUserModel = UserDataModel();
late final prefs;
ValueNotifier<int> bankAmount = ValueNotifier<int>(0);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyDaPZ90K5QTukxVO82S8Yr1ChF7LmMn0yU",
              appId: "1:602621365384:android:f6add810cb64b9b250233d",
              messagingSenderId: "602621365384",
              projectId: "gambling-app-80e7b"))
      .then((v) {});

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  initApplication();
}

initApplication() {
  runApp(
    ScreenUtilInit(
      useInheritedMediaQuery: true,
      child: MultiBlocProvider(
        providers: BlocProviders.providersListing,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            setSystemNavigationBarColor(state.darkTheme);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: state.darkTheme
                  ? ThemeConfig.darkTheme
                  : ThemeConfig.lightTheme,
              initialRoute: RouteName.splashScreenRoute,
              onGenerateRoute: Routes.generateRoutes,
              home: PlayBlackJackScreen(),
            );
          },
        ),
      ),
    ),
  );
}

void setSystemNavigationBarColor(bool isDark) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: isDark ? Colors.black : Colors.white,
    systemNavigationBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark,
    statusBarColor: Colors.transparent, // optional
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
  ));
}
