import '../../../../export_file.dart';

class NoNetworkConnectionScreen extends StatelessWidget {
  const NoNetworkConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoInternetBloc, NoInternetState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_off,
                    size: font_40,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No Network Connection',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please check your internet settings and try again.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
