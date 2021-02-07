import "package:flutter/widgets.dart";

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double bH;
  static double bV;
  static double bC;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double sH;
  static double sV;

  static double aspectRatio(double ratio) {
    return (bH / bV) * ratio;
  }

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    bH = screenWidth / 100;
    bV = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    sH = (screenWidth - _safeAreaHorizontal) / 100;
    sV = (screenHeight - _safeAreaVertical) / 100;
  }
}
