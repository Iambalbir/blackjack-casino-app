import 'package:app/export_file.dart';

abstract class LoginEvent {}

class TogglePasswordVisibility extends LoginEvent {}

class LoginSubmitted extends LoginEvent {
  BuildContext context;
  String email;
  String password;

  LoginSubmitted(this.password, this.email, this.context);
}

class GoogleSignInPressed extends LoginEvent {
  BuildContext context;

  GoogleSignInPressed(this.context);
}
