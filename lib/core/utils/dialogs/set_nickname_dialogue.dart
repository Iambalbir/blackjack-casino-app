import '../../../export_file.dart';

void showNicknameDialog(BuildContext context, Function(String) onSave) {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  _controller.text = currentUserModel.nickname;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: height_20), // For spacing from the X icon
                    TextView(
                      text: 'Enter Nickname',
                      textStyle: textStyleBodyMedium(context).copyWith(
                          fontSize: font_18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height_16),
                    TextFieldWidget(
                      textController: _controller,
                      textColor: kBlack,
                      radius: radius_5,
                      validate: (value) =>
                          FieldChecker.fieldChecker(value, "Nickname"),
                      readOnly: false,
                      hint: "Your nickname",
                    ),
                    SizedBox(height: height_16),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          String nickname = _controller.text.trim();
                          Navigator.of(context).pop();
                          onSave(nickname);
                        }
                      },
                      child: TextView(
                        text: 'Save',
                        textStyle: textStyleBodyMedium(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Close icon in top right
            Positioned(
              top: margin_8,
              right: margin_8,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close, size: 24),
              ),
            ),
          ],
        ),
      );
    },
  );
}
