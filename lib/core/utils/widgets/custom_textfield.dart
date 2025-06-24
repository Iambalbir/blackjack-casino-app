import '../../../export_file.dart';

class TextFieldWidget extends StatelessWidget {
  final String? hint;
  final String? labelText;
  final String? tvHeading;
  final double? height;
  final double? width;
  final double? radius;
  final Color? color;
  final Color? bgColor;
  final Color? courserColor;
  final validate;
  final hintStyle;
  final labelTextStyle;
  final EdgeInsets? contentPadding;
  final TextInputType? inputType;
  final TextEditingController? textController;
  final FocusNode? focusNode;
  final Function(String value)? onFieldSubmitted;
  final Function()? onTap;
  final TextInputAction? inputAction;
  final bool? hideBorder;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLine;
  final decoration;
  final int? minLine;
  final int? maxLength;
  final bool readOnly;
  final bool? shadow;
  final bool? obscureText;
  final bool? isOutlined;
  final Function(String value)? onChange;
  final inputFormatter;
  final errorColor;
  final textColor;
  final labelMargin;
  final bool? optional;

  const TextFieldWidget({
    this.hint,
    this.labelText,
    this.tvHeading,
    this.inputType,
    this.textController,
    this.hintStyle,
    this.courserColor,
    this.validate,
    this.onChange,
    this.decoration,
    this.bgColor,
    this.radius,
    this.textColor,
    this.focusNode,
    this.readOnly = false,
    this.shadow,
    this.onFieldSubmitted,
    this.inputAction,
    this.height,
    this.width,
    this.contentPadding,
    this.isOutlined = false,
    this.maxLine = 1,
    this.minLine = 1,
    this.maxLength,
    this.color,
    this.hideBorder = true,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText,
    this.onTap,
    this.inputFormatter,
    this.errorColor,
    this.labelTextStyle,
    this.labelMargin,
    this.optional,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: labelMargin ?? margin_5),
                    child: TextView(
                        text: labelText ?? "",
                        textStyle: labelTextStyle ??
                            textStyleBodyLarge(context).copyWith(
                                color: isOutlined == true
                                    ? Colors.black87
                                    : Colors.grey,
                                fontWeight: FontWeight.w600)),
                  ),
                  (optional == true)
                      ? TextView(
                          text: "(Optional)",
                          textStyle: textStyleBodySmall(context).copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      : SizedBox()
                ],
              )
            : Container(),
        TextFormField(
          readOnly: readOnly,
          onTap: onTap,
          obscureText: obscureText ?? false,
          controller: textController,
          focusNode: focusNode,
          keyboardType: inputType,
          maxLength: maxLength,
          onChanged: onChange,
          cursorColor: courserColor ?? colorAppColor,
          inputFormatters: inputFormatter ??
              [
                FilteringTextInputFormatter(
                    RegExp(
                        '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                    allow: false),
              ],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: maxLine,
          minLines: minLine,
          textInputAction: inputAction,
          onFieldSubmitted: onFieldSubmitted,
          validator: validate,
          style: textStyleBodyMedium(context)
              .copyWith(fontSize: font_15, color: textColor),
          decoration: inputDecoration(context) ?? decoration,
        )
      ],
    );
  }

  inputDecoration(BuildContext context) => InputDecoration(
      counterText: "",
      errorMaxLines: 2,
      suffixIconConstraints:
          BoxConstraints(minHeight: height ?? height_20, minWidth: width_25),
      errorStyle: textStyleBodySmall(context)
          .copyWith(fontSize: font_8)
          .copyWith(color: Colors.red),
      isDense: true,
      filled: true,
      contentPadding: contentPadding ?? EdgeInsets.all(margin_12),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintText: hint,
      hintStyle: hintStyle ??
          textStyleBodyMedium(context).copyWith(
              color: Colors.grey,
              fontSize: font_12,
              fontWeight: FontWeight.w500),
      fillColor: bgColor ?? Colors.grey.shade100,
      border: decoration ??
          DecoratedInputBorder(
            child: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? margin_30),
                borderSide: BorderSide.none),
            shadow: BoxShadow(
              color: shadow == true ? Colors.transparent : Colors.grey[200]!,
              blurRadius: margin_0,
              spreadRadius: margin_0,
            ),
          ),
      focusedErrorBorder: decoration ??
          DecoratedInputBorder(
            child: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? margin_30),
                borderSide: BorderSide.none),
            shadow: BoxShadow(
              color: shadow == true ? Colors.transparent : Colors.grey[200]!,
              blurRadius: margin_0,
              spreadRadius: margin_0,
            ),
          ),
      errorBorder: decoration ??
          DecoratedInputBorder(
              child: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? margin_30),
                  borderSide: BorderSide.none),
              shadow: BoxShadow(
                color: shadow == true ? Colors.transparent : Colors.grey[200]!,
                blurRadius: margin_0,
                spreadRadius: margin_0,
              )),
      focusedBorder: decoration ??
          DecoratedInputBorder(
              child: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? margin_30),
                  borderSide: BorderSide.none),
              shadow: BoxShadow(
                color: shadow == true ? Colors.transparent : Colors.grey[200]!,
                blurRadius: margin_0,
                spreadRadius: margin_0,
              )),
      enabledBorder: decoration ??
          DecoratedInputBorder(
            child: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? margin_30),
                borderSide: BorderSide.none),
            shadow: BoxShadow(
              color: shadow == true ? Colors.transparent : Colors.grey[200]!,
              blurRadius: margin_0,
              spreadRadius: margin_0,
            ),
          ));
}

class DecoratedInputBorder extends InputBorder {
  DecoratedInputBorder({
    required this.child,
    required this.shadow,
  }) : super(borderSide: child.borderSide);

  final InputBorder child;

  final BoxShadow? shadow;

  @override
  bool get isOutline => child.isOutline;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      child.getInnerPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      child.getOuterPath(rect, textDirection: textDirection);

  @override
  EdgeInsetsGeometry get dimensions => child.dimensions;

  @override
  InputBorder copyWith(
      {BorderSide? borderSide,
      InputBorder? child,
      BoxShadow? shadow,
      bool? isOutline}) {
    return DecoratedInputBorder(
      child: (child ?? this.child).copyWith(borderSide: borderSide),
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ShapeBorder scale(double t) {
    final scalledChild = child.scale(t);

    return DecoratedInputBorder(
      child: scalledChild is InputBorder ? scalledChild : child,
      shadow: BoxShadow.lerp(null, shadow, t),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect,
      {double? gapStart,
      double gapExtent = 0.0,
      double gapPercentage = 0.0,
      TextDirection? textDirection}) {
    final clipPath = Path()
      ..addRect(const Rect.fromLTWH(-5000, -5000, 10000, 10000))
      ..addPath(getInnerPath(rect), Offset.zero)
      ..fillType = PathFillType.evenOdd;
    canvas.clipPath(clipPath);

    final Paint paint = shadow!.toPaint();
    final Rect bounds =
        rect.shift(shadow!.offset).inflate(shadow!.spreadRadius);

    canvas.drawPath(getOuterPath(bounds), paint);

    child.paint(canvas, rect,
        gapStart: gapStart,
        gapExtent: gapExtent,
        gapPercentage: gapPercentage,
        textDirection: textDirection);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is DecoratedInputBorder &&
        other.borderSide == borderSide &&
        other.child == child &&
        other.shadow == shadow;
  }
}
