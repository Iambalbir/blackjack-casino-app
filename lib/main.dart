import 'package:app/app/modules/internet_check/internet_service.dart';
import 'package:app/core/utils/values/theme_config.dart';
import 'package:app/core/utils/widgets/confetti_overlay.dart';
import 'package:app/core/utils/widgets/custom_loader.dart';
import 'package:app/core/utils/widgets/loose_overlay.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
export 'package:device_preview/device_preview.dart';
import 'export_file.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

final FirebaseRepository firebaseRepository = FirebaseRepository();
FirebaseAuth auth = FirebaseAuth.instance;
User? currentUser = auth.currentUser;

UserDataModel currentUserModel = UserDataModel();
late final prefs;
ValueNotifier<int> bankAmount = ValueNotifier<int>(0);
CustomLoader customLoader = CustomLoader();
final ConfettiOverlay confettiOverlay = ConfettiOverlay();
final LoseOverlay looseOverlay = LoseOverlay();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51RbKkXSGSB0zN8STl8nvVlCOgNCB9qV7yQOds5FL9h1wlbfScNHYGWtao78rCYuLEgiRidfIfqSU873lysYigl5Z00iggHlvb8";/*  Stripe.publishableKey =
      "pk_test_51RbHGLSA8zLXiFKtIieD419DmwBuSGEQAvFQlKLQY5LHlCK6O7LDy5LRh9frsOOIk4xYIhlpH84LlQnCqCVAPWA100Qj5qlwIs";*/
  await dotenv.load(fileName: "assets/.env");
  prefs = await SharedPreferences.getInstance();

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDaPZ90K5QTukxVO82S8Yr1ChF7LmMn0yU",
        appId: "1:602621365384:android:f6add810cb64b9b250233d",
        messagingSenderId: "602621365384",
        projectId: "gambling-app-80e7b",
      ),
    );
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      child: MultiBlocProvider(
        providers: BlocProviders.providersListing,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            final isDarkTheme = settingsState.darkTheme;
            return AppInitializer(
              settingsState: settingsState,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: isDarkTheme
                    ? ThemeConfig.darkTheme
                    : ThemeConfig.lightTheme,
                initialRoute: RouteName.splashScreenRoute,
                onGenerateRoute: Routes.generateRoutes,
              ),
            );
          },
        ),
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  final SettingsState settingsState;
  final Widget child;

  const AppInitializer({
    Key? key,
    required this.settingsState,
    required this.child,
  }) : super(key: key);

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late InternetService _internetService;

  @override
  void initState() {
    super.initState();
    _internetService = InternetService(context.read<NoInternetBloc>());
    setSystemNavigationBarColor(widget.settingsState.darkTheme);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoInternetBloc, NoInternetState>(
      builder: (context, state) {
        if (state is InternetDisconnectedState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, builder) {
              return NoNetworkConnectionScreen();
            },
          );
        }
        return widget.child;
      },
    );
  }
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
