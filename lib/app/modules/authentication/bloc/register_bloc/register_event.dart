import 'package:app/export_file.dart';

abstract class RegisterEvents {}

class TogglePasswordVis extends RegisterEvents {
  bool isPasswordVisible;

  TogglePasswordVis(this.isPasswordVisible);
}

class ToggleConfirmPasswordVis extends RegisterEvents {
  bool isConfirmPasswordVisible;

  ToggleConfirmPasswordVis(this.isConfirmPasswordVisible);
}

class RegisterNewUserEvent extends RegisterEvents {
  Map<String, dynamic> userData;
  BuildContext context;

  RegisterNewUserEvent(this.userData, this.context);
}
