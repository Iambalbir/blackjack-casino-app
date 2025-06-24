import 'package:app/export_file.dart';

class RegisterBloc extends Bloc<RegisterEvents, RegisterState> {
  RegisterBloc() : super(RegisterState.initialState()) {
    on<TogglePasswordVis>(_togglePasswordEvent);
    on<ToggleConfirmPasswordVis>(_toggleConfirmPasswordEvent);
    on<RegisterNewUserEvent>(_registerNewUserEvent);
  }

  _registerNewUserEvent(
      RegisterNewUserEvent event, Emitter<RegisterState> emit) async {
    try {
      customLoader.show(event.context);
      await firebaseRepository.registerNewUser(event.userData).then((onValue) {
        firebaseRepository.checkCurrentUser();
      }).onError((error, stack) {
        showToast(error.toString());
      });
      emit(state.copyWith(isSuccess: true));
      customLoader.hide();
    } catch (e) {
      customLoader.hide();
      emit(state.copyWith(isSuccess: false));
    }
  }

  _togglePasswordEvent(
      TogglePasswordVis event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  _toggleConfirmPasswordEvent(
      ToggleConfirmPasswordVis event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(
        isConfirmPasswordVisible: !state.isConfirmPasswordVisible));
  }
}
