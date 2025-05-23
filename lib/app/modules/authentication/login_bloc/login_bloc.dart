import '../../../../export_file.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(
        isSubmitting: true,
        error: null,
      ));

      try {
        var userDetails = AuthRequestModel.loginReq(
            email: state.email,
            password: state.password,
            deviceName: "",
            deviceToken: "",
            deviceType: "");

        await apiRepository.loginApiCall(userDetails).then((value) {
          emit(state.copyWith(
            isSubmitting: false,
            isSuccess: true,
          ));
        });
      } on FirebaseException catch (e) {
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
        emit(state.copyWith(isSubmitting: false, error: e.toString()));
      }
    });

    on<GoogleSignInPressed>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, error: null));

      try {
        apiRepository.googleSignInCall().onError((error, stack) {
          showToast(error.toString());
        });

        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, error: e.toString()));
      }
    });
  }
}
