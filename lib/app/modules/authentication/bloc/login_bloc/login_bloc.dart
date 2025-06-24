import '../../../../../export_file.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });

    on<LoginSubmitted>(_loginSubmitted);

    on<GoogleSignInPressed>(_googleSignIn);
  }

  _loginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(
      isSubmitting: true,
      error: null,
    ));
    customLoader.show(event.context);
    try {
      var userDetails = AuthRequestModel.loginReq(
          email: event.email,
          password: event.password,
          deviceName: "",
          firstName: "",
          lastName: "",
          deviceToken: "",
          deviceType: "");
      await firebaseRepository.loginApiCall(userDetails).then((value) {
        firebaseRepository.checkCurrentUser();
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
        ));
        customLoader.hide();
      });
    } on FirebaseException catch (e) {
      customLoader.hide();
      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials, please try again.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }

      emit(state.copyWith(isSubmitting: false, error: errorMessage));
    } catch (e) {
      customLoader.hide();
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }

  _googleSignIn(GoogleSignInPressed event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isSubmitting: true, error: null));
    customLoader.show(event.context);
    try {
      await firebaseRepository.googleSignInCall().then((value) async {
        if (value != null) {
          firebaseRepository.checkCurrentUser();

          await firebaseRepository.saveUserSession(value).whenComplete(() {
            customLoader.hide();
            emit(state.copyWith(isSubmitting: false, isSuccess: true));
          });
        }
      }).onError((error, stack) {
        customLoader.hide();
        showToast(error.toString());
      });
    } catch (e) {
      customLoader.hide();
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }
}
