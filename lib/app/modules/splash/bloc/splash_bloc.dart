import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<FadeInEvent>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 1000));
      emit(SplashFadeInState());
      add(NavigateToNextScreenEvent());
    });

    on<NavigateToNextScreenEvent>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 2000));
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        emit(SplashNoInternetState());
      } else {
        emit(SplashNavigateState());
      }
    });
  }
}
