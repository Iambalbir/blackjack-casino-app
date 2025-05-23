import '../../../export_file.dart';

class MaterialButtonWidget extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor;
  final double? buttonRadius;
  final TextStyle? buttonTextStyle;
  final double? minWidth;
  final double? minHeight;
  final double? padding;
  final double? horizontalPadding;
  final void Function()? onPressed;
  final decoration;
  final double? textHorizontalMargin;
  final double? textVerticalMargin;
  final elevation;
  final bool? isSocial;
  final double? fontsize;
  final Widget? iconWidget;

  const MaterialButtonWidget({
    Key? key,
    this.buttonText = "",
    this.buttonColor,
    this.borderColor,
    this.buttonTextStyle,
    this.textColor,
    this.buttonRadius,
    this.decoration,
    this.isSocial = false,
    this.onPressed,
    this.elevation,
    this.iconWidget,
    this.fontsize,
    this.minWidth,
    this.minHeight,
    this.padding,
    this.horizontalPadding,
    this.textHorizontalMargin,
    this.textVerticalMargin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        height: minHeight,
        splashColor: Colors.transparent,
        minWidth: minWidth ?? MediaQuery.sizeOf(context).width,
        color: buttonColor ?? colorAppColor,
        elevation: elevation,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius ?? radius_0),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none),
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(
            vertical: padding ?? 12, horizontal: horizontalPadding ?? margin_0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget ?? SizedBox(),
            SizedBox(
              width: iconWidget != null ? width_15 : width_0,
            ),
            TextView(
                text: buttonText!,
                textStyle: buttonTextStyle ??
                    textStyleBodyMedium(context).copyWith(
                        color: textColor ?? Colors.white,
                        fontSize: fontsize ?? font_14,
                        fontWeight: FontWeight.w400)),
          ],
        ));
  }
}
