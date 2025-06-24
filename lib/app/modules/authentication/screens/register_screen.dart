import '../../../../export_file.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  TextEditingController nickNameTextController = TextEditingController();
  final GlobalKey<FormState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final registerBloc = context.read<RegisterBloc>();
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteName.streamUserStateScreenRoute,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: SingleChildScrollView(
          padding: EdgeInsets.all(margin_15),
          child: Column(
            children: [
              SizedBox(height: height_45),
              AssetImageWidget(
                imageUrl: iconAppLogo,
                imageHeight: height * .25,
              ),
              Form(
                key: globalKey,
                child: Column(
                  children: [
                    TextFieldWidget(
                      radius: radius_10,
                      maxLength: 16,
                      hint: "Nick name",
                      onChange: (value) {
                        if (value.isNotEmpty) {
                          if (value[0] == " ") {
                            nickNameTextController.text = value.trimLeft();
                          }
                        }
                      },
                      validate: (data) => Validator.fieldCheck(
                          value: data, message: "Nickname"),
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[ a-zA-Z0-9]"))
                      ],
                      textController: nickNameTextController,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: margin_13, horizontal: margin_13),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: margin_9),
                      child: TextFieldWidget(
                        radius: radius_10,
                        maxLength: 16,
                        hint: "Email",
                        inputType: TextInputType.emailAddress,
                        onChange: (value) {
                          if (value.isNotEmpty) {
                            if (value[0] == " ") {
                              emailTextController.text = value.trimLeft();
                            }
                          }
                        },
                        validate: (data) => Validator.validateEmail(data),
                        textController: emailTextController,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: margin_13, horizontal: margin_13),
                      ),
                    ),
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        return TextFieldWidget(
                          radius: radius_8,
                          hint: strEnterPassword,
                          textController: passwordTextController,
                          maxLength: 20,
                          obscureText: state.isPasswordVisible,
                          onChange: (value) {
                            if (value.isNotEmpty && value[0] == " ") {
                              passwordTextController.text = value.trimLeft();
                            }
                          },
                          validate: (value) => Validator.password(value),
                          suffixIcon: IconButton(
                            onPressed: () {
                              registerBloc.add(
                                  TogglePasswordVis(state.isPasswordVisible));
                            },
                            icon: AssetImageWidget(
                              imageUrl: state.isPasswordVisible
                                  ? icon_password_hidden
                                  : icon_password_visible,
                              imageHeight: height_10,
                            ),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                        );
                      },
                    ),
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: margin_9),
                          child: TextFieldWidget(
                            radius: radius_8,
                            hint: strEnterPassword,
                            textController: confirmPasswordTextController,
                            maxLength: 20,
                            obscureText: state.isPasswordVisible,
                            onChange: (value) {
                              if (value.isNotEmpty && value[0] == " ") {
                                confirmPasswordTextController.text =
                                    value.trimLeft();
                              }
                            },
                            validate: (value) =>
                                Validator.validateConfirmPasswordMatch(
                                    value: value,
                                    password: passwordTextController.text),
                            suffixIcon: IconButton(
                              onPressed: () {
                                registerBloc.add(ToggleConfirmPasswordVis(
                                    state.isConfirmPasswordVisible));
                              },
                              icon: AssetImageWidget(
                                imageUrl: state.isConfirmPasswordVisible
                                    ? icon_password_hidden
                                    : icon_password_visible,
                                imageHeight: height_10,
                              ),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: height_40,
                    ),
                    MaterialButtonWidget(
                      buttonRadius: radius_8,
                      onPressed: () {
                        if (globalKey.currentState!.validate()) {
                          var userData = {
                            'email': emailTextController.text,
                            'password': confirmPasswordTextController.text,
                            'nickname': nickNameTextController.text
                          };
                          registerBloc
                              .add(RegisterNewUserEvent(userData, context));
                        }
                      },
                      buttonText: "Sign up",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    );
  }
}
