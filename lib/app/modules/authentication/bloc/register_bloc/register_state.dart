class RegisterState {
  String nickName;
  String email;
  String password;
  bool isPasswordVisible;
  bool isConfirmPasswordVisible;
  dynamic isSuccess;

  RegisterState(
      {required this.nickName,
      required this.email,
      required this.password,
      required this.isSuccess,
      required this.isConfirmPasswordVisible,
      required this.isPasswordVisible});

  factory RegisterState.initialState() {
    return RegisterState(
        nickName: "",
        isSuccess: false,
        email: "",
        password: "",
        isPasswordVisible: false,
        isConfirmPasswordVisible: false);
  }

  RegisterState copyWith(
      {nickName,
      email,
      password,
        isSuccess,
      isPasswordVisible,
      isConfirmPasswordVisible}) {
    return RegisterState(
        nickName: nickName ?? this.nickName,
        isSuccess: isSuccess ?? this.isSuccess,
        email: email ?? this.email,
        isConfirmPasswordVisible:
            isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
        password: password ?? this.password,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible);
  }
}
