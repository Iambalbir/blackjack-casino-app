// Project imports:
import 'package:loading_animation_widget/loading_animation_widget.dart'
    show LoadingAnimationWidget;

import '../../../export_file.dart';

class CustomLoader {
  static CustomLoader? _loader;

  CustomLoader._createObject();

  factory CustomLoader() {
    if (_loader != null) {
      return _loader!;
    } else {
      _loader = CustomLoader._createObject();
      return _loader!;
    }
  }

  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;

  _buildLoader() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: buildLoader(),
              color: Colors.black.withOpacity(.3),
            )
          ],
        );
      },
    );
  }

  show(context) {
    _overlayState = Overlay.of(context);
    _buildLoader();
    _overlayState!.insert(_overlayEntry!);
  }

  hide() {
    try {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
    } catch (_) {}
  }

  buildLoader({isTransparent = false}) {
    return Center(
      child: Container(
        color: isTransparent ? Colors.transparent : Colors.transparent,
        child: Center(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal:  margin_12,vertical: margin_8),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: radius_1,
                    blurRadius: radius_2)
              ],
              borderRadius: BorderRadius.circular(radius_9)),
          child: LoadingAnimationWidget.fourRotatingDots(
            color: colorAppColor,
            size: height_30,
          ),
        )), //CircularProgressIndicator(),
      ),
    );
  }
}
