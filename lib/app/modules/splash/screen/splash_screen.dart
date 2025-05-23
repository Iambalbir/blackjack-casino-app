import 'package:app/core/utils/assets/image_assets.dart';
import 'package:app/core/utils/widgets/asset_image.dart';
import 'package:app/export_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final splashBloc = BlocProvider.of<SplashBloc>(context);
    splashBloc.add(FadeInEvent());
    return Scaffold(
      body: BlocConsumer<SplashBloc, SplashState>(
        bloc: splashBloc,
        listener: (context, state) {
          if (state is SplashNoInternetState) {
          } else if (state is SplashNavigateState) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              RouteName.streamUserStateScreenRoute,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final isVisible = state is SplashFadeInState;
          return Center(
            child: AnimatedOpacity(
              curve: Curves.easeInCubic,
              duration: const Duration(seconds: 1),
              opacity: isVisible ? 1 : 0,
              child: AssetImageWidget(imageUrl: iconAppLogo),
            ),
          );
        },
      ),
    );
  }
}
