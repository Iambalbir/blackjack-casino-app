class LoginState {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;

  const LoginState({
    required this.email,
    required this.password,
    required this.isPasswordVisible,
    required this.isSubmitting,
    required this.isSuccess,
    this.error,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      isPasswordVisible: true,
      isSubmitting: false,
      isSuccess: false,
      error: null,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}
