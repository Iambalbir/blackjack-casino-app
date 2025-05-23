import '../../../export_file.dart';

TextStyle textStyleHeading(BuildContext context) => Theme.of(context)
    .textTheme
    .headlineLarge!
    .copyWith(fontWeight: FontWeight.w600);

TextStyle textStyleHeadingMedium(BuildContext context) => Theme.of(context)
    .textTheme
    .headlineMedium!
    .copyWith(fontWeight: FontWeight.w600);

TextStyle textStyleHeadingSmall(BuildContext context) => Theme.of(context)
    .textTheme
    .headlineSmall!
    .copyWith(fontWeight: FontWeight.w600);

TextStyle textStyleTitle(BuildContext context) =>
    Theme.of(context).textTheme.titleMedium!.copyWith();

TextStyle textStyleSubTitle(BuildContext context) =>
    Theme.of(context).textTheme.titleMedium!.copyWith();

TextStyle textStyleSubTitle2(BuildContext context) =>
    Theme.of(context).textTheme.titleSmall!.copyWith();

TextStyle textStyleDisplayLarge(BuildContext context) =>
    Theme.of(context).textTheme.displayLarge!;

TextStyle textStyleDisplayMedium(BuildContext context) =>
    Theme.of(context).textTheme.displayMedium!.copyWith();

TextStyle textStyleDisplaySmall(BuildContext context) =>
    Theme.of(context).textTheme.displaySmall!.copyWith();

TextStyle textStyleHeadlineLarge(BuildContext context) =>
    Theme.of(context).textTheme.headlineLarge!.copyWith();

TextStyle textStyleHeadlineMedium(BuildContext context) =>
    Theme.of(context).textTheme.headlineMedium!.copyWith();

TextStyle textStyleHeadlineSmall(BuildContext context) =>
    Theme.of(context).textTheme.headlineSmall!.copyWith();

TextStyle textStyleLabelLarge(BuildContext context) =>
    Theme.of(context).textTheme.labelLarge!;

TextStyle textStyleLabelMedium(BuildContext context) =>
    Theme.of(context).textTheme.labelMedium!.copyWith();

TextStyle textStyleLabelSmall(BuildContext context) =>
    Theme.of(context).textTheme.labelSmall!.copyWith();

TextStyle textStyleBodyLarge(BuildContext context) =>
    Theme.of(context).textTheme.bodyLarge!.copyWith();

TextStyle textStyleBodyMedium(BuildContext context) => Theme.of(context)
    .textTheme
    .bodyMedium!
    .copyWith( decorationColor: Colors.black);

TextStyle textStyleBodySmall(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall!.copyWith();

TextStyle textStyleTitleLarge(BuildContext context) =>
    Theme.of(context).textTheme.titleLarge!.copyWith();

TextStyle textStyleTitleMedium(BuildContext context) =>
    Theme.of(context).textTheme.titleMedium!.copyWith();

TextStyle textStyleTitleSmall(BuildContext context) =>
    Theme.of(context).textTheme.titleSmall!.copyWith();
