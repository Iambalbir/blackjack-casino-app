import '../../../export_file.dart';

class CustomPageRoute<T> extends MaterialPageRoute<T> {
  final Color transitionColor;

  CustomPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    this.transitionColor = Colors.white,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return Stack(
      children: [
        Container(color: Theme.of(context).scaffoldBackgroundColor),
        FadeTransition(
          opacity: animation,
          child: child,
        ),
      ],
    );
  }
}
