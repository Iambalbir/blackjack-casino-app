import 'package:flutter_bloc/flutter_bloc.dart';
import 'no_internet_events.dart';
import 'no_internet_states.dart';

class NoInternetBloc extends Bloc<NoInternetEvents, NoInternetState> {
  NoInternetBloc() : super(InternetConnectedState()) {
    on<InternetConnected>(_onInternetConnected);
    on<InternetDisconnected>(_onInternetDisconnected);
  }

  void _onInternetConnected(
      InternetConnected event, Emitter<NoInternetState> emit) {
    if (state is! InternetConnectedState) {
      emit(InternetConnectedState());
    }
  }

  void _onInternetDisconnected(
      InternetDisconnected event, Emitter<NoInternetState> emit) {
    if (state is! InternetDisconnectedState) {
      emit(InternetDisconnectedState());
    }
  }
}
