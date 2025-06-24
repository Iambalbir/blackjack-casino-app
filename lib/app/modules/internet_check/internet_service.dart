import 'package:connectivity_plus/connectivity_plus.dart';
import 'bloc/no_internet_bloc.dart';
import 'bloc/no_internet_events.dart';

class InternetService {
  final NoInternetBloc bloc;

  InternetService(this.bloc) {
    print('entered this one');
    _init();
  }

  final Connectivity _connectivity = Connectivity();

  void _init() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      bloc.add(InternetDisconnected());
    } else {
      bloc.add(InternetConnected());
    }
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      bloc.add(InternetDisconnected());
    } else {
      bloc.add(InternetConnected());
    }
  }
}
