import 'package:app/export_file.dart';
import 'package:flutter/foundation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  DateTime? currentTime;

  @override
  void initState() {
    if (kDebugMode) {
      emailController.text = "steve@test.in";
      passwordController.text = "Test@123";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final height = MediaQuery.sizeOf(context).height;

    Future<void> saveGuestIdLocally(String guestId) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("guest_id", guestId);
      await prefs.setBool("is_guest", true);
    }

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (currentTime == null ||
            now.difference(currentTime!) > Duration(seconds: 2)) {
          currentTime = now;
          showToast(doubleBackPressed);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isSuccess && !state.isSubmitting) {
              Future.delayed(Duration(seconds: 1)).then((value) {
                print('this calledasdfffffffffffffff');
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteName.streamUserStateScreenRoute,
                  (route) => false,
                );
              });
            } else if (state.error != null) {
              showToast(state.error!);
              emailController.clear();
              passwordController.clear();
              emailFocusNode.requestFocus();
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(margin_15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height_45),
                AssetImageWidget(
                  imageUrl: iconAppLogo,
                  imageHeight: height * .25,
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: margin_10),
                    child: Column(
                      children: [
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            return TextFieldWidget(
                              radius: radius_8,
                              hint: "Enter your email address",
                              textController: emailController,
                              focusNode: emailFocusNode,
                              inputType: TextInputType.emailAddress,
                              onChange: (value) {
                                if (value.isNotEmpty && value[0] == " ") {
                                  emailController.text = value.trimLeft();
                                }
                                // loginBloc.add(EmailChanged(value));
                              },
                              validate: (value) =>
                                  Validator.validateEmail(value),
                            );
                          },
                        ),
                        SizedBox(height: height_15),
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            return TextFieldWidget(
                              radius: radius_8,
                              hint: strEnterPassword,
                              textController: passwordController,
                              maxLength: 20,
                              focusNode: passwordFocusNode,
                              obscureText: state.isPasswordVisible,
                              onChange: (value) {
                                if (value.isNotEmpty && value[0] == " ") {
                                  passwordController.text = value.trimLeft();
                                }
                              },
                              validate: (value) =>
                                  Validator.validatePassword(value),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  loginBloc.add(TogglePasswordVisibility());
                                },
                                icon: AssetImageWidget(
                                  imageUrl: state.isPasswordVisible
                                      ? icon_password_hidden
                                      : icon_password_visible,
                                  imageHeight: height_14,
                                ),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return MaterialButtonWidget(
                      buttonRadius: radius_8,
                      buttonText:
                          state.isSubmitting ? "Logging in..." : "Login",
                      onPressed: () {
                        if (!state.isSubmitting) {
                          if (formKey.currentState!.validate()) {
                            loginBloc.add(LoginSubmitted(
                                passwordController.text,
                                emailController.text,
                                context));
                          }
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: height_15),
                MaterialButtonWidget(
                  buttonRadius: radius_8,
                  iconWidget: AssetImageWidget(
                    imageUrl: iconGoogle,
                    imageHeight: height_24,
                  ),
                  buttonText: "Sign in with Google",
                  onPressed: () {
                    loginBloc.add(GoogleSignInPressed(context));
                  },
                ),
                SizedBox(height: height_15),
                MaterialButtonWidget(
                  buttonRadius: radius_8,
                  iconWidget: Icon(Icons.person_outline),
                  buttonText: "Continue as Guest",
                  onPressed: () async {
                    showToast("Functionality yet to implement");
                    /* final guestId =
                        "Guest#${DateTime.now().millisecondsSinceEpoch % 10000}";
                    await saveGuestIdLocally(guestId); // see below
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteName.streamUserStateScreenRoute,
                      (route) => false,
                    );*/
                  },
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.singUpScreenRoute);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(margin_10),
                    child: TextView(
                      text: strClickToSetupAccount,
                      textStyle: textStyleBodyMedium(context).copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: font_14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
