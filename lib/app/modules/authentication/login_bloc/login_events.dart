abstract class LoginEvent {}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged(this.email);
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged(this.password);
}

class TogglePasswordVisibility extends LoginEvent {}

class LoginSubmitted extends LoginEvent {}

class GoogleSignInPressed extends LoginEvent {}
