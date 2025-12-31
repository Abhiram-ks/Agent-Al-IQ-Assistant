import 'package:flutter/widgets.dart';

class MeidaQuaryHelper {
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

class Constant {
  static Widget hight({required BuildContext context, required double hight}) {
    return SizedBox(height: MeidaQuaryHelper.height(context) * hight);
  }

  static Widget width({required BuildContext context, required double width}) {
    return SizedBox(width: MeidaQuaryHelper.width(context) * width);
  }

}