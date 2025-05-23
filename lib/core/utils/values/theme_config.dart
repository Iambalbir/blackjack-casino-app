import '../../../export_file.dart';

class ThemeConfig {
  static ThemeData createTheme({
    required Brightness brightness,
  }) {
    final baseTheme =
        brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light();

    final isDark = brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    final baseTextTheme =
        isDark ? Typography.whiteMountainView : Typography.blackMountainView;

    return baseTheme.copyWith(
      scaffoldBackgroundColor: isDark ? Colors.black : Colors.white,
      iconTheme: IconThemeData(
        color: textColor,
      ),

      appBarTheme: AppBarTheme(

        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: textColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: brightness,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        elevation: 0,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      },),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
      ),
      cardTheme: CardTheme(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: isDark ? Colors.grey[900] : Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1.5,
            color: textColor.withOpacity(0.5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1.5,
            color: textColor,
          ),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          color: textColor.withOpacity(0.5),
        ),
      ),
      unselectedWidgetColor: Colors.grey,
      textTheme: TextTheme(
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: textColor,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static ThemeData get lightTheme => createTheme(
        brightness: Brightness.light,
      );

  static ThemeData get darkTheme => createTheme(
        brightness: Brightness.dark,
      );
}
